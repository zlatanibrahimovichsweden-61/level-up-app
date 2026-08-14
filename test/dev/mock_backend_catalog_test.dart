import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';

/// The on-device preview harness must keep answering the catalog endpoints in
/// shapes the REAL models parse — otherwise the Learn tab renders its error
/// state on the device and the harness stops being a preview of anything.
///
/// If a model changes and the canned JSON is not updated, this fails here
/// instead of on a Pixel showing "Something went wrong".
void main() {
  test('mock GET /catalog/subjects parses into Subjects', () async {
    final dio = buildMockDio(latency: Duration.zero);

    final res = await dio.get<List<dynamic>>('/catalog/subjects');
    final subjects = res.data!
        .map((e) => Subject.fromJson(e as Map<String, dynamic>))
        .toList();

    expect(res.statusCode, 200);
    expect(subjects.length, greaterThanOrEqualTo(4));
    expect(subjects.every((s) => s.name.isNotEmpty), isTrue);
    // The harness deliberately serves both extremes of the counter so it is
    // visible on device that neither locks anything.
    expect(subjects.any((s) => s.questionCounter.fraction == 1), isTrue);
    expect(subjects.any((s) => s.questionCounter.total == 0), isTrue);
  });

  test('every mocked subject has a walkable tree', () async {
    final dio = buildMockDio(latency: Duration.zero);
    final subjects = (await dio.get<List<dynamic>>(
      '/catalog/subjects',
    )).data!.map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList();

    var withContent = 0;
    for (final subject in subjects) {
      final res = await dio.get<Map<String, dynamic>>(
        '/catalog/subjects/${subject.id}/tree',
      );
      final tree = SchoolSubjectTree.fromJson(res.data!);
      expect(tree.track, Track.school);
      if (tree.units.isEmpty) continue; // the deliberate empty-state subject

      withContent++;
      expect(tree.units.length, greaterThanOrEqualTo(2));
      expect(tree.units.first.chapters.length, greaterThanOrEqualTo(2));
      expect(
        tree.units.first.chapters.first.lessons.length,
        greaterThanOrEqualTo(2),
      );
    }
    expect(withContent, greaterThanOrEqualTo(1));
  });

  group('university mode (OTP code 111111)', () {
    /// Signs the harness in as a university student, the way you do on device.
    Future<Dio> universityDio() async {
      final dio = buildMockDio(latency: Duration.zero);
      await dio.post<Map<String, dynamic>>(
        '/auth/otp/verify',
        data: <String, dynamic>{'phone': '+201001234567', 'code': '111111'},
      );
      return dio;
    }

    test('GET /me comes back as a university profile', () async {
      final dio = await universityDio();

      final me = StudentProfile.fromJson(
        (await dio.get<Map<String, dynamic>>('/me')).data!,
      );

      expect(me.track, Track.university);
      expect(me.university, isNotNull);
      expect(me.school, isNull);
      expect(me.points.university, greaterThan(0));
    });

    test('every university subject has a walkable lecture tree', () async {
      final dio = await universityDio();
      final subjects = (await dio.get<List<dynamic>>(
        '/catalog/subjects',
      )).data!.map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList();

      expect(subjects.length, greaterThanOrEqualTo(3));

      var withLectures = 0;
      for (final subject in subjects) {
        final res = await dio.get<Map<String, dynamic>>(
          '/catalog/subjects/${subject.id}/tree',
        );
        final tree = UniversitySubjectTree.fromJson(res.data!);
        expect(tree.track, Track.university);
        if (tree.lectures.isEmpty) continue; // the deliberate empty-state one

        withLectures++;
        expect(tree.lectures.length, greaterThanOrEqualTo(3));
        expect(tree.quizTypes, isNotEmpty);
      }
      expect(withLectures, greaterThanOrEqualTo(1));
    });

    test(
      'quizTypes vary per subject, so the tab row cannot be hardcoded',
      () async {
        final dio = await universityDio();

        Future<List<QuizType>> typesOf(String id) async =>
            UniversitySubjectTree.fromJson(
              (await dio.get<Map<String, dynamic>>(
                '/catalog/subjects/$id/tree',
              )).data!,
            ).quizTypes;

        expect(await typesOf('uni-anatomy'), hasLength(4));
        // No practical component — the Practice tab must not appear here.
        expect(
          await typesOf('uni-physio'),
          isNot(contains(QuizType.practicalRevision)),
        );
        expect(await typesOf('uni-biochem'), [QuizType.normal]);
      },
    );

    test(
      'a school subject id is out of scope for a university student',
      () async {
        final dio = await universityDio();

        await expectLater(
          () => dio.get<Map<String, dynamic>>('/catalog/subjects/sub-bio/tree'),
          throwsA(
            isA<DioException>().having(
              (e) => e.response?.statusCode,
              'status',
              403,
            ),
          ),
        );
      },
    );
  });

  test('an out-of-scope subject answers the contract 403', () async {
    final dio = buildMockDio(latency: Duration.zero);

    await expectLater(
      () => dio.get<Map<String, dynamic>>('/catalog/subjects/not-mine/tree'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          403,
        ),
      ),
    );
  });
}
