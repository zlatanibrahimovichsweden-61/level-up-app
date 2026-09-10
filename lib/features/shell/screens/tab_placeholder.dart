import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// The shared body of the four not-yet-built tabs.
///
/// Each tab gets its own screen class (below) rather than one parameterised
/// route, so that replacing a placeholder with the real screen is a one-line
/// router change and the diff shows exactly which tab was built.
class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule, size: 48, color: ext.mutedText),
            const SizedBox(height: 16),
            Text(
              l10n.comingSoon,
              style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// `/leaderboard` — real data is `GET /leaderboard`, which is
/// **`x-stability: draft`** at the pinned contract (`openapi.yaml:1221`;
/// `/leaderboard/me` likewise at `:1263`). The board itself is fully built and
/// tested under `lib/features/leaderboard/` — it is held behind this
/// placeholder, not unwritten, because the app builds only against stable
/// paths.
///
/// **Both operations are already `stable` UPSTREAM** — promoted in `3.5.0-m1`
/// (2026-09-05); the source repo is ten minor versions ahead of our pin. This
/// gate is therefore a holding action until `contract/` is re-vendored, not a
/// verdict on the board. Un-gating is NOT a plain revert: the board predates
/// six behavioural changes (top-200 bound, signed/expiring cursor, short pages
/// while `hasMore` is true, `scoreHidden` exclusion, `403` on self-rank,
/// `404 not_ranked`). Audit against them first — D-008, Correction of
/// 2026-09-10.
///
/// No live updates either way: `contract/realtime.md:9` lists the `leaderboard`
/// hub as "not drafted".
class LeaderboardPlaceholderScreen extends StatelessWidget {
  const LeaderboardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      TabPlaceholder(title: AppLocalizations.of(context).navLeaderboard);
}

// The Learn tab's placeholder was removed in Day 5 — `/learn` now serves the
// real SubjectsScreen (see app_router.dart).

/// `/message` — the in-app inbox (admin broadcasts, end-of-year promotion).
class MessagePlaceholderScreen extends StatelessWidget {
  const MessagePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      TabPlaceholder(title: AppLocalizations.of(context).navMessage);
}

// The Account tab's placeholder was removed in Day 8 — `/account` now serves
// the real ProfileScreen (see app_router.dart).
