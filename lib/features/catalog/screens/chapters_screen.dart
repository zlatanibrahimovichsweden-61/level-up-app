import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../models/subject_tree.dart';
import '../notifier/subject_tree_notifier.dart';
import '../widgets/catalog_scaffold.dart';
import '../widgets/catalog_states.dart';
import '../widgets/tree_list_row.dart';

/// Chapters — level 2 · Figma `135:1270` (dark `337:6047`)
/// (`/learn/subject/:subjectId/unit/:unitId`).
///
/// Reads the CACHED tree. Watching `subjectTreeProvider(subjectId)` here is a
/// cache read, not a second request: the provider is already built and alive
/// from the Units screen. (Arriving by deep link instead, it builds once — one
/// call for the whole stack either way.)
class ChaptersScreen extends ConsumerWidget {
  const ChaptersScreen({
    super.key,
    required this.subjectId,
    required this.unitId,
  });

  final String subjectId;
  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(subjectTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;

    // The frame titles this screen after its parent unit ("Cell Biology
    // Chapters"). The unit's name IS in the cached tree, so no extra lookup.
    final unitName = _unitOf(tree.value)?.name;

    return CatalogScaffold(
      title: unitName == null
          ? l10n.chaptersTitle
          : l10n.chaptersTitleFor(unitName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Expanded(
            child: CatalogAsyncView<SubjectTree>(
              value: tree,
              // An unknown unitId (stale deep link, content withdrawn) is EMPTY,
              // not a crash and not an error.
              isEmpty: (data) => _chaptersOf(data).isEmpty,
              emptyMessage: l10n.nothingHere,
              onRetry: () =>
                  ref.read(subjectTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) => _ChapterList(
                subjectId: subjectId,
                unitId: unitId,
                chapters: _chaptersOf(data),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Only a school tree has units. These routes are unreachable on university
  /// (its tree is flat and stops at the lecture), so a university payload here
  /// means a hand-typed URL — treated as EMPTY, never a crash.
  Unit? _unitOf(SubjectTree? tree) {
    if (tree is! SchoolSubjectTree) return null;
    for (final unit in tree.units) {
      if (unit.id == unitId) return unit;
    }
    return null;
  }

  List<Chapter> _chaptersOf(SubjectTree tree) =>
      _unitOf(tree)?.chapters ?? const [];
}

class _ChapterList extends StatelessWidget {
  const _ChapterList({
    required this.subjectId,
    required this.unitId,
    required this.chapters,
  });

  final String subjectId;
  final String unitId;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: chapters.length,
      // 16: the frames' 78 dp rows on a 94 dp pitch (`135:1270`, dark
      // `337:6047`), the same rhythm as Units. API→UI Wave 09; this was 12.
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return TreeListRow(
          index: index + 1,
          name: chapter.name,
          // No `progress` — chapters carry no questionCounter either.
          // See docs/DESIGN_ISSUES.md #16.
          onTap: () => context.go(
            '/learn/subject/$subjectId/unit/$unitId/chapter/${chapter.id}',
          ),
        );
      },
    );
  }
}
