import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz.dart';
import '../models/quiz_mode.dart';
import '../models/quiz_setup_args.dart';
import '../repository/quiz_repository.dart';

/// `POST /quizzes` — one request, then navigate.
///
/// **Riverpod, not Bloc, and that is deliberate.** The project reserves Bloc for
/// the quiz SESSION, which is a state machine with ordering constraints.
/// Creating a quiz is a single command with one result; forcing it into the
/// Bloc would mean the Bloc had a "before there is a quiz" state that the
/// taking screen could never render.
///
/// Shaped exactly like `RegistrationSubmitNotifier`: an [AsyncNotifier] whose
/// `build` seeds idle and does no work, because this is a command rather than a
/// fetch.
///
/// - `AsyncData(null)`  → idle
/// - `AsyncLoading()`   → in flight, button disabled
/// - `AsyncData(Quiz)`  → created; the screen pushes the quiz
/// - `AsyncError(...)`  → the screen maps the code:
///     · 403 `weekly_question_limit_reached` / `subscription_required` → sheet
///     · 422 `not_enough_questions` → inline, and NEVER a silent smaller retry
///     · offline/network → the offline view
class QuizSetupNotifier extends AsyncNotifier<Quiz?> {
  /// True once this notifier has been disposed — see [create].
  bool _disposed = false;

  @override
  FutureOr<Quiz?> build() {
    ref.onDispose(() => _disposed = true);
    return null;
  }

  Future<void> create({
    required QuizSetupArgs scope,
    required QuizLength length,
    QuizMode mode = QuizMode.normal,
  }) async {
    if (state.isLoading) return; // no double-submit

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(quizRepositoryProvider)
          .createQuiz(scope: scope, length: length, mode: mode),
    );

    // autoDispose + screen-scoped: backing out of the setup screen while
    // `POST /quizzes` is in flight disposes this notifier mid-await, and the
    // assignment below would throw on a dead notifier.
    //
    // A quiz may have been created server-side that the student never sees.
    // That is pre-existing behaviour and not something this guard can fix from
    // here — it needs an abandon/cleanup call the contract does not offer. The
    // guard only stops the unhandled exception.
    if (_disposed) return;

    state = result;
  }

  /// Back to idle. Called after the screen has navigated with the quiz, so
  /// returning to setup does not immediately re-push the same session, and when
  /// the student changes the length after a failure.
  void reset() => state = const AsyncData(null);
}

/// `autoDispose`: a quiz creation is scoped to one visit to the setup screen.
/// Without it, backing out and returning would find a stale `Quiz` sitting in
/// state and push straight into a session the student did not ask for.
final quizSetupProvider =
    AsyncNotifierProvider.autoDispose<QuizSetupNotifier, Quiz?>(
      QuizSetupNotifier.new,
      // Its build never fetches; the rule is uniform (project_rules_test).
      retry: (_, _) => null,
    );
