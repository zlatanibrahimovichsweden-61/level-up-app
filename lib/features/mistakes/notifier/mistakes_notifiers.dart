import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mistakes_subject.dart';
import '../models/mistakes_tree.dart';
import '../repository/mistakes_repository.dart';

/// `GET /me/mistakes` — the Mistakes overview.
///
/// One screen, BOTH tracks: the overview is track-agnostic (Figma `404:6292`
/// and `404:7110` are the same screen), so there is no branch here and no
/// `Track` in the state.
class MistakesOverviewNotifier extends AsyncNotifier<List<MistakesSubject>> {
  /// Set once the provider is torn down. See [refresh]. Re-armed on EVERY build:
  /// Riverpod 3 keeps this instance across rebuilds and runs the dispose
  /// callbacks on each one.
  bool _disposed = false;

  @override
  Future<List<MistakesSubject>> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return ref.watch(mistakesRepositoryProvider).getMistakes();
  }

  /// User-tapped retry. Never auto-retried on failure — see
  /// [mistakesOverviewProvider].
  Future<void> refresh() async {
    // Captured BEFORE the await: `ref` is dead after disposal
    // (`riverpod-3.3.2/lib/src/core/ref.dart:232-240` throws
    // `UnmountedRefException`), and this is the W3-1 hazard that is still open
    // elsewhere in the app. Do not add a new instance of it.
    final repository = ref.read(mistakesRepositoryProvider);
    state = const AsyncLoading();
    final next = await AsyncValue.guard(repository.getMistakes);
    // Assigning `state` after disposal throws too (the student can leave, or
    // the session can end, mid-flight). The request itself still completes.
    if (_disposed) return;
    state = next;
  }
}

/// `retry: noMistakesRetry` is NOT optional. Riverpod 3 retries a failed
/// provider build automatically with exponential backoff, and while it retries
/// the state stays `AsyncLoading` (carrying the error) instead of becoming
/// `AsyncError` — the screen would sit on its skeleton forever rather than
/// showing error/offline, and would keep hammering the endpoint on a dead
/// network. Retry here is a user-tapped button, never silent.
///
/// **autoDispose, and that is the session boundary** (E4-05, the same remedy as
/// `meProvider`, KNOWN_BUGS BUG-015). The overview is the flow's landing screen
/// and still survives the drill-down, because it stays mounted below the tree
/// screens, exactly as `subjectsProvider` does. What it no longer does is outlive
/// the student: it holds a named minor's per-subject wrong-answer counts, and as
/// a plain provider `invalidateSessionScope` only rebuilt it with the previous
/// value kept, so the next student on the handset saw those counts until their
/// own request landed. A sign-out unmounts the shell, and the last listener
/// leaving drops the element. See [mistakesTreeProvider] for why the TREE is
/// dropped even sooner.
///
/// ⚠️ **KNOWN GAP, recorded rather than papered over (2026-09-12).** An earlier
/// draft of this comment claimed the overview "is invalidated deliberately
/// after a quiz". **It is not.** The only invalidation today is sign-out
/// (`session_scope.dart`).
///
/// That matters, because finishing any quiz can change these counts: the
/// contract computes `mistakeCount` on every read and a question stops counting
/// the moment the student's most recent graded answer to it is right
/// (`openapi.yaml:882-886`). So a student who clears a lesson and returns to an
/// overview that is still mounted below the quiz sees a count they have already
/// fixed. (Leaving the Mistakes flow altogether now drops the overview, so the
/// next entry asks again.)
///
/// It is NOT wired here on purpose. The trigger belongs in the caller that
/// navigates back from the quiz — never in `initState` (BUG-001) — which means
/// touching the quiz feature, and the Day 10 brief flags where to put it as "a
/// real design question" rather than a mechanical addition. The user-tapped
/// [refresh] and the screen's retry are the mitigation until then.
///
/// The blast radius is bounded: the TREE is `autoDispose`, so the per-subject
/// counts a student actually drills into are re-fetched every time.
final mistakesOverviewProvider =
    AsyncNotifierProvider.autoDispose<
      MistakesOverviewNotifier,
      List<MistakesSubject>
    >(MistakesOverviewNotifier.new, retry: noMistakesRetry);

/// `GET /me/mistakes/subjects/{subjectId}`, keyed by subject.
///
/// **One call, whole tree.** The endpoint returns the subject's entire pruned
/// structure in one payload, so the screens fetch once per subject and drive
/// every level below from the cached object — the same architecture as the
/// catalog drill-down, and for the same reason: re-fetching per level would be
/// three extra round trips for data the client already has.
///
/// The state is the sealed [MistakesTree], not one track's shape, so the same
/// provider serves a school student (units → chapters → lessons) and a
/// university one (a flat lecture list); the screens switch on the parsed
/// discriminator.
class MistakesTreeNotifier extends AsyncNotifier<MistakesTree> {
  MistakesTreeNotifier(this.subjectId);

  final String subjectId;

  /// Set once the provider is torn down. See [refresh].
  bool _disposed = false;

  @override
  Future<MistakesTree> build() {
    ref.onDispose(() => _disposed = true);
    return ref
        .watch(mistakesRepositoryProvider)
        .getMistakesForSubject(subjectId);
  }

  /// User-tapped retry only.
  Future<void> refresh() async {
    // Two separate hazards, and this provider has both because it is
    // autoDispose and the student can pop the screen mid-flight.
    //
    // 1. `ref` is DEAD after disposal — `riverpod-3.3.2/lib/src/core/ref.dart`
    //    `:232-240` throws `UnmountedRefException` — so the repository is
    //    captured BEFORE the first await rather than read after it. (W3-1 is
    //    still open elsewhere in this app for exactly this; do not add another.)
    // 2. Assigning `state` after disposal throws too, which is what
    //    `_disposed` guards. The flag is checked AFTER the await returns, so
    //    the request itself still completes — nothing is cancelled, the result
    //    is simply not written to a torn-down notifier.
    final repository = ref.read(mistakesRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.getMistakesForSubject(subjectId),
    );
    if (_disposed) return;
    state = result;
  }
}

/// 🔴 **`autoDispose`, and that is what makes the counts honest.**
///
/// `subjectTreeProvider` is autoDispose now too, but for the session boundary
/// alone: a catalog tree does not change while the student is looking at it, so
/// nothing about it would be wrong if it stayed warm.
///
/// A mistakes tree DOES change. `mistakeCount` counts a question only while the
/// student's most recent graded answer to it was wrong, it is recomputed on
/// every read and never cached server-side, and two requests seconds apart can
/// legitimately disagree (`openapi.yaml:882-886`). A warm cache would show a
/// student "8 mistakes" on a lesson they had just cleared. Leaving the screen
/// must therefore drop the tree.
final mistakesTreeProvider = AsyncNotifierProvider.autoDispose
    .family<MistakesTreeNotifier, MistakesTree, String>(
      MistakesTreeNotifier.new,
      retry: noMistakesRetry,
    );

/// Returning `null` tells Riverpod not to schedule a retry.
Duration? noMistakesRetry(int retryCount, Object error) => null;
