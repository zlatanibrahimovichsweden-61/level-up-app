import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject_tree.dart';
import '../notifier/subject_tree_notifier.dart';
import '../notifier/subjects_notifier.dart';
import '../widgets/catalog_scaffold.dart';
import '../widgets/catalog_states.dart';
import '../widgets/tree_list_row.dart';

/// Units — level 1 of the drill-down · Figma `337:5894`
/// (`/learn/subject/:subjectId`).
///
/// This is the ONLY screen in the stack that causes a network call: watching
/// `subjectTreeProvider(subjectId)` fetches the whole tree once. Chapters and
/// Lessons read the same cached object.
class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(subjectTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;

    // The frame titles this screen "Biology Units". The subject's NAME is not in
    // the tree payload (`SchoolSubjectTree` is track + units), so it comes from
    // the already-loaded subjects list. Arriving by deep link, that list may not
    // be loaded — hence the bare fallback rather than an invented name.
    final subjectName = _subjectName(ref);

    return CatalogScaffold(
      title: subjectName == null
          ? l10n.unitsTitle
          : l10n.unitsTitleFor(subjectName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Expanded(
            child: CatalogAsyncView<SchoolSubjectTree>(
              value: tree,
              isEmpty: (data) => data.units.isEmpty,
              emptyMessage: l10n.nothingHere,
              onRetry: () =>
                  ref.read(subjectTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) => _UnitList(
                subjectId: subjectId,
                units: data.units,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _subjectName(WidgetRef ref) {
    for (final subject in ref.watch(subjectsProvider).value ?? const []) {
      if (subject.id == subjectId) return subject.name;
    }
    return null;
  }
}

class _UnitList extends StatelessWidget {
  const _UnitList({required this.subjectId, required this.units});

  final String subjectId;
  final List<Unit> units;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: units.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final unit = units[index];
        return TreeListRow(
          index: index + 1,
          name: unit.name,
          // No `progress`: the contract gives units no questionCounter, and
          // summing their lessons' counters would be exactly the client-side
          // math the contract forbids. See docs/DESIGN_ISSUES.md #16.
          // No fetch — the chapters are already in the object behind this row.
          onTap: () =>
              context.go('/learn/subject/$subjectId/unit/${unit.id}'),
        );
      },
    );
  }
}
