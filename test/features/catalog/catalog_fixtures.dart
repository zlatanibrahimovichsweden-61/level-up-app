/// Shared catalog fixtures, shaped from `contract/openapi.yaml`
/// (`GET /catalog/subjects`, `SchoolSubjectTree`, `QuestionCounter`) — not
/// hand-invented. Used by the model, repository, notifier, screen and router
/// tests so they all agree on one payload.
library;

import 'package:level_up_app/features/catalog/models/subject.dart';
import 'package:level_up_app/features/catalog/models/subject_tree.dart';

Map<String, dynamic> counterJson(int answered, int total) =>
    <String, dynamic>{'answered': answered, 'total': total};

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

List<Subject> subjects() =>
    subjectsJson().map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList();

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
