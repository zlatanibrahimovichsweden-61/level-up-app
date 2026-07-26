import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/registration/models/school_registration.dart';
import 'package:level_up_app/features/registration/models/university_registration.dart';
import 'package:level_up_app/features/registration/repository/registration_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

final _schoolBody = SchoolRegistration(
  registrationToken: 'reg.token',
  name: 'Nour Hassan',
  dateOfBirth: DateTime(2009, 5, 1),
  countryCode: 'EG',
  governorateId: 'gov-cairo',
  cityId: 'city-nasr',
  schoolId: 'school-42',
  stage: 'secondary1',
  educationSystem: 'ig',
  parentPhone: '+201021871999',
);

final _universityBody = UniversityRegistration(
  registrationToken: 'reg.token',
  name: 'Nour Hassan',
  dateOfBirth: DateTime(2004, 3, 7),
  universityId: 'uni-cairo',
  facultyId: 'fac-medicine',
  studyYearId: 'year-2',
  governorateId: 'gov-giza',
  cityId: 'city-dokki',
  parentPhone: '+201021871999',
);

/// The contract's 201 body — `AuthenticatedResult` (tokens + profile).
Map<String, dynamic> _authenticated201() => {
      'result': 'authenticated',
      'tokens': {
        'accessToken': 'access.jwt',
        'accessExpiresInSeconds': 900,
        'refreshToken': 'refresh.jwt',
        'refreshExpiresInSeconds': 5184000,
      },
      'profile': {'id': 'student-1', 'track': 'school', 'name': 'Nour Hassan'},
    };

Response<Map<String, dynamic>> _created(Map<String, dynamic> data) =>
    Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/auth/register'),
      statusCode: 201,
      data: data,
    );

/// The ErrorInterceptor has already mapped the failure onto `DioException.error`
/// by the time a repository sees it.
DioException _mapped(AppException mapped) => DioException(
      requestOptions: RequestOptions(path: '/auth/register'),
      error: mapped,
    );

void main() {
  late MockDio dio;
  late RegistrationRepository repo;

  setUp(() {
    dio = MockDio();
    repo = RegistrationRepository(dio);
  });

  void stubPost(Object answer) {
    final call = when(
      () => dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: any<Object?>(named: 'data'),
      ),
    );
    if (answer is Response<Map<String, dynamic>>) {
      call.thenAnswer((_) async => answer);
    } else {
      call.thenThrow(answer);
    }
  }

  group('201 — register logs you in', () {
    test('parses the AuthenticatedResult (tokens + profile)', () async {
      stubPost(_created(_authenticated201()));

      final result = await repo.register(_schoolBody);

      expect(result, isA<AuthenticatedResult>());
      expect(result.tokens.accessToken, 'access.jwt');
      expect(result.tokens.refreshToken, 'refresh.jwt');
      expect(result.profile['id'], 'student-1');
    });

    test('posts the discriminated school body to /auth/register', () async {
      stubPost(_created(_authenticated201()));
      await repo.register(_schoolBody);

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: captureAny<Object?>(named: 'data'),
        ),
      ).captured.single as Map<String, dynamic>;

      expect(captured['track'], 'school');
      expect(captured['schoolId'], 'school-42');
      expect(captured['dateOfBirth'], '2009-05-01');
    });

    test('posts the discriminated university body', () async {
      stubPost(_created(_authenticated201()));
      await repo.register(_universityBody);

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: captureAny<Object?>(named: 'data'),
        ),
      ).captured.single as Map<String, dynamic>;

      expect(captured['track'], 'university');
      expect(captured['studyYearId'], 'year-2');
      expect(captured.containsKey('countryCode'), isFalse);
    });

    test('a non-authenticated 201 is contract drift, not silently coerced', () {
      stubPost(
        _created({
          'result': 'registrationRequired',
          'registrationToken': 'x',
          'expiresInSeconds': 600,
        }),
      );

      expect(repo.register(_schoolBody), throwsA(isA<UnknownException>()));
    });
  });

  group('errors surface as the typed AppException the screen branches on', () {
    test('400 validation_failed → ValidationException with the field map', () {
      stubPost(
        _mapped(
          const ValidationException(
            errors: {
              'schoolName': ['not allowed when countryCode is EG'],
            },
          ),
        ),
      );

      expect(
        repo.register(_schoolBody),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.fields, 'fields', contains('schoolName')),
        ),
      );
    });

    test('401 registration_token_invalid → UnauthorizedException', () {
      stubPost(
        _mapped(
          const UnauthorizedException(code: 'registration_token_invalid'),
        ),
      );

      expect(
        repo.register(_schoolBody),
        throwsA(
          isA<UnauthorizedException>()
              .having((e) => e.code, 'code', 'registration_token_invalid'),
        ),
      );
    });

    test('409 phone_already_registered → ApiException(409)', () {
      stubPost(
        _mapped(
          const ApiException(status: 409, code: 'phone_already_registered'),
        ),
      );

      expect(
        repo.register(_schoolBody),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', 409)
              .having((e) => e.code, 'code', 'phone_already_registered'),
        ),
      );
    });

    test('connectivity failure → NetworkException (drives Offline)', () {
      stubPost(_mapped(const NetworkException(detail: 'timeout')));
      expect(repo.register(_schoolBody), throwsA(isA<NetworkException>()));
    });

    test('anything bypassing the interceptor → UnknownException', () {
      stubPost(DioException(requestOptions: RequestOptions(path: '/x')));
      expect(repo.register(_schoolBody), throwsA(isA<UnknownException>()));
    });
  });
}
