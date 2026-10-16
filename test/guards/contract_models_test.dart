import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'rules.dart';

/// Contract-`required` response fields must exist on the Dart model that
/// decodes them.
///
/// **The gap this closes.** `build_runner` never reads `contract/` — every
/// model in this repo is hand-written against a YAML file nothing compares it
/// to. So a field the contract marks `required` can be added upstream, vendored
/// in, and simply never modelled: `format`, `analyze` and 1300 tests all stay
/// green, because nothing in the toolchain has ever been told the two files are
/// supposed to agree. Two fields reached a shipped pin that way —
/// `Lecture.hasFlashcards` (3.12.0-m1) and, one level down, the expanded
/// `explanationAvailable` contract — and both were found by a human reading
/// YAML, which is the method this project has repeatedly established does not
/// scale.
///
/// **What it actually protects, precisely.** For each binding below, the
/// `required: [...]` list is read OUT OF THE CONTRACT at run time and every
/// name in it must appear as a constructor parameter on the bound Dart file.
/// The field list is therefore never hardcoded: re-vendor a contract that adds
/// a required field to a bound schema and this test fails until the model
/// catches up. That is the whole point — a hardcoded list would have to be
/// updated by the same person who forgot the model, at the same moment.
///
/// **What it does NOT protect, equally precisely** — say it out loud, because a
/// guard trusted past its range is worse than no guard:
/// - *Only bound schemas.* The bindings are hardcoded, because nothing in
///   either file links a contract schema to a Dart class. A NEW schema added
///   upstream is not covered until someone adds a row.
/// - *Only `required`.* An optional field (`pendingDeletion`,
///   `parentReportStatus`, `termNumber`) can still be missed. Optional is a
///   judgement call — plenty of optional fields are legitimately not modelled —
///   and a guard that flagged them all would be turned off within a week.
/// - *Presence, not correctness.* It checks the model TAKES the parameter. It
///   cannot see whether the type matches, whether nullability matches, or
///   whether any screen reads it. `hasFlashcards` would satisfy this test while
///   no UI consumed it.
/// - *Not the response-to-schema link.* Nothing verifies that `GET /me` really
///   returns `StudentProfile`; that binding is asserted here by a human.
/// - *Still a regex, not a type system.* Scope is now one class (see below),
///   but within it the check is textual: a name in the right position counts.
///
/// **Scope is the CLASS, not the file — since Phase 3.** Each binding names its
/// [dartClass] and [dartClassBody] narrows the source to that class before
/// [dartDeclaresField] looks. Previously the search covered the whole file, so
/// a same-named field on ANY other class in it satisfied the check: of the 47
/// field names asserted below, **12 were maskable that way** — `NamedRef`'s
/// `id`/`nameAr`/`nameEn` were answerable by five classes sharing
/// `reference_models.dart`, and `lectures[]`'s `id`/`name` by four sharing
/// `subject_tree.dart`. None was actually answered by the wrong class when the
/// scoping landed, which is why this was hardening rather than a bug fix; the
/// masking was a loaded gun, not a wound.
void main() {
  late String contract;

  setUpAll(() {
    contract = File('contract/openapi.yaml').readAsStringSync();
  });

  /// Schema path in the contract → the Dart CLASS that decodes it.
  ///
  /// The path is spelled in YAML terms (`properties` included) because that is
  /// how the document nests `required`; see [contractRequiredFields].
  ///
  /// [dartClass] is asserted by a human, like [dart] and [path]: nothing links
  /// a contract schema to a Dart class. Naming it is what keeps the check
  /// inside one class — without it, `NamedRef`'s three required fields were
  /// satisfiable by any of the five classes sharing `reference_models.dart`.
  const bindings = <({String label, List<String> path, String dart, String dartClass})>[
    (
      label: 'StudentProfile (GET /me, PATCH /me)',
      path: ['StudentProfile'],
      dart: 'lib/features/profile/models/student_profile.dart',
      dartClass: 'StudentProfile',
    ),
    (
      label: 'StudentProfile.school',
      path: ['StudentProfile', 'properties', 'school'],
      dart: 'lib/features/profile/models/student_profile.dart',
      dartClass: 'ProfileSchool',
    ),
    (
      label: 'StudentProfile.geography',
      path: ['StudentProfile', 'properties', 'geography'],
      dart: 'lib/features/profile/models/student_profile.dart',
      dartClass: 'ProfileGeography',
    ),
    (
      label: 'StudentProfile.points',
      path: ['StudentProfile', 'properties', 'points'],
      dart: 'lib/features/profile/models/student_profile.dart',
      dartClass: 'ProfilePoints',
    ),
    (
      label: 'StudentProfile.privacy',
      path: ['StudentProfile', 'properties', 'privacy'],
      dart: 'lib/features/profile/models/student_profile.dart',
      dartClass: 'ProfilePrivacy',
    ),
    (
      label: 'StudentProfile.pendingDeletion (adr-114)',
      path: ['StudentProfile', 'properties', 'pendingDeletion'],
      dart: 'lib/features/profile/models/student_profile.dart',
      dartClass: 'PendingDeletion',
    ),
    (
      label: 'EntitlementState',
      path: ['EntitlementState'],
      dart: 'lib/features/profile/models/entitlement_state.dart',
      dartClass: 'EntitlementState',
    ),
    (
      label: 'UniversitySubjectTree',
      path: ['UniversitySubjectTree'],
      dart: 'lib/features/catalog/models/subject_tree.dart',
      dartClass: 'UniversitySubjectTree',
    ),
    (
      label: 'UniversitySubjectTree.lectures[] — the hasFlashcards miss',
      path: ['UniversitySubjectTree', 'properties', 'lectures', 'items'],
      dart: 'lib/features/catalog/models/subject_tree.dart',
      dartClass: 'Lecture',
    ),
    (
      label: 'SchoolSubjectTree',
      path: ['SchoolSubjectTree'],
      dart: 'lib/features/catalog/models/subject_tree.dart',
      dartClass: 'SchoolSubjectTree',
    ),
    (
      label: 'AnswerResult (submitAnswer)',
      path: ['AnswerResult'],
      dart: 'lib/features/quiz/models/answer_result.dart',
      dartClass: 'AnswerResult',
    ),
    (
      label: 'NamedRef',
      path: ['NamedRef'],
      dart: 'lib/features/registration/models/reference_models.dart',
      dartClass: 'NamedRef',
    ),
    (
      // Two of its five required fields are nullable (`imageUrl`, `selfGrade`),
      // which is exactly the shape a hand-written model is most likely to drop:
      // "required but usually null" reads like "optional" to a human skimming
      // the YAML.
      label: 'FlashcardCard (getFlashcardsForLecture)',
      path: ['FlashcardCard'],
      dart: 'lib/features/flashcards/models/flashcard.dart',
      dartClass: 'FlashcardCard',
    ),
  ];

  /// Operations whose `200` response is a bare array of an INLINE item — the
  /// contract writes the item under the operation instead of naming a schema,
  /// so [bindings] (which reads `components.schemas`) cannot see it. Kept as a
  /// SEPARATE list so the table above stays exactly what it was; the check is
  /// the same one, class-scoped, and reads the item's `required` list from
  /// `contractOperationItemRequiredFields`.
  ///
  /// Both rows exist because `status: active | soon` (3.51.0-m1 / 3.52.0-m1)
  /// is `required` on them and a School registration that does not model it
  /// would offer a closed stage as open.
  const inlineBindings =
      <
        ({
          String label,
          String path,
          String method,
          String dart,
          String dartClass,
        })
      >[
        (
          label: 'listSchoolStages (GET /reference/school-stages) items',
          path: '/reference/school-stages',
          method: 'get',
          dart: 'lib/features/registration/models/reference_models.dart',
          dartClass: 'SchoolStageRef',
        ),
        (
          label:
              'listEducationSystems (GET /reference/education-systems) items',
          path: '/reference/education-systems',
          method: 'get',
          dart: 'lib/features/registration/models/reference_models.dart',
          dartClass: 'EducationSystemRef',
        ),
      ];

  /// The contract-required names of an inline binding that [body] does not take
  /// as a constructor parameter.
  List<String> missingInline(
    String body,
    ({String label, String path, String method, String dart, String dartClass})
    b,
  ) => [
    for (final field in contractOperationItemRequiredFields(
      contract,
      path: b.path,
      method: b.method,
    ))
      if (!dartDeclaresField(body, field)) field,
  ];

  test('the contract is actually being read', () {
    // The canary. If `contract/openapi.yaml` moves or is emptied, every binding
    // below would raise rather than pass vacuously — but this states the
    // expectation in one place and fails first, with a readable reason.
    expect(contract, contains('openapi: '));
    expect(contract.length, greaterThan(100000));
  });

  for (final b in bindings) {
    test('${b.label} — every contract-required field is modelled', () {
      final required = contractRequiredFields(contract, b.path);
      final dart = File(b.dart).readAsStringSync();

      // Narrow to the ONE class before looking for fields. A binding naming a
      // class the file no longer declares fails here rather than silently
      // widening back to file scope — which would restore the masking this
      // scoping exists to remove.
      final body = dartClassBody(dart, b.dartClass);
      expect(
        body,
        isNotNull,
        reason:
            '${b.dart} declares no `class ${b.dartClass}`. Either the model was '
            'renamed or moved — update this binding — or it was deleted, which '
            'is a contract question for docs/seif_fight.md. Do NOT widen this '
            'back to the whole file.',
      );

      final missing = [
        for (final field in required)
          if (!dartDeclaresField(body!, field)) field,
      ];

      expect(
        missing,
        isEmpty,
        reason:
            'contract/openapi.yaml marks ${missing.join(", ")} as REQUIRED on '
            '${b.path.join(" > ")}, but ${b.dart} does not take '
            '${missing.length == 1 ? "it" : "them"} as a constructor '
            'parameter.\n'
            'The contract wins: add the field to the model and regenerate '
            '(`dart run build_runner build`). Do NOT delete this binding — if '
            'the field genuinely should not be modelled, that is a question for '
            'docs/seif_fight.md, not a guard to switch off.',
      );
    });
  }

  for (final b in inlineBindings) {
    test('${b.label} — every contract-required field is modelled', () {
      final dart = File(b.dart).readAsStringSync();

      // Class-scoped, exactly like the schema bindings: a binding naming a
      // class the file no longer declares fails here rather than widening back
      // to the whole file.
      final body = dartClassBody(dart, b.dartClass);
      expect(
        body,
        isNotNull,
        reason:
            '${b.dart} declares no `class ${b.dartClass}`. Either the model was '
            'renamed or moved — update this binding — or it was deleted, which '
            'is a contract question for docs/seif_fight.md. Do NOT widen this '
            'back to the whole file.',
      );

      final missing = missingInline(body!, b);

      expect(
        missing,
        isEmpty,
        reason:
            'contract/openapi.yaml marks ${missing.join(", ")} as REQUIRED on '
            'the items of ${b.method.toUpperCase()} ${b.path}, but ${b.dart} '
            'does not take ${missing.length == 1 ? "it" : "them"} as a '
            'constructor parameter on ${b.dartClass}.\n'
            'The contract wins: add the field to the model and regenerate '
            '(`dart run build_runner build`). Do NOT delete this binding — if '
            'the field genuinely should not be modelled, that is a question for '
            'docs/seif_fight.md, not a guard to switch off.',
      );
    });

    // MUTATION PROBE, permanent. Proves the guard above can FAIL, without ever
    // breaking a repo file: the real source is read, narrowed to the class, and
    // the `status` parameter is removed from that STRING in memory. The same
    // check must then name `status` — and name nothing on the unmodified body.
    test('${b.label} — mutation probe: dropping `status` from the model is '
        'caught', () {
      final dart = File(b.dart).readAsStringSync();
      final body = dartClassBody(dart, b.dartClass)!;

      // Unmodified: nothing missing (and `status` really is a required field
      // of the item, so the probe below is about something the contract says).
      expect(missingInline(body, b), isEmpty);
      expect(
        contractOperationItemRequiredFields(
          contract,
          path: b.path,
          method: b.method,
        ),
        contains('status'),
        reason: 'the probe removes `status`, so the contract must require it',
      );

      final lines = body.split('\n');
      final mutated = [
        for (final line in lines)
          if (!RegExp(r'\bstatus\s*[,)}]').hasMatch(line)) line,
      ];
      expect(
        mutated.length,
        lessThan(lines.length),
        reason:
            'no `status` parameter line was found to remove — the probe '
            'would be vacuous',
      );

      expect(missingInline(mutated.join('\n'), b), ['status']);
    });
  }
}
