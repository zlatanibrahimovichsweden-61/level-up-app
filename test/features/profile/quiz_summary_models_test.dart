import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/profile/models/quiz_summary_solved.dart';

import '../quiz/quiz_history_contract.dart';

/// The `200` body of `GET /me/quiz-summary`: `{solvedQuestions}`, an integer
/// with `minimum: 0`, required (`contract/openapi.yaml`, pin 3.46.0-m1).
void main() {
  test('decodes solvedQuestions', () {
    expect(
      QuizSummarySolved.fromJson(const {'solvedQuestions': 42}).solvedQuestions,
      42,
    );
  });

  test('zero is a normal answer: a student who has solved nothing yet', () {
    expect(
      QuizSummarySolved.fromJson(const {'solvedQuestions': 0}).solvedQuestions,
      0,
    );
  });

  test('a whole number sent as a JSON double still decodes', () {
    // `(json[...] as num).toInt()` - a server that serialises 5 as 5.0.
    expect(
      QuizSummarySolved.fromJson(const {
        'solvedQuestions': 5.0,
      }).solvedQuestions,
      5,
    );
  });

  test('solvedQuestions is required', () {
    expect(
      () => QuizSummarySolved.fromJson(const <String, dynamic>{}),
      throwsA(anything),
    );
  });

  test('a non-numeric solvedQuestions is drift and throws', () {
    expect(
      () => QuizSummarySolved.fromJson(const {'solvedQuestions': 'many'}),
      throwsA(anything),
    );
  });

  test('a key this app predates is ignored, not an error', () {
    final s = QuizSummarySolved.fromJson(const {
      'solvedQuestions': 3,
      'somethingAddedLater': true,
    });

    expect(s.solvedQuestions, 3);
  });

  test('every required field of the getMyQuizSummary body is '
      'modelled', () {
    // READ from contract/openapi.yaml at run time, not hardcoded. The body is
    // an inline schema, which test/guards/contract_models_test.dart cannot
    // reach.
    const anchor = 'operationId: getMyQuizSummary';
    expect(
      requiredAfter(File('contract/openapi.yaml').readAsStringSync(), anchor),
      contains('solvedQuestions'),
      reason: 'the anchor lands on the body list',
    );

    expect(
      unmodelledFields(
        anchor: anchor,
        dartFile: 'lib/features/profile/models/quiz_summary_solved.dart',
        className: 'QuizSummarySolved',
      ),
      isEmpty,
    );
  });

  test('round-trips through jsonEncode', () {
    const s = QuizSummarySolved(solvedQuestions: 7);

    expect(
      QuizSummarySolved.fromJson(
        jsonDecode(jsonEncode(s)) as Map<String, dynamic>,
      ),
      s,
    );
  });
}
