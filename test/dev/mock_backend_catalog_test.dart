import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';

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
    final subjects = (await dio.get<List<dynamic>>('/catalog/subjects')).data!
        .map((e) => Subject.fromJson(e as Map<String, dynamic>))
        .toList();

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
