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
/// FLAT tree: the lecture is the leaf, so there are no deeper routes — tapping
/// one hands straight off to `/quiz/setup`.
///
/// The frame also draws a search field (`180:5232`) whose placeholder reads
/// "Search Chapters" on a screen listing lectures. It is not built, for the same
/// reason as the school drill-down: the copy is an unreviewed paste and search is
/// scoped to Subjects. See docs/DESIGN_ISSUES.md #17.
///
/// The selected quiz type is ephemeral UI state — `setState`, never a provider:
/// it is not server data, and changing it must not touch the cached tree.
class LecturesView extends StatefulWidget {
  const LecturesView({super.key, required this.tree});

  final UniversitySubjectTree tree;

  @override
  State<LecturesView> createState() => _LecturesViewState();
}

class _LecturesViewState extends State<LecturesView> {
  QuizType? _selected;

  /// `normal` when the subject offers it (the contract's own default for
  /// `POST /quizzes.quizType`), otherwise whatever the server does offer.
  QuizType get _quizType {
    final types = widget.tree.quizTypes;
    return _selected ??
        (types.contains(QuizType.normal) || types.isEmpty
            ? QuizType.normal
            : types.first);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lectures = widget.tree.lectures;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // A subject could list no quiz types at all; then there is nothing to
        // choose between and the row is simply absent.
        if (widget.tree.quizTypes.isNotEmpty) ...[
          QuizTypeTabs(
            types: widget.tree.quizTypes,
            selected: _quizType,
            onSelected: (type) => setState(() => _selected = type),
          ),
          const SizedBox(height: 16),
        ],
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
            itemCount: lectures.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                    quizType: _quizType,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
