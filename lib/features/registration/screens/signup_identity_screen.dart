import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circle_back_button.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/models/phone.dart';
import '../models/registration_args.dart';
import '../notifier/registration_controller.dart';
import '../notifier/registration_submit_notifier.dart';
import '../registration_error_copy.dart';
import 'registration_expired_view.dart';

/// The header row is now the back chip's 48 box tall, not the pill's 36.10
/// (O-15), so the inset above it and the gap below it each give back half the
/// difference: the chip, the pill and everything under them keep their pixels.
const double _headerSlop =
    (CircleBackButton.tapTarget - LanguagePill.height) / 2;

/// Sign Up_1 (identity) · Figma `337:15875`. First wizard screen after the OTP
/// `registrationRequired` fork. Collects Full Name + Parent's Number (+ an
/// optional referral code that only the School body sends), shows the proven
/// phone read-only, and accumulates them into [RegistrationController] before
/// advancing to the track picker. No network call on this screen.
///
/// Reachable only with a valid `registrationToken`; if the draft is missing or
/// the token has expired, the expiry guard renders instead.
class SignupIdentityScreen extends ConsumerStatefulWidget {
  const SignupIdentityScreen({super.key, this.args});

  /// Carried from OTP via router `extra`, and null on re-entry (e.g. back from
  /// the track screen). Kept as the route payload only — the draft it describes
  /// is already seeded by `OtpScreen` before it navigates here, so this screen
  /// reads [registrationControllerProvider] and never seeds from it.
  final RegistrationArgs? args;

  @override
  ConsumerState<SignupIdentityScreen> createState() =>
      _SignupIdentityScreenState();
}

class _SignupIdentityScreenState extends ConsumerState<SignupIdentityScreen> {
  final _nameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _referralController = TextEditingController();

  // Flags, not messages: the copy is looked up in `build`, so an error already
  // on screen follows a language toggle (same defect as Login's W01-2, which
  // stored the resolved string and stayed in the old language).
  bool _showNameError = false;
  bool _showParentPhoneError = false;

  @override
  void initState() {
    super.initState();
    // READ ONLY. The draft is seeded at the OTP step, before navigation; this
    // screen must never mutate a provider here — initState runs inside element
    // mount (the build phase), which Riverpod asserts on (BUG-001).
    // Pre-fill from the draft so back-navigation preserves what was typed.
    final draft = ref.read(registrationControllerProvider);
    _nameController.text = draft?.name ?? '';
    _parentPhoneController.text = draft?.parentPhone ?? '';
    _referralController.text = draft?.referralCode ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentPhoneController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    final parentPhone = Phone.tryParse(_parentPhoneController.text);

    setState(() {
      _showNameError = name.isEmpty || name.length > 100;
      _showParentPhoneError = parentPhone == null;
    });
    if (_showNameError || _showParentPhoneError) return;

    // The server refused this exact name for this registration; it stays
    // marked and nothing moves on, since sending it again would only bring
    // the same answer back. A different name goes on as usual.
    if (_isRefused(name)) return;

    _clearNameRejection();
    FocusScope.of(context).unfocus();
    final referral = _referralController.text.trim();
    ref
        .read(registrationControllerProvider.notifier)
        .setIdentity(
          name: name,
          parentPhone: parentPhone!.e164,
          // Held on the draft until the track is known: the School body sends
          // it as `inviteCode`, the University body does not (SQ-24(l)).
          referralCode: referral.isEmpty ? null : referral,
        );
    context.push('/register/track');
  }

  /// The student goes on with a name the server has not refused, so the
  /// refusal that brought them here is spent. Only `name_not_allowed` is
  /// cleared here: any other submit failure belongs to the detail screen that
  /// shows it. The refused name itself stays recorded on the draft.
  void _clearNameRejection() {
    if (isNameNotAllowed(ref.read(registrationSubmitProvider).error)) {
      ref.read(registrationSubmitProvider.notifier).clearError();
    }
  }

  /// Was [name] (as it would be sent: trimmed) refused by the server during
  /// this registration (`422 name_not_allowed`)? Only changing it to a
  /// different name clears the mark; coming back to the screen or tapping
  /// Continue does not (owner, 2026-10-10).
  bool _isRefused(String name) =>
      ref.read(registrationControllerProvider)?.refusedNames.contains(name) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;
    final draft = ref.watch(registrationControllerProvider);
    final offline = ref.watch(isOnlineProvider).value == false;
    // A detail screen's submit came back `422 name_not_allowed` and sent the
    // student here (see `isNameNotAllowed`); the refused name is still in the
    // field, from the draft, and stays marked for as long as it reads the same.
    final nameRejected =
        draft?.refusedNames.contains(_nameController.text.trim()) ?? false;

