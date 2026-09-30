import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../quiz/models/quiz_setup_args.dart';
import '../../quiz/models/quiz_type.dart';
import '../models/subject_tree.dart';
import '../widgets/quiz_type_tabs.dart';
import '../widgets/tree_list_row.dart';

/// Lectures — the UNIVERSITY branch · Figma `180:5208`.
///
/// The loaded body of [SubjectTreeScreen] at `/learn/subject/:subjectId`, which
/// owns the header and the loading/empty/error/offline chrome. University is a
/// FLAT tree: the lecture is the leaf, so there is no drill-down — tapping one
/// hands straight off, to `/quiz/setup` on a quiz tab or to the lecture's
/// flashcards on the Flashcard tab.
///
/// **The Flashcard tab** (owner rulings 2026-09-29) is how a student opens
/// Flashcards: the second pill, after the first quiz type. It lists only the
/// lectures whose `hasFlashcards` is true — each keeping its ORIGINAL position
/// number, so a lecture's badge matches its number on the quiz tabs — and the
/// tab is absent altogether when no lecture in the subject has any. Its rows
/// carry no progress bar and no caption: the contract has no flashcard progress,
/// so there is nothing true to draw. The route stays inside the nav shell.
///
/// The frame also draws a search field (`180:5232`) whose placeholder reads
/// "Search Chapters" on a screen listing lectures. It is not built, for the same
/// reason as the school drill-down: the copy is an unreviewed paste and search is
/// scoped to Subjects. See docs/DESIGN_ISSUES.md #17.
///
/// The selected tab is ephemeral UI state — `setState`, never a provider: it is
/// not server data, and changing it must not touch the cached tree.
class LecturesView extends StatefulWidget {
  const LecturesView({
    super.key,
    required this.subjectId,
    required this.tree,
    this.subjectName,
  });

  /// The route's `:subjectId`, needed to build a lecture's flashcards path. The
  /// tree itself does not carry it.
  final String subjectId;

  final UniversitySubjectTree tree;

  /// Handed to `/quiz/setup` for its subject line (API→UI Wave 11). Null on a
  /// cold deep link, where the subjects list was never fetched.
  final String? subjectName;

  @override
  State<LecturesView> createState() => _LecturesViewState();
}

class _LecturesViewState extends State<LecturesView> {
  LecturesTab? _picked;

  /// `normal` when the subject offers it (the contract's own default for
  /// `POST /quizzes.quizType`), otherwise whatever the server does offer.
  QuizType get _defaultQuizType {
    final types = widget.tree.quizTypes;
    return types.contains(QuizType.normal) || types.isEmpty
        ? QuizType.normal
        : types.first;
  }

  /// The tab in force: the student's pick while the row still offers it,
  /// otherwise the default quiz type. The check matters after a refresh — a
  /// reloaded tree may no longer list the Flashcard tab (or a quiz type) the
  /// student had chosen, and a selection the row cannot show would leave the
  /// list and the highlight disagreeing. For the same reason a subject that
  /// lists no quiz type but has flashcards opens on its one tab, Flashcard: the
  /// default quiz type is not in its row.
  LecturesTab _selected(List<LecturesTab> tabs) {
    final picked = _picked;
    if (picked != null && tabs.contains(picked)) return picked;
    final quizDefault = QuizTab(_defaultQuizType);
    return tabs.isEmpty || tabs.contains(quizDefault)
        ? quizDefault
        : tabs.first;
  }

