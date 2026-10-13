import 'package:freezed_annotation/freezed_annotation.dart';

import 'quiz_mode.dart';

part 'quiz_history_item.freezed.dart';
part 'quiz_history_item.g.dart';

/// Contract `QuizHistoryItem` (`openapi.yaml:4607`) - one row of
/// `GET /quizzes` (`listQuizHistory`), required `[id, subjectName, scopeName,
/// mode, score, totalQuestions, finishedAt]`.
///
/// The list holds the caller's own FINISHED quizzes only, newest started first
/// (the item exposes `finishedAt`, not the start time, so the order cannot be
/// re-derived from the rows and must be kept exactly as the server sent it).
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// **Nothing here is computed.** [score] and [totalQuestions] are the values
/// frozen when the quiz finished; the app does not recount them from a review.
@freezed
abstract class QuizHistoryItem with _$QuizHistoryItem {
  const factory QuizHistoryItem({
    required String id,

    /// The CURRENT subject name for a normal-mode quiz. **An empty string** -
    /// not null, not absent - for `retakeWrong` and `favorites` quizzes (they
    /// span subjects) and when the subject can no longer be resolved. Server
    /// copy in the content language (adr-018): render it verbatim, never look
    /// it up in the ARB. Use [hasSubject] rather than comparing to `''`.
    required String subjectName,

    /// The quiz's scope label as the server sends it (a lesson or lecture name
    /// for a normal quiz). Also server copy, rendered verbatim.
    required String scopeName,

    /// A closed contract enum (`normal`, `retakeWrong`, `favorites`), so it
    /// reuses [QuizMode] and an unknown value throws rather than being coerced:
    /// the contract does not mark it extensible.
    required QuizMode mode,

    /// Correct answers, frozen at finish.
    required int score,

    /// The question count frozen at finish. A question whose content was later
    /// removed is NOT subtracted: `GET /quizzes/{id}` may return fewer
    /// questions than this and the two numbers are both right.
    required int totalQuestions,

    /// When the quiz was finished, as the server sent it (normally UTC). Call
    /// `.toLocal()` before formatting it for display.
    required DateTime finishedAt,
  }) = _QuizHistoryItem;

  const QuizHistoryItem._();

  factory QuizHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$QuizHistoryItemFromJson(json);

  /// Whether the server named a subject for this quiz. False for the pooled
  /// modes and for a subject that can no longer be resolved - the contract
  /// spells all of those as `''`.
  bool get hasSubject => subjectName.isNotEmpty;
}
