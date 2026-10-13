import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_summary_solved.freezed.dart';
part 'quiz_summary_solved.g.dart';

/// The `200` body of `GET /me/quiz-summary` (`getMyQuizSummary`,
/// `openapi.yaml:1731`) - the Profile "Solved Questions" number (spec-060).
/// The contract names no component schema for it, so the name here says what
/// it holds.
///
/// **Not `QuizSummary`.** `QuizSummary` (`models/quiz_summary.dart` in the
/// quiz feature) is the `finishQuiz` recap of ONE attempt. This is a lifetime
/// count across every quiz and every track.
///
/// **Not `QuestionCounter.answered`**, and it must never be reconciled with
/// it, summed from it, or derived from `finishQuiz`'s `answeredCount` or from
/// Mistakes: those are different numbers with different meanings. Flashcards
/// never count. The app displays what the server returns and does no
/// arithmetic on it.
///
/// **Nothing consumes this yet.** Showing it reopens the "Points only" ruling
/// (owner decision N-17, pending): until that is ruled, no provider, notifier
/// or screen may read it.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
@freezed
abstract class QuizSummarySolved with _$QuizSummarySolved {
  const factory QuizSummarySolved({
    /// The number of DISTINCT questions the caller has answered correctly at
    /// least once, in any quiz, finished or not. Lifetime and cross-track: it
    /// survives a Track transfer and never shrinks, even when a question is
    /// later deleted from the catalogue. Contract `minimum: 0`; `0` for a
    /// student who has solved nothing yet.
    required int solvedQuestions,
  }) = _QuizSummarySolved;

  factory QuizSummarySolved.fromJson(Map<String, dynamic> json) =>
      _$QuizSummarySolvedFromJson(json);
}
