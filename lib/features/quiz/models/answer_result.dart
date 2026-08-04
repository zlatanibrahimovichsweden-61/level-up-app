import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_result.freezed.dart';
part 'answer_result.g.dart';

/// Contract `AnswerResult` (`openapi.yaml:1438`) — the `200` body of
/// `POST /quizzes/{quizId}/answers`, required
/// `[correct, correctOptionId, pointsDelta, explanationAvailable]`.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// **This is the only place correctness is ever revealed.** Nothing is sent
/// when the student selects an option; this arrives on Confirm, and only then
/// does the screen know which option was right.
///
/// The idempotency key is `(quizId, questionId)`: a network retry returns the
/// ORIGINAL grade and never double-awards. So a retry is safe and must NOT be
/// suppressed client-side — the app re-sends the identical body and trusts the
/// server, rather than inventing a local "already answered" guard that would
/// lose the grade when the first response was the thing that got dropped.
@freezed
abstract class AnswerResult with _$AnswerResult {
  const factory AnswerResult({
    required bool correct,

    /// Revealed here and nowhere else. On a wrong answer the screen marks the
    /// student's choice AND reveals this one.
    required String correctOptionId,

    /// The contract: *"0 or 1 (server-side award; 0 on retry replay or
    /// free-plan edge)."*
    ///
    /// **Server-authoritative and never accumulated client-side.** The app does
    /// not sum these into a session total, does not preview a total on the
    /// setup screen, and does not reconcile them against
    /// `QuizSummary.pointsAwarded` — that value comes from `finish` and is the
    /// only points figure ever rendered. See docs/seif_fight.md S12: the design
    /// promises roughly 20x what this can award.
    required int pointsDelta,

    /// Gate for the AI EXPLANATION panel. When false there is nothing to fetch,
    /// so the panel is not offered at all rather than offered and then failing.
    required bool explanationAvailable,
  }) = _AnswerResult;

  factory AnswerResult.fromJson(Map<String, dynamic> json) =>
      _$AnswerResultFromJson(json);
}
