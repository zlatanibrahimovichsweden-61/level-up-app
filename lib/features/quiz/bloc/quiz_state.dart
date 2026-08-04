import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/exceptions.dart';
import '../models/answer_result.dart';
import '../models/explanation_state.dart';
import '../models/quiz.dart';
import '../models/quiz_question.dart';
import '../models/quiz_summary.dart';

part 'quiz_state.freezed.dart';

/// The accumulated facts of ONE quiz session — everything that survives moving
/// between questions.
///
/// Split out from the states below so the phase (`answering` / `confirming` /
/// `finishing`) can change without every variant having to redeclare five
/// fields. freezed gives it `copyWith`, which is what advancing the index or
/// recording a grade actually is.
///
/// **In memory only.** Nothing here is cached to Hive: the contract frames the
/// question bank as the product ("correct answers never ship with questions —
/// content protection"). If the app is killed the session is gone; answers
/// already submitted are safe server-side. See docs/seif_fight.md S2.
@freezed
abstract class QuizSession with _$QuizSession {
  const factory QuizSession({
    required Quiz quiz,
    required int index,

    /// questionId → the server's grade. Presence here means the question is
    /// COMMITTED and can never be re-answered.
    required Map<String, AnswerResult> grades,

    /// questionId → the option the student committed to. Kept alongside
    /// [grades] because `AnswerResult` reports the CORRECT option, not the
    /// chosen one, and the graded view has to mark both.
    required Map<String, String> chosen,

    /// questionId → panel state. Per question, so going back does not re-poll.
    required Map<String, ExplanationState> explanations,
  }) = _QuizSession;

  const QuizSession._();

  factory QuizSession.start(Quiz quiz) => QuizSession(
        quiz: quiz,
        index: 0,
        grades: const {},
        chosen: const {},
        explanations: const {},
      );

  QuizQuestion get question => quiz.questions[index];

  /// Null until the student confirms and the server answers.
  AnswerResult? get grade => grades[question.id];

  bool get isGraded => grade != null;

  /// The option the student committed to on this question, if any.
  String? get committedOptionId => chosen[question.id];

  ExplanationState get explanation =>
      explanations[question.id] ?? const ExplanationIdle();

  /// Denominator of the `n/total` counter — the questions DELIVERED, not the
  /// length requested.
  int get total => quiz.questionCount;

  /// 1-based, for display.
  int get position => index + 1;

  bool get isLast => index >= total - 1;

  bool get isFirst => index <= 0;

  /// How many questions have been committed. Drives the confirm-on-exit
  /// dialog's "you will lose your progress" case — NOT the result screen,
  /// which uses the server's own `answeredCount`.
  int get answeredCount => grades.length;

  double get progress => total <= 0 ? 0 : (position / total).clamp(0, 1).toDouble();
}

/// The quiz session state machine.
///
/// Deliberately NOT freezed unions and deliberately without `==`: the states
/// carry a whole [QuizSession] each, so structural equality would compare three
/// maps on every emit for no benefit, and `bloc_test` reads these with
/// `isA<T>().having(...)` matchers, which assert the fields that matter rather
/// than a whole reconstructed instance.
///
/// **There is no timer and no timeout state.** The `bloc` skill describes a
/// countdown, but the contract defines no time limit on a quiz anywhere — see
/// docs/seif_fight.md S7 ("designed, not specified"). Adding a client-side
/// countdown would invent a rule the server does not enforce.
sealed class QuizState {
  const QuizState();
}

/// Before [QuizStarted]. The screen never renders this for longer than a frame:
/// the `Quiz` is already in hand when the screen is pushed (`POST /quizzes`
/// happened on the setup screen), so there is no loading phase to wait through.
class QuizInitial extends QuizState {
  const QuizInitial();
}

/// Any state with a live session.
sealed class QuizActive extends QuizState {
  const QuizActive(this.session);

  final QuizSession session;
}

/// Showing a question. Two sub-positions, distinguished by the session rather
/// than by another class:
/// - not yet graded → the renderer accepts a selection, Confirm commits it
/// - graded → read-only, the correct option is revealed, Next moves on
///
/// [selectedOptionId] is the UNCOMMITTED choice. Nothing has been sent while it
/// is set — that is the whole point of the per-question submit model.
class QuizInProgress extends QuizActive {
  const QuizInProgress(super.session, {this.selectedOptionId});

  final String? selectedOptionId;

  /// Confirm is only meaningful when there is an uncommitted selection.
  bool get canConfirm => selectedOptionId != null && !session.isGraded;
}

/// `POST /answers` is in flight. Every further tap is rejected here — this is
/// what makes a double-submit impossible rather than merely unlikely.
class AnswerConfirming extends QuizActive {
  const AnswerConfirming(super.session, this.optionId);

  final String optionId;
}

/// The submit failed. The session is intact and [optionId] is retained, so
/// retry re-sends the IDENTICAL body — the server is idempotent on
/// `(quizId, questionId)`, so this cannot double-award and must not be
/// suppressed client-side.
class AnswerFailed extends QuizActive {
  const AnswerFailed(super.session, this.optionId, this.error);

  final String optionId;
  final AppException error;
}

/// `POST /finish` is in flight.
class QuizFinishing extends QuizActive {
  const QuizFinishing(super.session);
}

/// Finish failed. The session is intact — nothing the student answered is lost,
/// and `finish` is idempotent, so retry is always safe.
class FinishFailed extends QuizActive {
  const FinishFailed(super.session, this.error);

  final AppException error;
}

/// Terminal. [summary] is the server's own [QuizSummary], rendered verbatim —
/// no score, points or verdict is computed here or anywhere downstream.
///
/// [scopeName] rides along because `QuizSummary` does not carry one and the
/// result screen is titled by scope.
class QuizCompleted extends QuizState {
  const QuizCompleted(this.summary, this.scopeName);

  final QuizSummary summary;
  final String scopeName;
}
