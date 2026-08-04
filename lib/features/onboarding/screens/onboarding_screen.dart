import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../l10n/app_localizations.dart';

/// Onboarding — the app's first screen · Figma dark `337:15146`, light sheet
/// `459:43873`.
///
/// Route `/`. Purely presentational: no endpoint, no notifier, no state. It is a
/// [ConsumerWidget] for exactly one reason — the language pill needs
/// `localeProvider` — and for no other.
///
/// **Only the SHEET exists in light.** `459:43873` is a detached 402×360 frame:
/// the sheet alone, no canvas and no illustration. The full 402×878 composition
/// exists only in dark, and the illustration is one flat artwork with no
/// light/dark variant — so light is the same illustration under the light sheet.
/// Same dark-first pattern already documented for Home and Learn.
///
/// There is no "onboarding seen" flag and none is needed: `authRedirect` sends an
/// authenticated student straight to `/home`, so this screen is only ever reached
/// while signed out.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1 — the illustration, full-bleed from the top. In Figma it is
          // 419×682 at (-19,-19), i.e. deliberately bleeding past the top and
          // start edges; `cover` from `topCenter` reproduces that at any aspect
          // ratio without hard-coding either number.
          const _Illustration(),

          // 2 — the sheet, anchored to the BOTTOM and sized by its content.
          //
          // The frame puts the sheet top at y=529 of 878. That is NOT built as a
          // fraction or a fixed offset: the content column comes out at ~336dp
          // against the frame's 349dp visible sheet, so letting it size itself
          // lands on the design and still behaves on a 640dp phone or a tablet,
          // where any fixed anchor would either float or overflow.
          Align(
            alignment: Alignment.bottomCenter,
            child: _Sheet(
              onGetStarted: () => context.go('/register'),
              onLogIn: () => context.go('/login'),
            ),
          ),

          // 3 — the language pill, over the illustration.
          //
          // The frame does NOT draw one, but Login (`82:819`) and the OTP
          // success screen (`155:786`) both do — so without it a student who
          // lands here in the wrong language has no way out until the next
          // screen. Added deliberately; logged as a design gap
          // (docs/DESIGN_ISSUES.md #27).
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                child: LanguagePill(
                  label: l10n.switchLanguage,
                  onTap: () => ref.read(localeProvider.notifier).toggle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma `337:15166` — one flat artwork, no light/dark variant.
class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/onboarding_illustration.svg',
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
}

/// The translucent bottom sheet · Figma `337:15643` (dark) / `459:43873` (light).
class _Sheet extends StatelessWidget {
  const _Sheet({required this.onGetStarted, required this.onLogIn});

  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    const radius = BorderRadius.vertical(top: Radius.circular(25));

    return Container(
      // The opaque strip (Figma `337:19256`). NOT decoration: `sheetFill` is only
      // 20% opaque, so without something solid behind it the illustration bleeds
      // straight through the sheet. Figma does this with an oversized 622×138
      // rect at (-140,540); painting the background colour behind the sheet is
      // the same result without replicating those numbers.
      decoration: BoxDecoration(
        color: ext.background,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1.5),
            blurRadius: 9.2,
            // The frame's rgba(0,0,0,0.15). A shadow, not a palette colour —
            // expressed as an alpha on black rather than an inline hex.
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: ext.sheetFill, borderRadius: radius),
        child: SafeArea(
          top: false,
          child: Padding(
            // The frame's text block is w331 and the button block w362 inside
            // 402 — 35.5 and 20. Both collapse to 20, which is the horizontal
            // padding every other screen in the app already uses; the text
            // wraps inside the same 20.
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.onboardingTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const _AccentedTagline(),
                const SizedBox(height: 10),
                Text(
                  // The `\n` is the design's own deliberate line break.
                  l10n.onboardingSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: ext.bodyMuted,
                  ),
                ),
                const SizedBox(height: 20),
                // The theme already supplies primary fill, cream label, h60,
                // r20 — this is the same FilledButton as every other screen.
                //
                // The dark frame stacks a second, 4px-blurred copy of this
                // button behind it (`337:19258`): a Figma-only glow layer, not
                // a second control. Not rendered.
                FilledButton(
                  onPressed: onGetStarted,
                  child: Text(
                    l10n.getStarted,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _LogInButton(onPressed: onLogIn),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "**Your** Learning Journey" — Figma `459:43876` / `459:43886`.
///
/// Two spans from two SEPARATE `.arb` keys, not one string split at a space:
/// which word carries the accent is a translation decision, and Arabic does not
/// necessarily put it first. Keying them separately lets the translator move the
/// emphasis without a code change.
///
/// (The frame has a third span for the space between them, coloured `#384f47`.
/// It is a single space — the colour cannot be seen — so it is dropped.)
class _AccentedTagline extends StatelessWidget {
  const _AccentedTagline();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    const base = TextStyle(
      fontSize: 24,
      height: 1.3,
      fontWeight: FontWeight.w500,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: l10n.onboardingTaglineAccent,
            style: base.copyWith(color: ext.accentSoft),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: l10n.onboardingTaglineRest,
            style: base.copyWith(color: ext.textPrimary),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// The secondary button · Figma `337:15650` / `459:43881`.
///
/// Styled as the shipped dark **Login** secondary button, NOT as this frame
/// draws it. The dark onboarding frame gives it a cream `#fcfbf9` fill with a
/// `#0e0e0e` label and a purple `#ae87e7` border — the exact inversion of the
/// dark Login button two screens later, and the same frame also leaves the
/// status-bar clock as black text on a `#232428` background, which is
/// unreadable. Both read as a paste from the light frame rather than an intent,
/// so the two pre-auth screens are kept consistent and the conflict is logged
/// (docs/DESIGN_ISSUES.md #21 and #22) instead of being resolved silently.
class _LogInButton extends StatelessWidget {
  const _LogInButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppColors>()!;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        backgroundColor: ext.fieldFill,
        side: BorderSide(color: ext.secondaryButtonBorder, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        l10n.logIn,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ext.textPrimary,
        ),
      ),
    );
  }
}
