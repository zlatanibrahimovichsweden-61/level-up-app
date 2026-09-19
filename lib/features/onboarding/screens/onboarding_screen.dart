import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_elevation.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/elevation/elevated_surface.dart';
import '../../../core/widgets/elevation/glass_surface.dart';
import '../../../core/widgets/elevation/primary_cta.dart';
import '../../../core/widgets/language_pill.dart';
import '../../../l10n/app_localizations.dart';

/// Onboarding — the app's first screen · Figma dark `337:15146`, light sheet
/// `459:43873`.
///
/// Route `/`. Purely presentational: no endpoint, no notifier, no state. It is a
/// [ConsumerWidget] for exactly one reason — the language pill needs
/// `localeProvider` — and for no other.
///
/// **Both canvases carry the whole composition.** Corrected 2026-09-18 by
/// reading the file on the signed-in desktop app: light `81:92` is a full
/// 402x878 frame whose three children are the sheet `459:43873` (402x413 at
/// y 529 - NOT a detached 402x360 frame), `image 79 [Vectorized]` and
/// `Status_Bars`. Dark `337:15146` is the same plus `Rectangle 6429`. The
/// illustration is one flat artwork with no light/dark variant.
///
/// What the canvases really do differ on is the backing behind the sheet - see
/// `AppColors.onboardingIllustrationMask` and `_Sheet` below.
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
          // 1 — the illustration, bleeding from the top. In Figma it is
          // 419×682 at (-19,-19) inside a 402×878 frame: it overflows the
          // WIDTH by ~4% and stops well short of the bottom, where the sheet
          // covers it.
          //
          // `cover` did not reproduce that. `cover` scales by whichever axis is
          // short, and the artwork (aspect 0.61) is far squarer than a phone
          // (Pixel 8 is 0.45), so it scaled to the HEIGHT and rendered ~562dp
          // wide inside 411dp — cropping about a quarter of the width off both
          // sides. On device the books were sliced through and the grass they
          // stand on was gone entirely.
          //
          // `fitWidth` from `topCenter` is what the frame's numbers actually
          // describe: match the width, keep the aspect, anchor the top, let the
          // bottom run under the sheet. The values come from the geometry
          // already recorded above, not from a new reading of the design.
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
              // BOTH buttons go to /login, and that is not a copy-paste slip.
              //
              // `/register` cannot be entered directly: `SignupIdentityScreen`
              // requires a `RegistrationArgs` carrying a `registrationToken`,
              // and the ONLY thing that can mint one is a successful
              // `POST /auth/verify-otp` returning `registrationRequired`
              // (otp_screen.dart). Going straight to `/register` therefore hit
              // the `draft == null` guard every single time and showed
              // "registration session expired" to every new user — the P0 in
              // the 2026-08-04 device walkthrough, and the reason the four
              // registration screens had never been photographed.
              //
              // This is phone-first auth: the student enters a number, the
              // server decides whether it already has an account, and the OTP
              // screen forks to /home or /register. "Get Started" and "Log In"
              // genuinely share a first step — the fork is the server's to
              // make, not a button's.
              onGetStarted: () => context.go('/login'),
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
      fit: BoxFit.fitWidth,
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
    final theme = Theme.of(context);
    final ext = theme.extension<AppColors>()!;
    final elevation = theme.extension<AppElevation>()!;

    const radius = BorderRadius.vertical(top: Radius.circular(25));

    final mask = ext.onboardingIllustrationMask;

    // The fill is only 20% opaque, so whatever sits behind the sheet shows
    // through its frost. Figma controls how much of the illustration that is
    // with one opaque rect, and the two canvases answer differently:
    //
    //   dark  `337:15146` - `Rectangle 6429` (`337:19256`), 622x138 at
    //                       (-140, 540), `#232428` at 100%, stacked ABOVE the
    //                       illustration and BELOW the sheet. The sheet's top
    //                       is y 529, so the strip starts 11pt down and runs
    //                       138pt: only that top 11pt of artwork is frosted.
    //   light `81:92`     - no such node at all. Its illustration (419x682 at
    //                       (-19, -39)) ends at y 643 against the same y 529
    //                       sheet top, so 114pt of artwork is frosted through.
    //
    // Both read from the Properties panel on 2026-09-18 (DESIGN_ISSUES #75).
    // The strip is therefore painted only on the canvas that draws one: a light
    // strip would be an invention, not a translation.
    //
    // It is a positioned sibling inside this Stack rather than a wrapper,
    // because `top` then measures from the sheet's OWN top edge - which is
    // content-sized and unknowable from the screen's Stack. Sitting below the
    // sheet also means the backdrop frosts the strip's top edge exactly as
    // Figma's Glass frosts the rect's.
    return Stack(
      // The sheet's outer shadow paints ABOVE its top edge, and a Stack
      // clips as soon as a positioned child overflows. The strip cannot
      // overflow today (149 < the sheet's ~349dp of content, and it is
      // left/right 0), and the shadow is measurably still there in the dpr-3
      // render - but the day someone changes the strip's geometry the clip
      // would appear and silently eat a measured value. Say no.
      clipBehavior: Clip.none,
      children: [
        if (mask != null)
          Positioned(
            top: 11,
            height: 138,
            left: 0,
            right: 0,
            child: ColoredBox(color: mask),
          ),
        ElevatedSurface(
          shape: const RoundedRectangleBorder(borderRadius: radius),
          color: ext.sheetFill,
          // (0, -1.5) blur 9.2 black 15% — the file's one 15% shadow, and the
          // same value on BOTH canvases (`459:43873` light, `337:15643` dark).
          // Knocked out behind the 20% fill (edit1.md R4), which the old
          // `BoxShadow` under an opaque Container could not do.
          shadows: elevation.onboardingSheetShadows,
          // Glass G1 in both canvases — the only Glass present in the light
          // frames.
          glass: elevation.onboardingSheetGlass,
          // The app's ONE real `BackdropFilter` (edit2.md §13). Without it
          // the frost has nothing to blur and the sheet is a flat 20% wash;
          // with it, the illustration above the strip blurs into the sheet,
          // which is what G1 (frost 80 -> sigma 40) is there to do. Do not
          // use `GlassBackdrop.content` on any other surface.
          backdrop: GlassBackdrop.content,
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
                    style: AppType.displayLarge.copyWith(
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
                    style: AppType.bodyLarge.copyWith(color: ext.bodyMuted),
                  ),
                  const SizedBox(height: 20),
                  // The theme already supplies primary fill, cream label, h60,
                  // r20 — this is the same FilledButton as every other screen.
                  //
                  // The dark frame stacks a second, 4px-blurred copy of this
                  // button behind it (`337:19258`): a Figma-only glow layer, not
                  // a second control. `PrimaryCta` is what renders it, along with
                  // the (0.5, 0.5) blur-4 black drop shadow both canvases carry.
                  PrimaryCta(
                    child: FilledButton(
                      onPressed: onGetStarted,
                      child: Text(l10n.getStarted, style: AppType.buttonLarge),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _LogInButton(onPressed: onLogIn),
                ],
              ),
            ),
          ),
        ),
      ],
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

    const base = AppType.h1;

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

    return PrimaryCta(
      tone: CtaTone.outline,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
          backgroundColor: ext.fieldFill,
          side: BorderSide(color: ext.secondaryButtonBorder, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          l10n.logIn,
          style: AppType.buttonLarge.copyWith(color: ext.textPrimary),
        ),
      ),
    );
  }
}
