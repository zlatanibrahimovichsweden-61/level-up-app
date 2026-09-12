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
/// `account_pending_deletion`, the other `403` both routes can answer, is
/// deliberately NOT handled here: the contract's rule (route to the cancel
/// screen, do not log out, do not retry — `openapi.yaml:82-83`) belongs in the
/// global error interceptor, one place for every endpoint. This screen only has
/// to avoid swallowing it, which it does — the code is not `insufficient_scope`,
/// so it falls through to the generic error with retry rather than being
/// mistaken for a scope refusal.
/// TODO(contract): the mandated cancel screen does not exist. Both deletion
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

class _MistakesGrid extends StatelessWidget {
  const _MistakesGrid({required this.subjects});

  final List<MistakesSubject> subjects;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      // The same delegate as the catalog's Subjects grid — the two frames draw
      // the same 2-column layout at the same spacing, so they share the numbers
      // rather than each carrying their own copy of them.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16.5,
        childAspectRatio: MistakesSubjectCard.aspectRatio,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        // The server already ordered this list — `name` ascending, then `id`,
        // "a stable order the client can render without sorting"
        // (`openapi.yaml:901-903`). Rendered in arrival order; never sorted.
        return MistakesSubjectCard(
          subject: subject,
          // The ONE tree fetch for this subject starts here.
          onTap: () => context.push('/learn/mistakes/subject/${subject.id}'),
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
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16.5,
        childAspectRatio: MistakesSubjectCard.aspectRatio,
      ),
      itemCount: 6,
      // 89 tall at radius 10.7 — `CatalogBlock`'s own default radius, and the
      // card's exact height. The page does not jump when the data lands.
      itemBuilder: (_, _) => const CatalogBlock(height: 89),
    );
  }
}
