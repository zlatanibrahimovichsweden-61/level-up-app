/// Shared catalog fixtures, shaped from `contract/openapi.yaml`
/// (`GET /catalog/subjects`, `SchoolSubjectTree`, `QuestionCounter`) — not
/// hand-invented. Used by the model, repository, notifier, screen and router
/// tests so they all agree on one payload.
library;

import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';

Map<String, dynamic> counterJson(int answered, int total) => <String, dynamic>{
  'answered': answered,
  'total': total,
};

/// Three subjects that between them cover the counter's whole range: partway,
/// FINISHED (480/480) and EMPTY (0/0). The last two exist so tests can prove the
/// counter never gates anything.
List<dynamic> subjectsJson() => <dynamic>[
  <String, dynamic>{
    'id': 'sub-1',
    'name': 'Biology',
    'questionCounter': counterJson(216, 480),
  },
  <String, dynamic>{
    // `name` is already in the content language (adr-018) — Arabic here on
    // purpose, so the search tests exercise Arabic folding.
    'id': 'sub-2',
    'name': 'الكيمياء',
    'questionCounter': counterJson(480, 480),
  },
  <String, dynamic>{
    'id': 'sub-3',
    'name': 'Physics',
    'questionCounter': counterJson(0, 0),
  },
];

List<Subject> subjects() => subjectsJson()
    .map((e) => Subject.fromJson(e as Map<String, dynamic>))
    .toList();

/// Two units; the first has two chapters, the first of which has two lessons —
/// one untouched and one finished. The second unit's only chapter has NO
/// lessons, so the empty state at the deepest level is reachable.
Map<String, dynamic> schoolTreeJson() => <String, dynamic>{
  'track': 'school',
  'units': <dynamic>[
    <String, dynamic>{
      'id': 'unit-1',
      'name': 'Cell Biology',
      'chapters': <dynamic>[
        <String, dynamic>{
          'id': 'chap-1',
          'name': 'The Cell',
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-1',
              'name': 'Cell Structure',
              'questionCounter': counterJson(0, 25),
            },
            <String, dynamic>{
              'id': 'lesson-2',
              'name': 'Cell Division',
              'questionCounter': counterJson(40, 40),
            },
          ],
        },
        <String, dynamic>{
          'id': 'chap-2',
          'name': 'Transport',
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-3',
              'name': 'Osmosis',
              'questionCounter': counterJson(5, 30),
            },
          ],
        },
      ],
    },
    <String, dynamic>{
      'id': 'unit-2',
      'name': 'Genetics',
      'chapters': <dynamic>[
        <String, dynamic>{
          'id': 'chap-3',
          'name': 'Inheritance',
          'lessons': <dynamic>[],
        },
      ],
    },
  ],
};

SchoolSubjectTree schoolTree() => SchoolSubjectTree.fromJson(schoolTreeJson());

/// The other side of the contract's `oneOf` — flat, and the lectures DO carry
/// counters (unlike school units/chapters).
///
/// `quizTypes` deliberately omits `practicalRevision`: the tab row is built from
/// this list, so a fixture that listed all four could never catch a hardcoded
/// five-tab row. The counters again span the whole range — untouched, partway
/// and finished — so tests can prove the counter gates nothing.
Map<String, dynamic> universityTreeJson({
  List<String>? quizTypes,
  List<dynamic>? lectures,
}) => <String, dynamic>{
  'track': 'university',
  'quizTypes':
      quizTypes ?? <String>['normal', 'midTermRevision', 'finalRevision'],
  'lectures':
      lectures ??
      <dynamic>[
        // `hasFlashcards` and `flashcardCount` are contract-required and vary
        // across the three (`hasFlashcards` is exactly `flashcardCount > 0`),
        // so a surface that ignores them cannot pass on this fixture alone.
        <String, dynamic>{
          'id': 'lec-1',
          'name': 'Upper Limb',
          'questionCounter': counterJson(0, 60),
          'hasFlashcards': true,
          'flashcardCount': 12,
        },
        <String, dynamic>{
          'id': 'lec-2',
          'name': 'Lower Limb',
          'questionCounter': counterJson(30, 60),
          'hasFlashcards': false,
          'flashcardCount': 0,
        },
        <String, dynamic>{
          'id': 'lec-3',
          'name': 'Thorax',
          'questionCounter': counterJson(45, 45),
          'hasFlashcards': true,
          'flashcardCount': 5,
        },
      ],
};

UniversitySubjectTree universityTree({
  List<String>? quizTypes,
  List<dynamic>? lectures,
}) => UniversitySubjectTree.fromJson(
  universityTreeJson(quizTypes: quizTypes, lectures: lectures),
);

/// One `Lecture` payload. `hasFlashcards` is left to the caller and
/// `flashcardCount` follows it (the contract: `hasFlashcards` is exactly
/// `flashcardCount > 0`), so a fixture cannot describe a lecture the server
/// could never send.
Map<String, dynamic> lectureJson({
  required String id,
  required String name,
  required bool hasFlashcards,
  int? flashcardCount,
  Map<String, dynamic>? questionCounter,
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'questionCounter': questionCounter ?? counterJson(0, 10),
  'hasFlashcards': hasFlashcards,
  'flashcardCount': flashcardCount ?? (hasFlashcards ? 8 : 0),
};

/// The default three lectures with the flashcards taken away — the payload of a
/// faculty that has none, for which the Flashcard tab must not be offered at
/// all. Same ids, names and counters as [universityTreeJson]'s defaults, so a
/// test can swap this in and compare like with like.
List<dynamic> lecturesWithoutFlashcards() => <dynamic>[
  lectureJson(
    id: 'lec-1',
    name: 'Upper Limb',
    hasFlashcards: false,
    questionCounter: counterJson(0, 60),
  ),
  lectureJson(
    id: 'lec-2',
    name: 'Lower Limb',
    hasFlashcards: false,
    questionCounter: counterJson(30, 60),
  ),
  lectureJson(
    id: 'lec-3',
    name: 'Thorax',
    hasFlashcards: false,
    questionCounter: counterJson(45, 45),
  ),
];
