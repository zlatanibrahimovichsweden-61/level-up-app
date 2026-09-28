import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/widgets/catalog_scaffold.dart';
import '../../catalog/widgets/catalog_states.dart';
import '../models/mistakes_subject.dart';
import '../notifier/mistakes_notifiers.dart';
import '../widgets/mistakes_subject_card.dart';

/// The Mistakes overview · Figma `404:6292` (school) and `404:7110`
/// (university) · route `/learn/mistakes`.
///
/// **ONE screen, both tracks, no branch.** The two frames were opened and read
/// on 2026-09-12 and are pixel-identical — same grid, same cards, same copy —
/// and the endpoint behind them takes no track parameter and returns one shape.
/// Only the TREE below forks, on the payload's own discriminator.
///
/// Powered by one call, `GET /me/mistakes`, which the server scopes from the
/// token: this screen sends no scope parameters and must never start.
///
/// ---
///
/// **Two things here are not the catalog's, and both are contract-driven.**
///
/// 1. **Empty is the happy path.** `200 []` is "a NORMAL response — the record
///    of a student who has nothing outstanding", and the contract states that
///    clients MUST NOT render empty-as-error (`openapi.yaml:895-897`). A
///    subject with zero current mistakes is ABSENT from the array rather than
///    present with `0`, which is why `mistakeCount` publishes `minimum: 1`. No
///    frame draws this state; the neutral `noMistakes` ships until the designer
///    supplies a warmer one (docs/DESIGN_ISSUES.md #60).
///
/// 2. 🔴 **`insufficient_scope` does NOT mean "this subject isn't yours" here.**
///    This operation takes no id and refuses no id. The code means the caller
///    has no active enrolment to scope a history against — reachable in
///    ordinary use, because a track transfer closes the old enrolment before
///    the new one opens (adr-032). So the screen passes
///    [ScopeErrorCopy.enrolmentPending] in, which swaps the copy AND restores
///    the retry button the subject route suppresses. See #61.
///
/// `account_pending_deletion`, the other `403` both routes can answer, IS
/// handled — not in this file, but once, in the [CatalogAsyncView] that both
/// Mistakes routes render their states through. It gets its own copy
/// (`accountPendingDeletion`) and its Retry button is WITHHELD, because the
/// contract says outright do not log the user out and do not retry
/// (`openapi.yaml:82-83`). The single definition is `isAccountPendingDeletion`
/// in `core/network/exceptions.dart`. This screen's own job is unchanged: do
/// not mistake the code for a scope refusal, which it does not.
/// TODO(contract): the contract's THIRD rule — route to the cancel screen — is
/// still unimplemented, because that screen does not exist. Both deletion
/// operations became `x-stability: stable` at the current pin — see
/// docs/seif_fight.md S38 and DESIGN_ISSUES #62.
class MistakesOverviewScreen extends ConsumerWidget {
  const MistakesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mistakes = ref.watch(mistakesOverviewProvider);
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    return CatalogScaffold(
      title: l10n.mistakesTitle,
      // No trailing action: the Subjects header's one action is what brought
      // the student here, and pointing it at this screen would be a dead
      // control.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (offline) const OfflineBanner(),
          Expanded(
            child: CatalogAsyncView<List<MistakesSubject>>(
              value: mistakes,
              isEmpty: (data) => data.isEmpty,
              emptyMessage: l10n.noMistakes,
              scopeError: ScopeErrorCopy.enrolmentPending,
              onRetry: () =>
                  ref.read(mistakesOverviewProvider.notifier).refresh(),
              skeleton: const _MistakesSkeleton(),
              onLoaded: (data) => _MistakesGrid(subjects: data),
            ),
          ),
        ],
      ),
    );
  }
}

// The frame's grid (`404:6312`) starts 25 under the header (`404:6475` ends at
// 99.44, the cards start at 124.44). `CatalogScaffold` leaves 16 under every
// header, so this screen adds the rest. It had 16 (API→UI Wave 15).
const _belowHeader = 25.0 - 16;
const _columnGap = 16.5;
const _rowGap = 18.0;

class _MistakesGrid extends StatelessWidget {
  const _MistakesGrid({required this.subjects});

  final List<MistakesSubject> subjects;

  @override
  Widget build(BuildContext context) {
    // Two columns at the frame's spacing, built as rows rather than a
    // `GridView`: a grid cell has one height for every card, and the frame's
    // 89 is too short for the text at a raised text scale — an Arabic card
    // overflowed from 1.3 and every card at 2.0 (BUG-002). A row is as tall
    // as its taller card, and never shorter than the frame's.
    final rows = (subjects.length / 2).ceil();
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(20, _belowHeader, 20, 24),
      itemCount: rows,
      separatorBuilder: (_, _) => const SizedBox(height: _rowGap),
      itemBuilder: (context, row) {
        // The server already ordered this list — `name` ascending, then `id`,
        // "a stable order the client can render without sorting"
        // (`openapi.yaml:901-903`). Rendered in arrival order, row by row;
        // never sorted.
        Widget cell(int index) {
          if (index >= subjects.length) return const SizedBox.shrink();
          final subject = subjects[index];
          return MistakesSubjectCard(
            subject: subject,
            // The ONE tree fetch for this subject starts here.
            onTap: () => context.push('/learn/mistakes/subject/${subject.id}'),
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cell(row * 2)),
              const SizedBox(width: _columnGap),
              Expanded(child: cell(row * 2 + 1)),
            ],
          ),
        );
      },
    );
  }
}

class _MistakesSkeleton extends StatelessWidget {
  const _MistakesSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(20, _belowHeader, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: _rowGap,
        crossAxisSpacing: _columnGap,
        mainAxisExtent: MistakesSubjectCard.minHeight,
      ),
      itemCount: 6,
      // 89 tall at radius 10.7 — `CatalogBlock`'s own default radius, and the
      // card's height at the default text scale. The page does not jump when
      // the data lands.
      itemBuilder: (_, _) =>
          const CatalogBlock(height: MistakesSubjectCard.minHeight),
    );
  }
}
