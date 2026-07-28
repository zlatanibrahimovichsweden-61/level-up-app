import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
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
