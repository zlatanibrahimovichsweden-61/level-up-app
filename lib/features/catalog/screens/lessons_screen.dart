import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../quiz/models/quiz_setup_args.dart';
import '../models/subject_tree.dart';
import '../notifier/subject_tree_notifier.dart';
import '../notifier/subjects_notifier.dart';
import '../widgets/catalog_scaffold.dart';
import '../widgets/catalog_states.dart';
import '../widgets/tree_list_row.dart';

/// Lessons — level 3, the leaf · Figma `135:1485` (dark `337:6143`)
/// (`.../unit/:unitId/chapter/:chapterId`).
///
/// Reads the CACHED tree (same provider as Units/Chapters). Each row shows the
/// lesson's `{answered}/{total} questions`, DISPLAY ONLY — the contract says it
/// never locks retakes, so every lesson is tappable regardless of its counter.
///
/// Tapping one hands off to `/quiz/setup` (Day 6) with the lesson's id and name,
/// plus the subject's name for the setup header when it is known (Wave 11).
class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({
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
    final tree = ref.watch(subjectTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;
    final subjectName = cachedSubjectName(ref, subjectId);

    // Titled after its parent chapter, per the frame ("Cell Structure lessons").
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
            child: CatalogAsyncView<SubjectTree>(
              value: tree,
              isEmpty: (data) => _lessonsOf(data).isEmpty,
              emptyMessage: l10n.nothingHere,
              onRetry: () =>
                  ref.read(subjectTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) => _LessonList(
                lessons: _lessonsOf(data),
                subjectName: subjectName,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Only a school tree has units/chapters — see [ChaptersScreen] for why a
  /// university payload here is EMPTY rather than an error.
  Chapter? _chapterOf(SubjectTree? tree) {
    if (tree is! SchoolSubjectTree) return null;
    for (final unit in tree.units) {
      if (unit.id != unitId) continue;
      for (final chapter in unit.chapters) {
        if (chapter.id == chapterId) return chapter;
      }
    }
    return null;
  }

  List<Lesson> _lessonsOf(SubjectTree tree) =>
      _chapterOf(tree)?.lessons ?? const [];
}

class _LessonList extends StatelessWidget {
  const _LessonList({required this.lessons, required this.subjectName});

  final List<Lesson> lessons;

  /// For the setup header's subject line. Null on a cold deep link.
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: lessons.length,
      // 16: the frames' 78 dp rows on a 94 dp pitch (`135:1485`, dark
      // `337:6143`), the same rhythm as Units and Chapters. API→UI Wave 10;
      // this was 12.
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final counter = lesson.questionCounter;
        return TreeListRow(
          index: index + 1,
          name: lesson.name,
          // The ONLY level the contract gives a counter for — so the only level
          // whose bar is drawn from real data. The frame's trailing label is a
          // rounded "80%"; we show the server's own numbers instead, which is
          // strictly more information and involves no extra client math.
          // Rendered, never acted on: the row is tappable at 0/0 and at 40/40.
          progress: counter.fraction,
          caption: l10n.questionsCount(counter.answered, counter.total),
          onTap: () => context.push(
            '/quiz/setup',
            extra: QuizSetupArgs.lesson(
              lessonId: lesson.id,
              scopeName: lesson.name,
              subjectName: subjectName,
            ),
          ),
        );
      },
    );
  }
}
