import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// The shared body of the not-yet-built tabs. **One is left: Message.**
///
/// Each tab gets its own screen class (below) rather than one parameterised
/// route, so that replacing a placeholder with the real screen is a one-line
/// router change and the diff shows exactly which tab was built. Learn (Day 5),
/// Account (Day 8) and Leaderboard (2026-09-22) have each left this file that
/// way.
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

// The Leaderboard tab's placeholder was removed on 2026-09-22 —
// `/leaderboard` now serves the real LeaderboardScreen (see app_router.dart).
// It was held by D-008 from 2026-09-10, not by anything missing from the
// board; what closed the gate is `docs/D008_LEADERBOARD_AUDIT.md`, not the
// stability flip. Sharing and live updates remain gaps: there is no sharing
// surface in the contract, and `contract/realtime.md:9` lists the
// `leaderboard` hub as "not drafted".

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
