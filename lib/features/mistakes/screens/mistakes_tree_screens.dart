/// The two deeper SCHOOL levels of the Mistakes drill-down.
///
/// Both are VIEWS over the one tree [MistakesSubjectScreen] already fetched.
/// Watching `mistakesTreeProvider(subjectId)` here is a cache read, not a
/// second request: the provider is alive from the screen above. (Arriving by
/// deep link instead, it builds once — one call for the whole stack either
/// way.) The ids in the path SELECT from that object; they are not fetch keys.
///
/// Neither level exists on the university track, whose tree stops at the
/// lecture. A university payload reaching these routes means a hand-typed URL,
/// and is treated as EMPTY rather than as a crash — the same rule
/// `chapters_screen.dart` states for the catalog.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/widgets/catalog_scaffold.dart';
import '../../catalog/widgets/catalog_states.dart';
import '../../catalog/widgets/tree_list_row.dart';
import '../models/mistakes_tree.dart';
import '../notifier/mistakes_notifiers.dart';

// The Chapters frames' list starts 25 under the header (`404:6719` ends at
// 99.44, the first row `404:6697` starts at 124.44) and its rows are 16 apart
// (the second starts at 218.44), in light `404:6677` and dark `404:7894`: the
// Units list's rhythm. `CatalogScaffold` leaves 16 under every header, so the
// list adds the rest. It had 4 and 12 (API→UI Wave 17). The Lessons list takes
// the same (API→UI Wave 18): `404:6762` starts its one row 25 under the header
// (`404:6804` ends at 99.44, the row `404:6782` starts at 124.44; the RTL
// frame `549:19390` puts its row at the same 124.44). No dark frame draws
// Lessons: `404:7990`, the dark frame in its slot, draws a Chapters list with
// the same 25 and rows 16 apart. It had 4 and 12 too.
const _belowHeader = 25.0 - 16;
const _rowGap = 16.0;

/// Chapters — level 2 · Figma `404:6677`
/// (`/learn/mistakes/subject/:subjectId/unit/:unitId`).
class MistakesChaptersScreen extends ConsumerWidget {
  const MistakesChaptersScreen({
    super.key,
    required this.subjectId,
    required this.unitId,
  });

  final String subjectId;
  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(mistakesTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;

    // The frame titles this screen after its parent unit ("Cell Biology
    // Chapter"). The unit's name IS in the cached tree, so no extra lookup —
    // and the catalog's own `chaptersTitleFor` already says these words.
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
            child: CatalogAsyncView<MistakesTree>(
              value: tree,
              // An unknown unitId (stale deep link, a count that decayed to
              // zero and pruned the branch away between two reads) is EMPTY,
              // not a crash and not an error.
              isEmpty: (data) => _chaptersOf(data).isEmpty,
              emptyMessage: l10n.noMistakes,
              onRetry: () =>
                  ref.read(mistakesTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) => _MistakesChapterList(
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

  MistakesUnit? _unitOf(MistakesTree? tree) {
    if (tree is! SchoolMistakesTree) return null;
    for (final unit in tree.units) {
      if (unit.id == unitId) return unit;
    }
    return null;
  }

  List<MistakesChapter> _chaptersOf(MistakesTree tree) =>
      _unitOf(tree)?.chapters ?? const [];
}

class _MistakesChapterList extends StatelessWidget {
  const _MistakesChapterList({
    required this.subjectId,
    required this.unitId,
    required this.chapters,
  });

  final String subjectId;
  final String unitId;
  final List<MistakesChapter> chapters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, _belowHeader, 20, 24),
      itemCount: chapters.length,
      separatorBuilder: (_, _) => const SizedBox(height: _rowGap),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return TreeListRow(
          index: index + 1,
          name: chapter.name,
          palette: TreeRowPalette.mistakes,
          // The server's number for this chapter, rendered verbatim — never
          // the sum of the lessons below it, which are right there and are
          // still not added up (adr-133).
          countLabel: l10n.mistakeCount(chapter.mistakeCount),
          onTap: () => context.push(
            '/learn/mistakes/subject/$subjectId/unit/$unitId'
            '/chapter/${chapter.id}',
          ),
        );
      },
    );
  }
}

/// Lessons — level 3, the leaf · Figma `404:6762`
/// (`.../unit/:unitId/chapter/:chapterId`).
///
/// **Every row here is inert.** The replay quiz (`404:6853`) is out of scope
/// for Day 10, so a lesson has nowhere to go; the rows therefore drop their
/// chevron and their ripple rather than looking tappable and swallowing the
/// tap. Owner ruling 2026-09-12 — see [TreeListRow.onTap].
class MistakesLessonsScreen extends ConsumerWidget {
  const MistakesLessonsScreen({
    super.key,
    required this.subjectId,
    required this.unitId,
    required this.chapterId,
  });

  final String subjectId;
  final String unitId;
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(mistakesTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;

    // Titled after its parent chapter, per the frame ("Cell Structure
    // lessons").
    final chapterName = _chapterOf(tree.value)?.name;

    return CatalogScaffold(
      title: chapterName == null
          ? l10n.lessonsTitle
          : l10n.lessonsTitleFor(chapterName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Expanded(
            child: CatalogAsyncView<MistakesTree>(
              value: tree,
              isEmpty: (data) => _lessonsOf(data).isEmpty,
              emptyMessage: l10n.noMistakes,
              onRetry: () =>
                  ref.read(mistakesTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) =>
                  _MistakesLessonList(lessons: _lessonsOf(data)),
            ),
          ),
        ],
      ),
    );
  }

  MistakesChapter? _chapterOf(MistakesTree? tree) {
    if (tree is! SchoolMistakesTree) return null;
    for (final unit in tree.units) {
      if (unit.id != unitId) continue;
      for (final chapter in unit.chapters) {
        if (chapter.id == chapterId) return chapter;
      }
    }
    return null;
  }

  List<MistakesLesson> _lessonsOf(MistakesTree tree) =>
      _chapterOf(tree)?.lessons ?? const [];
}

class _MistakesLessonList extends StatelessWidget {
  const _MistakesLessonList({required this.lessons});

  final List<MistakesLesson> lessons;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, _belowHeader, 20, 24),
      itemCount: lessons.length,
      separatorBuilder: (_, _) => const SizedBox(height: _rowGap),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return TreeListRow(
          index: index + 1,
          name: lesson.name,
          palette: TreeRowPalette.mistakes,
          countLabel: l10n.mistakeCount(lesson.mistakeCount),
          // LEAF — inert. See the class doc.
          onTap: null,
        );
      },
    );
  }
}
