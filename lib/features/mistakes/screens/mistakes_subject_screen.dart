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

/// `/learn/mistakes/subject/:subjectId` — the one route both tracks land on.
///
/// This is the ONLY screen in the Mistakes stack that causes a network call:
/// watching `mistakesTreeProvider(subjectId)` fetches the subject's whole
/// pruned tree once. Every level below reads that cached object, exactly as the
/// catalog drill-down does — four screens, one request.
///
/// The contract returns a `oneOf` discriminated on `track`, so the route cannot
/// know in advance which shape it will get, and it must not guess from the
/// student's profile. It waits for the payload and switches on the parsed type:
/// school → [MistakesUnitsView], which drills into the nested unit/chapter
/// routes; university → [MistakesLecturesView], which is already the leaf.
///
/// 🔴 **No `QuizTypeTabs` on the university branch.** `UniversityMistakesTree`
/// carries no `quizTypes`, unlike `UniversitySubjectTree` — *"a mistakes tree
/// is a history view, not a quiz-build tree"* (`openapi.yaml:2239-2241`) — and
/// the frame `404:7181` draws no tab row either. Contract and design agree.
///
/// **An empty tree is a `200`, not an error and not a `403`.** An in-scope
/// subject the student has nothing outstanding in answers `mistakeCount: 0`
/// with an empty child list (`:960-964`); a subject outside their scope answers
/// `403 insufficient_scope`. Both are reachable with an empty history, so this
/// screen branches on the STATUS, never on emptiness.
///
/// Unlike the overview, `insufficient_scope` HERE does mean "this subject isn't
/// yours" — the route took an id and refused it, the same answer
/// `getSubjectTree` gives about the same id. So the default
/// [ScopeErrorCopy.subjectNotYours] is correct and is deliberately not
/// overridden. See docs/DESIGN_ISSUES.md #61.
class MistakesSubjectScreen extends ConsumerWidget {
  const MistakesSubjectScreen({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(mistakesTreeProvider(subjectId));
    final offline = ref.watch(isOnlineProvider).value == false;
    final subjectName = cachedMistakesSubjectName(ref, subjectId);

    return CatalogScaffold(
      title: _title(l10n, subjectName, tree.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Expanded(
            child: CatalogAsyncView<MistakesTree>(
              value: tree,
              isEmpty: (data) => switch (data) {
                SchoolMistakesTree(:final units) => units.isEmpty,
                UniversityMistakesTree(:final lectures) => lectures.isEmpty,
              },
              emptyMessage: l10n.noMistakes,
              onRetry: () =>
                  ref.read(mistakesTreeProvider(subjectId).notifier).refresh(),
              skeleton: const CatalogListSkeleton(),
              onLoaded: (data) => switch (data) {
                SchoolMistakesTree(:final units) => MistakesUnitsView(
                  subjectId: subjectId,
                  units: units,
                ),
                UniversityMistakesTree(:final lectures) => MistakesLecturesView(
                  lectures: lectures,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  /// The frames title this screen after its subject ("Biology Units",
  /// "Biology Lectures") — the same strings the catalog drill-down already
  /// uses, so the same ARB keys serve both rather than a second set saying the
  /// same words.
  ///
  /// Before the payload lands the track is unknown, so the header shows the
  /// subject's own name: track-neutral, and a university student never sees
  /// "Units" flash and correct itself. The bare fallbacks are for a cold deep
  /// link, where the overview was never fetched and there is no name to show —
  /// inventing one would be worse than showing none.
  static String _title(
    AppLocalizations l10n,
    String? subjectName,
    MistakesTree? tree,
  ) => switch (tree) {
    UniversityMistakesTree() =>
      subjectName == null
          ? l10n.lecturesTitle
          : l10n.lecturesTitleFor(subjectName),
    SchoolMistakesTree() =>
      subjectName == null ? l10n.unitsTitle : l10n.unitsTitleFor(subjectName),
    null => subjectName ?? l10n.mistakesTitle,
  };
}

// The frames' list starts 25 under the header (`404:6599` ends at 99.44, the
// first row `404:6642` starts at 124.44) and its rows are 16 apart (the second
// starts at 218.44), in the school `404:6539` and the university `404:7181`.
// `CatalogScaffold` leaves 16 under every header, so the lists add the rest.
// They had 4 and 12 (API→UI Wave 16).
const _belowHeader = 25.0 - 16;
const _rowGap = 16.0;

/// The subject's display name, read from the ALREADY-LOADED overview.
///
/// The tree payload contains no subject name — only the track, a count and its
/// children — so the name comes from the list the student just tapped through
/// rather than from a second request. The catalog's `cachedSubjectName` does
/// the same thing against `subjectsProvider`; this reads the Mistakes overview
/// instead, because the two lists are NOT the same set: the overview holds only
/// subjects with at least one current mistake.
///
/// Returns null on a cold deep link. Server copy, already in the content
/// language (adr-018) — never translated client-side.
String? cachedMistakesSubjectName(WidgetRef ref, String subjectId) {
  for (final subject in ref.watch(mistakesOverviewProvider).value ?? const []) {
    if (subject.id == subjectId) return subject.name;
  }
  return null;
}

/// Units — level 1 of the SCHOOL drill-down · Figma `404:6539`.
///
/// The loaded body of [MistakesSubjectScreen], which owns the header and the
/// loading/empty/error/offline chrome for both tracks. No fetch happens here:
/// the chapters behind every row are already inside the object this list was
/// built from.
///
/// **Every row leads somewhere.** The tree is pruned server-side — a lesson
/// appears only when its own count is above zero, a chapter only when it has
/// such a lesson, a unit only when it has such a chapter — so *"there is no
/// dead branch the student can tap into and find empty"* (`:953-957`). The
/// client needs no filtering and no empty-child guard.
class MistakesUnitsView extends StatelessWidget {
  const MistakesUnitsView({
    super.key,
    required this.subjectId,
    required this.units,
  });

  final String subjectId;
  final List<MistakesUnit> units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, _belowHeader, 20, 24),
      itemCount: units.length,
      separatorBuilder: (_, _) => const SizedBox(height: _rowGap),
      itemBuilder: (context, index) {
        final unit = units[index];
        return TreeListRow(
          index: index + 1,
          name: unit.name,
          palette: TreeRowPalette.mistakes,
          // The server's own number for this unit. It is NOT recomputed from
          // the chapters underneath it, even though they are in hand — the
          // contract guarantees the parent is their exact sum and forbids the
          // client doing the arithmetic anyway (adr-133).
          countLabel: l10n.mistakeCount(unit.mistakeCount),
          // No `progress`: this tree has no `questionCounter` at any level.
          onTap: () => context.push(
            '/learn/mistakes/subject/$subjectId/unit/${unit.id}',
          ),
        );
      },
    );
  }
}

/// Lectures — the UNIVERSITY branch · Figma `404:7181`.
///
/// University is a FLAT tree: the lecture is the leaf, so there are no deeper
/// routes and — Day 10 — no destination either. Every row here is inert; see
/// [TreeListRow.onTap].
class MistakesLecturesView extends StatelessWidget {
  const MistakesLecturesView({super.key, required this.lectures});

  final List<MistakesLecture> lectures;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, _belowHeader, 20, 24),
      itemCount: lectures.length,
      separatorBuilder: (_, _) => const SizedBox(height: _rowGap),
      itemBuilder: (context, index) {
        final lecture = lectures[index];
        return TreeListRow(
          index: index + 1,
          name: lecture.name,
          palette: TreeRowPalette.mistakes,
          countLabel: l10n.mistakeCount(lecture.mistakeCount),
          // LEAF — inert this day. The replay quiz (`404:7234`) is out of
          // scope, so there is nothing to navigate to; the row therefore drops
          // its chevron and its ripple rather than looking tappable and
          // swallowing the tap. Owner ruling 2026-09-12.
          onTap: null,
        );
      },
    );
  }
}
