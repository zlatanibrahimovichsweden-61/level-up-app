import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

/// The harness is the ONLY place any of Day 7c can be exercised end to end —
/// per seif_fight.md S1 we have still never made a single real request and
/// `baseUrl` is `TBD.example`. If it kept validating the v1.0 shapes, a device
/// walkthrough would confirm the OLD contract and hide every fix this day made.
///
/// So these assert the mock is STRICT where the server is strict, not merely
/// that it answers.

/// The mapped `AppException` behind a rejected mock call — the harness runs the
/// REAL ErrorInterceptor, so this is the same type a screen would receive.
Future<AppException> _failure(Future<void> Function() call) async {
  try {
    await call();
    fail('expected the mock to reject this request');
  } on DioException catch (e) {
    return e.error! as AppException;
  }
}

Map<String, dynamic> _schoolBody({
  String? cityId = 'city-1',
  String? cityName,
  String? schoolId,
  String countryCode = 'EG',
  String? governorateId = '0197b2f3-0001-7cc3-9b4e-000000000001',
  bool includeSchoolName = false,
}) =>
    <String, dynamic>{
      'track': 'school',
      'registrationToken': 'mock.registration.token',
      'name': 'Nour Hassan',
      'dateOfBirth': '2009-05-01',
      'countryCode': countryCode,
      'governorateId': ?governorateId,
      'cityId': ?cityId,
      'cityName': ?cityName,
      'schoolId': ?schoolId,
      if (includeSchoolName) 'schoolName': 'Some Free Text',
      'stage': 'secondary1',
      'educationSystem': 'ig',
      'parentPhone': '+201021871999',
    };

void main() {
  group('POST /auth/register enforces adr-028', () {
    test('a coded-city, coded-school Egyptian registration succeeds', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res = await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(schoolId: 'school-42'),
      );

      expect(res.statusCode, 201);
      final profile =
          StudentProfile.fromJson(res.data!['profile']! as Map<String, dynamic>);
      expect(profile.school!.school!.id, 'school-42');
    });

    test('an Egyptian registration with NO school succeeds (adr-028 §2)',
        () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res = await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(),
      );

      expect(res.statusCode, 201);
      final profile =
          StudentProfile.fromJson(res.data!['profile']! as Map<String, dynamic>);
      expect(profile.school, isNotNull);
      expect(profile.school!.school, isNull);
    });

    test('schoolName is REJECTED as an unknown property, not echoed', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(includeSchoolName: true),
        ),
      );

      expect(error, isA<ValidationException>());
      expect((error as ValidationException).fields, contains('schoolName'));
    });

    test('neither cityId nor cityName is validation_failed', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(cityId: null),
        ),
      );

      expect((error as ValidationException).fields, contains('cityId'));
    });

    test('BOTH cityId and cityName is validation_failed', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(cityName: 'Al Ain'),
        ),
      );

      expect((error as ValidationException).fields, contains('cityName'));
    });

    test('a schoolId outside Egypt is rejected — the coded list is Egyptian',
        () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: _schoolBody(
            countryCode: 'AE',
            governorateId: null,
            schoolId: 'school-42',
          ),
        ),
      );

      expect((error as ValidationException).fields, contains('schoolId'));
    });
  });

  group('the profile echoes the city arm the registration actually used', () {
    test('a coded registration comes back as the CODED arm', () async {
      final dio = buildMockDio(latency: Duration.zero);

      await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(cityId: '0197b2f3-0002-7cc3-9b4e-000000000009'),
      );
      final profile = StudentProfile.fromJson(
        (await dio.get<Map<String, dynamic>>('/me')).data!,
      );

      expect(profile.geography.city, isA<CodedCity>());
      expect(
        (profile.geography.city as CodedCity).ref.id,
        '0197b2f3-0002-7cc3-9b4e-000000000009',
      );
    });

    test('a free-text registration comes back as the FREE-TEXT arm', () async {
      // The whole point: a free-text registration whose profile came back coded
      // would prove nothing, and the free-text arm is the one that used to
      // throw on a well-formed GET /me.
      final dio = buildMockDio(latency: Duration.zero);

      await dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: _schoolBody(cityId: null, cityName: 'Somewhere Uncoded'),
      );
      final profile = StudentProfile.fromJson(
        (await dio.get<Map<String, dynamic>>('/me')).data!,
      );

      expect(profile.geography.city, isA<FreeTextCity>());
      expect(
        (profile.geography.city as FreeTextCity).name,
        'Somewhere Uncoded',
      );
    });

    test('no profile fixture carries a schoolName key any more', () async {
      final dio = buildMockDio(latency: Duration.zero);
      final school = (await dio.get<Map<String, dynamic>>('/me')).data!['school']
          as Map<String, dynamic>;

      expect(school.containsKey('schoolName'), isFalse);
    });
  });

  group('the /reference/* failure paths v1.1 added', () {
    test('an unrecognised countryCode is 404 country_not_found', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.get<List<dynamic>>('/reference/countries/XX/governorates'),
      );

      expect(error, isA<ApiException>());
      expect((error as ApiException).status, 404);
      expect(error.code, 'country_not_found');
    });

    test('a MALFORMED countryCode is 400, not 404 — the split is easy to '
        'get backwards', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.get<List<dynamic>>('/reference/countries/EGY/governorates'),
      );

      expect(error, isA<ValidationException>());
    });

    test('country codes normalize case-insensitively', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final res =
          await dio.get<List<dynamic>>('/reference/countries/eg/governorates');

      expect(res.statusCode, 200);
      expect(res.data, isNotEmpty);
    });

    test('cities 404 on an unrecognised country too', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.get<List<dynamic>>(
          '/reference/cities',
          queryParameters: <String, dynamic>{'countryCode': 'XX'},
        ),
      );

      expect((error as ApiException).code, 'country_not_found');
    });

    test('the 429 trigger yields RateLimitedException with a parsed '
        'Retry-After', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.get<List<dynamic>>(
          '/reference/cities',
          queryParameters: <String, dynamic>{'countryCode': 'ZZ'},
        ),
      );

      expect(error, isA<RateLimitedException>());
      // Proves the header survives the mock -> real-interceptor -> parser path,
      // rather than the duration being invented client-side.
      expect(
        (error as RateLimitedException).retryAfter,
        const Duration(seconds: 30),
      );
    });

    test('governorates carry the same 429', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.get<List<dynamic>>('/reference/countries/ZZ/governorates'),
      );

      expect(error, isA<RateLimitedException>());
    });

    test('the school search has its own 429 trigger', () async {
      final dio = buildMockDio(latency: Duration.zero);

      final error = await _failure(
        () => dio.get<Map<String, dynamic>>(
          '/reference/schools',
          queryParameters: <String, dynamic>{'q': '429'},
        ),
      );

      expect(error, isA<RateLimitedException>());
    });

    test('every trigger row is reachable from the country picker', () async {
      // The triggers are only useful if a student can actually select them:
      // there is no way to type a country code into the form.
      final dio = buildMockDio(latency: Duration.zero);
      final codes = (await dio.get<List<dynamic>>('/reference/countries'))
          .data!
          .map((c) => (c as Map)['code'])
          .toList();

      expect(codes, containsAll(<String>['EG', 'AE', 'ZZ', 'XX', 'EGY']));
    });
  });
}
