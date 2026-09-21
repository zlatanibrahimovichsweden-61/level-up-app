import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';
import 'package:level_up_app/features/profile/models/student_profile.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';

import 'catalog_fixtures.dart';

/// Contract keys are camelCase, so a `@JsonKey(name:)` bridge would be a bug
/// here, not a safeguard. Required fields have NO defaults: a missing one must
/// throw, because that is contract drift surfacing the moment it happens rather
/// than a student being shown `0 / 0` that the server never sent.
void main() {
  group('Subject', () {
    test('parses a row of GET /catalog/subjects', () {
      final subject = Subject.fromJson(
        subjectsJson().first as Map<String, dynamic>,
      );

      expect(subject.id, 'sub-1');
      expect(subject.name, 'Biology');
      expect(subject.questionCounter.answered, 216);
      expect(subject.questionCounter.total, 480);
    });

    test('a missing required field throws rather than defaulting', () {
      expect(
        () => Subject.fromJson(<String, dynamic>{
          'id': 'sub-1',
          'name': 'Biology',
          // questionCounter absent — contract-required
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('QuestionCounter.fraction', () {
    test('is answered/total', () {
      expect(
        const QuestionCounter(answered: 216, total: 480).fraction,
        closeTo(0.45, 0.001),
      );
    });

    test('a subject with no questions is 0, not NaN', () {
      // The bar must draw empty, not crash the grid.
      expect(const QuestionCounter(answered: 0, total: 0).fraction, 0);
    });

    test('is clamped, so bad server data cannot overflow the bar', () {
      expect(const QuestionCounter(answered: 500, total: 480).fraction, 1);
      expect(const QuestionCounter(answered: -5, total: 480).fraction, 0);
    });
  });

  group('SchoolSubjectTree', () {
    test('parses the whole nested structure from one payload', () {
      final tree = schoolTree();

      expect(tree.track, Track.school);
      expect(tree.units, hasLength(2));

      final unit = tree.units.first;
      expect(unit.id, 'unit-1');
      expect(unit.name, 'Cell Biology');
      expect(unit.chapters, hasLength(2));

      final chapter = unit.chapters.first;
      expect(chapter.id, 'chap-1');
      expect(chapter.lessons, hasLength(2));

      final lesson = chapter.lessons.first;
      expect(lesson.id, 'lesson-1');
      expect(lesson.name, 'Cell Structure');
      expect(lesson.questionCounter.total, 25);
    });

    test('an empty level parses as empty, not as an error', () {
      final tree = schoolTree();
      expect(tree.units.last.chapters.single.lessons, isEmpty);
    });

    test('a tree with no units at all parses', () {
      final tree = SchoolSubjectTree.fromJson(<String, dynamic>{
        'track': 'school',
        'units': <dynamic>[],
      });
      expect(tree.units, isEmpty);
    });

    test('a missing required field throws', () {
      expect(
        () => SchoolSubjectTree.fromJson(<String, dynamic>{'track': 'school'}),
        throwsA(isA<TypeError>()),
      );
    });

    test('an unknown track value throws — the discriminator is closed', () {
      expect(
        () => SchoolSubjectTree.fromJson(<String, dynamic>{
          'track': 'martian',
          'units': <dynamic>[],
        }),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('UniversitySubjectTree', () {
    test('parses the university branch of the oneOf', () {
      final tree = universityTree();

      expect(tree.track, Track.university);
      expect(tree.lectures.map((l) => l.name), [
        'Upper Limb',
        'Lower Limb',
        'Thorax',
      ]);
      expect(tree.lectures.first.id, 'lec-1');
    });

    test('lectures carry a questionCounter — unlike school units/chapters', () {
      final tree = universityTree();

      expect(tree.lectures[0].questionCounter.answered, 0);
      expect(tree.lectures[0].questionCounter.total, 60);
      expect(tree.lectures[1].questionCounter.fraction, closeTo(0.5, 0.001));
      expect(tree.lectures[2].questionCounter.fraction, 1.0);
    });

    test('hasFlashcards parses per lecture — contract 3.12.0-m1', () {
      final tree = universityTree();

      // Varies across the fixture on purpose: a surface that hardcoded the
      // affordance would pass on an all-true tree.
      expect(tree.lectures.map((l) => l.hasFlashcards), [true, false, true]);
    });

    test(
      'hasFlashcards is REQUIRED — an omitted one throws, never defaults',
      () {
        // `required: [id, name, questionCounter, hasFlashcards]`
        // (`openapi.yaml:2569`). A `?? false` would hide a whole surface for a
        // lecture that has flashcards, and never fail while doing it.
        expect(
          () => universityTree(
            lectures: <dynamic>[
              <String, dynamic>{
                'id': 'lec-x',
                'name': 'No flag',
                'questionCounter': counterJson(0, 10),
              },
            ],
          ),
          throwsA(isA<TypeError>()),
        );
      },
    );

    test('quizTypes parse as the contract enum, in server order', () {
      final tree = universityTree(
        quizTypes: <String>['practicalRevision', 'normal'],
      );

      expect(tree.quizTypes, [QuizType.practicalRevision, QuizType.normal]);
    });

    test('a quiz type outside the contract enum throws', () {
      // The contract does NOT mark this set extensible, so an unknown value is
      // drift — it must not be silently dropped from the tab row.
      expect(
        () => universityTree(quizTypes: <String>['flashcard']),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('a subject with no lectures parses — that is EMPTY, not an error', () {
      expect(universityTree(lectures: <dynamic>[]).lectures, isEmpty);
    });

    test('a missing required field throws', () {
      expect(
        () => UniversitySubjectTree.fromJson(<String, dynamic>{
          'track': 'university',
          'quizTypes': <dynamic>[],
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('the sealed union', () {
    test('both branches ARE a SubjectTree, and are told apart by type', () {
      const SubjectTree school = SchoolSubjectTree(
        track: Track.school,
        units: [],
      );
      final SubjectTree university = universityTree();

      expect(school, isA<SubjectTree>());
      expect(university, isA<SubjectTree>());
      expect(school, isNot(isA<UniversitySubjectTree>()));
      expect(university, isNot(isA<SchoolSubjectTree>()));
    });

    test('the runtime type and the parsed track agree', () {
      // Both are checked because the screens switch on the TYPE while the
      // repository dispatched on the VALUE — if those two ever disagreed, a
      // school payload could render as a lecture list.
      for (final tree in <SubjectTree>[schoolTree(), universityTree()]) {
        expect(switch (tree) {
          SchoolSubjectTree() => Track.school,
          UniversitySubjectTree() => Track.university,
        }, tree.track);
      }
    });
  });
}
