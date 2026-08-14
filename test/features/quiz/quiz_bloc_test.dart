import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:level_up_app/features/quiz/models/explanation_result.dart';
import 'package:level_up_app/features/quiz/models/explanation_state.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'quiz_fixtures.dart';

class _MockQuizRepository extends Mock implements QuizRepository {}

/// The states carry a whole session each, so these assert with
/// `isA<T>().having(...)` rather than reconstructing instances — it names the
/// field that matters instead of hiding it inside a 5-field equality.
void main() {
  late _MockQuizRepository repo;

  setUp(() {
    repo = _MockQuizRepository();
  });

  QuizBloc build() => QuizBloc(
    repository: repo,
    // No 2s waits in tests; production uses the contract's cadence.
    explanationPollInterval: Duration.zero,
  );

  void stubAnswer({bool correct = true, bool explanationAvailable = true}) {
    when(
      () => repo.submitAnswer(
        quizId: any(named: 'quizId'),
        questionId: any(named: 'questionId'),
        optionId: any(named: 'optionId'),
      ),
    ).thenAnswer(
      (_) async => answerResult(
        correct: correct,
        explanationAvailable: explanationAvailable,
      ),
    );
  }

  /// Seeds a started session sitting on question 1, ungraded.
  QuizSession started({int questionCount = 3}) =>
      QuizSession.start(quiz(questionCount: questionCount));

  group('start', () {
    blocTest<QuizBloc, QuizState>(
      'QuizStarted opens the session on question 1',
      build: build,
      act: (bloc) => bloc.add(QuizStarted(quiz())),
      expect: () => [
        isA<QuizInProgress>()
            .having((s) => s.session.position, 'position', 1)
            .having((s) => s.session.total, 'total', 3)
            .having((s) => s.session.isGraded, 'isGraded', false)
            .having((s) => s.selectedOptionId, 'selected', isNull),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'a second QuizStarted is ignored — it would discard committed grades',
      build: build,
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(QuizStarted(quiz(questionCount: 9))),
      expect: () => <QuizState>[],
    );
  });

  group('selecting an option', () {
    blocTest<QuizBloc, QuizState>(
      'moves the uncommitted selection and sends NOTHING',
      build: build,
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const OptionSelected('q1-opt2')),
      expect: () => [
        isA<QuizInProgress>()
            .having((s) => s.selectedOptionId, 'selected', 'q1-opt2')
            .having((s) => s.canConfirm, 'canConfirm', true),
      ],
      verify: (_) {
        // The whole point of the per-question submit model.
        verifyNever(
          () => repo.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            optionId: any(named: 'optionId'),
          ),
        );
      },
    );

    blocTest<QuizBloc, QuizState>(
      'is rejected once the question is graded — grading is committed',
      build: build,
      seed: () {
        final session = started();
        return QuizInProgress(
          session.copyWith(
            grades: {session.question.id: answerResult()},
            chosen: {session.question.id: 'q1-opt0'},
          ),
        );
      },
      act: (bloc) => bloc.add(const OptionSelected('q1-opt3')),
      expect: () => <QuizState>[],
    );
  });

  group('confirming an answer', () {
    blocTest<QuizBloc, QuizState>(
      'Confirm → AnswerConfirming → graded, revealing correctOptionId',
      build: build,
      setUp: () => stubAnswer(),
      seed: () => QuizInProgress(started(), selectedOptionId: 'q1-opt0'),
      act: (bloc) => bloc.add(const AnswerSubmitted()),
      expect: () => [
        isA<AnswerConfirming>().having(
          (s) => s.optionId,
          'optionId',
          'q1-opt0',
        ),
        isA<QuizInProgress>()
            .having((s) => s.session.isGraded, 'isGraded', true)
            .having(
              (s) => s.session.grade!.correctOptionId,
              'correctOptionId',
              'q1-opt0',
            )
            .having((s) => s.session.committedOptionId, 'committed', 'q1-opt0'),
      ],
      verify: (_) {
        verify(
          () => repo.submitAnswer(
            quizId: 'quiz-1',
            questionId: 'q1',
            optionId: 'q1-opt0',
          ),
        ).called(1);
      },
    );

    blocTest<QuizBloc, QuizState>(
      'Confirm with nothing selected is ignored',
      build: build,
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const AnswerSubmitted()),
      expect: () => <QuizState>[],
    );

    // A tap racing an in-flight submit must lose deterministically.
    blocTest<QuizBloc, QuizState>(
      'a double submit is rejected while the first is in flight',
      build: build,
      seed: () => AnswerConfirming(started(), 'q1-opt0'),
      act: (bloc) => bloc.add(const AnswerSubmitted()),
      expect: () => <QuizState>[],
      verify: (_) {
        verifyNever(
          () => repo.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            optionId: any(named: 'optionId'),
          ),
        );
      },
    );

    blocTest<QuizBloc, QuizState>(
      'an already-graded question can never be re-answered',
      build: build,
      seed: () {
        final session = started();
        return QuizInProgress(
          session.copyWith(
            grades: {session.question.id: answerResult()},
            chosen: {session.question.id: 'q1-opt0'},
          ),
          selectedOptionId: 'q1-opt3',
        );
      },
      act: (bloc) => bloc.add(const AnswerSubmitted()),
      expect: () => <QuizState>[],
    );

    blocTest<QuizBloc, QuizState>(
      'a failed submit keeps the session and the chosen option',
      build: build,
      setUp: () {
        when(
          () => repo.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            optionId: any(named: 'optionId'),
          ),
        ).thenThrow(const OfflineException());
      },
      seed: () => QuizInProgress(started(), selectedOptionId: 'q1-opt2'),
      act: (bloc) => bloc.add(const AnswerSubmitted()),
      expect: () => [
        isA<AnswerConfirming>(),
        isA<AnswerFailed>()
            .having((s) => s.optionId, 'optionId', 'q1-opt2')
            .having((s) => s.error, 'error', isA<OfflineException>())
            .having((s) => s.session.total, 'session intact', 3),
      ],
    );
  });

  // NON-NEGOTIABLE: the retry re-sends the identical body. The server is
  // idempotent on (quizId, questionId); suppressing the retry client-side would
  // lose the grade whenever it was the RESPONSE that got dropped.
  group('retrying a failed submit', () {
    blocTest<QuizBloc, QuizState>(
      'AnswerRetried re-sends the SAME (questionId, optionId) and regrades',
      build: build,
      setUp: () => stubAnswer(correct: false),
      seed: () => AnswerFailed(started(), 'q1-opt2', const OfflineException()),
      act: (bloc) => bloc.add(const AnswerRetried()),
      expect: () => [
        isA<AnswerConfirming>().having(
          (s) => s.optionId,
          'optionId',
          'q1-opt2',
        ),
        isA<QuizInProgress>()
            .having((s) => s.session.isGraded, 'isGraded', true)
            .having((s) => s.session.grade!.correct, 'correct', false)
            .having((s) => s.session.committedOptionId, 'committed', 'q1-opt2'),
      ],
      verify: (_) {
        verify(
          () => repo.submitAnswer(
            quizId: 'quiz-1',
            questionId: 'q1',
            optionId: 'q1-opt2',
          ),
        ).called(1);
      },
    );

    blocTest<QuizBloc, QuizState>(
      'AnswerRetried does nothing when there is no failure to retry',
      build: build,
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const AnswerRetried()),
      expect: () => <QuizState>[],
    );
  });

  group('navigation', () {
    blocTest<QuizBloc, QuizState>(
      'Next advances once the question is graded',
      build: build,
      seed: () {
        final session = started();
        return QuizInProgress(
          session.copyWith(grades: {session.question.id: answerResult()}),
        );
      },
      act: (bloc) => bloc.add(const NextQuestionRequested()),
      expect: () => [
        isA<QuizInProgress>()
            .having((s) => s.session.position, 'position', 2)
            .having((s) => s.session.isGraded, 'fresh question', false),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'Next is rejected while the question is ungraded',
      build: build,
      seed: () => QuizInProgress(started(), selectedOptionId: 'q1-opt0'),
      act: (bloc) => bloc.add(const NextQuestionRequested()),
      expect: () => <QuizState>[],
    );

    blocTest<QuizBloc, QuizState>(
      'Next is rejected on the last question — Finish is the only way out',
      build: build,
      seed: () {
        final session = started(questionCount: 1);
        return QuizInProgress(
          session.copyWith(grades: {session.question.id: answerResult()}),
        );
      },
      act: (bloc) => bloc.add(const NextQuestionRequested()),
      expect: () => <QuizState>[],
    );

    blocTest<QuizBloc, QuizState>(
      'Back returns to an earlier question, still graded and read-only',
      build: build,
      seed: () {
        final session = started();
        return QuizInProgress(
          session.copyWith(index: 1, grades: {'q1': answerResult()}),
        );
      },
      act: (bloc) => bloc.add(const PreviousQuestionRequested()),
      expect: () => [
        isA<QuizInProgress>()
            .having((s) => s.session.position, 'position', 1)
            .having((s) => s.session.isGraded, 'still graded', true),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'Back on the first question is a no-op',
      build: build,
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const PreviousQuestionRequested()),
      expect: () => <QuizState>[],
    );
  });

  group('explanation', () {
    QuizSession graded({bool explanationAvailable = true}) {
      final session = started();
      return session.copyWith(
        grades: {
          session.question.id: answerResult(
            explanationAvailable: explanationAvailable,
          ),
        },
        chosen: {session.question.id: 'q1-opt0'},
      );
    }

    blocTest<QuizBloc, QuizState>(
      '202 → poll → 200: Pending first, then the text',
      build: build,
      setUp: () {
        var calls = 0;
        when(() => repo.getExplanation(any())).thenAnswer((_) async {
          calls++;
          return calls == 1
              ? const ExplanationGenerating()
              : const ExplanationReady('Because mitochondria.');
        });
      },
      seed: () => QuizInProgress(graded()),
      act: (bloc) => bloc.add(const ExplanationRequested()),
      // The poll runs OUTSIDE the event pipeline and reports back as an event,
      // so the second state needs a window to arrive in. That round trip is
      // the whole design — it is what keeps Next alive while generating.
      wait: const Duration(milliseconds: 50),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.session.explanation,
          'panel',
          isA<ExplanationPending>(),
        ),
        isA<QuizInProgress>().having(
          (s) => (s.session.explanation as ExplanationLoaded).text,
          'text',
          'Because mitochondria.',
        ),
      ],
      verify: (_) => verify(() => repo.getExplanation('q1')).called(2),
    );

    blocTest<QuizBloc, QuizState>(
      'is not requested before the question is graded',
      build: build,
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const ExplanationRequested()),
      expect: () => <QuizState>[],
      verify: (_) => verifyNever(() => repo.getExplanation(any())),
    );

    blocTest<QuizBloc, QuizState>(
      'is not requested when the server said none is available',
      build: build,
      seed: () => QuizInProgress(graded(explanationAvailable: false)),
      act: (bloc) => bloc.add(const ExplanationRequested()),
      expect: () => <QuizState>[],
      verify: (_) => verifyNever(() => repo.getExplanation(any())),
    );

    blocTest<QuizBloc, QuizState>(
      'asking twice does not restart a generation the server charges for',
      build: build,
      setUp: () {
        when(
          () => repo.getExplanation(any()),
        ).thenAnswer((_) async => const ExplanationGenerating());
      },
      seed: () => QuizInProgress(graded()),
      act: (bloc) => bloc
        ..add(const ExplanationRequested())
        ..add(const ExplanationRequested()),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.session.explanation,
          'panel',
          isA<ExplanationPending>(),
        ),
      ],
    );

    // The contract calls this expected, not a bug — so it renders as "not
    // available", never as a broken quiz.
    blocTest<QuizBloc, QuizState>(
      'a 403 lands as ExplanationFailed, leaving the session untouched',
      build: build,
      setUp: () {
        when(() => repo.getExplanation(any())).thenThrow(
          const ApiException(status: 403, code: 'insufficient_scope'),
        );
      },
      seed: () => QuizInProgress(graded()),
      act: (bloc) => bloc.add(const ExplanationRequested()),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.session.explanation,
          'panel',
          isA<ExplanationPending>(),
        ),
        isA<QuizInProgress>()
            .having(
              (s) => (s.session.explanation as ExplanationFailed).code,
              'code',
              'insufficient_scope',
            )
            .having((s) => s.session.isGraded, 'quiz still fine', true),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'a generation that never settles gives up rather than polling forever',
      build: build,
      setUp: () {
        when(
          () => repo.getExplanation(any()),
        ).thenAnswer((_) async => const ExplanationGenerating());
      },
      seed: () => QuizInProgress(graded()),
      act: (bloc) => bloc.add(const ExplanationRequested()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<QuizInProgress>().having(
          (s) => s.session.explanation,
          'panel',
          isA<ExplanationPending>(),
        ),
        isA<QuizInProgress>().having(
          (s) => (s.session.explanation as ExplanationFailed).code,
          'code',
          'explanation_timeout',
        ),
      ],
    );
  });

  group('finish', () {
    blocTest<QuizBloc, QuizState>(
      'finishing renders the SERVER summary verbatim',
      build: build,
      setUp: () {
        when(
          () => repo.finishQuiz(any()),
        ).thenAnswer((_) async => quizSummary());
      },
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const QuizFinishRequested()),
      expect: () => [
        isA<QuizFinishing>(),
        isA<QuizCompleted>()
            .having((s) => s.summary.score, 'score', 5)
            .having((s) => s.summary.answeredCount, 'answeredCount', 8)
            .having((s) => s.summary.pointsAwarded, 'pointsAwarded', 5)
            // Derived from answeredCount, never from totalQuestions.
            .having((s) => s.summary.wrong, 'wrong', 3)
            .having((s) => s.summary.skipped, 'skipped', 2)
            .having((s) => s.scopeName, 'scopeName', 'Cell Structure'),
      ],
      verify: (_) => verify(() => repo.finishQuiz('quiz-1')).called(1),
    );

    blocTest<QuizBloc, QuizState>(
      'finishing early is legal — that is how questions become skipped',
      build: build,
      setUp: () {
        when(() => repo.finishQuiz(any())).thenAnswer(
          (_) async => quizSummary(
            score: 1,
            totalQuestions: 3,
            answeredCount: 1,
            pointsAwarded: 1,
          ),
        );
      },
      seed: () {
        final session = started();
        return QuizInProgress(
          session.copyWith(grades: {session.question.id: answerResult()}),
        );
      },
      act: (bloc) => bloc.add(const QuizFinishRequested()),
      expect: () => [
        isA<QuizFinishing>(),
        isA<QuizCompleted>()
            .having((s) => s.summary.wrong, 'wrong', 0)
            .having((s) => s.summary.skipped, 'skipped', 2),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'a failed finish keeps the session so retry is possible',
      build: build,
      setUp: () {
        when(() => repo.finishQuiz(any())).thenThrow(const OfflineException());
      },
      seed: () => QuizInProgress(started()),
      act: (bloc) => bloc.add(const QuizFinishRequested()),
      expect: () => [
        isA<QuizFinishing>(),
        isA<FinishFailed>()
            .having((s) => s.error, 'error', isA<OfflineException>())
            .having((s) => s.session.total, 'session intact', 3),
      ],
    );

    blocTest<QuizBloc, QuizState>(
      'retrying a failed finish calls again — finish is idempotent',
      build: build,
      setUp: () {
        when(
          () => repo.finishQuiz(any()),
        ).thenAnswer((_) async => quizSummary());
      },
      seed: () => FinishFailed(started(), const OfflineException()),
      act: (bloc) => bloc.add(const QuizFinishRequested()),
      expect: () => [isA<QuizFinishing>(), isA<QuizCompleted>()],
    );

    blocTest<QuizBloc, QuizState>(
      'finish is ignored while an answer is still in flight',
      build: build,
      seed: () => AnswerConfirming(started(), 'q1-opt0'),
      act: (bloc) => bloc.add(const QuizFinishRequested()),
      expect: () => <QuizState>[],
      verify: (_) => verifyNever(() => repo.finishQuiz(any())),
    );

    blocTest<QuizBloc, QuizState>(
      'nothing is accepted after the quiz is completed',
      build: build,
      seed: () => QuizCompleted(quizSummary(), 'Cell Structure'),
      act: (bloc) => bloc
        ..add(const OptionSelected('q1-opt0'))
        ..add(const AnswerSubmitted())
        ..add(const NextQuestionRequested())
        ..add(const QuizFinishRequested()),
      expect: () => <QuizState>[],
    );
  });

  // The full walk, end to end, in one sequence — the thing every guard above
  // exists to protect.
  blocTest<QuizBloc, QuizState>(
    'the whole session: start → answer → next → answer → finish',
    build: build,
    setUp: () {
      stubAnswer();
      when(() => repo.finishQuiz(any())).thenAnswer(
        (_) async => quizSummary(
          score: 2,
          totalQuestions: 3,
          answeredCount: 2,
          pointsAwarded: 2,
        ),
      );
    },
    act: (bloc) async {
      bloc.add(QuizStarted(quiz()));
      bloc.add(const OptionSelected('q1-opt0'));
      bloc.add(const AnswerSubmitted());
      bloc.add(const NextQuestionRequested());
      bloc.add(const OptionSelected('q2-opt0'));
      bloc.add(const AnswerSubmitted());
      bloc.add(const QuizFinishRequested());
    },
    expect: () => [
      isA<QuizInProgress>().having((s) => s.session.position, 'q', 1),
      isA<QuizInProgress>().having(
        (s) => s.selectedOptionId,
        'selected',
        'q1-opt0',
      ),
      isA<AnswerConfirming>(),
      isA<QuizInProgress>().having((s) => s.session.isGraded, 'graded', true),
      isA<QuizInProgress>().having((s) => s.session.position, 'q', 2),
      isA<QuizInProgress>().having(
        (s) => s.selectedOptionId,
        'selected',
        'q2-opt0',
      ),
      isA<AnswerConfirming>(),
      isA<QuizInProgress>().having(
        (s) => s.session.answeredCount,
        'answered',
        2,
      ),
      isA<QuizFinishing>(),
      isA<QuizCompleted>()
          .having((s) => s.summary.score, 'score', 2)
          .having((s) => s.summary.skipped, 'skipped', 1),
    ],
  );
}
