---
name: bloc
description: How to build the Level Up quiz engine with Bloc — typed events, a strict state machine that rejects invalid transitions (answer after timeout, double-submit), the countdown timer, and bloc_test. Use this skill whenever working on the quiz feature in any way — quiz screens, question flow, timer, answer submission, quiz results — even if the user doesn't say "Bloc". Do NOT apply Bloc to any other Level Up feature; everything else uses Riverpod (see the river skill).
---

# Quiz Engine — Bloc State Machine

The quiz is the one place in Level Up where Bloc is used, and the only place it's allowed. Reason: three concurrent async sources — countdown timer ticks, answer taps, network confirmations — arrive in unpredictable order. Typed events + an explicit state machine make illegal interleavings impossible and leave an audit trail (`bloc_test` asserts exact sequences). Rule of thumb from the vault: "call this method" state → Notifier; overlapping async events → full Bloc. The quiz is the latter.

## Events and states (glossary names, quiz domain)

Events are things that happen, not method calls:

```dart
sealed class QuizEvent {}
class QuizStarted extends QuizEvent { final QuizConfig config; ... }
class AnswerSubmitted extends QuizEvent { final String questionId; final String choiceId; ... }
class QuizTimeExpired extends QuizEvent {}      // fired by the bloc's own timer
class NextQuestionRequested extends QuizEvent {}
class QuizFinished extends QuizEvent {}
```

States are the machine's positions — one sealed hierarchy, no boolean soup:

```dart
sealed class QuizState {}
class QuizInitial extends QuizState {}
class QuizLoading extends QuizState {}                 // fetching questions
class QuizInProgress extends QuizState { /* question, index, secondsLeft, answers so far */ }
class AnswerConfirming extends QuizState { /* submitted, awaiting server */ }
class QuizTimedOut extends QuizState {}
class QuizCompleted extends QuizState { final QuizResult result; }  // result FROM the server
class QuizError extends QuizState { final String message; }
```

## The state machine rejects invalid transitions

This is the core value of the pattern — guard every handler on the current state and ignore (or log) anything else:

- `AnswerSubmitted` while `QuizTimedOut` or `AnswerConfirming` → ignored. A tap racing the timer must lose deterministically.
- `QuizTimeExpired` while `AnswerConfirming` → the submitted answer stands; don't retro-timeout.
- Double `AnswerSubmitted` for the same question → second one ignored.

Use a sequential event transformer (default) so events process one at a time; never `concurrent` for answer submission.

## Timer discipline

The countdown lives inside the bloc (a periodic `Stream`/`Ticker` subscription), emitting tick updates and adding `QuizTimeExpired` to itself. Cancel the subscription in `close()` and on `QuizCompleted` — a leaked ticker firing into a closed bloc is the classic crash here. The UI renders `secondsLeft` from state; it never runs its own timer.

## Server-authoritative scoring

The bloc submits answers and displays what comes back. It never computes points, score, or pass/fail — `QuizCompleted` carries the server's `QuizResult` verbatim. Offline/error during submission → typed `AppException` from the repository → `QuizError` with a user-tapped retry that re-adds the same event; never silent auto-retry, never locally-invented results.

## Testing (bloc_test — this is why Bloc earns its place)

```dart
blocTest<QuizBloc, QuizState>(
  'ignores AnswerSubmitted after QuizTimeExpired',
  build: () => QuizBloc(repository: mockRepo),
  seed: () => QuizTimedOut(),
  act: (bloc) => bloc.add(AnswerSubmitted(questionId: 'q1', choiceId: 'c2')),
  expect: () => <QuizState>[],   // nothing — the tap was rejected
);
```

Minimum suite: happy path sequence · timeout path · answer-vs-timeout race · double-submit · repository error → `QuizError` → retry. Screenshot protection applies to quiz screens (`FLAG_SECURE` / secure layer) — don't remove it while wiring the UI.
