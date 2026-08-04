import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject_tree.dart';
import '../notifier/subject_tree_notifier.dart';
import '../notifier/subjects_notifier.dart';
import '../widgets/catalog_scaffold.dart';
import '../widgets/catalog_states.dart';
import 'lectures_screen.dart';
import 'units_screen.dart';

/// `/learn/subject/:subjectId` — the one route both tracks land on.
///
/// This is the ONLY screen in the Learn stack that causes a network call:
/// watching `subjectTreeProvider(subjectId)` fetches the subject's whole tree
/// once. Everything below reads that cached object.
///
/// The contract returns a `oneOf` discriminated on `track`, so the route cannot
/// know in advance which shape it will get — and it must not guess from the
/// student's profile. It waits for the payload and switches on the parsed type:
/// school → [UnitsView] (which drills further into unit/chapter/lesson routes),
/// university → [LecturesView] (flat; the lecture is already the leaf).
///
/// Loading, empty, error and offline live HERE rather than in the two bodies:
/// they are identical for both tracks, and duplicating them is how the two
/// branches drift apart.
class SubjectTreeScreen extends ConsumerWidget {
  const SubjectTreeScreen({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(subjectTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;
    final subjectName = cachedSubjectName(ref, subjectId);

    return CatalogScaffold(
      title: _title(l10n, subjectName, tree.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Expanded(
            child: CatalogAsyncView<SubjectTree>(
              value: tree,
              isEmpty: (data) => switch (data) {
                SchoolSubjectTree(:final units) => units.isEmpty,
                UniversitySubjectTree(:final lectures) => lectures.isEmpty,
              },
              emptyMessage: tree.value is UniversitySubjectTree
                  ? l10n.noLectures
                  : l10n.nothingHere,
              onRetry: () =>
                  ref.read(subjectTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) => switch (data) {
                SchoolSubjectTree(:final units) =>
                  UnitsView(subjectId: subjectId, units: units),
                UniversitySubjectTree() => LecturesView(tree: data),
              },
            ),
          ),
        ],
      ),
    );
  }

  /// The frames title this screen after its subject ("Biology Units",
  /// "Biology Lectures"), and the noun differs by track.
  ///
  /// Before the payload lands the track is unknown, so the header shows the
  /// subject's own name — track-neutral, and it means a university student never
  /// sees "Units" flash and correct itself. The bare fallbacks are for a cold
  /// deep link, where the subjects list was never fetched and there is no name
  /// to show; inventing one would be worse than showing none.
  static String _title(
    AppLocalizations l10n,
    String? subjectName,
    SubjectTree? tree,
  ) =>
      switch (tree) {
        UniversitySubjectTree() => subjectName == null
            ? l10n.lecturesTitle
            : l10n.lecturesTitleFor(subjectName),
        SchoolSubjectTree() => subjectName == null
            ? l10n.unitsTitle
            : l10n.unitsTitleFor(subjectName),
        null => subjectName ?? l10n.navLearn,
      };
}
