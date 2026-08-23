import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../registration/models/registration_args.dart';
import '../../registration/notifier/registration_controller.dart';
import '../../../core/network/exceptions.dart';
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
        // The registration wizard's seed: the token, its TTL, and the proven
        // phone (shown read-only on Sign Up_1; never re-submitted).
        final args = RegistrationArgs(
          registrationToken: outcome.registrationToken,
          expiresInSeconds: outcome.expiresInSeconds,
          phone: widget.args.phone,
        );
        // Seed HERE, not in SignupIdentityScreen.initState. A ref.listen
        // callback runs outside the build phase, so mutating a provider is
        // legal; initState is part of element mount, and Riverpod asserts on
        // it — which red-screened the whole wizard (BUG-001).
        ref.read(registrationControllerProvider.notifier).start(args);
        context.go('/register', extra: args);
      }
    });

    final succeeded = state.outcome is AuthenticatedOutcome;

    return Scaffold(
      // No AppBar at all now. It used to be `succeeded ? null : AppBar()`,
      // which made OTP the only screen in the app wearing Material's stock
      // back arrow while every other pushed screen wears the design's chevron
      // chip (`CircleBackButton`, Figma `90:208`). Same control, third
      // appearance. The affordance itself stays — a student who mistyped their
      // number needs a way back to Login — it is only the widget that changes.
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            // One header row, 24dp gutters to match `_InputView` below it.
            // Before verification it carries the back chip; after it, the
            // language pill from the success frame (155:809). Never both:
            // once tokens are stored, "back" to the OTP input is meaningless.
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
              child: succeeded
                  ? Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: LanguagePill(
                        label: l10n.switchLanguage,
                        onTap: () => ref.read(localeProvider.notifier).toggle(),
                      ),
                    )
                  : Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: CircleBackButton(onPressed: () => context.pop()),
                    ),
            ),
            Expanded(
              child: succeeded
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

// The offline indicator is the shared `OfflineBanner` (core/widgets). This
// screen used to carry a private line-for-line copy of it (register SF-01).

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
      textStyle: AppType.h2.copyWith(color: ext.textPrimary),
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
            style: AppType.h1.copyWith(color: ext.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.otpSubtitle,
            textAlign: TextAlign.center,
            style: AppType.bodyLarge.copyWith(color: ext.textSecondary),
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
                : Text(l10n.verify, style: AppType.buttonLarge),
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

/// The resend block · Figma `82:1328` → Frame `427319517` (161 × hug, vertical,
/// gap 20). While the countdown runs it stacks the timer pill over the
/// "Resend OTP" label exactly as the frame does; at zero only the label is
/// left, now tappable. Resending itself shows a spinner in place of both.
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

    if (isResending) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: cs.primary),
        ),
      );
    }
    final counting = secondsRemaining > 0;

    // The label is drawn in full colour even while counting — the frame shows
    // it that way under the pill — but `onPressed` is null until zero, which is
    // what keeps the notifier's `canResend` rule honest. The explicit colour on
    // the Text is what stops Material greying a disabled button.
    final label = TextButton(
      onPressed: counting ? null : onResend,
      child: Text(
        l10n.resendOtp,
        style: AppType.buttonMedium.copyWith(color: cs.primary),
      ),
    );
    if (!counting) return Center(child: label);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ResendTimerPill(l10n: l10n, secondsRemaining: secondsRemaining),
        const SizedBox(height: _ResendTimerPill.gapBelow),
        label,
      ],
    );
  }
}

/// The countdown pill · Figma `82:1328` → Frame `427319517`, first child.
///
/// A stadium holding a stroke-drawn stopwatch and the remaining time as
/// `mm.ss`. The frame really does separate with a DOT ("00.21"); that is built
/// verbatim and flagged (docs/DESIGN_ISSUES.md #49) rather than silently
/// "corrected" to a colon.
///
/// **Every number below except [gapBelow] is measured off a 100%-zoom
/// screenshot, not read from Dev Mode** — the Figma MCP connector is on a
/// view-only seat (issue #49) — so treat them as ±2dp until the designer
/// confirms. The fill, shadow and tint are approved tokens reused rather than
/// hexes invented: [AppColors.cardFill] is the raised surface, the shadow is
/// the recipe the five measured card shadows share (issue #47), and the glyph
/// and digits take [AppColors.textSecondary].
class _ResendTimerPill extends StatelessWidget {
  const _ResendTimerPill({required this.l10n, required this.secondsRemaining});

