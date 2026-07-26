import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../registration/models/registration_args.dart';
import '../auth_error_copy.dart';
import '../models/auth_outcome.dart';
import '../models/otp_args.dart';
import '../notifier/otp_notifier.dart';

/// OTP verify. SIX boxes (contract mandates 6; the Figma's 4 is superseded).
/// Forks on verify: authenticated → success screen → /home; registrationRequired
/// → carry the registrationToken to /register. Renders loading / error / offline
/// / success, in AR (RTL) + EN (LTR).
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  String _pin = '';

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verify() {
    // Guard the auto-submit path too (button is disabled when offline).
    if (ref.read(isOnlineProvider).value == false) return;
    FocusScope.of(context).unfocus();
    ref.read(otpProvider(widget.args).notifier).verify(_pin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(otpProvider(widget.args));
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    // registrationRequired navigates away immediately (no success screen);
    // navigation can't happen during build, so it goes through this listener.
    ref.listen(otpProvider(widget.args), (prev, next) {
      final outcome = next.outcome;
      if (outcome is RegistrationRequiredOutcome) {
        // Seed the registration wizard with the token, its TTL, and the proven
        // phone (shown read-only on Sign Up_1; never re-submitted).
        context.go(
          '/register',
          extra: RegistrationArgs(
            registrationToken: outcome.registrationToken,
            expiresInSeconds: outcome.expiresInSeconds,
            phone: widget.args.phone,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const _OfflineBanner(),
            Expanded(
              child: state.outcome is AuthenticatedOutcome
                  ? _SuccessView(onContinue: () => context.go('/home'))
                  : _InputView(
                      l10n: l10n,
                      state: state,
                      pinController: _pinController,
                      focusNode: _focusNode,
                      onChanged: (v) => setState(() => _pin = v),
                      onCompleted: (v) {
                        _pin = v;
                        _verify();
                      },
                      onVerify:
                          _pin.length == 6 && !state.isVerifying && !offline
                          ? _verify
                          : null,
                      // Resend is disabled while offline (null → button disabled).
                      onResend: offline
                          ? null
                          : () => ref
                                .read(otpProvider(widget.args).notifier)
                                .resend(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A distinct, pinned offline indicator (NOT a failed-request error). Shown when
/// connectivity is definitively down; Verify and Resend are disabled alongside it.
class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

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
                style: TextStyle(
                  color: cs.onErrorContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputView extends StatelessWidget {
  const _InputView({
    required this.l10n,
    required this.state,
    required this.pinController,
    required this.focusNode,
    required this.onChanged,
    required this.onCompleted,
    required this.onVerify,
    required this.onResend,
  });

  final AppLocalizations l10n;
  final OtpUiState state;
  final TextEditingController pinController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final VoidCallback? onVerify;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ext.textPrimary,
      ),
      decoration: BoxDecoration(
        color: ext.fieldFill,
        border: Border.all(color: ext.fieldBorder, width: 1.17),
        borderRadius: BorderRadius.circular(16),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyBorderWith(
      border: Border.all(color: cs.primary, width: 1.5),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: cs.error.withValues(alpha: 0.06),
        border: Border.all(color: cs.error, width: 1.5),
      ),
    );

    // The mapped inline message: otp_invalid uses the "incorrect code" copy and
    // red boxes; other failures (expired/throttled/offline/generic) show below.
    final hasError = state.error != null;

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.checkOtpTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ext.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.otpSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: ext.textSecondary),
          ),
          const SizedBox(height: 32),
          // OTP boxes fill left-to-right regardless of UI locale.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 6,
              controller: pinController,
              focusNode: focusNode,
              autofocus: true,
              keyboardType: TextInputType.number,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              errorPinTheme: errorPinTheme,
              forceErrorState: state.isInvalidCode,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              onChanged: onChanged,
              onCompleted: onCompleted,
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 16),
            _InlineMessage(
              text: authErrorMessage(l10n, state.error),
              color: cs.error,
              icon: isOffline(state.error)
                  ? Icons.wifi_off
                  : Icons.error_outline,
            ),
          ],
          const SizedBox(height: 28),
          FilledButton(
            onPressed: onVerify,
            child: state.isVerifying
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: cs.onPrimary,
                    ),
                  )
                : Text(
                    l10n.verify,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          _ResendRow(
            l10n: l10n,
            secondsRemaining: state.secondsRemaining,
            isResending: state.isResending,
            onResend: onResend,
          ),
        ],
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.l10n,
    required this.secondsRemaining,
    required this.isResending,
    required this.onResend,
  });

  final AppLocalizations l10n;
  final int secondsRemaining;
  final bool isResending;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    if (isResending) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: cs.primary),
        ),
      );
    }
    if (secondsRemaining > 0) {
      return Center(
        child: Text(
          l10n.resendIn(secondsRemaining),
          style: TextStyle(fontSize: 14, color: ext.hint),
        ),
      );
    }
    return Center(
      child: TextButton(
        onPressed: onResend,
        child: Text(
          l10n.resendOtp,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.primary,
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO(design-asset): real OTP success badge (green scalloped check, Figma node
          // 155:786) — blocked by export-disabled + View-only seat. See docs/DESIGN_ISSUES.md #1.
          Icon(Icons.check_circle, size: 96, color: cs.primary),
          const SizedBox(height: 24),
          Text(
            l10n.otpSuccessTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ext.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.otpSuccessSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: ext.textSecondary),
          ),
          const SizedBox(height: 40),
          FilledButton(
            onPressed: onContinue,
            child: Text(
              l10n.continueLabel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.text, required this.color, this.icon});
  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
