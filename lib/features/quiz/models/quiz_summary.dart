import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_summary.freezed.dart';
part 'quiz_summary.g.dart';

/// Contract `QuizSummary` (`openapi.yaml:1652`, 3.0.0-m1) — the `200` body of
/// `POST /quizzes/{quizId}/finish`, required `[quizId, score, totalQuestions,
/// answeredCount, pointsAwarded, leveledUp, newBadge, questions]`.
///
/// **3.0.0-m1 (adr-102) removed `totalPoints` and `level`.** The contract's
/// rule: a field that describes an EVENT is frozen, a field that describes
/// STATE is live. The student's current total and level are state and come
/// from `GET /me` (`StudentProfile.points.total`, `.level`); this summary
/// reports only what THIS attempt did. A 2.x server that still sends the two
/// keys parses unchanged — json_serializable ignores unknown keys — so the
/// client cannot break in either direction.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// `finish` is idempotent — repeat calls return the same summary — and
/// unfinished quizzes auto-finish server-side after 24h.
@freezed
abstract class QuizSummary with _$QuizSummary {
  const factory QuizSummary({
    required String quizId,

    /// Correct answers. The numerator of the percentage ring.
    required int score,
    required int totalQuestions,

    /// Questions the student actually answered. Distinct from
    /// [totalQuestions] because *"unanswered questions are recorded unanswered
    /// (not counted wrong)"* — which is the whole reason [wrong] and [skipped]
    /// below are two different numbers.
    required int answeredCount,

    /// Points awarded for THIS quiz. Rendered verbatim; never computed,
    /// predicted or previewed. See docs/seif_fight.md S12.
    required int pointsAwarded,

    /// True when THIS quiz crossed a level boundary.
    ///
    /// A frozen EVENT (adr-102): set at the moment it happened and never
    /// changed by a later quiz. Do not recompute it by comparing two `GET /me`
    /// reads — that approximation is wrong whenever another quiz awarded
    /// points while this one was open.
    ///
    /// **Parsed, not celebrated.** The contract goes to the trouble of telling
    /// us, but the result frame has no level-up state to render — flagged in
    /// docs/DESIGN_ISSUES.md rather than invented here.
    required bool leveledUp,

    /// True when THIS quiz earned a badge (every 5,000 total_points past
    /// Level 12). Frozen on the same rule as [leveledUp].
    ///
    /// Identical treatment: required by the contract, so it is parsed; no
    /// badge celebration exists in the result frame, so nothing is rendered.
    /// Owner decision — no celebration UI this ticket.
    required bool newBadge,

    /// Per-question recap rows. The contract points at
    /// `GET /quizzes/{id}` for the full review, which is `draft` — so these
    /// rows are the only post-quiz per-question data available today.
    ///
    /// Parsed because the contract requires them; not rendered, because the
    /// result frame's only per-question affordance is "Review Questions", and
    /// that is disabled (docs/seif_fight.md S14).
    required List<QuizSummaryQuestion> questions,
  }) = _QuizSummary;

  const QuizSummary._();

  factory QuizSummary.fromJson(Map<String, dynamic> json) =>
      _$QuizSummaryFromJson(json);

  /// Wrong answers = **answered minus correct**.
  ///
  /// NOT `totalQuestions - score`. A student who finishes a 10-question quiz
  /// after 8 answers with 5 correct got 3 wrong and skipped 2 — computing from
  /// [totalQuestions] would report 5 wrong and call two untouched questions
  /// mistakes. The contract separates [answeredCount] from [totalQuestions]
  /// precisely so this can be truthful.
  ///
  /// Clamped at zero: a negative here would mean the server sent a score higher
  /// than the answer count, which is drift, and a bare `-1` on screen is worse
  /// than a `0` plus a summary that still adds up.
  int get wrong => (answeredCount - score).clamp(0, answeredCount);

  /// Questions never answered. Rendered as a third **Skipped** figure, and only
  /// when non-zero — the frame has two buckets and no room for a third that
  /// always reads 0. Flagged to the designer in docs/DESIGN_ISSUES.md.
  int get skipped => (totalQuestions - answeredCount).clamp(0, totalQuestions);

  /// The percentage ring, 0.0–1.0.
  ///
  /// This is presentation arithmetic on two server-supplied integers, not a
  /// score the app decided: the ring cannot be drawn without a fraction, and
  /// the contract sends no percentage. A zero-question quiz draws an empty ring
  /// rather than dividing by zero.
  ///
  /// **No Pass/Fail verdict is derived from it.** The frame says "50% — Pass";
  /// there is no threshold anywhere in the contract, so the word is omitted
  /// rather than guessed. See docs/seif_fight.md S13.
  double get fraction {
    if (totalQuestions <= 0) return 0;
    return (score / totalQuestions).clamp(0, 1).toDouble();
  }
}

/// One recap row inside [QuizSummary.questions] (`openapi.yaml:1671`),
/// required `[questionId, answered]`.
@freezed
abstract class QuizSummaryQuestion with _$QuizSummaryQuestion {
  const factory QuizSummaryQuestion({
    required String questionId,
    required bool answered,

    /// Contract-nullable: *"null when unanswered."* The three-way
    /// correct/wrong/unanswered distinction lives in this one field.
    bool? correct,
  }) = _QuizSummaryQuestion;

  factory QuizSummaryQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizSummaryQuestionFromJson(json);
}
