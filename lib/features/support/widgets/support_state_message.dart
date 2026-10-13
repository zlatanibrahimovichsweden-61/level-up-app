import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Centred icon + localized line + optional Retry, shared by the support
/// screens' empty, error and offline states so the three never drift apart.
///
/// Same shape as the notifications inbox's, kept private to its feature like
/// every other screen's. Retry re-asks the same request on a tap and nothing
/// else: the caller passes `null` when the failure must not be retried (a
/// rate-limited call, a pending deletion, an unknown ticket).
class SupportStateMessage extends StatelessWidget {
  const SupportStateMessage({
    super.key,
    required this.icon,
    required this.text,
    this.onRetry,
    this.retryKey,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  /// The key of the Retry button, so each screen's own is findable.
  final Key? retryKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: ext.mutedText),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              // Retry re-triggers the same request on tap, never a silent loop.
              FilledButton(
                key: retryKey,
                onPressed: onRetry,
                child: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
