import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_typography.dart';

/// A distinct, pinned offline indicator (NOT a failed-request error). Shown when
/// connectivity is definitively down; screens disable their primary action
/// alongside it. Driven by `isOnlineProvider` at the call site.
///
/// Shared so every screen renders the same offline cue; RTL-safe via
/// directional insets and centered content.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.errorContainer,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 18, color: cs.onErrorContainer),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.offline,
                textAlign: TextAlign.center,
                style: AppType.bodyMediumStrong.copyWith(
                  color: cs.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
