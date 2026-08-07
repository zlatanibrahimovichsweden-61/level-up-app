import 'package:flutter/material.dart';

import '../../../core/widgets/titled_chrome.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/shell_body.dart';

/// Friends · routed at `/friends`.
///
/// TODO(contract): seif_fight.md **S36** — a `Friends` frame exists in the
/// Account cluster and the contract has nothing behind it: no friends list, no
/// requests, no social graph of any kind. `scoreHidden`'s own description
/// (`openapi.yaml:1094`) says it "affects profiles/friends", so the concept is
/// in the contract's *prose* and in no path.
///
/// **This screen has no entry point.** The Profile hub draws ten rows and none
/// of them is Friends, so nothing in the app navigates here — it is reachable
/// only as a direct route. That is recorded rather than fixed: inventing an
/// eleventh row the frame does not draw would be exactly the invention this day
/// exists to avoid. Whoever designs the entry point gets a built destination.
///
/// **Nothing here is invented** — no friend rows, no counts, no avatars.
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: TitledChrome(
          title: l10n.friendsTitle,
          backKey: const Key('friends_back'),
          child: ShellBody(
            key: const Key('friends_body'),
            icon: Icons.group_outlined,
            message: l10n.friendsUnavailable,
          ),
        ),
      ),
    );
  }
}
