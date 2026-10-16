import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';

/// SEIF1014 / SSG: the mock serves `GET /reference/school-stages`, puts a
/// `status` on every education system, and refuses a School registration whose
/// stage or education system is not open — `422 school_stage_not_available` /
/// `education_system_not_available`, through the REAL ErrorInterceptor — the way
/// the contract (3.52.0-m1) says the server does.
///
/// The LAUNCH rule is the default (Seif's message of 2026-10-12): only
/// `secondary2` and `secondary3`, and only `nationalArabic` and
/// `nationalLanguages`, are open. `kMockSchoolRegistrationAllOpen` flips it to
/// "everything open" (staging's test accounts); a test reaches that through
/// `buildMockDio(schoolRegistrationAllOpen: true)` rather than by editing the
/// constant.

const _stagesInOrder = [
  'prep1',
  'prep2',
  'prep3',
  'secondary1',
  'secondary2',
  'secondary3',
];

/// The mapped `AppException` behind a rejected mock call.
Future<AppException> _failure(Future<void> Function() call) async {
  try {
    await call();
    fail('expected the mock to reject this request');
  } on DioException catch (e) {
    return e.error! as AppException;
  }
}

Map<String, dynamic> _schoolBody({
  String stage = 'secondary2',
  String educationSystem = 'nationalArabic',
  String? cityId = '0197b2f3-0002-7cc3-9b4e-000000000001',
  String? cityName,
}) => <String, dynamic>{
  'track': 'school',
  'registrationToken': 'mock.registration.token',
  'name': 'Nour Hassan',
  'dateOfBirth': '2009-05-01',
  'countryCode': 'EG',
  'governorateId': '0197b2f3-0001-7cc3-9b4e-000000000001',
  'cityId': ?cityId,
  'cityName': ?cityName,
  'stage': stage,
  'educationSystem': educationSystem,
  'parentPhone': '+2010000000001',
};

Map<String, dynamic> _universityBody() => <String, dynamic>{
  'track': 'university',
  'registrationToken': 'mock.registration.token',
  'name': 'Nour Hassan',
  'dateOfBirth': '2004-03-07',
  'universityId': '0197b2f3-0005-7cc3-9b4e-000000000001',
  'facultyId': '0197b2f3-0006-7cc3-9b4e-000000000001',
  'studyYearId': '0197b2f3-0007-7cc3-9b4e-000000000001',
  'governorateId': '0197b2f3-0001-7cc3-9b4e-000000000001',
  'cityId': '0197b2f3-0002-7cc3-9b4e-000000000001',
  'parentPhone': '+2010000000001',
};

Future<List<SchoolStageRef>> _stages(Dio dio) async => [
  for (final row in (await dio.get<List<dynamic>>(
    '/reference/school-stages',
  )).data!)
    SchoolStageRef.fromJson(row as Map<String, dynamic>),
];

Future<List<EducationSystemRef>> _systems(Dio dio) async => [
  for (final row in (await dio.get<List<dynamic>>(
    '/reference/education-systems',
  )).data!)
    EducationSystemRef.fromJson(row as Map<String, dynamic>),
];

