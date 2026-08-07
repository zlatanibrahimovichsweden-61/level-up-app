import 'package:flutter/material.dart';

import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/shell_body.dart';

/// Refer a Friend · routed at `/refer`, reached from the Profile hub.
///
/// TODO(contract): seif_fight.md **S5** — there is no referral endpoint, no
/// attribution model and no reward. This is not a missing screen; it is a
/// missing *feature* that the design already has an entry point for, and the
/// code a student types at Sign Up_1 is discarded client-side today.
///
/// **Nothing here is invented.** No referral code, no share sheet, no invite
/// count. A code is the one thing this screen exists to hand over, and there is
/// no endpoint that mints one — showing a plausible-looking string would send a
/// student off to share something meaningless with their friends. The frame's
/// share control renders, disabled, so the shape of the feature is visible and
/// its state is unambiguous.
class ReferAFriendScreen extends StatelessWidget {
  const ReferAFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: l10n.profileReferAFriend,
          backKey: const Key('refer_back'),
          child: ShellBody(
            icon: Icons.share,
            message: l10n.referUnavailable,
            action: DisabledActionButton(
              key: const Key('refer_share_button'),
              label: l10n.shareInvite,
              disabledHint: l10n.referUnavailable,
            ),
          ),
        ),
      ),
    );
  }
}
