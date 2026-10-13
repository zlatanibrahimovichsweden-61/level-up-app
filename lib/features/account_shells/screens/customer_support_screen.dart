import 'package:flutter/material.dart';

import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../../support/widgets/support_tickets_list.dart';

/// Customer Support · routed at `/support`, reached from the Profile hub.
///
/// The student's own support tickets, text only (CW12a): the "Create a New
/// Ticket" card, then the ticket list (`GET /support/tickets`) with its four
/// states. Figma `178:2800` (Customer Support).
///
/// It keeps the path and the class name it had as a placeholder: the router and
/// the return-target tests refer to it, and the route is unchanged. It is still
/// pushed outside the shell, so it is not a rememberable location.
///
/// The screen is only the frame, the title bar and its back chip. Everything
/// in it is [SupportTicketsList].
///
/// No dark, Arabic or empty/loading/error/offline frame exists for support, so
/// those are derived from the shared states and the established dark
/// treatments (docs/DESIGN_ISSUES.md #131).
class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: l10n.profileCustomerSupport,
          backKey: const Key('support_back'),
          child: const SupportTicketsList(),
        ),
      ),
    );
  }
}
