import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/network/exceptions.dart';
import '../auth_error_copy.dart';
import '../models/otp_args.dart';
import '../models/phone.dart';
import '../notifier/auth_controller.dart';
import '../notifier/login_notifier.dart';

/// Login (phone entry). Collects an Egyptian number behind a fixed +20 chip,
/// requests an OTP, and ALWAYS advances to /otp on success (anti-enumeration —
/// no account-existence branch here). Renders loading (button spinner) / error /
/// offline inline; both AR (RTL) and EN (LTR) via directional insets + l10n.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();

  /// Client-side phone-format error (separate from server/offline errors).
  /// A flag, not a message: the copy is looked up in `build`, so it follows
  /// a language toggle while it is on screen.
  bool _showPhoneError = false;

  @override
  void initState() {
    super.initState();
    // The forced-logout message: on arrival at /login (fresh mount after a
    // forceLogout), show the reason ONCE, then clear it so it can't repeat.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showLogoutReasonOnce(),
    );
  }

  void _showLogoutReasonOnce() {
    if (!mounted) return;
    final status = ref.read(authControllerProvider);
    if (status is! AuthUnauthenticated || status.reason == null) return;

    final l10n = AppLocalizations.of(context);
    final message = switch (status.reason!) {
      LogoutReason.supersededOtherDevice => l10n.sessionEndedSuperseded,
      LogoutReason.sessionExpired => l10n.sessionExpired,
      LogoutReason.userInitiated => null, // routine sign-out → no message
    };
    ref.read(authControllerProvider.notifier).clearReason();
    if (message == null) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// Requests an OTP for the typed phone and advances to `/otp`.
  ///
  /// This backs BOTH buttons on this screen. "Create New Account" used to push
  /// `/register` directly, which always dead-ended on the registration expiry
  /// guard: the contract is phone-verify-first, so there is no token-less
  /// registration route to push. The new-vs-existing fork is decided by the
  /// server at `otp/verify` (`registrationRequired` vs `authenticated`), so
  /// signing in and signing up are the same first step. An empty/invalid number
  /// surfaces the same inline error either way.
  /// See docs/DESIGN_ISSUES.md #8 — the designer still owes us the intended copy.
  Future<void> _submit() async {
    final phone = Phone.tryParse(_phoneController.text);
    if (phone == null) {
      setState(() => _showPhoneError = true);
      return;
    }
    // Don't fire a doomed request while known-offline (the button is also
    // disabled; this guards the keyboard-submit path too).
    if (ref.read(isOnlineProvider).value == false) return;
    setState(() => _showPhoneError = false);
    FocusScope.of(context).unfocus();

    final result = await ref.read(loginProvider.notifier).sendOtp(phone.e164);
    if (result == null || !mounted) return; // failure → state holds the error
    // `go` to the nested route, not `push('/otp')`: a push left the router's
    // location at `/login`, so the signed-in redirect off `/login` fired the
    // moment verify succeeded and took the OTP success view with it (BUG-005).
    // Nested, the stack is still Login → OTP, so the back chip still pops.
    context.go(
      '/login/otp',
      extra: OtpArgs(
        phone: phone.e164,
        resendAfterSeconds: result.resendAfterSeconds,
        expiresInSeconds: result.expiresInSeconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>()!;
    final loginState = ref.watch(loginProvider);
    final isSubmitting = loginState.isLoading;
    // Distinct offline STATE: only when connectivity is definitively down
    // (null = unknown/first frame → treated as online, don't block).
    final offline = ref.watch(isOnlineProvider).value == false;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Language toggle — top-end (right in LTR, left in RTL).
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: LanguagePill(
                        label: l10n.switchLanguage,
                        onTap: () => ref.read(localeProvider.notifier).toggle(),
                      ),
                    ),
                    // Vertical rhythm is the frame's (82:819 / 337:15652): pill
                    // bottom 100.98 → bird 119.15, bird → title gap 3, title
                    // box bottom 299 → subtitle 367, then the form's 25 dp
                    // auto-layout gaps. It used to be 16/16/8/28, which packed
                    // the whole block ~125 dp high and left the bottom empty
                    // (device walk, Wave 01, W01-5).
                    const SizedBox(height: 18),
                    // The brand bird · Figma 82:849 (light) / 337:15678 (dark),
                    // at the frame's own size, 152.901 × 132.854 — it was drawn
                    // at 88 dp tall with no reason recorded (W01-4). ONE asset,
                    // tinted per canvas: the export is `#040404`, and the dark
                    // frame fills the same paths `#FCFBF9` (W01-1).
                    SvgPicture.asset(
                      'assets/images/bird_logo.svg',
                      height: 132.854,
                      colorFilter: ColorFilter.mode(
                        ext.brandLogo,
                        BlendMode.srcIn,
                      ),
                      semanticsLabel: l10n.appTitle,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: AppType.h1.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 68),
                    // Figma 82:886: Inter Bold 20 / 1.3, `#0E0E0E` light and
                    // `#FCFBF9` dark, start-aligned with the form — exactly
                    // `h2` + `textPrimary`. It was `bodyLarge` centred (W01-3).
                    Text(
                      l10n.loginSubtitle,
                      textAlign: TextAlign.start,
                      style: AppType.h2.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      l10n.phoneLabel,
                      style: AppType.labelLarge.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _PhoneField(
                      controller: _phoneController,
                      hint: l10n.phoneHint,
                      enabled: !isSubmitting,
                      onSubmitted: (_) => _submit(),
                    ),
                    // Resolved HERE, per build, so a language toggle re-labels
                    // an error already on screen (W01-2: it used to store the
                    // resolved string and stayed English after switching).
                    if (_showPhoneError) ...[
                      const SizedBox(height: 8),
                      _InlineMessage(text: l10n.invalidPhone, color: cs.error),
                    ],
                    // Server / offline error from the request itself.
                    if (loginState.hasError) ...[
                      const SizedBox(height: 8),
                      _InlineMessage(
                        text: authErrorMessage(l10n, loginState.error),
                        color: cs.error,
                        icon: isOffline(loginState.error)
                            ? Icons.wifi_off
                            : Icons.error_outline,
                      ),
                    ],
                    const SizedBox(height: 25),
                    PrimaryCta(
                      enabled: !(isSubmitting || offline),
                      child: FilledButton(
                        onPressed: (isSubmitting || offline) ? null : _submit,
                        child: isSubmitting
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: cs.onPrimary,
                                ),
                              )
                            : Text(l10n.sendOtp, style: AppType.buttonLarge),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      l10n.orDivider,
                      textAlign: TextAlign.center,
                      style: AppType.bodyMedium.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 25),
                    PrimaryCta(
                      tone: CtaTone.outline,
                      enabled: !(isSubmitting || offline),
                      child: OutlinedButton(
                        onPressed: (isSubmitting || offline) ? null : _submit,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60),
                          backgroundColor: ext.fieldFill,
                          side: BorderSide(
                            color: ext.secondaryButtonBorder,
                            width: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          l10n.createNewAccount,
                          style: AppType.buttonLarge.copyWith(
                            color: ext.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _LegalLine(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The offline indicator is the shared `OfflineBanner` (core/widgets). This
// screen used to carry a private line-for-line copy; two copies of one banner
// is how it ended up in two type styles across the app (register SF-01).

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.hint,
    required this.enabled,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    // `FieldShell`, not a private copy of its decoration: this container used
    // to repeat the fill, the 1.17 border and the radius by hand, so the dark
    // canvas's Glass and 0.03 hairline would have missed it (edit2 #26).
    return FieldShell(
      child: Row(
        children: [
          // Flag placeholder (Figma EG flag not yet exported to assets).
          const Text('🇪🇬', style: AppType.h2),
          const SizedBox(width: 8),
          Text(
            Phone.egyptDialCode, // +20 (Figma shows +02 — a design typo)
            // A leading `+` is bidi class ES: it only joins a number when it
            // sits BETWEEN two, so under an Arabic Directionality it takes the
            // paragraph direction and paints `20+`. Dial codes read LTR in
            // every locale, like the number field beside it.
            textDirection: TextDirection.ltr,
            style: AppType.h4.copyWith(color: ext.textPrimary),
          ),
          Icon(Icons.arrow_drop_down, color: ext.hint),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.phone,
              // Phone numbers read left-to-right regardless of UI locale.
              textDirection: TextDirection.ltr,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
              ],
              onSubmitted: onSubmitted,
              style: AppType.bodyLarge.copyWith(color: ext.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: AppType.bodyLarge.copyWith(color: ext.hint),
              ),
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
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(text, style: AppType.bodyMedium.copyWith(color: color)),
        ),
      ],
    );
  }
}

/// The consent line under the buttons (Figma `82:1086`).
///
/// CW04a (owner, 2026-10-10): each link opens the in-app viewer, which is
/// public, so it works before sign-in. "User Agreement" opens the Terms of Use
/// (C1: the contract serves only `terms` and `privacy`). The Cookie Policy link
/// is gone (C2): there is no cookie document to open, and it went to a domain
/// that never resolved. The sentence loses that clause with it, since agreeing
/// to a document that does not exist is the misleading part; the two remaining
/// links are joined by the existing "and" fragment instead of the comma. No new
/// words: `cookiePolicy` and `legalSeparator` stay in the ARB files for when a
/// cookie document exists.
///
/// The links were bare tap targets with no role; a screen reader now hears
/// each as a link.
class _LegalLine extends StatelessWidget {
  const _LegalLine();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final base = AppType.captionRegular.copyWith(color: ext.legalText);
    final link = AppType.buttonSmall.copyWith(color: ext.link);

    Widget linkText(String label, String route, Key key) => Semantics(
      link: true,
      child: GestureDetector(
        key: key,
        onTap: () => context.push(route),
        child: Text(label, style: link),
      ),
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${l10n.legalPrefix} ', style: base),
        linkText(
          l10n.userAgreement,
          '/legal/terms',
          const Key('login_legal_terms'),
        ),
        Text(' ${l10n.legalAnd} ', style: base),
        linkText(
          l10n.privacyPolicy,
          '/legal/privacy',
          const Key('login_legal_privacy'),
        ),
      ],
    );
  }
}
