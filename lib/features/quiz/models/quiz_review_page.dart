import 'package:freezed_annotation/freezed_annotation.dart';

import 'quiz_question.dart';

part 'quiz_review_page.freezed.dart';
part 'quiz_review_page.g.dart';

/// Contract `QuizReview` (`openapi.yaml:4618`) - the `200` body of
/// `GET /quizzes/{quizId}` (`getQuizReview`), required `[id, subjectName,
/// scopeName, score, totalQuestions, finishedAt, questions]`.
///
/// A FINISHED quiz, rendered from the CURRENT question text (adr-017). It is
/// not the in-memory `QuizReviewArgs` the result screen pushes after a quiz
/// (that one is built from the session and dies with the process); this is the
/// server's record and can be fetched at any time later.
///
/// Contract keys are already camelCase, so NO `@JsonKey(name:)` bridge is
/// needed and none must be added.
///
/// **Nothing here is recomputed.** [score] and [totalQuestions] keep the values
/// frozen at finish even when [questions] is shorter: a question whose content
/// no longer exists is omitted from the list and is NOT subtracted from the
/// totals. Do not "fix" the mismatch client-side.
@freezed
abstract class QuizReview with _$QuizReview {
  const factory QuizReview({
    required String id,

    /// The CURRENT subject name for a normal-mode quiz; **null** for
    /// `retakeWrong` and `favorites` quizzes (they span subjects) and when the
    /// subject can no longer be resolved. Required but nullable: the key is
    /// always there and its value is often null. Note the contrast with
    /// `QuizHistoryItem.subjectName`, which spells the same situation `''`.
    required String? subjectName,
    required String scopeName,

    /// Correct answers, frozen at finish.
    required int score,
    required int totalQuestions,

    /// When the quiz was finished (normally UTC). Call `.toLocal()` before
    /// formatting it for display.
    required DateTime finishedAt,
    required List<QuizReviewQuestion> questions,
  }) = _QuizReview;

  factory QuizReview.fromJson(Map<String, dynamic> json) =>
      _$QuizReviewFromJson(json);
}

/// One element of `QuizReview.questions` - the contract's `allOf` of
/// `QuizQuestion` and four review fields.
///
/// Modelled as the same composition: [question] is the existing
/// [QuizQuestion], decoded from the same JSON object, so the review carries
/// the stem, options, `order` and `isFavorite` exactly as the taking screen
/// does and a field added to `QuizQuestion` reaches the review with no second
/// edit. The review-only fields sit beside it.
///
/// The JSON is hand-mapped (`fromJson`/`toJson` below) because the wire object
/// is FLAT while the model is nested - the one thing json_serializable cannot
/// express without a `@JsonKey` bridge, which this codebase does not use.
///
/// **A correct answer is revealed only for a question the student answered**
/// (adr-178 D1): [correctOptionId] is null on every unanswered question, and
/// [correct] is the verdict recorded when the answer was submitted - never
/// recomputed here from the two option ids.
@Freezed(fromJson: false, toJson: false)
abstract class QuizReviewQuestion with _$QuizReviewQuestion {
  const factory QuizReviewQuestion({
    /// `id`, `order`, `text`, `imageUrl`, `thumbnailUrl`, `options` and
    /// `isFavorite` - the contract's `QuizQuestion` half of the `allOf`.
    required QuizQuestion question,

    /// The option the student picked; null = unanswered. Optional in the
    /// contract, so an absent key reads as unanswered too.
    String? selectedOptionId,

    /// The current correct option. Required but nullable: present ONLY when the
    /// student answered the question ([selectedOptionId] is not null), null on
    /// every unanswered one. The KEY must always be on the wire - a response
    /// that drops it throws instead of reading as "withheld".
    ///
    /// It is the CURRENT correct option, whereas [correct] is the verdict from
    /// submit time, so the two can legitimately disagree (the question was
    /// edited after the answer): `selectedOptionId == correctOptionId` does NOT
    /// imply `correct == true`, and vice versa. Never derive one from the other.
    required String? correctOptionId,

    /// The verdict recorded at submit time, never recomputed; null when
    /// unanswered. Optional in the contract.
    bool? correct,

    /// The same value `AnswerResult.explanationAvailable` carries for this
    /// question and track. Always false on an unanswered question (an
    /// explanation is only served for a question the caller answered).
    required bool explanationAvailable,
  }) = _QuizReviewQuestion;

  const QuizReviewQuestion._();

  factory QuizReviewQuestion.fromJson(Map<String, dynamic> json) {
    // `correctOptionId` is required AND nullable. A null VALUE is the normal
    // "unanswered, answer withheld" case; a missing KEY is contract drift. Read
    // as null it would be indistinguishable from the withheld case and would
    // hide the correct answer of an answered question without any signal, so
    // the key is demanded here, as `explanationAvailable` is below. (The
    // generated `QuizReview.subjectName` tolerates its absence instead - an
    // absent subject name is harmless, a silently hidden answer is not.)
    if (!json.containsKey('correctOptionId')) {
      throw const FormatException(
        'QuizReviewQuestion: required key correctOptionId is missing',
      );
    }
    return QuizReviewQuestion(
      question: QuizQuestion.fromJson(json),
      selectedOptionId: json['selectedOptionId'] as String?,
      correctOptionId: json['correctOptionId'] as String?,
      correct: json['correct'] as bool?,
      explanationAvailable: json['explanationAvailable'] as bool,
    );
  }

  /// The flat wire object again (`QuizQuestion` keys plus the four review
  /// keys). Nested options stay `QuizOption` instances until `jsonEncode`, as
  /// they do for every other freezed model here.
  Map<String, dynamic> toJson() => <String, dynamic>{
    ...question.toJson(),
    'selectedOptionId': selectedOptionId,
    'correctOptionId': correctOptionId,
    'correct': correct,
    'explanationAvailable': explanationAvailable,
  };

  /// Whether the student answered this question.
  bool get isAnswered => selectedOptionId != null;

  /// Answered and correct, by the verdict the server recorded - not by
  /// comparing [selectedOptionId] with [correctOptionId], which can differ from
  /// that verdict after the question was edited.
  bool get isCorrect => correct == true;

  /// The contract's own definition of the review's "wrong" filter: *answered
  /// and incorrect* (`selectedOptionId != null && correct == false`). An
  /// unanswered question is **never** wrong - it appears only under "all".
  bool get isWrong => selectedOptionId != null && correct == false;
}
