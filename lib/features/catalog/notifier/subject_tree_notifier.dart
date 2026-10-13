import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subject_tree.dart';
import '../repository/catalog_repository.dart';
import 'subjects_notifier.dart' show noCatalogRetry;

/// `GET /catalog/subjects/{subjectId}/tree`, cached per subject.
///
/// **This is the whole architecture of the drill-down.** The endpoint returns
/// the subject's entire tree in ONE payload, so:
/// - every level of the stack watches this one provider;
/// - opening a subject fetches once, and every level below it reads the cached
///   object — no second request, no spinner between levels;
/// - the family is keyed by `subjectId` and every level of the drill-down is
///   still mounted below the one on screen, so walking down and back up one
///   level keeps the tree warm.
///
/// Re-fetching per level would be the obvious-looking mistake: three extra
/// round trips for data the client already has.
///
/// **autoDispose, and that is the session boundary** (E4-05, the same remedy as
/// `meProvider`, KNOWN_BUGS BUG-015). The cost is deliberate and small: leaving
/// a subject for the Learn list drops its tree, and opening it again asks once
/// more. The alternative kept the previous student's units, chapters and
/// lessons readable through every rebuild, so the NEXT student on the same
/// handset saw them until their own answer landed (`invalidateSessionScope`
/// rebuilds a listened provider with the old value kept; it never disposes it).
///
/// The state is the sealed [SubjectTree], not one track's shape: the same
/// provider serves a school student (units → chapters → lessons) and a
/// university one (a flat lecture list), and the screens switch on the parsed
/// discriminator. Selecting a quiz type on the Lectures screen is local UI
/// state — it must never invalidate this provider.
class SubjectTreeNotifier extends AsyncNotifier<SubjectTree> {
  SubjectTreeNotifier(this.subjectId);

  final String subjectId;

  /// Set when the provider is torn down, so a Retry still in flight does not
  /// write to a dead notifier. Re-armed on EVERY build (Riverpod 3 keeps this
  /// instance across rebuilds and runs the dispose callbacks on each one).
  bool _disposed = false;

  @override
  Future<SubjectTree> build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return ref.watch(catalogRepositoryProvider).getSubjectTree(subjectId);
  }

  /// User-tapped retry only — see [subjectTreeProvider].
  Future<void> refresh() async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(
      () => ref.read(catalogRepositoryProvider).getSubjectTree(subjectId),
    );
    if (_disposed) return;
    state = next;
  }
}

/// `retry: noCatalogRetry` for the same reason as `subjectsProvider`: Riverpod 3
/// would otherwise auto-retry a failed build and hold the state in
/// `AsyncLoading`, so the screen would show an endless skeleton instead of the
/// error/offline view.
final subjectTreeProvider = AsyncNotifierProvider.autoDispose
    .family<SubjectTreeNotifier, SubjectTree, String>(
      SubjectTreeNotifier.new,
      retry: noCatalogRetry,
    );