void main() {
  group('GET /reference/school-stages', () {
    test('serves all six stages in the fixed order, parsed by the REAL '
        'model, with nothing but {stage, status}', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res = await dio.get<List<dynamic>>('/reference/school-stages');

      expect(res.statusCode, 200);
      expect(res.data, hasLength(6));
      expect(
        [for (final row in res.data!) (row as Map).keys.toSet()],
        [
          for (var i = 0; i < 6; i++) {'stage', 'status'},
        ],
      );
      expect((await _stages(dio)).map((s) => s.stage), _stagesInOrder);
    });

    test('the LAUNCH rule is the default: only secondary2 and secondary3 are '
        'active', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final stages = await _stages(dio);

      expect(
        {for (final s in stages) s.stage: s.status},
        {
          'prep1': 'soon',
          'prep2': 'soon',
          'prep3': 'soon',
          'secondary1': 'soon',
          'secondary2': 'active',
          'secondary3': 'active',
        },
      );
    });

    test('all-open: every stage is active, still all six in order', () async {
      final dio = buildMockDio(
        latency: Duration.zero,
        schoolRegistrationAllOpen: true,
      );

      final stages = await _stages(dio);

      expect(stages.map((s) => s.stage), _stagesInOrder);
      expect(stages.map((s) => s.status).toSet(), {'active'});
    });
  });

  group('GET /reference/education-systems', () {
    test('every row carries a status; LAUNCH rule: only nationalArabic and '
        'nationalLanguages are active', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final systems = await _systems(dio);

      expect(
        {for (final s in systems) s.code: s.status},
        {
          'nationalArabic': 'active',
          'nationalLanguages': 'active',
          'ig': 'soon',
          'american': 'soon',
          'ib': 'soon',
        },
      );
    });

    test('all-open: every system is active', () async {
      final dio = buildMockDio(
        latency: Duration.zero,
        schoolRegistrationAllOpen: true,
      );

      expect((await _systems(dio)).map((s) => s.status).toSet(), {'active'});
    });
  });

  group('POST /auth/register · School availability (spec-081)', () {
    test('secondary2 + nationalArabic is a 201', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res = await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(),
      );

      expect(res.statusCode, 201);
      expect(res.data!['result'], 'authenticated');
    });

    test('secondary3 + nationalLanguages is a 201 too', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res = await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(
          stage: 'secondary3',
          educationSystem: 'nationalLanguages',
        ),
      );

      expect(res.statusCode, 201);
    });

    for (final stage in ['prep1', 'prep2', 'prep3', 'secondary1']) {
      test('a closed stage ($stage) is 422 school_stage_not_available, typed '
          'by the real ErrorInterceptor', () async {
        final dio = buildMockDio(latency: Duration.zero);

        final error = await _failure(
          () => dio.post<Map<String, dynamic>>(
            '/auth/register',
            data: _schoolBody(stage: stage),
          ),
        );

        expect(error, isA<ApiException>());
        expect((error as ApiException).status, 422);
        expect(error.code, 'school_stage_not_available');
      });
    }

    for (final system in ['ig', 'american', 'ib']) {
      test('a closed system ($system) with an open stage is 422 '
          'education_system_not_available', () async {
        final dio = buildMockDio(latency: Duration.zero);

        final error = await _failure(
          () => dio.post<Map<String, dynamic>>(
            '/auth/register',
            data: _schoolBody(educationSystem: system),
          ),
        );

        expect((error as ApiException).status, 422);
        expect(error.code, 'education_system_not_available');
      });
    }

    test('BOTH closed → school_stage_not_available (the stage wins)', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(stage: 'prep1', educationSystem: 'ib'),
        ),
      );

      expect((error as ApiException).code, 'school_stage_not_available');
    });

    test('a 400 comes first: a body that is both invalid and closed is '
        'validation_failed', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(stage: 'prep1', cityId: null),
        ),
      );

      expect(error, isA<ValidationException>());
      expect((error as ValidationException).fields, contains('cityId'));
    });

    test('NOTHING is written on a 422: the next /me is the untouched fixture '
        'and a later 201 is what registers', () async {
      final dio = buildMockDio(latency: Duration.zero);

      await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(
            stage: 'prep1',
            cityId: null,
            cityName: 'Somewhere Uncoded',
          ),
        ),
      );
      final afterRefusal = StudentProfile.fromJson(
        (await dio.get<Map<String, dynamic>>('/me')).data!,
      );
      expect(
        afterRefusal.geography.city,
        isA<CodedCity>(),
        reason: 'the refused free-text city must not have been remembered',
      );

      // The same body with an open stage is accepted, and only now is the
      // registered city remembered.
      await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(cityId: null, cityName: 'Somewhere Uncoded'),
      );
      final afterRegistration = StudentProfile.fromJson(
        (await dio.get<Map<String, dynamic>>('/me')).data!,
      );
      expect(afterRegistration.geography.city, isA<FreeTextCity>());
    });

    test(
      'all-open: a closed-under-launch stage and system now register',
      () async {
        final dio = buildMockDio(
          latency: Duration.zero,
          schoolRegistrationAllOpen: true,
        );

        final res = await dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(stage: 'prep1', educationSystem: 'ib'),
        );

        expect(res.statusCode, 201);
      },
    );

    test('the University body is not affected', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res = await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _universityBody(),
      );

      expect(res.statusCode, 201);
    });
  });
}
