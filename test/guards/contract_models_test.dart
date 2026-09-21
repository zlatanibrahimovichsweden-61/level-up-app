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
/// - *File scope, not class scope.* [dartDeclaresField] searches the whole FILE
///   for the parameter — nothing parses class bodies — so a same-named field on
///   ANOTHER class in the same file satisfies the check. Of the 42 field names
///   asserted below, 12 are maskable that way (`id`, `name`, `track`,
///   `questionCounter` and the rest that repeat across the models sharing a
///   file). None is currently answered by the wrong class, and a NEWLY required
///   contract field on a bound schema — the case this guard exists for — is
///   still caught. Class-scoped detection is a future hardening item and was
///   deliberately left out of the pass that wrote this list.
void main() {
  late String contract;

  setUpAll(() {
    contract = File('contract/openapi.yaml').readAsStringSync();
  });

  /// Schema path in the contract → the Dart file that decodes it.
  ///
  /// The path is spelled in YAML terms (`properties` included) because that is
  /// how the document nests `required`; see [contractRequiredFields].
  const bindings = <({String label, List<String> path, String dart})>[
    (
      label: 'StudentProfile (GET /me, PATCH /me)',
      path: ['StudentProfile'],
      dart: 'lib/features/profile/models/student_profile.dart',
    ),
    (
      label: 'StudentProfile.school',
      path: ['StudentProfile', 'properties', 'school'],
      dart: 'lib/features/profile/models/student_profile.dart',
    ),
    (
      label: 'StudentProfile.geography',
      path: ['StudentProfile', 'properties', 'geography'],
      dart: 'lib/features/profile/models/student_profile.dart',
    ),
    (
      label: 'StudentProfile.points',
      path: ['StudentProfile', 'properties', 'points'],
      dart: 'lib/features/profile/models/student_profile.dart',
    ),
    (
      label: 'StudentProfile.privacy',
      path: ['StudentProfile', 'properties', 'privacy'],
      dart: 'lib/features/profile/models/student_profile.dart',
    ),
    (
      label: 'StudentProfile.pendingDeletion (adr-114)',
      path: ['StudentProfile', 'properties', 'pendingDeletion'],
      dart: 'lib/features/profile/models/student_profile.dart',
    ),
    (
      label: 'EntitlementState',
      path: ['EntitlementState'],
      dart: 'lib/features/profile/models/entitlement_state.dart',
    ),
    (
      label: 'UniversitySubjectTree',
      path: ['UniversitySubjectTree'],
      dart: 'lib/features/catalog/models/subject_tree.dart',
    ),
    (
      label: 'UniversitySubjectTree.lectures[] — the hasFlashcards miss',
      path: ['UniversitySubjectTree', 'properties', 'lectures', 'items'],
      dart: 'lib/features/catalog/models/subject_tree.dart',
    ),
    (
      label: 'SchoolSubjectTree',
      path: ['SchoolSubjectTree'],
      dart: 'lib/features/catalog/models/subject_tree.dart',
    ),
    (
      label: 'AnswerResult (submitAnswer)',
      path: ['AnswerResult'],
      dart: 'lib/features/quiz/models/answer_result.dart',
    ),
    (
      label: 'NamedRef',
      path: ['NamedRef'],
      dart: 'lib/features/registration/models/reference_models.dart',
    ),
    (
      // Two of its five required fields are nullable (`imageUrl`, `selfGrade`),
      // which is exactly the shape a hand-written model is most likely to drop:
      // "required but usually null" reads like "optional" to a human skimming
      // the YAML.
      label: 'FlashcardCard (getFlashcardsForLecture)',
      path: ['FlashcardCard'],
      dart: 'lib/features/flashcards/models/flashcard.dart',
    ),
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

      final missing = [
        for (final field in required)
          if (!dartDeclaresField(dart, field)) field,
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
}