  @override
  Widget build(BuildContext context) {
    final lectures = widget.tree.lectures;
    final tabs = lecturesTabsFor(
      quizTypes: widget.tree.quizTypes,
      // Hidden unless at least one lecture has cards — the contract: "a faculty
      // whose whole tree returns false ... the surface should not be offered at
      // all". Content presence only; never an entitlement check.
      hasFlashcards: lectures.any((lecture) => lecture.hasFlashcards),
    );
    final selected = _selected(tabs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // A subject could list no quiz types and no flashcards at all; then
        // there is nothing to choose between and the row is simply absent.
        if (tabs.isNotEmpty) ...[
          QuizTypeTabs(
            tabs: tabs,
            selected: selected,
            onSelected: (tab) => setState(() => _picked = tab),
          ),
          // 21 + the list's own top padding of 4 = the 25 every Lectures frame
          // leaves between the tabs and the first row (`180:5354`, `180:5208`,
          // dark `349:15962`, `337:11059`). API→UI Wave 08; this was 20.
          const SizedBox(height: 21),
        ],
        Expanded(
          child: switch (selected) {
            // Two different widgets, so crossing between the Flashcard tab and a
            // quiz tab starts the new list at the top; moving between QUIZ tabs
            // is the same widget and keeps its scroll place, as it always did.
            FlashcardsTab() => _FlashcardLectureList(
              subjectId: widget.subjectId,
              lectures: lectures,
            ),
            QuizTab(:final type) => _QuizLectureList(
              lectures: lectures,
              quizType: type,
              subjectName: widget.subjectName,
            ),
          },
        ),
      ],
    );
  }
}

/// The quiz tabs' list: every lecture, with its question counter. Tap →
/// `/quiz/setup`.
class _QuizLectureList extends StatelessWidget {
  const _QuizLectureList({
    required this.lectures,
    required this.quizType,
    required this.subjectName,
  });

  final List<Lecture> lectures;
  final QuizType quizType;
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: lectures.length,
      // 16, the same 94 dp pitch as Units. API→UI Wave 08; was 12.
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final lecture = lectures[index];
        final counter = lecture.questionCounter;
        return TreeListRow(
          index: index + 1,
          name: lecture.name,
          // Unlike school units/chapters, a lecture HAS a counter, so this
          // bar is drawn from real server numbers. Same rule as the school
          // lesson row: rendered, never acted on — a 0/0 lecture and a
          // fully-answered one are equally tappable, because the contract
          // says the counter never locks retakes.
          //
          // Label format matches school's lessons ("{answered} / {total}
          // questions") rather than the frame's rounded "80%": one format
          // across both tracks, and no extra client math either way.
          progress: counter.fraction,
          caption: l10n.questionsCount(counter.answered, counter.total),
          onTap: () => context.push(
            '/quiz/setup',
            extra: QuizSetupArgs.lecture(
              lectureId: lecture.id,
              scopeName: lecture.name,
              quizType: quizType,
              subjectName: subjectName,
            ),
          ),
        );
      },
    );
  }
}

/// The Flashcard tab's list: only the lectures with cards, in server order.
///
/// Each row keeps its position in the WHOLE lecture list (`index + 1` over
/// `tree.lectures`, not over the filtered set), so "3 · Thorax" here is the same
/// "3 · Thorax" on the quiz tabs even when lecture 2 has no cards.
///
/// **No bar and no caption.** The contract has no flashcard progress — a
/// flashcard's `selfGrade` is per card, and `flashcardCount` is "informational
/// and uncharged", explicitly not a progress denominator — so drawing either
/// would be inventing a number. `TreeListRow` omits both when `progress` and
/// `caption` are null, which is the whole implementation.
class _FlashcardLectureList extends StatelessWidget {
  const _FlashcardLectureList({
    required this.subjectId,
    required this.lectures,
  });

  final String subjectId;
  final List<Lecture> lectures;

  @override
  Widget build(BuildContext context) {
    // Positions are taken BEFORE filtering; see the class comment.
    final rows = <(int position, Lecture lecture)>[
      for (var i = 0; i < lectures.length; i++)
        if (lectures[i].hasFlashcards) (i + 1, lectures[i]),
    ];

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
      itemCount: rows.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final (position, lecture) = rows[index];
        return TreeListRow(
          index: position,
          name: lecture.name,
          onTap: () => context.push(
            '/learn/subject/$subjectId/lecture/${lecture.id}/flashcards',
          ),
        );
      },
    );
  }
}
