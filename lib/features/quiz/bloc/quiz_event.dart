import '../models/explanation_state.dart';
import '../models/quiz.dart';

/// Things that HAPPEN in a quiz session, not methods to call.
///
/// Every one is guarded against the current state in [QuizBloc]; an event that
/// does not belong in the current position is dropped, not queued. That is the
/// reason this feature is the one place the project uses Bloc.
sealed class QuizEvent {
  const QuizEvent();
}

/// The session begins. The [Quiz] is already in hand — the setup screen made
/// `POST /quizzes` and pushed the result — so this carries it rather than
/// triggering a fetch.
class QuizStarted extends QuizEvent {
  const QuizStarted(this.quiz);

  final Quiz quiz;
}

/// The student tapped an option. **Nothing is sent.** This only moves the
/// uncommitted selection, which is what enables Confirm.
class OptionSelected extends QuizEvent {
  const OptionSelected(this.optionId);

  final String optionId;
}

/// Confirm. THIS is the only thing that reaches `POST /answers`.
class AnswerSubmitted extends QuizEvent {
  const AnswerSubmitted();
}

/// Retry after a failed submit — re-sends the same `(questionId, optionId)`.
class AnswerRetried extends QuizEvent {
  const AnswerRetried();
}

/// Forward. Only legal once the current question is graded.
class NextQuestionRequested extends QuizEvent {
  const NextQuestionRequested();
}

/// Back to an earlier question. It is always already graded, so it renders
/// read-only.
class PreviousQuestionRequested extends QuizEvent {
  const PreviousQuestionRequested();
}

/// The student opened the AI EXPLANATION panel. Starts the `202 → poll → 200`
/// cycle; only legal after the question is graded, because the endpoint 403s
/// before that by design.
class ExplanationRequested extends QuizEvent {
  const ExplanationRequested();
}

/// Finish the quiz — from the last question, or early (which is how questions
/// end up counted as skipped rather than wrong).
class QuizFinishRequested extends QuizEvent {
  const QuizFinishRequested();
}

/// Internal: the explanation poll reported a new position.
///
/// The poll runs OUTSIDE the event handler and feeds its progress back in as
/// events, so the sequential transformer is never occupied by a multi-second
/// wait. Without this the Next button would be dead while an explanation
/// generated — the brief is explicit that it must not be.
class ExplanationUpdated extends QuizEvent {
  const ExplanationUpdated(this.questionId, this.state);

  final String questionId;
  final ExplanationState state;
}
