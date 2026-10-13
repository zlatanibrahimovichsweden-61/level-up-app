import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../notifier/registration_controller.dart';

/// The friendly client guard shown when the registration draft is missing or the
/// `registrationToken`'s 10-minute window has elapsed. A distinct state (not an
/// error): a clear message + a single CTA back to `/login` to start again. Also
/// covers a deep-link into a wizard sub-route without a live token.
///
/// The server enforces expiry too; this just avoids a doomed submit and gives
/// the student a way out. Tapping the CTA resets the spine.
///
/// The OS Back does the same, and the view says so itself - on EVERY wizard
/// screen that renders it (identity, track, School, University), not at one
/// call site. The wizard is entered with `go` (the OTP screen replaces itself, a
/// cold link has no stack), so an OS Back left alone either closed the app from
/// the one screen whose only message is "start again" or, deeper in the wizard,
/// popped to a sibling screen that shows this same view. Because it is handled
/// HERE, a screen must not wrap this view in a second `PopScope` of its own:
/// nested ones each fire their handler.
class RegistrationExpiredView extends ConsumerWidget {
  const RegistrationExpiredView({super.key});

  /// Spend the spine and start again at Login: the button and the OS Back.
  void _leave(BuildContext context, WidgetRef ref) {
    ref.read(registrationControllerProvider.notifier).reset();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave(context, ref);
      },
      child: Scaffold(
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
                    style: AppType.h2.copyWith(color: ext.textPrimary),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => _leave(context, ref),
                    child: Text(l10n.backToLogin, style: AppType.buttonLarge),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
