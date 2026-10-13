import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/quiz/models/favorite_question.dart';

import 'quiz_history_contract.dart';

/// One row of `GET /me/favorites`, shaped from the inline item schema in
/// `contract/openapi.yaml` (pin 3.46.0-m1): `questionId`, `text`,
/// `subjectName` and `favoritedAt`, all required.
void main() {
  Map<String, dynamic> favoriteJson({
    String text = 'Which statement about Physics is correct?',
  }) => <String, dynamic>{
    'questionId': '6b000000-0000-4000-8000-000000000001',
    'text': text,
    'subjectName': 'Physics',
    'favoritedAt': '2026-10-09T08:00:00Z',
  };

  test('decodes every required field', () {
    final f = FavoriteQuestion.fromJson(favoriteJson());

    expect(f.questionId, '6b000000-0000-4000-8000-000000000001');
    expect(f.text, 'Which statement about Physics is correct?');
    expect(f.subjectName, 'Physics');
    expect(f.favoritedAt, DateTime.utc(2026, 10, 9, 8));
    expect(f.favoritedAt.isUtc, isTrue);
  });

  test('the stem is kept verbatim, markup and all', () {
    // The contract does not promise the stem is markup-free here, so the model
    // must not strip or rewrite it.
    final f = FavoriteQuestion.fromJson(
      favoriteJson(text: 'Which is the <u>correct</u> one?'),
    );

    expect(f.text, 'Which is the <u>correct</u> one?');
  });

  test('every contract-required key is required', () {
    for (final key in favoriteJson().keys) {
      final json = favoriteJson()..remove(key);
      expect(
        () => FavoriteQuestion.fromJson(json),
        throwsA(anything),
        reason: 'removing `$key`',
      );
    }
  });

  test('a key this app predates is ignored, not an error', () {
    final f = FavoriteQuestion.fromJson(
      favoriteJson()..['somethingAddedLater'] = 1,
    );

    expect(f.text, isNotEmpty);
  });

  test('carries no option and no correct answer', () {
    // Nothing on this model could leak the answer: the row is a stem and a
    // subject, nothing else.
    final wire =
        jsonDecode(jsonEncode(FavoriteQuestion.fromJson(favoriteJson())))
            as Map<String, dynamic>;

    expect(wire.keys.toSet(), {
      'questionId',
      'text',
      'subjectName',
      'favoritedAt',
    });
  });

  test('every required field of the listFavorites item is '
      'modelled', () {
    // READ from contract/openapi.yaml at run time, not hardcoded. The item is
    // an inline schema, which test/guards/contract_models_test.dart cannot
    // reach.
    const anchor = 'operationId: listFavorites';
    expect(
      requiredAfter(File('contract/openapi.yaml').readAsStringSync(), anchor),
      contains('favoritedAt'),
      reason: 'the anchor lands on the item list',
    );

    expect(
      unmodelledFields(
        anchor: anchor,
        dartFile: 'lib/features/quiz/models/favorite_question.dart',
        className: 'FavoriteQuestion',
      ),
      isEmpty,
    );
  });

  test('round-trips through jsonEncode', () {
    final f = FavoriteQuestion.fromJson(favoriteJson());

    expect(
      FavoriteQuestion.fromJson(
        jsonDecode(jsonEncode(f)) as Map<String, dynamic>,
      ),
      f,
    );
  });
}
