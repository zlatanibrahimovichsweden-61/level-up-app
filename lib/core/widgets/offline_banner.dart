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
    // A live region: the banner appears when connectivity drops, usually while
    // the student's attention is elsewhere on the screen, so a screen reader
    // announces it (its words are the Text's own - no copy of its own). Only
    // the banner that is shown is announced: it is built only while `offline`.
    return Semantics(
      liveRegion: true,
      child: Material(
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
                  // labelLarge (14/18/600), not bodyMediumStrong: this banner
                  // was 14px w600 on every screen before the type scale, and
                  // Login and OTP carried a private copy at the same metrics.
                  // One widget, one style — Fable style-fitting register SF-01.
                  style: AppType.labelLarge.copyWith(
                    color: cs.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
