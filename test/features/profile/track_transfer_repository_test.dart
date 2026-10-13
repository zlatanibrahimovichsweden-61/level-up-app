import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/models/track_transfer_request.dart';
import 'package:level_up_app/features/profile/repository/track_transfer_repository.dart';
import 'package:level_up_app/features/profile/track_transfer_errors.dart';
import 'package:mocktail/mocktail.dart';

import 'profile_fixtures.dart';

class _MockDio extends Mock implements Dio {}

/// `POST /me/track-transfer` (`transferToUniversity`): the body the app builds,
/// the profile it decodes, and the typed errors it hands back.
void main() {
  late _MockDio dio;
  late TrackTransferRepository repo;

  const path = '/me/track-transfer';
  const request = TrackTransferRequest(
    universityId: '0197b2f3-0005-7cc3-9b4e-000000000001',
    facultyId: '0197b2f3-0006-7cc3-9b4e-000000000001',
    studyYearId: '0197b2f3-0007-7cc3-9b4e-000000000001',
  );

  setUp(() {
    dio = _MockDio();
    repo = TrackTransferRepository(dio);
  });

  Response<Map<String, dynamic>> ok(Map<String, dynamic>? data) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: data,
      );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: path),
    error: mapped,
  );

  void stubPost(Map<String, dynamic>? body) {
    when(
      () => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')),
    ).thenAnswer((_) async => ok(body));
  }

  void stubPostThrows(Object error) {
    when(
      () => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')),
    ).thenThrow(error);
  }

  group('the request', () {
    test(
      'POSTs exactly the four contract keys to /me/track-transfer',
      () async {
        stubPost(universityProfileJson());

        await repo.transferToUniversity(request);

        final body =
            verify(
                  () => dio.post<Map<String, dynamic>>(
                    path,
                    data: captureAny(named: 'data'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(body, <String, dynamic>{
          'universityId': request.universityId,
          'facultyId': request.facultyId,
          'studyYearId': request.studyYearId,
          'acknowledgeIrreversible': true,
        });
      },
    );

    test(
      'acknowledgeIrreversible reaches the wire as the boolean true',
      () async {
        stubPost(universityProfileJson());

        await repo.transferToUniversity(request);

        final body =
            verify(
                  () => dio.post<Map<String, dynamic>>(
                    path,
                    data: captureAny(named: 'data'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(body['acknowledgeIrreversible'], same(true));
      },
    );

    test(
      'no other call is made: no second GET /me to re-read the profile',
      () async {
        stubPost(universityProfileJson());

        await repo.transferToUniversity(request);

        verify(
          () => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')),
        ).called(1);
        verifyNoMoreInteractions(dio);
      },
    );
  });

  group('the response', () {
    test(
      'decodes with the existing StudentProfile, now on University',
      () async {
        stubPost(universityProfileJson());

        final profile = await repo.transferToUniversity(request);

        expect(profile, isA<StudentProfile>());
        expect(profile.track, Track.university);
        expect(profile.school, isNull);
        expect(profile.university, isNotNull);
        expect(profile.university!.yearNumber, 1);
      },
    );

    test('the points are the server\'s, not recomputed', () async {
      final json = universityProfileJson();
      // Contract: school points stay, university points start where they are,
      // total carries. The repository must pass these through, whatever they are.
      json['points'] = <String, dynamic>{
        'school': 1000,
        'university': 250,
        'total': 1250,
      };
      stubPost(json);

      final profile = await repo.transferToUniversity(request);

      expect(profile.points.school, 1000);
      expect(profile.points.university, 250);
      expect(profile.points.total, 1250);
    });
  });

  group('refusals arrive as the typed exception the interceptor mapped', () {
    test('403 track_transfer_not_eligible', () async {
      const mapped = ApiException(
        status: 403,
        code: 'track_transfer_not_eligible',
      );
      stubPostThrows(failure(mapped));

      try {
        await repo.transferToUniversity(request);
        fail('should have thrown');
      } on Object catch (e) {
        expect(e, same(mapped));
        expect(isTrackTransferNotEligible(e), isTrue);
        expect(isTrackTransferNotAllowed(e), isFalse);
        expect(isAccountPendingDeletion(e), isFalse);
      }
    });

    test('409 track_transfer_not_allowed', () async {
      const mapped = ApiException(
        status: 409,
        code: 'track_transfer_not_allowed',
      );
      stubPostThrows(failure(mapped));

      try {
        await repo.transferToUniversity(request);
        fail('should have thrown');
      } on Object catch (e) {
        expect(e, same(mapped));
        expect(isTrackTransferNotAllowed(e), isTrue);
        expect(isTrackTransferNotEligible(e), isFalse);
      }
    });

    test('403 account_pending_deletion is surfaced untouched', () async {
      const mapped = ApiException(
        status: 403,
        code: 'account_pending_deletion',
      );
      stubPostThrows(failure(mapped));

      try {
        await repo.transferToUniversity(request);
        fail('should have thrown');
      } on Object catch (e) {
        expect(e, same(mapped));
        expect(isAccountPendingDeletion(e), isTrue);
        expect(isTrackTransferNotEligible(e), isFalse);
      }
    });

    test('400 validation_failed keeps the field map', () async {
      const mapped = ValidationException(
        errors: {
          'studyYearId': ['not an active year'],
        },
      );
      stubPostThrows(failure(mapped));

      try {
        await repo.transferToUniversity(request);
        fail('should have thrown');
      } on ValidationException catch (e) {
        expect(e, same(mapped));
        expect(e.fields, ['studyYearId']);
      }
    });

    final others = <String, AppException>{
      '401 session_superseded': const UnauthorizedException(
        code: 'session_superseded',
      ),
      '401 authentication_required': const UnauthorizedException(
        code: 'authentication_required',
      ),
      'offline': const OfflineException(),
      'timeout': const NetworkException(detail: 'timeout'),
      '500': const ApiException(status: 500, code: 'internal_error'),
    };
    for (final entry in others.entries) {
      test(entry.key, () async {
        stubPostThrows(failure(entry.value));

        await expectLater(
          repo.transferToUniversity(request),
          throwsA(same(entry.value)),
        );
      });
    }

    test(
      'a DioException that bypassed the interceptor becomes UnknownException',
      () async {
        stubPostThrows(
          DioException(requestOptions: RequestOptions(path: path)),
        );

        await expectLater(
          repo.transferToUniversity(request),
          throwsA(isA<UnknownException>()),
        );
      },
    );

    test('a refused call is not retried by the repository', () async {
      stubPostThrows(
        failure(
          const ApiException(status: 409, code: 'track_transfer_not_allowed'),
        ),
      );

      await expectLater(
        repo.transferToUniversity(request),
        throwsA(isA<ApiException>()),
      );

      verify(
        () => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')),
      ).called(1);
    });
  });

  group('schema drift stays inside the typed boundary', () {
    test('a profile missing a required field is an UnknownException', () async {
      final json = universityProfileJson()..remove('points');
      stubPost(json);

      await expectLater(
        repo.transferToUniversity(request),
        throwsA(isA<UnknownException>()),
      );
    });

    test('an empty body is an UnknownException', () async {
      stubPost(null);

      await expectLater(
        repo.transferToUniversity(request),
        throwsA(isA<UnknownException>()),
      );
    });

    test(
      'the error detail carries the runtime type only, never profile data',
      () async {
        final json = universityProfileJson();
        json['points'] = 'not a map';
        stubPost(json);

        try {
          await repo.transferToUniversity(request);
          fail('should have thrown');
        } on UnknownException catch (e) {
          expect(e.detail, startsWith('parse: '));
          expect(e.detail, isNot(contains('Mona')));
          expect(e.detail, isNot(contains('+2010')));
        }
      },
    );
  });

  test('nothing is printed on the success or failure path', () async {
    final printed = <String>[];
    await runZoned(
      () async {
        stubPost(universityProfileJson());
        await repo.transferToUniversity(request);
        stubPostThrows(
          failure(
            const ApiException(
              status: 403,
              code: 'track_transfer_not_eligible',
            ),
          ),
        );
        await repo
            .transferToUniversity(request)
            .then<void>((_) {}, onError: (Object _) {});
      },
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => printed.add(line),
      ),
    );

    expect(printed, isEmpty);
  });
}
