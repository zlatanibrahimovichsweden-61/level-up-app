import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subject_tree.dart';
import '../repository/catalog_repository.dart';
import 'subjects_notifier.dart' show noCatalogRetry;

/// `GET /catalog/subjects/{subjectId}/tree`, cached per subject.
///
/// **This is the whole architecture of the drill-down.** The endpoint returns
/// units → chapters → lessons in ONE payload, so:
/// - Units, Chapters and Lessons all watch this one provider;
/// - opening a subject fetches once, and every level below it reads the cached
///   object — no second request, no spinner between levels;
/// - the family is keyed by `subjectId` and is NOT autoDispose, so walking back
///   up and into another subject keeps the first tree warm for the session.
///
/// Re-fetching per level would be the obvious-looking mistake: three extra
/// round trips for data the client already has.
class SubjectTreeNotifier extends AsyncNotifier<SchoolSubjectTree> {
  SubjectTreeNotifier(this.subjectId);

  final String subjectId;

  @override
  Future<SchoolSubjectTree> build() =>
      ref.watch(catalogRepositoryProvider).getSubjectTree(subjectId);

  /// User-tapped retry only — see [subjectTreeProvider].
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(catalogRepositoryProvider).getSubjectTree(subjectId),
    );
  }
}

/// `retry: noCatalogRetry` for the same reason as `subjectsProvider`: Riverpod 3
/// would otherwise auto-retry a failed build and hold the state in
/// `AsyncLoading`, so the screen would show an endless skeleton instead of the
/// error/offline view.
final subjectTreeProvider =
    AsyncNotifierProvider.family<SubjectTreeNotifier, SchoolSubjectTree, String>(
  SubjectTreeNotifier.new,
  retry: noCatalogRetry,
);
