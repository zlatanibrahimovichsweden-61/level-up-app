import 'package:flutter/material.dart';

import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/shell_body.dart';

/// Customer Support · routed at `/support`, reached from the Profile hub.
///
/// TODO(contract): seif_fight.md **S33** — support is fully designed
/// (`Customer Support` ×3, `Create Ticket`, `Customer support chat`, the whole
/// Message tab) and has **no endpoint of any kind**. Not draft — absent.
///
/// **Nothing here is invented**: no ticket list, no chat thread, no reference
/// number. A support screen that accepts a message and drops it is worse than
/// one that says it is not open yet, because the student walks away believing
/// they have been heard. The frame's Create Ticket control renders, disabled.
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
          child: ShellBody(
            icon: Icons.headset_mic,
            message: l10n.supportUnavailable,
            action: DisabledActionButton(
              key: const Key('support_create_ticket_button'),
              label: l10n.createTicket,
              disabledHint: l10n.supportUnavailable,
            ),
          ),
        ),
      ),
    );
  }
}
