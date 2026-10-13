import 'package:flutter/material.dart';

import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/notifications_inbox.dart';

/// Notifications · routed at `/notifications`, pushed from the Home bell.
///
/// Figma `180:8386` (School) / `309:9525` (University, read identical), light
/// and EN only: no dark, Arabic, empty, loading, error or offline frame exists
/// (DESIGN_ISSUES DG-35, DG-08, DG-31), so those are derived from the shared
/// states and the established dark treatments, and logged for the designer.
///
/// The screen is only the frame — the title bar and its back chip. Everything
/// in it, from the filter chips down, is [NotificationsInbox], so a later
/// Message tab can host the same inbox (CW07b).
///
/// Pushed over the shell, as `/support` is: the frame draws no nav bar. It is
/// authenticated like every non-auth route, and it is not a shell location, so
/// return-to-target never remembers it.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: l10n.notifications,
          backKey: const Key('notifications_back'),
          child: const NotificationsInbox(),
        ),
      ),
    );
  }
}
