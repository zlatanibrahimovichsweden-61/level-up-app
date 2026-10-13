/// Reads an INLINE contract schema's `required: [...]` list at run time and
/// checks the Dart model takes every name as a constructor parameter.
///
/// `test/guards/contract_models_test.dart` does this for schemas under
/// `components.schemas`, but it cannot reach a schema written inline in a path
/// (the `listFavorites` item, the `listModules` item, the `getMyQuizSummary`
/// body) or one nested in an `allOf` list (the review-only half of
/// `QuizReview.questions[]`), because its navigator only descends `components >
/// schemas` by key. These are exactly the CW16 shapes, so the same idea is
/// applied here with a text anchor instead of a key path.
///
/// The field list is never hardcoded: re-vendor a contract that adds a required
/// field to one of these shapes and the test using this fails until the model
/// catches up.
///
/// Same limits as the guard, said plainly: presence of a constructor parameter,
/// not its type or nullability, and it trusts the anchor a human chose.
library;

import 'dart:io';

import '../../guards/rules.dart';

/// The first `required: [a, b]` list at or after [anchor] in [yaml].
///
/// Throws rather than returning `[]` when it finds nothing: a lookup that
/// quietly found no fields would make every check using it pass.
List<String> requiredAfter(String yaml, String anchor) {
  final start = yaml.indexOf(anchor);
  if (start < 0) throw StateError('contract anchor not found: $anchor');
  final match = RegExp(
    r'required: \[([^\]]*)\]',
  ).firstMatch(yaml.substring(start));
  if (match == null) {
    throw StateError('no flow-form `required: [...]` after: $anchor');
  }
  final names = match
      .group(1)!
      .split(',')
      .map((n) => n.trim())
      .where((n) => n.isNotEmpty)
      .toList();
  if (names.isEmpty) throw StateError('empty `required:` list after: $anchor');
  return names;
}

/// The contract-required fields after [anchor] that class [className] in
/// [dartFile] does not take as a constructor parameter. Empty means complete.
///
/// [yaml] defaults to the pinned `contract/openapi.yaml`; a test passes a
/// doctored copy to prove the check can fail.
List<String> unmodelledFields({
  required String anchor,
  required String dartFile,
  required String className,
  String? yaml,
}) {
  final contract = yaml ?? File('contract/openapi.yaml').readAsStringSync();
  final body = dartClassBody(File(dartFile).readAsStringSync(), className);
  if (body == null) {
    throw StateError('$dartFile declares no `class $className`');
  }
  return [
    for (final field in requiredAfter(contract, anchor))
      if (!dartDeclaresField(body, field)) field,
  ];
}
