import 'package:flutter/foundation.dart';

import 'answer_result.dart';
import 'quiz_question.dart';

/// What `/quiz/:quizId/result/review` is pushed with.
///
/// A purpose-built, immutable view of the finished [QuizSession] — deliberately
/// NOT the session itself. The review frame (`162:2377`) renders a question's
/// text and whether it was right; it renders no options, so the student's own
/// pick never appears and `chosen` is not carried. Passing the whole session
/// would hand the screen four fields it must not use.
///
/// **This is the only source of review data, and it dies with the process.**
/// `QuizSession` is in-memory by design — the contract frames the question bank
/// as the product ("correct answers never ship with questions — content
/// protection"), so nothing here may be cached. Reviewing a quiz from history
/// needs `GET /quizzes/{quizId}`, which is `x-stability: draft`
/// (`openapi.yaml:1010`); see docs/seif_fight.md S14. Nothing in this class
/// consumes an endpoint.
///
/// Carried as go_router `extra` — typed, like `OtpArgs`, `RegistrationArgs` and
/// `QuizSetupArgs` before it — rather than as query parameters.
@immutable
class QuizReviewArgs {
  const QuizReviewArgs({required this.questions, required this.grades});

  /// The questions as delivered, in the order they were asked. The row's
  /// "QUESTION n" label is this list's index + 1, not a field.
  final List<QuizQuestion> questions;

  /// questionId → the server's grade. A question ABSENT from this map was never
  /// committed — that is the skipped row state, and the frame has no design for
  /// it (docs/DESIGN_ISSUES.md #55).
  ///
  /// [AnswerResult] carries no `questionId` of its own, so the pairing lives
  /// here in the key rather than in the value.
  final Map<String, AnswerResult> grades;

  // No `scopeName` here, unlike `QuizResultArgs`. The review screen is titled
  // "Quiz Review" from the frame (`162:2411`), not by scope, so carrying one
  // would be a field nothing reads.

  @override
  bool operator ==(Object other) =>
      other is QuizReviewArgs &&
      listEquals(other.questions, questions) &&
      mapEquals(other.grades, grades);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(questions),
    Object.hashAllUnordered(grades.keys),
    Object.hashAllUnordered(grades.values),
  );
}
