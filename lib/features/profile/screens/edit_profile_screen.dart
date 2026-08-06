import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// `/profile/edit` — **TEMPORARY.**
///
/// Day 8 Step 1 builds the Profile hub, and the hub's pencil has to go
/// somewhere. Step 2 replaces this file with the real Edit Profile form (Figma
/// `180:3989`) against `PATCH /me`, the last unconsumed stable endpoint.
///
/// It exists as a real route rather than a dead pencil on purpose: an
/// affordance the frame draws should either work or say why it does not, and
/// "not built yet" is a different, more honest statement than a tap that does
/// nothing.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
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
