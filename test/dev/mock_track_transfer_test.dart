import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/dev/mock_track_transfer.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/profile/models/track_transfer_request.dart';
import 'package:level_up_app/features/profile/repository/track_transfer_repository.dart';
import 'package:level_up_app/features/profile/track_transfer_errors.dart';

import '../features/profile/profile_fixtures.dart';

/// `POST /me/track-transfer`, served by the on-device mock.
///
/// The desk is driven both directly (the rules, in the contract's order of
/// refusals) and through the REAL [TrackTransferRepository] and the REAL
/// `ErrorInterceptor`, by a Dio whose session mirrors what `mock_backend.dart`
/// does around the desk: it owns the track and the stage, passes them in, and on
/// [MockTrackTransferDone] flips to University and answers the University
/// profile. So these prove the mock enforces the contract and that the request
/// the app builds is the one the mock understands.
void main() {
  // Same shape as the mock backend's `/reference/universities` rows, with ids in
  // the same UUID form.
  const cairo = '0197b2f3-0005-7cc3-9b4e-000000000001';
  const ainShams = '0197b2f3-0005-7cc3-9b4e-000000000002';
  const cairoMedicine = '0197b2f3-0006-7cc3-9b4e-000000000001';
  const cairoPharmacy = '0197b2f3-0006-7cc3-9b4e-000000000002';
  const ainShamsMedicine = '0197b2f3-0006-7cc3-9b4e-000000000003';
  const medYear1 = '0197b2f3-0007-7cc3-9b4e-000000000001';
  const medYear2 = '0197b2f3-0007-7cc3-9b4e-000000000002';
  const medYear4Soon = '0197b2f3-0007-7cc3-9b4e-000000000004';
  const pharmacyYear1 = '0197b2f3-0007-7cc3-9b4e-000000000006';
  const ainShamsYear1 = '0197b2f3-0007-7cc3-9b4e-000000000008';

  Map<String, dynamic> year(String id, int n, String status) =>
      <String, dynamic>{'id': id, 'yearNumber': n, 'status': status};

  final universities = <dynamic>[
    <String, dynamic>{
      'id': cairo,
      'nameAr': 'جامعة القاهرة',
      'nameEn': 'Cairo University',
      'faculties': <dynamic>[
        <String, dynamic>{
          'id': cairoMedicine,
          'nameAr': 'كلية الطب البشري',
          'nameEn': 'Faculty of Human Medicine',
          'years': <dynamic>[
            year(medYear1, 1, 'active'),
            year(medYear2, 2, 'active'),
            year(medYear4Soon, 4, 'soon'),
          ],
        },
        <String, dynamic>{
          'id': cairoPharmacy,
          'nameAr': 'كلية الصيدلة',
          'nameEn': 'Faculty of Pharmacy',
          'years': <dynamic>[year(pharmacyYear1, 1, 'active')],
        },
      ],
    },
    <String, dynamic>{
      'id': ainShams,
      'nameAr': 'جامعة عين شمس',
      'nameEn': 'Ain Shams University',
      'faculties': <dynamic>[
        <String, dynamic>{
          'id': ainShamsMedicine,
          'nameAr': 'كلية الطب البشري',
          'nameEn': 'Faculty of Human Medicine',
          'years': <dynamic>[year(ainShamsYear1, 1, 'active')],
        },
      ],
    },
  ];

  late MockTrackTransferDesk desk;

  setUp(() => desk = MockTrackTransferDesk());

  Map<String, dynamic> validBody() => <String, dynamic>{
    'universityId': cairo,
    'facultyId': cairoMedicine,
    'studyYearId': medYear2,
    'acknowledgeIrreversible': true,
  };

  MockTrackTransferReply? post(
    Map<String, dynamic> body, {
    String track = 'school',
    String? stage = 'secondary3',
  }) => desk.handle(
    'POST',
    '/me/track-transfer',
    body,
    track: track,
    stage: stage,
    universities: universities,
  );

  Map<String, List<String>> fieldsOf(MockTrackTransferReply? reply) {
    expect(reply, isA<MockTrackTransferValidation>());
    return (reply! as MockTrackTransferValidation).errors;
  }

  group('a valid transfer by a final-year school student', () {
    test('is accepted and carries the chosen University block', () {
      final reply = post(validBody());

      expect(reply, isA<MockTrackTransferDone>());
      final block = (reply! as MockTrackTransferDone).university;
      expect(block['university'], <String, dynamic>{
        'id': cairo,
        'nameAr': 'جامعة القاهرة',
        'nameEn': 'Cairo University',
      });
      expect(block['faculty'], <String, dynamic>{
        'id': cairoMedicine,
        'nameAr': 'كلية الطب البشري',
        'nameEn': 'Faculty of Human Medicine',
      });
      expect(block['yearNumber'], 2);
    });

    test('any ACTIVE year may be chosen, not only the first', () {
      for (final (id, n) in [(medYear1, 1), (medYear2, 2)]) {
        final reply = post({...validBody(), 'studyYearId': id});

        expect((reply! as MockTrackTransferDone).university['yearNumber'], n);
      }
    });

    test('the block decodes as a ProfileUniversity', () {
      final reply = post(validBody())! as MockTrackTransferDone;

      final university = ProfileUniversity.fromJson(reply.university);

      expect(university.university.nameEn, 'Cairo University');
      expect(university.faculty.nameEn, 'Faculty of Human Medicine');
      expect(university.yearNumber, 2);
    });
  });

  group('the contract\'s order of refusals', () {
    test('409 track_transfer_not_allowed comes first: already University', () {
      // Even with a garbage body AND a stage that would also be ineligible.
      final reply = post(
        <String, dynamic>{'universityId': 'nope'},
        track: 'university',
        stage: 'secondary1',
      );

      expect(reply, isA<MockTrackTransferProblem>());
      final problem = reply! as MockTrackTransferProblem;
      expect(problem.status, 409);
      expect(problem.code, 'track_transfer_not_allowed');
    });

    test('403 track_transfer_not_eligible comes before body validation', () {
      // Every member of the contract's `Stage` enum (openapi.yaml:4109) except
      // the final one, `secondary3`.
      for (final stage in [
        'prep1',
        'prep2',
        'prep3',
        'secondary1',
        'secondary2',
      ]) {
        final reply = post(<String, dynamic>{}, stage: stage);

        final problem = reply! as MockTrackTransferProblem;
        expect(problem.status, 403, reason: stage);
        expect(problem.code, 'track_transfer_not_eligible', reason: stage);
      }
    });

    test('an unknown stage cannot be proven eligible', () {
      final problem =
          post(validBody(), stage: null)! as MockTrackTransferProblem;

      expect(problem.code, 'track_transfer_not_eligible');
    });

    test('400 only once the student is eligible', () {
      final reply = post(<String, dynamic>{});

      expect(fieldsOf(reply).keys, containsAll(['universityId', 'facultyId']));
    });

    test('a refused call changes nothing: the desk keeps no state', () {
      post(<String, dynamic>{});
      post(validBody(), track: 'university');
      post(validBody(), stage: 'secondary2');

      expect(post(validBody()), isA<MockTrackTransferDone>());
    });
  });

  group('400 validation_failed names the field', () {
    test('every id missing', () {
      final errors = fieldsOf(
        post(<String, dynamic>{'acknowledgeIrreversible': true}),
      );

      expect(errors.keys, {'universityId', 'facultyId', 'studyYearId'});
    });

    test('an id that is not a UUID', () {
      for (final field in ['universityId', 'facultyId', 'studyYearId']) {
        final errors = fieldsOf(post({...validBody(), field: 'not-a-uuid'}));

        expect(errors.keys, contains(field), reason: field);
      }
    });

    test('an id that is not a string', () {
      expect(
        fieldsOf(post({...validBody(), 'universityId': 7})).keys,
        contains('universityId'),
      );
    });

    test('an unknown university', () {
      final errors = fieldsOf(
        post({
          ...validBody(),
          'universityId': '0197b2f3-0005-7cc3-9b4e-0000000000ff',
        }),
      );

      expect(errors.keys, ['universityId']);
    });

    test('a faculty outside the university', () {
      final errors = fieldsOf(
        post({...validBody(), 'facultyId': ainShamsMedicine}),
      );

      expect(errors.keys, ['facultyId']);
    });

    test('a study year that is not a year of that faculty', () {
      final errors = fieldsOf(
        post({...validBody(), 'studyYearId': pharmacyYear1}),
      );

      expect(errors.keys, ['studyYearId']);
    });

    test('a `soon` study year is refused', () {
      final errors = fieldsOf(
        post({...validBody(), 'studyYearId': medYear4Soon}),
      );

      expect(errors.keys, ['studyYearId']);
    });

    test('acknowledgeIrreversible missing', () {
      final body = validBody()..remove('acknowledgeIrreversible');

      expect(fieldsOf(post(body)).keys, ['acknowledgeIrreversible']);
    });

    test('acknowledgeIrreversible must be the boolean true', () {
      for (final bad in <Object?>[false, null, 'true', 1, 'yes']) {
        final errors = fieldsOf(
          post({...validBody(), 'acknowledgeIrreversible': bad}),
        );

        expect(errors.keys, ['acknowledgeIrreversible'], reason: '$bad');
      }
    });

    test('several problems are reported together', () {
      final errors = fieldsOf(
        post({
          ...validBody(),
          'studyYearId': medYear4Soon,
          'acknowledgeIrreversible': false,
        }),
      );

      expect(errors.keys.toSet(), {'studyYearId', 'acknowledgeIrreversible'});
    });
  });

  group('only that one route is served', () {
    test('other methods on the path fall through', () {
      for (final method in ['GET', 'PUT', 'PATCH', 'DELETE']) {
        final reply = desk.handle(
          method,
          '/me/track-transfer',
          validBody(),
          track: 'school',
          stage: 'secondary3',
          universities: universities,
        );

        expect(reply, isNull, reason: method);
      }
    });

    test('other paths fall through', () {
      final reply = desk.handle(
        'POST',
        '/me/track-transfers',
        validBody(),
        track: 'school',
        stage: 'secondary3',
        universities: universities,
      );

      expect(reply, isNull);
    });
  });

  group('through the real repository', () {
    test('a final-year student transfers once, then the account is University '
        'and a second attempt is 409', () async {
      final session = _Session(
        desk,
        universities,
        track: 'school',
        stage: 'secondary3',
      );
      final repo = TrackTransferRepository(session.dio);
      const request = TrackTransferRequest(
        universityId: cairo,
        facultyId: cairoMedicine,
        studyYearId: medYear2,
      );

      final profile = await repo.transferToUniversity(request);

      expect(profile.track, Track.university);
      expect(profile.school, isNull);
      expect(profile.university!.university.id, cairo);
      expect(profile.university!.faculty.id, cairoMedicine);
      expect(profile.university!.yearNumber, 2);
      expect(session.track, 'university');

      try {
        await repo.transferToUniversity(request);
        fail('the second transfer must be refused');
      } on Object catch (e) {
        expect(isTrackTransferNotAllowed(e), isTrue);
        expect((e as ApiException).status, 409);
      }
    });

    test(
      'a school student below the final year gets 403 not_eligible',
      () async {
        final session = _Session(
          desk,
          universities,
          track: 'school',
          stage: 'secondary2',
        );
        final repo = TrackTransferRepository(session.dio);

        try {
          await repo.transferToUniversity(
            const TrackTransferRequest(
              universityId: cairo,
              facultyId: cairoMedicine,
              studyYearId: medYear1,
            ),
          );
          fail('should have been refused');
        } on Object catch (e) {
          expect(isTrackTransferNotEligible(e), isTrue);
          expect((e as ApiException).status, 403);
        }
        expect(session.track, 'school');
      },
    );

    test('a university student gets 409 not_allowed', () async {
      final session = _Session(
        desk,
        universities,
        track: 'university',
        stage: null,
      );
      final repo = TrackTransferRepository(session.dio);

      try {
        await repo.transferToUniversity(
          const TrackTransferRequest(
            universityId: cairo,
            facultyId: cairoMedicine,
            studyYearId: medYear1,
          ),
        );
        fail('should have been refused');
      } on Object catch (e) {
        expect(isTrackTransferNotAllowed(e), isTrue);
      }
    });

    test('a bad id arrives as a ValidationException on that field, and the '
        'track does not move', () async {
      final session = _Session(
        desk,
        universities,
        track: 'school',
        stage: 'secondary3',
      );
      final repo = TrackTransferRepository(session.dio);

      try {
        await repo.transferToUniversity(
          const TrackTransferRequest(
            universityId: cairo,
            facultyId: ainShamsMedicine,
            studyYearId: medYear1,
          ),
        );
        fail('should have been refused');
      } on ValidationException catch (e) {
        expect(e.fields, ['facultyId']);
      }
      expect(session.track, 'school');
    });
  });
}

