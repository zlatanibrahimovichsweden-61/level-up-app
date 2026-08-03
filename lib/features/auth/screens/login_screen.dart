import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/language_pill.dart';
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
  String? _phoneErrorKey;

  // TODO(legal): real legal URLs are TBD — these are placeholders flagged to
  // product/legal. Wired through url_launcher so the links work once finalized.
  static const _userAgreementUrl =
      'https://levelup.example/legal/user-agreement';
  static const _privacyPolicyUrl = 'https://levelup.example/legal/privacy';
  static const _cookiePolicyUrl = 'https://levelup.example/legal/cookies';

  @override
  void initState() {
    super.initState();
    // The forced-logout message: on arrival at /login (fresh mount after a
    // forceLogout), show the reason ONCE, then clear it so it can't repeat.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLogoutReasonOnce());
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
    final l10n = AppLocalizations.of(context);
    final phone = Phone.tryParse(_phoneController.text);
    if (phone == null) {
      setState(() => _phoneErrorKey = l10n.invalidPhone);
      return;
    }
    // Don't fire a doomed request while known-offline (the button is also
    // disabled; this guards the keyboard-submit path too).
    if (ref.read(isOnlineProvider).value == false) return;
    setState(() => _phoneErrorKey = null);
    FocusScope.of(context).unfocus();

    final result = await ref.read(loginProvider.notifier).sendOtp(phone.e164);
    if (result == null || !mounted) return; // failure → state holds the error
    context.push(
      '/otp',
      extra: OtpArgs(
        phone: phone.e164,
        resendAfterSeconds: result.resendAfterSeconds,
        expiresInSeconds: result.expiresInSeconds,
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
            if (offline) const _OfflineBanner(),
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
                    const SizedBox(height: 16),
                    // The brand bird · Figma 82:849. Rendered at its own aspect
                    // ratio (152.901 × 132.854 in the export) rather than forced
                    // square, so it is not stretched.
                    SvgPicture.asset(
                      'assets/images/bird_logo.svg',
                      height: 88,
                      semanticsLabel: l10n.appTitle,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: ext.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ext.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.phoneLabel,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PhoneField(
                      controller: _phoneController,
                      hint: l10n.phoneHint,
                      enabled: !isSubmitting,
                      onSubmitted: (_) => _submit(),
                    ),
                    if (_phoneErrorKey != null) ...[
                      const SizedBox(height: 8),
                      _InlineMessage(text: _phoneErrorKey!, color: cs.error),
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
                    const SizedBox(height: 20),
                    FilledButton(
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
                          : Text(
                              l10n.sendOtp,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.orDivider,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: ext.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: ext.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _LegalLine(
                      onOpen: _openUrl,
                      userAgreementUrl: _userAgreementUrl,
                      privacyPolicyUrl: _privacyPolicyUrl,
                      cookiePolicyUrl: _cookiePolicyUrl,
                    ),
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

/// A distinct, pinned offline indicator (NOT a failed-request error). Shown when
/// connectivity is definitively down; the primary action is disabled alongside it.
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
    return Container(
      height: 60,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: ext.fieldFill,
        border: Border.all(color: ext.fieldBorder, width: 1.17),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Flag placeholder (Figma EG flag not yet exported to assets).
          const Text('🇪🇬', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            Phone.egyptDialCode, // +20 (Figma shows +02 — a design typo)
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ext.textPrimary,
            ),
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
              style: TextStyle(fontSize: 18, color: ext.textPrimary),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 18, color: ext.hint),
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
          child: Text(text, style: TextStyle(color: color, fontSize: 14)),
        ),
      ],
    );
  }
}

class _LegalLine extends StatelessWidget {
  const _LegalLine({
    required this.onOpen,
    required this.userAgreementUrl,
    required this.privacyPolicyUrl,
    required this.cookiePolicyUrl,
  });

  final Future<void> Function(String url) onOpen;
  final String userAgreementUrl;
  final String privacyPolicyUrl;
  final String cookiePolicyUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final base = TextStyle(fontSize: 14, color: ext.legalText);
    final link = base.copyWith(color: ext.link, fontWeight: FontWeight.w600);

    Widget linkText(String label, String url) => GestureDetector(
      onTap: () => onOpen(url),
      child: Text(label, style: link),
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${l10n.legalPrefix} ', style: base),
        linkText(l10n.userAgreement, userAgreementUrl),
        Text('، ', style: base),
        linkText(l10n.privacyPolicy, privacyPolicyUrl),
        Text(' ${l10n.legalAnd} ', style: base),
        linkText(l10n.cookiePolicy, cookiePolicyUrl),
      ],
    );
  }
}
