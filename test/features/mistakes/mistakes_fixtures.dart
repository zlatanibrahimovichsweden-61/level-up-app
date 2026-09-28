/// Wire-shaped fixtures for the Mistakes surface.
///
/// Every shape here is taken from the contract at the vendored pin `2dca3c5`
/// (3.13.0-m1) — `openapi.yaml:908-921` for the overview items and
/// `:2193-2257` for the two tree schemas. Keys are camelCase on the wire
/// (adr-026), so there are no `@JsonKey` bridges anywhere in this feature.
library;

import 'package:level_up_app/features/mistakes/models/mistakes_subject.dart';
import 'package:level_up_app/features/mistakes/models/mistakes_tree.dart';

/// `GET /me/mistakes` — three subjects, already ordered by `name` then `id`
/// exactly as the server promises.
///
/// Deliberately mixed shapes, because all three are contract-legal:
/// - `Biology` carries `termId: null` explicitly (the school case the `200`
///   description calls out);
/// - `Chemistry` OMITS both term keys entirely — they are in `properties` but
///   not in `required` (`:921`). See `seif_fight.md` S42.
/// - `Physics` carries real term values, as a university subject would.
List<dynamic> mistakesOverviewJson() => <dynamic>[
  <String, dynamic>{
    'id': 'sub-bio',
    'name': 'Biology',
    'termId': null,
    'termNumber': null,
    'mistakeCount': 20,
  },
  <String, dynamic>{'id': 'sub-chem', 'name': 'Chemistry', 'mistakeCount': 3},
  <String, dynamic>{
    'id': 'sub-phys',
    'name': 'Physics',
    'termId': 'term-uuid-1',
    'termNumber': 2,
    'mistakeCount': 1,
  },
];

/// A school tree: 1 unit → 2 chapters → 3 lessons.
///
/// The counts here sum correctly (5 + 15 = 20) because the SERVER sums them.
/// See [schoolMistakesTreeInconsistentJson] for the guard case.
Map<String, dynamic> schoolMistakesTreeJson() => <String, dynamic>{
  'track': 'school',
  'mistakeCount': 20,
  'units': <dynamic>[
    <String, dynamic>{
      'id': 'unit-1',
      'name': 'Cell Biology',
      'mistakeCount': 5,
      'chapters': <dynamic>[
        <String, dynamic>{
          'id': 'chap-1',
          'name': 'Cell Structure',
          'mistakeCount': 3,
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-1',
              'name': 'Genetics',
              'mistakeCount': 3,
            },
          ],
        },
        <String, dynamic>{
          'id': 'chap-2',
          'name': 'Mitosis',
          'mistakeCount': 2,
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-2',
              'name': 'Phases',
              'mistakeCount': 2,
            },
          ],
        },
      ],
    },
    <String, dynamic>{
      'id': 'unit-2',
      'name': 'Genetics',
      'mistakeCount': 15,
      'chapters': <dynamic>[
        <String, dynamic>{
          'id': 'chap-3',
          'name': 'Inheritance',
          'mistakeCount': 15,
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-3',
              'name': 'Punnett Squares',
              'mistakeCount': 15,
            },
          ],
        },
      ],
    },
  ],
};

/// A school tree whose parent count does NOT equal the sum of its children.
///
/// Contract-legal as far as the client is concerned: the server owns the
/// arithmetic and the client renders what it is given. This fixture exists so a
/// test can prove the client never "corrects" a parent from its descendants.
Map<String, dynamic> schoolMistakesTreeInconsistentJson() => <String, dynamic>{
  'track': 'school',
  // Deliberately NOT 3 + 4 = 7.
  'mistakeCount': 99,
  'units': <dynamic>[
    <String, dynamic>{
      'id': 'unit-1',
      'name': 'Cell Biology',
      // Deliberately NOT 3 + 4 = 7 either.
      'mistakeCount': 42,
      'chapters': <dynamic>[
        <String, dynamic>{
          'id': 'chap-1',
          'name': 'Cell Structure',
          'mistakeCount': 3,
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-1',
              'name': 'Organelles',
              'mistakeCount': 3,
            },
          ],
        },
        <String, dynamic>{
          'id': 'chap-2',
          'name': 'Mitosis',
          'mistakeCount': 4,
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-2',
              'name': 'Phases',
              'mistakeCount': 4,
            },
          ],
        },
      ],
    },
  ],
};