/// The session `mock_backend.dart` keeps around the desk: it owns the track and
/// the stage, hands them to the desk, and on a success flips to University and
/// answers the University profile with the chosen `university` block.
class _Session {
  _Session(
    this.desk,
    this.universities, {
    required this.track,
    required this.stage,
  }) {
    dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api/v1'));
    dio.interceptors.addAll([_SessionInterceptor(this), ErrorInterceptor()]);
  }

  final MockTrackTransferDesk desk;
  final List<dynamic> universities;
  String track;
  String? stage;
  late final Dio dio;
  Map<String, dynamic>? movedTo;

  Map<String, dynamic> profile() {
    if (track == 'university') {
      return <String, dynamic>{
        ...universityProfileJson(),
        if (movedTo != null) 'university': movedTo,
      };
    }
    return schoolProfileJson();
  }
}

class _SessionInterceptor extends Interceptor {
  _SessionInterceptor(this.session);

  final _Session session;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = options.data is Map
        ? Map<String, dynamic>.from(options.data as Map)
        : const <String, dynamic>{};
    final reply = session.desk.handle(
      options.method.toUpperCase(),
      options.path,
      body,
      track: session.track,
      stage: session.stage,
      universities: session.universities,
    );
    switch (reply) {
      case MockTrackTransferDone(:final university):
        session.track = 'university';
        session.stage = null;
        session.movedTo = university;
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: 200,
            data: session.profile(),
          ),
        );
      case MockTrackTransferValidation(:final errors):
        _reject(handler, options, 400, <String, dynamic>{
          'status': 400,
          'code': 'validation_failed',
          'errors': errors,
        });
      case MockTrackTransferProblem(:final status, :final code, :final detail):
        _reject(handler, options, status, <String, dynamic>{
          'status': status,
          'code': code,
          'detail': detail,
        });
      case null:
        _reject(handler, options, 404, <String, dynamic>{
          'status': 404,
          'code': 'not_found',
        });
    }
  }

  void _reject(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    Map<String, dynamic> problem,
  ) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: problem,
        ),
      ),
      true,
    );
  }
}
