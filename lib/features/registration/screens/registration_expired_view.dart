import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../notifier/registration_controller.dart';

/// The friendly client guard shown when the registration draft is missing or the
/// `registrationToken`'s 10-minute window has elapsed. A distinct state (not an
/// error): a clear message + a single CTA back to `/login` to start again. Also
/// covers a deep-link into a wizard sub-route without a live token.
///
/// The server enforces expiry too; this just avoids a doomed submit and gives
/// the student a way out. Tapping the CTA resets the spine.
class RegistrationExpiredView extends ConsumerWidget {
  const RegistrationExpiredView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_off_outlined, size: 72, color: cs.error),
                const SizedBox(height: 24),
                Text(
                  l10n.registrationExpired,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () {
                    ref.read(registrationControllerProvider.notifier).reset();
                    context.go('/login');
                  },
                  child: Text(
                    l10n.backToLogin,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