  final AppLocalizations l10n;
  final int secondsRemaining;

  /// Frame 427319517's vertical gap to "Resend OTP" — the ONE value here that
  /// comes from the Properties panel rather than a measurement.
  static const gapBelow = 20.0;

  static const _height = 36.0;
  static const _radius = _height / 2; // a full stadium, holds at any width
  static const _inset = 14.0;
  static const _gap = 8.0;
  static const _iconSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');

    return Semantics(
      // A screen reader gets the sentence, not "zero zero dot two one".
      label: l10n.resendIn(secondsRemaining),
      excludeSemantics: true,
      child: Container(
        height: _height,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: _inset),
        decoration: BoxDecoration(
          color: ext.cardFill,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: ext.elevationShadow.withValues(alpha: 0.25),
              offset: const Offset(0.5, 0.5),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO(design-asset): `assets/icons/stopwatch.svg` is a PLACEHOLDER
            // drawn to the language.svg recipe (stroke currentColor, round
            // caps). Replace the file with "Copy as SVG" of the icon layer in
            // Frame 427319517 — no code change needed — then delete this marker.
            SvgPicture.asset(
              'assets/icons/stopwatch.svg',
              width: _iconSize,
              height: _iconSize,
              colorFilter: ColorFilter.mode(ext.textSecondary, BlendMode.srcIn),
            ),
            const SizedBox(width: _gap),
            Text(
              l10n.resendTimer(minutes, seconds),
              style: AppType.bodyMedium.copyWith(color: ext.textSecondary),
            ),
          ],
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
    final ext = Theme.of(context).extension<AppColors>()!;

    return Padding(
      // Figma puts this block at x17.5/w363 of 402; built at 20, the app-wide
      // horizontal padding.
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
      child: Column(
        // The frame top-anchors the block at y245 of 878 (28%), which reads as
        // optically centred now that the AppBar is gone.
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SuccessBadge(),
          const SizedBox(height: 18),
          Text(
            l10n.otpSuccessTitle,
            textAlign: TextAlign.center,
            style: AppType.h1.copyWith(color: ext.textPrimary),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.otpSuccessSubtitle,
            textAlign: TextAlign.center,
            style: AppType.bodyLarge.copyWith(color: ext.bodyMuted),
          ),
          const SizedBox(height: 60),
          FilledButton(
            onPressed: onContinue,
            child: Text(l10n.continueLabel, style: AppType.buttonLarge),
          ),
        ],
      ),
    );
  }
}

/// The scalloped emerald check · Figma `82:1598`.
///
/// Carries its own emerald — `#22C55E`, the value `AppColors.successBadge`
/// records — and is deliberately NOT tinted at the call site.
///
/// The brief asks for the badge to be tinted with the token instead of
/// `colorScheme.primary`, and the *intent* (a success signal must not follow the
/// green→purple accent flip, which is why it used to render purple in dark) is
/// exactly right. But a `ColorFilter` is single-channel: the badge is two
/// colours — an emerald scallop and a WHITE checkmark — so any `srcIn` tint
/// flattens the check into the fill and leaves a green blob. The asset already
/// holds the correct colours, so it renders unfiltered, and
/// `otp_success_badge_test.dart` asserts the SVG's fill still equals the token
/// in both palettes — which catches a re-export drifting away from it.
///
/// **Sized 152×148, not the design's 144×140, and that is correct.** Figma's
/// export pads the canvas by the drop shadow's bleed (the frame's own
/// `inset[-1.79% -4.17% -3.93% -1.39%]` = 8dp on each axis), so the scalloped
/// shape lands at exactly 144×140 inside a 152×148 box. Sizing the box to
/// 144×140 would shrink the badge itself to ~136×132.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/success_badge.svg',
        width: 152,
        height: 148,
        semanticsLabel: AppLocalizations.of(context).otpSuccessTitle,
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
            style: AppType.bodyMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