/// A university tree — a FLAT lecture list, and note the absence of
/// `quizTypes`, which `UniversitySubjectTree` does carry.
Map<String, dynamic> universityMistakesTreeJson() => <String, dynamic>{
  'track': 'university',
  'mistakeCount': 20,
  'lectures': <dynamic>[
    <String, dynamic>{'id': 'lec-1', 'name': 'Cell Biology', 'mistakeCount': 5},
    <String, dynamic>{'id': 'lec-2', 'name': 'Genetics', 'mistakeCount': 15},
  ],
};

/// An in-scope subject the student has nothing outstanding in.
///
/// **`200`, not `403`, and not an error** — `mistakeCount: 0` with an empty
/// child list (`:960-964`).
Map<String, dynamic> emptySchoolMistakesTreeJson() => <String, dynamic>{
  'track': 'school',
  'mistakeCount': 0,
  'units': <dynamic>[],
};

/// Same, university-shaped.
Map<String, dynamic> emptyUniversityMistakesTreeJson() => <String, dynamic>{
  'track': 'university',
  'mistakeCount': 0,
  'lectures': <dynamic>[],
};

/// A school tree whose one chapter has FOUR lessons (API→UI Wave 18).
///
/// Every chapter in [schoolMistakesTreeJson] has one lesson, so no fixture had
/// a gap between two lesson rows or a lesson with one mistake. The first
/// lesson is the frame's own row (`404:6762`: "Genetics", 1), and the four
/// counts walk the Arabic plural categories a lesson row can show: 1 `one`,
/// 2 `two`, 3 `few`, 11 `many`.
Map<String, dynamic> schoolMistakesTreeLessonsJson() => <String, dynamic>{
  'track': 'school',
  'mistakeCount': 17,
  'units': <dynamic>[
    <String, dynamic>{
      'id': 'unit-1',
      'name': 'Cell Biology',
      'mistakeCount': 17,
      'chapters': <dynamic>[
        <String, dynamic>{
          'id': 'chap-1',
          'name': 'Cell Structure',
          'mistakeCount': 17,
          'lessons': <dynamic>[
            <String, dynamic>{
              'id': 'lesson-1',
              'name': 'Genetics',
              'mistakeCount': 1,
            },
            <String, dynamic>{
              'id': 'lesson-2',
              'name': 'Membranes',
              'mistakeCount': 2,
            },
            <String, dynamic>{
              'id': 'lesson-3',
              'name': 'Organelles',
              'mistakeCount': 3,
            },
            <String, dynamic>{
              'id': 'lesson-4',
              'name': 'Transport',
              'mistakeCount': 11,
            },
          ],
        },
      ],
    },
  ],
};

// ---------------------------------------------------------------------------
// Parsed forms
//
// The screen tests stub the REPOSITORY, which returns models, so they need the
// same payloads already decoded. Built by running the real `fromJson` over the
// JSON above rather than by hand-constructing the objects: a fixture that can
// drift from its own wire shape is worse than no fixture.
// ---------------------------------------------------------------------------

List<MistakesSubject> mistakesOverview() => mistakesOverviewJson()
    .map((e) => MistakesSubject.fromJson(e as Map<String, dynamic>))
    .toList();

SchoolMistakesTree schoolMistakesTree() =>
    SchoolMistakesTree.fromJson(schoolMistakesTreeJson());

/// The parent counts here do NOT equal the sums of their children, on purpose.
/// See [schoolMistakesTreeInconsistentJson].
SchoolMistakesTree schoolMistakesTreeInconsistent() =>
    SchoolMistakesTree.fromJson(schoolMistakesTreeInconsistentJson());

UniversityMistakesTree universityMistakesTree() =>
    UniversityMistakesTree.fromJson(universityMistakesTreeJson());

SchoolMistakesTree emptySchoolMistakesTree() =>
    SchoolMistakesTree.fromJson(emptySchoolMistakesTreeJson());

UniversityMistakesTree emptyUniversityMistakesTree() =>
    UniversityMistakesTree.fromJson(emptyUniversityMistakesTreeJson());

SchoolMistakesTree schoolMistakesTreeLessons() =>
    SchoolMistakesTree.fromJson(schoolMistakesTreeLessonsJson());
