import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/profile/models/profile_update.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';

/// Repository level, with a mocked Dio: the response really parses into the
/// domain model, and every failure arrives as a typed `AppException` — never a
/// `DioException` — so the UI can branch on offline vs error.

class _MockDio extends Mock implements Dio {}

DioException _dioError(AppException mapped) => DioException(
      requestOptions: RequestOptions(path: '/me'),
      // The real ErrorInterceptor has already mapped the failure onto `.error`;
      // the repository's job is only to unwrap it.
      error: mapped,
    );

void main() {
  late _MockDio dio;
  late ProfileRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = ProfileRepository(dio);
  });

  group('GET /me', () {
    test('parses the response into a StudentProfile', () async {
      when(() => dio.get<Map<String, dynamic>>('/me')).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/me'),
          statusCode: 200,
          data: schoolProfileJson(),
        ),
      );

      final profile = await repo.getMe();

      expect(profile.name, 'Ahmed Mohamed');
      expect(profile.level, 8);
      expect(profile.points.total, 2450);
    });

    test('offline surfaces as OfflineException, not a DioException', () async {
      when(() => dio.get<Map<String, dynamic>>('/me'))
          .thenThrow(_dioError(const OfflineException()));

      await expectLater(repo.getMe(), throwsA(isA<OfflineException>()));
    });

    test('a 401 surfaces as UnauthorizedException carrying its code', () async {
      when(() => dio.get<Map<String, dynamic>>('/me')).thenThrow(
        _dioError(const UnauthorizedException(code: 'session_superseded')),
      );

      await expectLater(
        repo.getMe(),
        throwsA(
          isA<UnauthorizedException>()
              .having((e) => e.code, 'code', 'session_superseded'),
        ),
      );
    });

    test('anything that bypassed the interceptor becomes UnknownException',
        () async {
      when(() => dio.get<Map<String, dynamic>>('/me')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/me')),
      );

      await expectLater(repo.getMe(), throwsA(isA<UnknownException>()));
    });
  });

  group('PATCH /me', () {
    Response<Map<String, dynamic>> ok(Map<String, dynamic> body) =>
        Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/me'),
          statusCode: 200,
          data: body,
        );

    /// The body Dio was actually handed.
    Map<String, dynamic> sentBody() =>
        verify(() => dio.patch<Map<String, dynamic>>('/me', data: captureAny(named: 'data')))
            .captured
            .single as Map<String, dynamic>;

    setUp(() {
      when(() => dio.patch<Map<String, dynamic>>('/me', data: any(named: 'data')))
          .thenAnswer((_) async => ok(schoolProfileJson()));
    });

    test('sends only the changed field and parses the updated profile',
        () async {
      final profile = await repo.updateMe(
        ProfileUpdate.diff(
          current: schoolProfile(),
          name: 'Ahmed Ali',
          email: '',
        ),
      );

      expect(sentBody(), <String, dynamic>{'name': 'Ahmed Ali'});
      expect(profile.name, 'Ahmed Mohamed'); // whatever the server returned
    });

    test('a cleared email reaches Dio with the key present and null', () async {
      await repo.updateMe(
        ProfileUpdate.diff(
          current: profileWithEmail(),
          name: 'Ahmed Mohamed',
          email: '',
        ),
      );

      final body = sentBody();
      expect(body.containsKey('email'), isTrue);
      expect(body['email'], isNull);
    });

    test('avatarId round-trips: sent on the request, back on the response',
        () async {
      when(() => dio.patch<Map<String, dynamic>>('/me', data: any(named: 'data')))
          .thenAnswer(
        (_) async => ok(<String, dynamic>{
          ...schoolProfileJson(),
          'avatar': <String, dynamic>{
            'type': 'default',
            'id': 'avatar-99',
            'url': 'https://cdn.levelup.example/avatars/9.png',
          },
        }),
      );

      final profile = await repo.updateMe(
        ProfileUpdate.diff(
          current: schoolProfile(),
          name: 'Ahmed Mohamed',
          email: '',
          avatarId: 'avatar-99',
        ),
      );

      expect(sentBody(), <String, dynamic>{'avatarId': 'avatar-99'});
      expect(profile.avatar.id, 'avatar-99');
      expect(profile.avatar.url, endsWith('/9.png'));
    });

    test('400 validation_failed surfaces as ValidationException with its fields',
        () async {
      when(() => dio.patch<Map<String, dynamic>>('/me', data: any(named: 'data')))
          .thenThrow(
        _dioError(
          const ValidationException(
            errors: <String, List<String>>{
              'email': <String>['must be a valid email address'],
            },
          ),
        ),
      );

      await expectLater(
        repo.updateMe(
          ProfileUpdate.diff(
            current: schoolProfile(),
            name: 'Ahmed Mohamed',
            email: 'nope',
          ),
        ),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.fields, 'fields', contains('email')),
        ),
      );
    });

    test('offline surfaces as OfflineException', () async {
      when(() => dio.patch<Map<String, dynamic>>('/me', data: any(named: 'data')))
          .thenThrow(_dioError(const OfflineException()));

      await expectLater(
        repo.updateMe(const ProfileUpdate(name: 'x')),
        throwsA(isA<OfflineException>()),
      );
    });
  });

  group('GET /me/entitlements', () {
    test('unwraps the { items: [...] } envelope', () async {
      when(() => dio.get<Map<String, dynamic>>('/me/entitlements')).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/me/entitlements'),
          statusCode: 200,
          data: <String, dynamic>{
            'items': <dynamic>[
              <String, dynamic>{
                'type': 'baseSubscription',
                'active': true,
                'inGrace': false,
              },
            ],
          },
        ),
      );

      final items = await repo.getEntitlements();

      expect(items, hasLength(1));
      expect(items.single.active, isTrue);
    });

    test('offline surfaces as OfflineException', () async {
      when(() => dio.get<Map<String, dynamic>>('/me/entitlements'))
          .thenThrow(_dioError(const OfflineException()));

      await expectLater(
        repo.getEntitlements(),
        throwsA(isA<OfflineException>()),
      );
    });
  });
}