    // Guard: no active draft or the 10-minute token window has elapsed.
    if (draft == null || draft.isExpired) {
      return const RegistrationExpiredView();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (offline) const OfflineBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  24,
                  8 - _headerSlop,
                  24,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        // The wizard's back chip (Figma `90:208`), same as
                        // Sign Up_2 uses. This was a bare `IconButton` with
                        // Material's arrow — exactly the drift
                        // `CircleBackButton`'s docstring says it exists to
                        // stop. It mirrors under RTL and carries the same
                        // back-button semantics label. Abandons registration
                        // → /login.
                        CircleBackButton(
                          onPressed: () => context.go('/login'),
                          variant: BackChipVariant.registration,
                          // Flush to the start, so the box reaches into the
                          // free space before the pill, not past the gutter.
                          tapTargetSize: MaterialTapTargetSize.padded,
                          chipAlignment: AlignmentDirectional.centerStart,
                        ),
                        const Spacer(),
                        LanguagePill(
                          label: l10n.switchLanguage,
                          onTap: () =>
                              ref.read(localeProvider.notifier).toggle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8 - _headerSlop),
                    Text(
                      l10n.createAccountTitle,
                      style: AppType.h1.copyWith(color: ext.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.createAccountSubtitle,
                      style: AppType.bodyLarge.copyWith(
                        color: ext.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Full Name
                    FieldLabel(l10n.fullNameLabel),
                    const SizedBox(height: 8),
                    PlainTextField(
                      controller: _nameController,
                      hint: l10n.fullNameHint,
                      keyboardType: TextInputType.name,
                      maxLength: 100,
                      hasError: nameRejected,
                      // Re-derives the mark: a different name clears it, the
                      // refused one brings it back.
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_showNameError)
                      InlineFieldError(l10n.invalidName)
                    else if (nameRejected)
                      InlineFieldError(l10n.fieldRejected),
                    const SizedBox(height: 16),
                    // Phone — read-only, proven at the OTP step, never submitted.
                    FieldLabel(l10n.phoneLabel),
                    const SizedBox(height: 8),
                    _ReadOnlyPhone(phone: draft.phone),
                    const SizedBox(height: 16),
                    // Parent's Number — the one phone that IS submitted.
                    FieldLabel(l10n.parentNumberLabel),
                    const SizedBox(height: 8),
                    _DialCodePhoneField(
                      controller: _parentPhoneController,
                      hint: l10n.phoneHint,
                    ),
                    if (_showParentPhoneError)
                      InlineFieldError(l10n.invalidPhone),
                    const SizedBox(height: 16),
                    // Referral — optional, collected but NOT submitted (#1).
                    FieldLabel(l10n.referralCodeOptional),
                    const SizedBox(height: 8),
                    PlainTextField(
                      controller: _referralController,
                      hint: l10n.referralCodeHint,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 28),
                    PrimaryCta(
                      child: FilledButton(
                        onPressed: _continue,
                        child: Text(
                          l10n.continueLabel,
                          style: AppType.buttonLarge,
                        ),
                      ),
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

// The field label, plain text field and inline error are the shared
// `form_fields.dart` primitives (`FieldLabel`, `PlainTextField`,
// `InlineFieldError`). This screen used to carry private line-for-line copies
// of all three; that duplication is how the error rows drifted to two sizes
// across the app (Fable style-fitting register SF-02, SF-10).

/// The proven phone, rendered read-only (disabled look). Never editable, never
/// submitted — it is already bound to the registrationToken.
class _ReadOnlyPhone extends StatelessWidget {
  const _ReadOnlyPhone({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    // `FieldShell` rather than a private copy of its decoration (edit2 #26).
    return FieldShell(
      child: Row(
        children: [
          // Phone numbers read left-to-right regardless of UI locale.
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  phone,
                  style: AppType.h4.copyWith(color: ext.textSecondary),
                ),
              ),
            ),
          ),
          Icon(Icons.lock_outline, size: 18, color: ext.hint),
        ],
      ),
    );
  }
}

/// Parent's Number entry behind a fixed +20 chip — mirrors the Login field.
/// Normalized to E.164 via [Phone.tryParse] before it reaches the draft.
class _DialCodePhoneField extends StatelessWidget {
  const _DialCodePhoneField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>()!;
    // `FieldShell` rather than a private copy of its decoration (edit2 #26).
    return FieldShell(
      child: Row(
        children: [
          const Text('🇪🇬', style: AppType.h2),
          const SizedBox(width: 8),
          Text(
            Phone.egyptDialCode,
            // LTR for the same bidi reason as the login chip: a leading `+`
            // otherwise paints as `20+` in Arabic.
            textDirection: TextDirection.ltr,
            style: AppType.h4.copyWith(color: ext.textPrimary),
          ),
          Icon(Icons.arrow_drop_down, color: ext.hint),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
              ],
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
