import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
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
              style: TextStyle(fontSize: 16, color: ext.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// `/leaderboard` — real data is `GET /leaderboard` (stable, paginated, SignalR
/// live updates). Not Day 4.
class LeaderboardPlaceholderScreen extends StatelessWidget {
  const LeaderboardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      TabPlaceholder(title: AppLocalizations.of(context).navLeaderboard);
}

/// `/learn` — this is where the subjects list (`GET /catalog/subjects`) lands.
/// Explicitly deferred: subjects are the Learn tab, not Home.
class LearnPlaceholderScreen extends StatelessWidget {
  const LearnPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      TabPlaceholder(title: AppLocalizations.of(context).navLearn);
}

/// `/message` — the in-app inbox (admin broadcasts, end-of-year promotion).
class MessagePlaceholderScreen extends StatelessWidget {
  const MessagePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      TabPlaceholder(title: AppLocalizations.of(context).navMessage);
}

/// `/account` — profile + settings + subscription entry point.
class AccountPlaceholderScreen extends StatelessWidget {
  const AccountPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      TabPlaceholder(title: AppLocalizations.of(context).navAccount);
}
