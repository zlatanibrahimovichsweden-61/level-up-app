import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/exceptions.dart';
import '../models/explanation_result.dart';
import '../models/explanation_state.dart';
import '../repository/quiz_repository.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

export 'quiz_event.dart';
export 'quiz_state.dart';

/// The contract's suggested explanation backoff: "poll, suggested 2s backoff".
const _kExplanationPollInterval = Duration(seconds: 2);

/// Give up after ~20s of generating. Not in the contract — a client-side floor
/// so a stuck generation shows "not available" instead of spinning forever.
const _kMaxExplanationPolls = 10;

/// Owns ONE quiz session: the questions, where the student is in them, the
/// per-question grade, the explanation panel, and the finished summary.
///
/// This is the only Bloc in Level Up. Everything else is Riverpod. It earns the
/// exception because the per-question submit/reveal cycle has real ordering
/// constraints — a tap racing an in-flight submit, a re-answer of a committed
/// question, an explanation poll running while the student moves on — and a
/// typed event log plus guarded transitions makes the illegal interleavings
/// impossible rather than merely unlikely.
///
/// **Renderer-agnostic.** It knows a question has options and that one of them
/// gets committed; it knows nothing about four buttons, letter badges or flip
/// cards. That is what lets a second renderer drop in later without the session
/// logic moving (see `widgets/question_renderer.dart`).
///
/// **Server-authoritative.** It submits and displays. It never grades, never
/// sums `pointsDelta`, never derives a score or a verdict.
///
/// Setup (`POST /quizzes`) is NOT here — one request then navigate is a
/// Riverpod command, not a state machine. Nor is invalidating `/me` after
/// finish: that is the result screen's job, and keeping it out means this class
/// has no Riverpod dependency at all.
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required QuizRepository repository,
    Duration explanationPollInterval = _kExplanationPollInterval,
  }) : _repository = repository,
       _pollInterval = explanationPollInterval,
       super(const QuizInitial()) {
    on<QuizStarted>(_onStarted);
    on<OptionSelected>(_onOptionSelected);
    on<AnswerSubmitted>(_onAnswerSubmitted);
    on<AnswerRetried>(_onAnswerRetried);
    on<NextQuestionRequested>(_onNext);
    on<PreviousQuestionRequested>(_onPrevious);
    on<ExplanationRequested>(_onExplanationRequested);
    on<ExplanationUpdated>(_onExplanationUpdated);
    on<QuizFinishRequested>(_onFinish);
  }

  final QuizRepository _repository;

  /// Injectable so tests do not spend 2s per poll. Production uses the
  /// contract's suggested cadence.
  final Duration _pollInterval;

  /// The question whose explanation poll is currently allowed to report back.
  /// Moving question or closing the bloc clears it, which is how a poll started
  /// on question 3 stops mattering once the student is on question 4.
  String? _pollingFor;

  // ---- session -------------------------------------------------------------

  void _onStarted(QuizStarted event, Emitter<QuizState> emit) {
    // Re-starting an existing session would silently discard committed grades.
    // The screen creates one bloc per quiz, so this only fires once.
    if (state is! QuizInitial) return;
    emit(QuizInProgress(QuizSession.start(event.quiz)));
  }

  /// Selection is local and free. It is rejected once the question is graded —
  /// grading is committed server-side and a second choice would be a lie.
  void _onOptionSelected(OptionSelected event, Emitter<QuizState> emit) {
    if (state case QuizInProgress(:final session) when !session.isGraded) {
      emit(QuizInProgress(session, selectedOptionId: event.optionId));
    }
  }

  // ---- answering -----------------------------------------------------------

  Future<void> _onAnswerSubmitted(
    AnswerSubmitted event,
    Emitter<QuizState> emit,
  ) async {
    // Guarded on QuizInProgress specifically: from AnswerConfirming this is a
    // double-submit, and from a graded question it is a re-answer. Both are
    // dropped, so the rejection is deterministic rather than a race.
    if (state case QuizInProgress(
      :final session,
      :final selectedOptionId,
    ) when selectedOptionId != null && !session.isGraded) {
      await _submit(session, selectedOptionId, emit);
    }
  }

  /// Retry re-sends the IDENTICAL `(questionId, optionId)`.
  ///
  /// The server's idempotency key is `(quizId, questionId)`, so a replay
  /// returns the original grade and awards nothing further. Suppressing the
  /// retry client-side would be the actual bug: the failure this has to survive
  /// is a DROPPED RESPONSE to a request the server did process.
  Future<void> _onAnswerRetried(
    AnswerRetried event,
    Emitter<QuizState> emit,
  ) async {
    if (state case AnswerFailed(:final session, :final optionId)) {
      await _submit(session, optionId, emit);
    }
  }

  Future<void> _submit(
    QuizSession session,
    String optionId,
    Emitter<QuizState> emit,
  ) async {
    emit(AnswerConfirming(session, optionId));
    try {
      final result = await _repository.submitAnswer(
        quizId: session.quiz.id,
        questionId: session.question.id,
        optionId: optionId,
      );
      emit(
        QuizInProgress(
          session.copyWith(
            grades: {...session.grades, session.question.id: result},
            chosen: {...session.chosen, session.question.id: optionId},
          ),
        ),
      );
    } on AppException catch (error) {
      emit(AnswerFailed(session, optionId, error));
    }
  }

  // ---- navigation ----------------------------------------------------------

  /// Forward. Only from a graded question — the shell renders Confirm until
  /// then, so there is nothing to advance past.
  void _onNext(NextQuestionRequested event, Emitter<QuizState> emit) {
    if (state case QuizInProgress(
      :final session,
    ) when session.isGraded && !session.isLast) {
      _stopPolling();
      emit(QuizInProgress(session.copyWith(index: session.index + 1)));
    }
  }

  /// Back to an earlier question. It is necessarily graded, so [QuizInProgress]
  /// renders it read-only with the correct option still revealed.
  void _onPrevious(PreviousQuestionRequested event, Emitter<QuizState> emit) {
    if (state case QuizInProgress(:final session) when !session.isFirst) {
      _stopPolling();
      emit(QuizInProgress(session.copyWith(index: session.index - 1)));
    }
  }

  // ---- explanation ---------------------------------------------------------

  /// Starts the `202 → poll → 200` cycle.
  ///
  /// Only legal once the question is graded: the endpoint 403s with
  /// `insufficient_scope` before the caller has answered, which the contract
  /// documents as expected behaviour rather than an error. Guarding here means
  /// the app never makes that call in the first place.
  void _onExplanationRequested(
    ExplanationRequested event,
    Emitter<QuizState> emit,
  ) {
    if (state case QuizInProgress(:final session) when session.isGraded) {
      // Already fetched, or already running — asking twice must not restart a
      // generation the server is charging for.
      if (session.explanation is! ExplanationIdle) return;
      if (session.grade?.explanationAvailable != true) return;

      final questionId = session.question.id;
      emit(
        QuizInProgress(
          session.copyWith(
            explanations: {
              ...session.explanations,
              questionId: const ExplanationPending(),
            },
          ),
        ),
      );

      _pollingFor = questionId;
      // Deliberately not awaited: the poll must not occupy the sequential
      // event handler, or Next would be dead for as long as generation takes.
      unawaited(_poll(questionId));
    }
  }

  /// The poll reporting back. Ignored if the student has moved on, so a late
  /// answer cannot repaint a question they are no longer looking at.
  void _onExplanationUpdated(
    ExplanationUpdated event,
    Emitter<QuizState> emit,
  ) {
    if (state case final QuizActive active) {
      final session = active.session;
      if (!session.explanations.containsKey(event.questionId) &&
          session.question.id != event.questionId) {
        return;
      }
      final updated = session.copyWith(
        explanations: {...session.explanations, event.questionId: event.state},
      );
      // Exhaustive over the five active positions, no `default:` — an
      // explanation landing must not knock the machine out of whichever phase
      // it is in, and a sixth position added later fails to compile here.
      emit(switch (active) {
        QuizInProgress(:final selectedOptionId) => QuizInProgress(
          updated,
          selectedOptionId: selectedOptionId,
        ),
        AnswerConfirming(:final optionId) => AnswerConfirming(
          updated,
          optionId,
        ),
        AnswerFailed(:final optionId, :final error) => AnswerFailed(
          updated,
          optionId,
          error,
        ),
        QuizFinishing() => QuizFinishing(updated),
        FinishFailed(:final error) => FinishFailed(updated, error),
      });
    }
  }

  /// Runs outside the event pipeline and feeds results back in as events.
  ///
  /// Cancellation is by token rather than by `StreamSubscription`: there is no
  /// stream to cancel, and checking [_pollingFor] before every `add` covers
  /// both moving question and closing the bloc.
  Future<void> _poll(String questionId) async {
    for (var attempt = 0; attempt < _kMaxExplanationPolls; attempt++) {
      if (isClosed || _pollingFor != questionId) return;
      try {
        final result = await _repository.getExplanation(questionId);
        if (isClosed || _pollingFor != questionId) return;

        switch (result) {
          case ExplanationReady(:final text):
            add(ExplanationUpdated(questionId, ExplanationLoaded(text)));
            return;
          case ExplanationGenerating():
            await Future<void>.delayed(_pollInterval);
        }
      } on AppException catch (error) {
        if (isClosed || _pollingFor != questionId) return;
        // Includes the 403 the contract calls expected. Rendered as "not
        // available", never as a failed quiz.
        add(ExplanationUpdated(questionId, ExplanationFailed(error.code)));
        return;
      }
    }
    if (isClosed || _pollingFor != questionId) return;
    add(
      ExplanationUpdated(
        questionId,
        const ExplanationFailed('explanation_timeout'),
      ),
    );
  }

  void _stopPolling() => _pollingFor = null;

  // ---- finish --------------------------------------------------------------

  /// Closes the quiz. Legal from any live position, including mid-quiz — that
  /// is exactly how questions come to be counted as skipped rather than wrong.
  ///
  /// `finish` is idempotent, so a retry after a dropped response returns the
  /// same summary and cannot award twice.
  Future<void> _onFinish(
    QuizFinishRequested event,
    Emitter<QuizState> emit,
  ) async {
    final session = switch (state) {
      QuizInProgress(:final session) => session,
      FinishFailed(:final session) => session,
      // Mid-submit or already finishing: let the in-flight call land first.
      _ => null,
    };
    if (session == null) return;

    _stopPolling();
    emit(QuizFinishing(session));
    try {
      final summary = await _repository.finishQuiz(session.quiz.id);
      emit(QuizCompleted(summary, session.quiz.scopeName));
    } on AppException catch (error) {
      emit(FinishFailed(session, error));
    }
  }

  @override
  Future<void> close() {
    // A poll firing into a closed bloc is the classic crash in this pattern.
    _stopPolling();
    return super.close();
  }
}
