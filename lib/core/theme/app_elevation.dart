/// Elevation as tokens, the way [AppColors] is colour as tokens.
///
/// **Why this file exists.** Until 2026-09-17 every shadow in this app was a
/// `BoxShadow` decided at its own call site, with a blur number copied out of
/// Figma into a field that means something else (see [kFigmaBlurToSigma]) and a
/// colour that was right on one canvas only. That is the identical defect class
/// the palette guard was built for — a design value decided by a widget — and
/// it was entirely uncaught. So: every offset, blur, spread, alpha, Glass
/// setting, back-light and scrim in the design now lives here, per theme, with
/// the Figma node that produced it, and `lib/core/widgets/elevation/` is the
/// only code allowed to turn one into paint.
///
/// **The two canvases elevate by different mechanisms, on purpose** (edit1.md
/// R1). Light raises a surface with a drop shadow. Dark raises it with Figma's
/// **Glass** effect over a 20%-alpha fill, plus a lavender back-light behind
/// it; and where a dark node *does* keep a shadow, it is the **same black** as
/// light, measured, never the cream that `AppColors.elevationShadow` derived
/// when no dark frame was known (DESIGN_ISSUES #47, superseded). **A dark node
/// without a shadow is not a missing shadow** — an empty list here is a
/// reading, not a gap.
///
/// Values are verbatim from Figma file `P6044i0giD9TmdQ7C2AmLq`, page `design`,
/// read 2026-09-16/17. The five near-identical small shadows (0.02/0.02 at blur
/// 1.5, 1.6, 2, 2.3 and 3) are deliberately five tokens and are never
/// normalised to one — edit1.md R2/#39.
///
/// Offsets are **physical** and are never mirrored in RTL, and so is Glass
/// `lightAngle`: the RTL onboarding sheet (`549:29406`) carries the same
/// `lightAngle 37` as its LTR twin (`459:43873`). Back-light offsets are the
/// one directional value — see [Backlight].
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'glass_mapping.dart';

// ---------------------------------------------------------------------------
// Shadow colours that are plain black at an alpha. Named here rather than in
// AppColors because they are not a palette choice a designer can re-issue:
// every drop shadow in the file is black, and only the alpha varies. The
// non-black shadow colours that DO belong to the palette (the back-light, the
// OTP card's lavender glow) are read from AppColors below.
// ---------------------------------------------------------------------------

const _black25 = Color.fromRGBO(0, 0, 0, 0.25);
const _black15 = Color.fromRGBO(0, 0, 0, 0.15);
const _black10 = Color.fromRGBO(0, 0, 0, 0.10);
const _black13 = Color.fromRGBO(0, 0, 0, 0.13);

/// One Figma drop or inner shadow, exactly as the Properties panel states it.
///
/// [blur] is Figma's own "Blur" number — **not** a Flutter `blurRadius`. The
/// conversion happens once, in [sigma], so the two can never be confused at a
/// call site.
@immutable
class FigmaShadow {
  const FigmaShadow({
    required this.color,
    required this.offset,
    required this.blur,
    this.spread = 0,
    this.inset = false,
  });

  /// Alpha included — the frame's own depth, not a base colour the call site
  /// has to remember to dim.
  final Color color;

  /// Physical pixels. Never mirrored in RTL (edit1.md R9).
  final Offset offset;

  /// Figma's "Blur" == the CSS blur radius. See [sigma].
  final double blur;

  /// Positive grows the shadow shape, negative shrinks it (CSS semantics).
  final double spread;

  /// `true` renders as a real inner shadow, never as an outer shadow faking one
  /// (edit1.md R7).
  final bool inset;

  /// The Gaussian sigma to actually paint with.
  double get sigma => blur * kFigmaBlurToSigma;

  static FigmaShadow? lerp(FigmaShadow? a, FigmaShadow? b, double t) {
    if (a == null || b == null) return t < 0.5 ? a : b;
    // An inset shadow cannot become an outer one halfway through a theme
    // animation without looking like a glitch, so the flag snaps.
    return FigmaShadow(
      color: Color.lerp(a.color, b.color, t)!,
      offset: Offset.lerp(a.offset, b.offset, t)!,
      blur: lerpDouble(a.blur, b.blur, t)!,
      spread: lerpDouble(a.spread, b.spread, t)!,
      inset: t < 0.5 ? a.inset : b.inset,
    );
  }

  /// Element-wise when the two lists are the same length; otherwise the whole
  /// list snaps at the midpoint. A two-shadow card fading into a one-shadow one
  /// has no meaningful in-between.
  static List<FigmaShadow> lerpList(
    List<FigmaShadow> a,
    List<FigmaShadow> b,
    double t,
  ) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return <FigmaShadow>[
      for (var i = 0; i < a.length; i++) FigmaShadow.lerp(a[i], b[i], t)!,
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FigmaShadow &&
          other.color == color &&
          other.offset == offset &&
          other.blur == blur &&
          other.spread == spread &&
          other.inset == inset;

  @override
  int get hashCode => Object.hash(color, offset, blur, spread, inset);

  @override
  String toString() =>
      'FigmaShadow($color, $offset, blur $blur, spread $spread, '
      'inset $inset)';
}

/// Figma's **Glass** effect, field names exactly as the Plugin API reports them
/// (`{type:"GLASS", radius, refraction, depth, lightAngle, lightIntensity,
/// dispersion, splay}`).
///
/// The view-only seat hides Glass in every surface Figma offers — Design panel,
/// Dev Mode inspect, CSS/SwiftUI/UIKit export, Copy properties, Copy as SVG —
/// so these were read with a local read-only Dev Mode development plugin, with
/// the owner's approval, and the method is recorded in DESIGN_ISSUES #72.
///
/// [refraction], [dispersion] and [depth] are carried but not rendered by the
/// tier-1 model: over the uniform backdrops this app's surfaces sit on they are
/// visually a no-op (edit1.md R5). They are stored so a tier-2 shader would not
/// have to go back to Figma.
@immutable
class GlassStyle {
  const GlassStyle({
    required this.frost,
    required this.refraction,
    required this.depth,
    required this.lightAngle,
    required this.lightIntensity,
    required this.dispersion,
    required this.splay,
  });

  /// The plugin's `radius`. Converted with [kGlassFrostToSigma].
  final double frost;

  /// 0..1.
  final double refraction;

  /// Pixels.
  final double depth;

  /// Degrees, Figma's convention: y-up, so the Flutter direction vector is
  /// `(cos theta, -sin theta)`. Physical — not mirrored in RTL (edit1.md R9).
  final double lightAngle;

  /// 0..1. Scales the rim highlight's alpha.
  final double lightIntensity;

  /// 0..1.
  final double dispersion;

  /// 0..1. Spreads the rim highlight around the outline.
  final double splay;

  /// The frost radius as a Gaussian sigma.
  double get frostSigma => frost * kGlassFrostToSigma;

  /// Snaps at the midpoint when either side is null: a surface does not
  /// half-have Glass, it changes mechanism with the canvas.
  static GlassStyle? lerp(GlassStyle? a, GlassStyle? b, double t) {
    if (a == null || b == null) return t < 0.5 ? a : b;
    return GlassStyle(
      frost: lerpDouble(a.frost, b.frost, t)!,
      refraction: lerpDouble(a.refraction, b.refraction, t)!,
      depth: lerpDouble(a.depth, b.depth, t)!,
      lightAngle: lerpDouble(a.lightAngle, b.lightAngle, t)!,
      lightIntensity: lerpDouble(a.lightIntensity, b.lightIntensity, t)!,
      dispersion: lerpDouble(a.dispersion, b.dispersion, t)!,
      splay: lerpDouble(a.splay, b.splay, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlassStyle &&
          other.frost == frost &&
          other.refraction == refraction &&
          other.depth == depth &&
          other.lightAngle == lightAngle &&
          other.lightIntensity == lightIntensity &&
          other.dispersion == dispersion &&
          other.splay == splay;

  @override
  int get hashCode => Object.hash(
    frost,
    refraction,
    depth,
    lightAngle,
    lightIntensity,
    dispersion,
    splay,
  );

  @override
  String toString() =>
      'GlassStyle(frost $frost, refraction $refraction, depth $depth, '
      'angle $lightAngle, intensity $lightIntensity, '
      'dispersion $dispersion, splay $splay)';
}

/// A lavender back-light: in Figma a solid ellipse, no blur and no opacity,
/// locked behind exactly one glass surface (edit1.md R6).
///
/// The visible glow is that hard-edged ellipse seen *through* the covering
/// surface's frost, which is why it is modelled as part of the surface rather
/// than as a page background: it scrolls with the card, and it is blurred with
/// the card's own frost sigma and clipped to the card's shape.
///
/// [offset] is measured from the covering surface's top-**start** corner in the
/// 402-wide LTR dark frame. It is the one directional value in this file: in
/// RTL it mirrors, so the glow stays behind the leading content. That mirroring
/// is an assumption — no dark RTL frame exists — consistent with the build's
/// "mirror structurally" precedent (DESIGN_ISSUES #58/#64).
@immutable
class Backlight {
  const Backlight({
    required this.offset,
    required this.size,
    required this.color,
  });

  final Offset offset;
  final Size size;
  final Color color;

  static Backlight? lerp(Backlight? a, Backlight? b, double t) {
    if (a == null || b == null) return t < 0.5 ? a : b;
    return Backlight(
      offset: Offset.lerp(a.offset, b.offset, t)!,
      size: Size.lerp(a.size, b.size, t)!,
      color: Color.lerp(a.color, b.color, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Backlight &&
          other.offset == offset &&
          other.size == size &&
          other.color == color;

  @override
  int get hashCode => Object.hash(offset, size, color);

  @override
  String toString() => 'Backlight($offset, $size, $color)';
}

/// A modal scrim: the colour laid over the page, plus the backdrop blur sigma
/// behind it (0 = no blur).
///
/// The sigma values come from Figma's own CSS export, which already expresses a
/// backdrop blur as a sigma, so [kGlassFrostToSigma]'s halving does **not**
/// apply to them.
@immutable
class ScrimStyle {
  const ScrimStyle({required this.color, this.sigma = 0});

  final Color color;
  final double sigma;

  static ScrimStyle? lerp(ScrimStyle? a, ScrimStyle? b, double t) {
    if (a == null || b == null) return t < 0.5 ? a : b;
    return ScrimStyle(
      color: Color.lerp(a.color, b.color, t)!,
      sigma: lerpDouble(a.sigma, b.sigma, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScrimStyle && other.color == color && other.sigma == sigma;

  @override
  int get hashCode => Object.hash(color, sigma);

  @override
  String toString() => 'ScrimStyle($color, sigma $sigma)';
}

// ---------------------------------------------------------------------------
// The twenty distinct Glass settings in the file, named G1..G20 as the reading
// numbered them. Shared constants rather than repeated literals: G5 (Figma's
// default Glass) alone covers 363 nodes, and a token that drifted from its
// group by one digit would be undetectable by eye.
// ---------------------------------------------------------------------------

/// G1 — the onboarding sheet. The **only** Glass in the light frames.
/// `459:43873` light · `549:29406` RTL · `337:15643` dark.
const _g1 = GlassStyle(
  frost: 80,
  refraction: 0.73,
  depth: 27,
  lightAngle: 37,
  lightIntensity: 0.95,
  dispersion: 0.62,
  splay: 0.76,
);

/// G2 — the registration back chip. `337:19690`, `340:19731`, `349:16811`.
const _g2 = GlassStyle(
  frost: 20,
  refraction: 1,
  depth: 36,
  lightAngle: 22,
  lightIntensity: 0.25,
  dispersion: 0.70,
  splay: 0.16,
);

/// G3 — the language pill, all seven dark instances including OTP.
/// `340:19734`, `349:16814`, `337:19540`, `337:19693`.
const _g3 = GlassStyle(
  frost: 4,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.25,
  dispersion: 0.50,
  splay: 0,
);

/// G4 — form fields (19 nodes). `348:8659`, `348:8664`, `337:15718`.
const _g4 = GlassStyle(
  frost: 0,
  refraction: 1,
  depth: 53,
  lightAngle: 28,
  lightIntensity: 0.25,
  dispersion: 0.50,
  splay: 0.97,
);

/// G5 — Figma's **default** Glass, 363 nodes: back chips, tree-row discs,
/// profile menu rows, leaderboard row rectangles, result buckets, review filter
/// pills, the AI inner card and more. Differs from G3 only in `lightIntensity`
/// (0.80 against 0.25), which is exactly why both are named.
const _g5 = GlassStyle(
  frost: 4,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G6 — the Home level card. `337:5336` school · `349:16593` university.
const _g6 = GlassStyle(
  frost: 62,
  refraction: 0.80,
  depth: 78,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 1,
);

/// G7 — the Daily Tasks block. `337:5357` · `349:16615`.
const _g7 = GlassStyle(
  frost: 39,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G9 — the Top Student block. `337:5460` · `349:16690`.
/// (G8, the Home task discs, is not built — recorded in edit1.md §5.1.)
const _g9 = GlassStyle(
  frost: 34,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G10 — the leaderboard row GROUP that wraps each row. `337:5621`, `337:5629`.
/// The rectangle inside it carries G5; the group is a second, different Glass.
const _g10 = GlassStyle(
  frost: 4,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0.31,
);

/// G13 — the quiz previous-question button (13 nodes). `337:6464`, `404:8198`.
const _g13 = GlassStyle(
  frost: 45,
  refraction: 0.63,
  depth: 17,
  lightAngle: 51,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0.48,
);

/// G14 — the result rewards card. `337:6680` · `349:14575`.
const _g14 = GlassStyle(
  frost: 54,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G15 — the profile header card. `337:7455` · `349:12941`.
const _g15 = GlassStyle(
  frost: 57,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G16 — the Settings section cards. `642:8583`, `337:8195`, `349:12171`.
const _g16 = GlassStyle(
  frost: 63,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G18 — the AI panel's outer container. `337:9270` · `349:15005`.
const _g18 = GlassStyle(
  frost: 33,
  refraction: 0.80,
  depth: 20,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// G19 — the OTP digit boxes. `I337:19295;337:19276`..`;337:19279`.
/// The file's deepest Glass (depth 100).
const _g19 = GlassStyle(
  frost: 56,
  refraction: 0.80,
  depth: 100,
  lightAngle: -45,
  lightIntensity: 0.80,
  dispersion: 0.65,
  splay: 0.50,
);

/// G20 — the FIRST sign-up track card. `337:15981`. The second card is G5, and
/// the only difference between them is `lightAngle` (25 against -45), which is
/// why the two cards carry two tokens.
const _g20 = GlassStyle(
  frost: 4,
  refraction: 0.80,
  depth: 20,
  lightAngle: 25,
  lightIntensity: 0.80,
  dispersion: 0.50,
  splay: 0,
);

/// Every measured elevation value in the design, per canvas.
///
/// Read it the way [AppColors] is read — `Theme.of(context).extension<
/// AppElevation>()!` — and hand the tokens to the primitives in
/// `lib/core/widgets/elevation/`. Nothing else may paint a shadow, a blur or a
/// backdrop; `test/guards/project_rules_test.dart` enforces that.
@immutable
class AppElevation extends ThemeExtension<AppElevation> {
  const AppElevation({
    required this.navBarShadows,
    required this.primaryCtaShadows,
    required this.primaryCtaGlowLayerBlur,
    required this.outlineCtaShadows,
    required this.backChipShadows,
    required this.backChipGlass,
    required this.registrationBackChipGlass,
    required this.languagePillGlass,
    required this.languagePillBorderWidth,
    required this.fieldGlass,
    required this.fieldBorderWidth,
    required this.onboardingSheetShadows,
    required this.onboardingSheetGlass,
    required this.limitSheetScrim,
    required this.avatarActionSheetScrim,
    required this.chooseAvatarSheetScrim,
    required this.logoutDialogScrim,
    required this.goToUniversityDialogScrim,
    required this.levelCardShadows,
    required this.levelCardGlass,
    required this.levelCardBacklightSchool,
    required this.levelCardBacklightUniversity,
    required this.dailyTasksBorderWidth,
    required this.dailyTasksGlass,
    required this.dailyTasksBacklightSchool,
    required this.dailyTasksBacklightUniversity,
    required this.topStudentBorderWidth,
    required this.topStudentGlass,
    required this.topStudentBacklightSchool,
    required this.continueLearningShadows,
    required this.homeBellGlass,
    required this.subjectSearchShadows,
    required this.subjectSearchGlass,
    required this.subjectCardShadows,
    required this.mistakesPillShadows,
    required this.mistakesPillBorderWidth,
    required this.mistakesPillGlass,
    required this.mistakesCardShadows,
    required this.mistakesCardGlass,
    required this.treeRowBadgeGlass,
    required this.pillTrackInsetShadows,
    required this.pillTrackSelectedInsetShadows,
    required this.lengthChipShadows,
    required this.aiPanelCardShadows,
    required this.aiPanelGlass,
    required this.aiPanelBacklight,
    required this.aiPanelCardGlass,
    required this.quizPrevButtonShadows,
    required this.quizPrevButtonGlass,
    required this.quizPrevButtonRadius,
    required this.quizQuestionCardBorderWidth,
    required this.quizSetupDividerWidth,
    required this.resultBucketShadows,
    required this.resultBucketGlass,
    required this.rewardsCardShadows,
    required this.rewardsCardGlass,
    required this.rewardsCardBacklight,
    required this.resultStarDiscGlass,
    required this.reviewFilterIdleShadows,
    required this.reviewFilterIdleGlass,
    required this.reviewRowGlass,
    required this.scopeTrackInsetShadows,
    required this.scopeSelectedInsetShadows,
    required this.leaderboardListShadows,
    required this.leaderboardRowGlass,
    required this.leaderboardRowGroupGlass,
    required this.profileHeaderShadows,
    required this.profileHeaderGlass,
    required this.profileHeaderBacklight,
    required this.profileEditChipShadows,
    required this.profileEditChipGlass,
    required this.profileStatShadows,
    required this.profileMenuRowGlass,
    required this.profileMenuIconDiscGlass,
    required this.avatarBadgeShadows,
    required this.avatarBadgeGlass,
    required this.settingsSectionBorderWidth,
    required this.settingsSectionGlass,
    required this.notificationPreferencesBacklightSchool,
    required this.notificationPreferencesBacklightUniversity,
    required this.otpTimerInsetShadows,
    required this.otpCardShadows,
    required this.otpDigitBorderWidth,
    required this.otpDigitGlass,
    required this.trackCardShadows,
    required this.trackCardGlassFirst,
    required this.trackCardGlassSecond,
    required this.flashcardCardShadows,
    required this.notificationRowShadows,
    required this.notificationRowGlass,
    required this.notificationDiscGlass,
    required this.notificationChipIdleShadows,
    required this.notificationChipIdleGlass,
    required this.supportCreateCardShadows,
    required this.supportCreateCardGlass,
    required this.supportAddButtonShadows,
    required this.supportRowShadows,
    required this.supportRowGlass,
    required this.supportFieldSectionShadows,
    required this.supportFieldSectionGlass,
    required this.supportInputShadows,
    required this.supportComposerBarShadows,
    required this.supportComposerBarGlass,
    required this.supportComposerFieldShadows,
  });

  // --- edit2: shell, auth, onboarding, registration ------------------------

  /// The bottom nav bar's shadow. Light `59:1264` (the `Union`) · dark
  /// `349:16719`. The two canvases differ in BOTH colour and blur — this is the
  /// clearest example in the file of R1: dark is a lavender haze, light a cool
  /// grey drop.
  final List<FigmaShadow> navBarShadows;

  /// The primary CTA's shadow, and the destructive dialog button's — the same
  /// value in both canvases. `348:8911` · `Frame 427319502` ·
  /// `Frame 1000003068`.
  final List<FigmaShadow> primaryCtaShadows;

  /// Dark only: the CTA sits over a LAYER BLUR of its own fill (`348:8909`).
  /// The number is the Figma panel value; the painter halves it, because
  /// Figma's own CSS export halves layer blur (panel 8 -> `blur(4px)`).
  /// `null` in light, where the frames draw no glow.
  final double? primaryCtaGlowLayerBlur;

  /// The outline CTA's shadow — onboarding and login secondary buttons.
  /// `Frame 427319504`. Same value in both canvases.
  final List<FigmaShadow> outlineCtaShadows;

  /// The circular back chip's shadow. Light `90:208`; the dark twin
  /// (`404:7424`) carries **no** shadow and elevates with [backChipGlass].
  final List<FigmaShadow> backChipShadows;

  /// Back chip, dark only — G5. `404:7424`.
  final GlassStyle? backChipGlass;

  /// The registration back chip is a DIFFERENT Glass from the ordinary back
  /// chip — G2, `337:19690`. Dark only.
  final GlassStyle? registrationBackChipGlass;

  /// The language pill, dark only — G3, `340:19734`. All seven dark pills
  /// (including the OTP screen's) share it.
  final GlassStyle? languagePillGlass;

  /// The language pill's outline width. `82:1093` light; dark `337:19693` draws
  /// no outline at all, hence 0.
  final double languagePillBorderWidth;

  /// Form fields, dark only — G4, `348:8659`.
  final GlassStyle? fieldGlass;

  /// The field hairline. Light `Rectangle 9` 1.17338 · dark `348:8659` **0.03**
  /// — a hairline so fine it reads as a seam, kept verbatim rather than rounded
  /// to 0 or to 0.5 (edit1.md R2).
  final double fieldBorderWidth;

  /// The onboarding sheet's shadow — the file's one 15% shadow, and one of the
  /// few identical in both canvases. `459:43873` · `337:15643`.
  final List<FigmaShadow> onboardingSheetShadows;

  /// The onboarding sheet's Glass — G1, and the **only** Glass present in the
  /// light frames, which is why this field is non-null on both canvases.
  final GlassStyle? onboardingSheetGlass;

  /// The limit sheet's scrim. Light `Rectangle 6427` in the Limitation
  /// notification frame. **Dark is null because no dark frame exists** — it is
  /// blocked, not absent by design (DESIGN_ISSUES #51's family).
  final ScrimStyle? limitSheetScrim;

  /// Edit Profile's avatar action sheet scrim. Light has no backdrop blur; dark
  /// blurs at sigma 14.7.
  final ScrimStyle? avatarActionSheetScrim;

  /// The "choose avatar" sheet scrim. Same shape as
  /// [avatarActionSheetScrim] with its own dark sigma — two frames, two
  /// readings, not one value reused.
  final ScrimStyle? chooseAvatarSheetScrim;

  /// The logout confirmation's scrim, from the Logout frame. Dark is both
  /// darker (60%) and blurred.
  final ScrimStyle? logoutDialogScrim;

  /// The "Go to University" confirmation's scrim. Its dark sigma (10.05)
  /// differs from the logout dialog's (9.95) by a tenth of a pixel; both are
  /// kept verbatim (edit1.md R2).
  final ScrimStyle? goToUniversityDialogScrim;

  // --- edit3: home, catalog, mistakes --------------------------------------

  /// The Home level card. Light `308:4209` carries the 0.5/0.5/4 black; dark
  /// `337:5336` carries **no shadow** and elevates with [levelCardGlass] plus
  /// [levelCardBacklightSchool].
  final List<FigmaShadow> levelCardShadows;

  /// Level card, dark only — G6, the file's widest splay. `337:5336`.
  final GlassStyle? levelCardGlass;

  /// B1: ellipse `348:6951` at (23, 25) inside the school level card.
  final Backlight? levelCardBacklightSchool;

  /// B9: ellipse `349:16784` at (23, 23) inside the university level card. The
  /// two tracks differ by two pixels, and both are kept.
  final Backlight? levelCardBacklightUniversity;

  /// The Daily Tasks block's border. Light `308:4305` 0.302507; the dark frame
  /// hides the stroke, hence 0.
  final double dailyTasksBorderWidth;

  /// Daily Tasks, dark only — G7. `337:5357`.
  final GlassStyle? dailyTasksGlass;

  /// B2: ellipse `348:6952` at (3, 0), 100x14.
  final Backlight? dailyTasksBacklightSchool;

  /// B10: ellipse `349:16786` at (13, 0) and 133x21 — a different size AND
  /// offset from the school one.
  final Backlight? dailyTasksBacklightUniversity;

  /// Top Student's hairline — all four sides and the row dividers —
  /// `59:2090` / `337:5460`. The same width in both canvases, unlike every
  /// other border here.
  final double topStudentBorderWidth;

  /// Top Student, dark only — G9. `337:5460`.
  final GlassStyle? topStudentGlass;

  /// B3: ellipse `348:6954` at (3, 7.57). The university Top Student has no
  /// back-light — `349:16788` sits under no glass surface at all and is
  /// recorded as not built (edit1.md #44).
  final Backlight? topStudentBacklightSchool;

  /// Home's "Continue Learning" card: two shadows, one of them with a negative
  /// spread, identical in both canvases.
  final List<FigmaShadow> continueLearningShadows;

  /// The Home header bell, dark only — G5. `337:5330`.
  final GlassStyle? homeBellGlass;

  /// The Subjects search field. Light `135:610` carries two 10% shadows — the
  /// file's only 10% — and the dark twin `337:5724` carries none.
  final List<FigmaShadow> subjectSearchShadows;

  /// Subjects search field, dark only — G5. `337:5724`.
  final GlassStyle? subjectSearchGlass;

  /// The subject card's two shadows, `135:618` / `337:5732`. Identical on both
  /// canvases — this is the measurement that withdrew the cream derivation
  /// (DESIGN_ISSUES #47).
  final List<FigmaShadow> subjectCardShadows;

  /// The Mistakes pill in the Subjects header. `404:7421`, both canvases.
  final List<FigmaShadow> mistakesPillShadows;

  /// The Mistakes pill's red hairline, 0.266667 — the same number as its own
  /// shadow offset, which is a scaled instance, not a coincidence.
  final double mistakesPillBorderWidth;

  /// Mistakes pill, dark only — G5. `404:7421`.
  final GlassStyle? mistakesPillGlass;

  /// The Mistakes overview card's two shadows, `404:6322` / `404:7637`. Note
  /// the order differs from [subjectCardShadows]: the x-offset shadow is listed
  /// first here. Kept as read.
  final List<FigmaShadow> mistakesCardShadows;

  /// Mistakes overview card, dark only — G5. `404:7637`.
  final GlassStyle? mistakesCardGlass;

  /// The catalog/Mistakes tree-row index disc, dark only — G5. `337:5926`,
  /// `404:7767`.
  final GlassStyle? treeRowBadgeGlass;

  /// The segmented pill TRACK's inner shadow (quiz-type tabs, Settings
  /// language). Dark `337:8177` only; the light frame draws a flat track.
  final List<FigmaShadow> pillTrackInsetShadows;

  /// The SELECTED segment's inner shadow — note the y-offset flips sign against
  /// the track's, which is what makes the selected pill read as raised inside a
  /// sunken groove.
  final List<FigmaShadow> pillTrackSelectedInsetShadows;

  // --- edit4: quiz, result, review, leaderboard ----------------------------

  /// Quiz setup's length chips. `146:2315` / `337:6289`, both canvases.
  final List<FigmaShadow> lengthChipShadows;

  /// The AI explanation panel's WRAPPER shadow, `159:1825` / `337:9278` — the
  /// shadow belongs to the wrapper, not to the outer container that carries
  /// [aiPanelGlass].
  final List<FigmaShadow> aiPanelCardShadows;

  /// AI panel outer container, dark only — G18. `337:9270`.
  final GlassStyle? aiPanelGlass;

  /// B5: ellipse `348:7706` at (5, 11.02) inside the AI outer container.
  final Backlight? aiPanelBacklight;

  /// The AI panel's inner explanation card, dark only — G5. `337:9279`.
  final GlassStyle? aiPanelCardGlass;

  /// The quiz previous-question button. Light carries the small 1.3 blur; dark
  /// `337:6464` carries none and elevates with [quizPrevButtonGlass].
  final List<FigmaShadow> quizPrevButtonShadows;

  /// Quiz previous button, dark only — G13, `lightAngle 51`. `337:6464`.
  final GlassStyle? quizPrevButtonGlass;

  /// The previous button's corner radius, which differs by canvas: the light
  /// chip `159:1920` reads 9 and the dark chip `337:6464` reads 10.
  ///
  /// Both READ from the Properties panel on 2026-09-20, in the owner's own
  /// signed-in Figma session. One dp apart on a 58-high pill is not a
  /// difference anyone would notice, and it is also not this edit's call to
  /// normalise: the two frames say two numbers, so the file carries two.
  final double quizPrevButtonRadius;

  /// The quiz question card's hairline: 0.5 light, 0.2 dark.
  final double quizQuestionCardBorderWidth;

  /// The rule under the setup screen's scope header: 1.18 light (`146:2287`),
  /// 0.5 dark (`337:6268`). Its colour is `AppColors.quizDivider`.
  final double quizSetupDividerWidth;

  /// The result screen's two stat buckets. Light `159:2289`; dark `337:6667`
  /// none.
  final List<FigmaShadow> resultBucketShadows;

  /// Result buckets, dark only — G5. `337:6667`.
  final GlassStyle? resultBucketGlass;

  /// The result rewards card. Light `159:2252`; dark `337:6680` none.
  final List<FigmaShadow> rewardsCardShadows;

  /// Rewards card, dark only — G14. `337:6680`.
  final GlassStyle? rewardsCardGlass;

  /// B6: ellipse `348:8971` at (5, 11.83) inside the rewards card.
  final Backlight? rewardsCardBacklight;

  /// The rewards card's 33x33 star disc, dark only — G5. `337:6685`.
  final GlassStyle? resultStarDiscGlass;

  /// The review screen's IDLE filter pill. Light `162:2782`; dark `337:6827`
  /// none. The selected pill has no shadow in either canvas.
  final List<FigmaShadow> reviewFilterIdleShadows;

  /// Idle review filter pill, dark only — G5. `337:6827`.
  final GlassStyle? reviewFilterIdleGlass;

  /// A review ANSWER row, dark only — G5. `337:6731` (correct) and its wrong
  /// twin, both READ 2026-09-20: 362 x 73, radius 16, a 0.5 semantic stroke,
  /// the semantic fill at 20% and one Glass effect whose values the view seat
  /// hides (DESIGN_ISSUES #72) — G5, the file's default, like every other
  /// plain translucent card on this canvas.
  ///
  /// One token for all three row states on purpose. The designer's 2026-09-17
  /// ruling (D-010) asks for the rows to be EQUAL in treatment rather than
  /// one opaque and its neighbour glassed, so the skipped row — which the
  /// frame never draws — takes the same Glass as the two it does.
  final GlassStyle? reviewRowGlass;

  /// The leaderboard scope toggle's track, dark `337:5615`: a lavender inner
  /// shadow AND a black one. Light draws a flat track.
  final List<FigmaShadow> scopeTrackInsetShadows;

  /// The scope toggle's selected segment, dark `337:5615`: a white inner
  /// highlight above a black inner shadow.
  final List<FigmaShadow> scopeSelectedInsetShadows;

  /// The leaderboard LIST's shadow (`133:3117` and its dark twin) — on the
  /// vertical stack, not on each row. Both canvases.
  final List<FigmaShadow> leaderboardListShadows;

  /// The leaderboard row rectangle, dark only — G5. `337:5630`.
  final GlassStyle? leaderboardRowGlass;

  /// The GROUP wrapping each leaderboard row carries its own, different Glass —
  /// G10, `337:5629`. Two Glass effects, one row.
  final GlassStyle? leaderboardRowGroupGlass;

  // --- edit5: profile, settings, OTP, track card ---------------------------

  /// The profile header card, `169:4609` / `337:7455`. Both canvases — the dark
  /// frame keeps the black shadow AND adds Glass.
  final List<FigmaShadow> profileHeaderShadows;

  /// Profile header, dark only — G15. `337:7455`.
  final GlassStyle? profileHeaderGlass;

  /// B7: ellipse `348:8973` at (4, 11) inside the profile header.
  final Backlight? profileHeaderBacklight;

  /// The profile edit pencil chip, `166:4416` / `337:7466`. Both canvases.
  final List<FigmaShadow> profileEditChipShadows;

  /// Profile edit chip, dark only — G5. `337:7466`.
  final GlassStyle? profileEditChipGlass;

  /// A profile stat card, `661:8571` / `661:8579`. Both canvases — the dark
  /// stat card is the node that proves dark shadows are black.
  final List<FigmaShadow> profileStatShadows;

  /// A profile menu row, dark only — G5. `337:7479`.
  final GlassStyle? profileMenuRowGlass;

  /// The 35x35 icon disc inside a profile menu row, dark only — G5.
  /// `337:7480`.
  final GlassStyle? profileMenuIconDiscGlass;

  /// The Edit Profile avatar badge, `180:3989` / `337:7925`. Both canvases.
  final List<FigmaShadow> avatarBadgeShadows;

  /// Avatar badge, dark only — G5. `337:7925`.
  final GlassStyle? avatarBadgeGlass;

  /// The Settings section card's border: 0.5 light, none in dark.
  final double settingsSectionBorderWidth;

  /// Settings section cards, dark only — G16. `642:8583`, `337:8195`.
  final GlassStyle? settingsSectionGlass;

  /// B8: ellipse `348:8975` at (0, 33) inside the school Notification
  /// Preferences card — the one back-light flush with its surface's start edge.
  final Backlight? notificationPreferencesBacklightSchool;

  /// B15: ellipse `349:12114` at (0, 27) — the university card's own offset.
  final Backlight? notificationPreferencesBacklightUniversity;

  /// The OTP resend-timer pill's inner shadow. The two canvases differ in
  /// colour, offset AND blur: black from above in light, a pale grey from the
  /// start-bottom in dark. `332:3391` / `337:19503`.
  final List<FigmaShadow> otpTimerInsetShadows;

  /// The OTP code card. Light is the plain black; **dark is a lavender glow**
  /// (`AppColors.otpCardGlow`) at nearly twice the blur — the one drop shadow
  /// in the file whose dark colour is not black. `308:5114` / `337:19501`.
  final List<FigmaShadow> otpCardShadows;

  /// The OTP digit box's border: 1.17333 light, 0.5 dark.
  final double otpDigitBorderWidth;

  /// OTP digit boxes, dark only — G19. `I337:19295;337:19276`.
  final GlassStyle? otpDigitGlass;

  /// The sign-up track card. Light `125:862`; dark `337:15981` none.
  final List<FigmaShadow> trackCardShadows;

  /// The FIRST track card, dark only — G20 (`lightAngle 25`). `337:15981`.
  final GlassStyle? trackCardGlassFirst;

  /// The SECOND track card, dark only — G5. `I337:15982;125:727`. Same card
  /// component, different Glass; both are kept rather than averaged.
  final GlassStyle? trackCardGlassSecond;

  /// The flashcard's face: an INNER shadow, `#000000` at 25%, offset (0, -1),
  /// blur 5.4 — the same on both canvases, because the card is a light object
  /// on the dark canvas too (`247:3260` light, `337:14513` dark, both Figma
  /// `INNER_SHADOW`). Painted by `ElevatedSurface`'s inset path. The corner
  /// radius (20) is the same on both canvases, so it stays at the call site
  /// rather than becoming a token. API→UI Wave 22.
  final List<FigmaShadow> flashcardCardShadows;

  // --- Notifications inbox (CW07a · Figma 180:8386, light only) -------------
  //
  // No dark frame exists (DESIGN_ISSUES DG-35). Dark takes the treatment the
  // established dark chips and discs use — no shadow, the translucent fill and
  // Glass G5 — as a STAND-IN, not a reading.

  /// A notification row's INNER shadow: `#000000` at 25%, offset (0, -0.5),
  /// blur 2.5 (`180:8743`). Dark stand-in: none — the row elevates with
  /// [notificationRowGlass] alone, as [treeRowBadgeGlass]'s disc does. CW07a.
  final List<FigmaShadow> notificationRowShadows;

  /// A notification row, dark only — G5, the file's default for a plain
  /// translucent card. Stand-in: no dark frame (DG-35). CW07a.
  final GlassStyle? notificationRowGlass;

  /// The 40 category disc in a notification row, dark only — G5, the value
  /// [treeRowBadgeGlass] gives the catalog's index disc. Stand-in: no dark
  /// frame (DG-35). CW07a.
  final GlassStyle? notificationDiscGlass;

  /// An IDLE inbox filter chip's INNER shadow: `#000000` at 25%, offset (0, -1),
  /// blur 3.3 (`180:8557`). Dark stand-in: none, as [reviewFilterIdleShadows]
  /// (`337:6827`). The SELECTED chip is flat on both canvases and takes no
  /// token. CW07a.
  final List<FigmaShadow> notificationChipIdleShadows;

  /// An IDLE inbox filter chip, dark only — G5, the value
  /// [reviewFilterIdleGlass] gives the review screen's idle pill. Stand-in: no
  /// dark frame (DG-35). CW07a.
  final GlassStyle? notificationChipIdleGlass;

  // --- Support tickets, text only (CW12a · Figma 178:2800, 178:3222, 178:3378)
  //
  // Light only: no dark support frame exists. Dark takes the treatment the
  // notifications inbox settled on (DESIGN_ISSUES #130) as a STAND-IN, not a
  // reading: no shadow, plus Glass G5 on the four surfaces below that have
  // Glass tokens. A surface with no Glass token (the add button, an input, the
  // composer field) is flat in dark.

  /// The create-ticket card's drop shadow: `#000000` at 25%, offset (0.5, 0.5),
  /// blur 4 (`178:3052`). Dark stand-in: none — [supportCreateCardGlass] alone.
  /// CW12a.
  final List<FigmaShadow> supportCreateCardShadows;

  /// The create-ticket card, dark only — G5. Stand-in: no dark frame. CW12a.
  final GlassStyle? supportCreateCardGlass;

  /// The 40 add button's drop shadow: `#000000` at 25%, offset (0.028, 0.028),
  /// blur 1.3 (`178:3066`). Dark stand-in: none (flat). CW12a.
  final List<FigmaShadow> supportAddButtonShadows;

  /// A ticket row's INNER shadow: `#000000` at 25%, offset (0.02, 0.02), blur
  /// 2.8 (`178:3104`). Dark stand-in: none — [supportRowGlass] alone. CW12a.
  final List<FigmaShadow> supportRowShadows;

  /// A ticket row, dark only — G5. Stand-in: no dark frame. CW12a.
  final GlassStyle? supportRowGlass;

  /// A form field section's INNER shadow: `#000000` at 25%, offset (0.2, 0.2),
  /// blur 3.4 (`178:3333`, `178:3345`). Dark stand-in: none —
  /// [supportFieldSectionGlass] alone. CW12a.
  final List<FigmaShadow> supportFieldSectionShadows;

  /// A form field section, dark only — G5. Stand-in: no dark frame. CW12a.
  final GlassStyle? supportFieldSectionGlass;

  /// A form input's INNER shadow: `#000000` at 25%, offset (0, 0), blur 3.3
  /// (`178:3333`, `178:3345`). Dark stand-in: none (flat). CW12a.
  final List<FigmaShadow> supportInputShadows;

  /// The composer bar's drop shadow: `#000000` at 10%, offset (0, -1), blur 3.7
  /// (`178:3467`) — upward, the bar being at the bottom. Dark stand-in: none —
  /// [supportComposerBarGlass] alone. CW12a.
  ///
  /// **3.7, not the 1.85 the export prints.** The frame exports this as a CSS
  /// drop-shadow FILTER (`drop-shadow-[0px_-1px_1.85px…]`), and a filter's third
  /// value is half the Figma blur — the project's own evidence is the primary CTA:
  /// [primaryCtaShadows] is blur 4 and node `348:8911` exports it as
  /// `drop-shadow-[0.5px_0.5px_2px]`. So 1.85 × 2 = 3.7. (The other support
  /// shadows are box-shadows, exported as `shadow-[…]`, and are 1:1.)
  final List<FigmaShadow> supportComposerBarShadows;

  /// The composer bar, dark only — G5. Stand-in: no dark frame. CW12a.
  final GlassStyle? supportComposerBarGlass;

  /// The composer field's drop shadow: `#000000` at 13%, offset (0.2, 0.2),
  /// blur 1.6 (`178:3468`). Dark stand-in: none (flat). CW12a.
  ///
  /// **1.6, not the 0.8 the export prints**, for the same reason as
  /// [supportComposerBarShadows]: it is exported as a CSS drop-shadow filter
  /// (`drop-shadow-[0.2px_0.2px_0.8px…]`), whose third value is half the Figma
  /// blur (the CTA evidence: blur 4 ↔ `drop-shadow-[0.5px_0.5px_2px]`, node
  /// `348:8911`). So 0.8 × 2 = 1.6.
  final List<FigmaShadow> supportComposerFieldShadows;

  /// Light canvas.
  ///
  /// **`static final`, not `const`, deliberately:** two tokens take their
  /// colour from [AppColors] (the back-light and the OTP card's glow) rather
  /// than repeating a hex here, and instance-field access is not a constant
  /// expression in Dart. One source per value beats one `const` keyword.
  static final light = AppElevation(
    // Light nav `Union` 59:1264 — a cool grey-lilac, not black.
    navBarShadows: const [
      FigmaShadow(
        color: Color.fromRGBO(184, 184, 210, 0.5),
        offset: Offset(0, 2.144),
        blur: 16.08,
      ),
    ],
    primaryCtaShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    primaryCtaGlowLayerBlur: null, // no glow in the light frames
    outlineCtaShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    backChipShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02833, 0.02833), blur: 1.3),
    ],
    backChipGlass: null,
    registrationBackChipGlass: null,
    languagePillGlass: null,
    languagePillBorderWidth: 0.629032,
    fieldGlass: null,
    fieldBorderWidth: 1.17338,
    onboardingSheetShadows: const [
      FigmaShadow(color: _black15, offset: Offset(0, -1.5), blur: 9.2),
    ],
    onboardingSheetGlass: _g1,
    limitSheetScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.5),
      sigma: 5.75,
    ),
    avatarActionSheetScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.3),
    ),
    chooseAvatarSheetScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.3),
    ),
    logoutDialogScrim: const ScrimStyle(color: Color.fromRGBO(49, 49, 49, 0.3)),
    goToUniversityDialogScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.3),
    ),
    levelCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    levelCardGlass: null,
    levelCardBacklightSchool: null,
    levelCardBacklightUniversity: null,
    dailyTasksBorderWidth: 0.302507,
    dailyTasksGlass: null,
    dailyTasksBacklightSchool: null,
    dailyTasksBacklightUniversity: null,
    topStudentBorderWidth: 1.20791,
    topStudentGlass: null,
    topStudentBacklightSchool: null,
    continueLearningShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, 0.425436), blur: 1.27631),
      FigmaShadow(
        color: _black25,
        offset: Offset(0.423807, 0),
        blur: 0.850872,
        spread: -0.425436,
      ),
    ],
    homeBellGlass: null,
    subjectSearchShadows: const [
      FigmaShadow(color: _black10, offset: Offset(0, 1), blur: 3),
      FigmaShadow(color: _black10, offset: Offset(0, 1), blur: 2, spread: -1),
    ],
    subjectSearchGlass: null,
    subjectCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, 0.530516), blur: 1.59155),
      FigmaShadow(
        color: _black25,
        offset: Offset(0.528485, 0),
        blur: 1.06103,
        spread: -0.530516,
      ),
    ],
    mistakesPillShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.266667, 0.266667),
        blur: 2.13333,
      ),
    ],
    mistakesPillBorderWidth: 0.266667,
    mistakesPillGlass: null,
    mistakesCardShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.528485, 0),
        blur: 1.06103,
        spread: -0.530516,
      ),
      FigmaShadow(color: _black25, offset: Offset(0, 0.530516), blur: 1.59155),
    ],
    mistakesCardGlass: null,
    treeRowBadgeGlass: null,
    pillTrackInsetShadows: const [],
    pillTrackSelectedInsetShadows: const [],
    lengthChipShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 2.3),
    ],
    aiPanelCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 3),
    ],
    aiPanelGlass: null,
    aiPanelBacklight: null,
    aiPanelCardGlass: null,
    quizPrevButtonShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02833, 0.02833), blur: 1.3),
    ],
    quizPrevButtonGlass: null,
    quizPrevButtonRadius: 9,
    quizQuestionCardBorderWidth: 0.5,
    quizSetupDividerWidth: 1.18,
    resultBucketShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 2),
    ],
    resultBucketGlass: null,
    rewardsCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    rewardsCardGlass: null,
    rewardsCardBacklight: null,
    resultStarDiscGlass: null,
    reviewFilterIdleShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 1.5),
    ],
    reviewFilterIdleGlass: null,
    reviewRowGlass: null,
    scopeTrackInsetShadows: const [],
    scopeSelectedInsetShadows: const [],
    leaderboardListShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 1.6),
    ],
    leaderboardRowGlass: null,
    leaderboardRowGroupGlass: null,
    profileHeaderShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    profileHeaderGlass: null,
    profileHeaderBacklight: null,
    profileEditChipShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02833, 0.02833), blur: 1.3),
    ],
    profileEditChipGlass: null,
    profileStatShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 2),
    ],
    profileMenuRowGlass: null,
    profileMenuIconDiscGlass: null,
    avatarBadgeShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.0240833, 0.0240833),
        blur: 1.105,
      ),
    ],
    avatarBadgeGlass: null,
    settingsSectionBorderWidth: 0.5,
    settingsSectionGlass: null,
    notificationPreferencesBacklightSchool: null,
    notificationPreferencesBacklightUniversity: null,
    otpTimerInsetShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, -1), blur: 4, inset: true),
    ],
    otpCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.2, 0.2), blur: 4),
    ],
    otpDigitBorderWidth: 1.17333,
    otpDigitGlass: null,
    trackCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    trackCardGlassFirst: null,
    trackCardGlassSecond: null,
    flashcardCardShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0, -1),
        blur: 5.4,
        inset: true,
      ),
    ],
    // Notifications inbox, Figma 180:8743 (row) and 180:8557 (idle chip).
    notificationRowShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0, -0.5),
        blur: 2.5,
        inset: true,
      ),
    ],
    notificationRowGlass: null,
    notificationDiscGlass: null,
    notificationChipIdleShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0, -1),
        blur: 3.3,
        inset: true,
      ),
    ],
    notificationChipIdleGlass: null,
    // Support tickets, Figma 178:3052 (create card), 178:3066 (add button),
    // 178:3104 (row), 178:3333 / 178:3345 (field section and input), 178:3467
    // (composer bar) and 178:3468 (composer field). CW12a.
    supportCreateCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    supportCreateCardGlass: null,
    supportAddButtonShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.028, 0.028), blur: 1.3),
    ],
    supportRowShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.02, 0.02),
        blur: 2.8,
        inset: true,
      ),
    ],
    supportRowGlass: null,
    supportFieldSectionShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.2, 0.2),
        blur: 3.4,
        inset: true,
      ),
    ],
    supportFieldSectionGlass: null,
    supportInputShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0, 0),
        blur: 3.3,
        inset: true,
      ),
    ],
    supportComposerBarShadows: const [
      // 2 × the exported filter value (1.85): see the field's doc.
      FigmaShadow(color: _black10, offset: Offset(0, -1), blur: 3.7),
    ],
    supportComposerBarGlass: null,
    supportComposerFieldShadows: const [
      // 2 × the exported filter value (0.8): see the field's doc.
      FigmaShadow(color: _black13, offset: Offset(0.2, 0.2), blur: 1.6),
    ],
  );

  /// Dark canvas.
  ///
  /// Every shadow here is the **measured black** (edit1.md §5.3) — `337:5732`,
  /// `661:8579`, `337:7455`, `404:7637` and nine more all read black at the
  /// light alpha. The one exception is [otpCardShadows], a lavender glow the
  /// frame states explicitly. The cream `AppColors.elevationShadow` is not used
  /// by any token in this file.
  ///
  /// `static final` for the reason given on [light].
  static final dark = AppElevation(
    // Dark nav 349:16719 — lavender at a tenth alpha, and a smaller blur.
    navBarShadows: const [
      FigmaShadow(
        color: Color.fromRGBO(124, 58, 237, 0.1),
        offset: Offset(0, 2.144),
        blur: 12.5,
      ),
    ],
    primaryCtaShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    // Figma layer-blur panel value; the painter halves it (Figma's own CSS
    // export does: panel 8 -> blur(4px)). Colour is the button's own fill.
    primaryCtaGlowLayerBlur: 8,
    outlineCtaShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    // 404:7424 draws no shadow — it elevates with Glass instead. Not a gap.
    backChipShadows: const [],
    backChipGlass: _g5,
    registrationBackChipGlass: _g2,
    languagePillGlass: _g3,
    languagePillBorderWidth: 0,
    fieldGlass: _g4,
    fieldBorderWidth: 0.03,
    onboardingSheetShadows: const [
      FigmaShadow(color: _black15, offset: Offset(0, -1.5), blur: 9.2),
    ],
    onboardingSheetGlass: _g1,
    // BLOCKED: no dark Limitation-notification frame exists. Null is "not
    // measured", not "no scrim" — edit2 must not invent one.
    limitSheetScrim: null,
    avatarActionSheetScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.3),
      sigma: 14.7,
    ),
    chooseAvatarSheetScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.3),
      sigma: 13.4,
    ),
    logoutDialogScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.6),
      sigma: 9.95,
    ),
    goToUniversityDialogScrim: const ScrimStyle(
      color: Color.fromRGBO(49, 49, 49, 0.6),
      sigma: 10.05,
    ),
    levelCardShadows: const [],
    levelCardGlass: _g6,
    levelCardBacklightSchool: Backlight(
      offset: const Offset(23, 25),
      size: const Size(133, 21),
      color: AppColors.dark.backlight,
    ),
    levelCardBacklightUniversity: Backlight(
      offset: const Offset(23, 23),
      size: const Size(133, 21),
      color: AppColors.dark.backlight,
    ),
    dailyTasksBorderWidth: 0,
    dailyTasksGlass: _g7,
    dailyTasksBacklightSchool: Backlight(
      offset: const Offset(3, 0),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    dailyTasksBacklightUniversity: Backlight(
      offset: const Offset(13, 0),
      size: const Size(133, 21),
      color: AppColors.dark.backlight,
    ),
    topStudentBorderWidth: 1.20791,
    topStudentGlass: _g9,
    topStudentBacklightSchool: Backlight(
      offset: const Offset(3, 7.57),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    continueLearningShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, 0.425436), blur: 1.27631),
      FigmaShadow(
        color: _black25,
        offset: Offset(0.423807, 0),
        blur: 0.850872,
        spread: -0.425436,
      ),
    ],
    homeBellGlass: _g5,
    subjectSearchShadows: const [],
    subjectSearchGlass: _g5,
    subjectCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, 0.530516), blur: 1.59155),
      FigmaShadow(
        color: _black25,
        offset: Offset(0.528485, 0),
        blur: 1.06103,
        spread: -0.530516,
      ),
    ],
    mistakesPillShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.266667, 0.266667),
        blur: 2.13333,
      ),
    ],
    mistakesPillBorderWidth: 0.266667,
    mistakesPillGlass: _g5,
    mistakesCardShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.528485, 0),
        blur: 1.06103,
        spread: -0.530516,
      ),
      FigmaShadow(color: _black25, offset: Offset(0, 0.530516), blur: 1.59155),
    ],
    mistakesCardGlass: _g5,
    treeRowBadgeGlass: _g5,
    pillTrackInsetShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, -3), blur: 4, inset: true),
    ],
    pillTrackSelectedInsetShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0, 4), blur: 4, inset: true),
    ],
    lengthChipShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 2.3),
    ],
    aiPanelCardShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 3),
    ],
    aiPanelGlass: _g18,
    aiPanelBacklight: Backlight(
      offset: const Offset(5, 11.02),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    aiPanelCardGlass: _g5,
    quizPrevButtonShadows: const [],
    quizPrevButtonGlass: _g13,
    quizPrevButtonRadius: 10,
    quizQuestionCardBorderWidth: 0.2,
    quizSetupDividerWidth: 0.5,
    resultBucketShadows: const [],
    resultBucketGlass: _g5,
    rewardsCardShadows: const [],
    rewardsCardGlass: _g14,
    rewardsCardBacklight: Backlight(
      offset: const Offset(5, 11.83),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    resultStarDiscGlass: _g5,
    reviewFilterIdleShadows: const [],
    reviewFilterIdleGlass: _g5,
    reviewRowGlass: _g5,
    scopeTrackInsetShadows: const [
      FigmaShadow(
        color: Color.fromRGBO(207, 179, 255, 0.1),
        offset: Offset(6, 1),
        blur: 4,
        inset: true,
      ),
      FigmaShadow(color: _black25, offset: Offset(0, -2), blur: 4, inset: true),
    ],
    scopeSelectedInsetShadows: const [
      FigmaShadow(
        color: Color.fromRGBO(255, 255, 255, 0.6),
        offset: Offset(1, -2),
        blur: 2,
        inset: true,
      ),
      FigmaShadow(color: _black25, offset: Offset(0, 3), blur: 2, inset: true),
    ],
    leaderboardListShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 1.6),
    ],
    leaderboardRowGlass: _g5,
    leaderboardRowGroupGlass: _g10,
    profileHeaderShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.5, 0.5), blur: 4),
    ],
    profileHeaderGlass: _g15,
    profileHeaderBacklight: Backlight(
      offset: const Offset(4, 11),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    profileEditChipShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02833, 0.02833), blur: 1.3),
    ],
    profileEditChipGlass: _g5,
    profileStatShadows: const [
      FigmaShadow(color: _black25, offset: Offset(0.02, 0.02), blur: 2),
    ],
    profileMenuRowGlass: _g5,
    profileMenuIconDiscGlass: _g5,
    avatarBadgeShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0.0240833, 0.0240833),
        blur: 1.105,
      ),
    ],
    avatarBadgeGlass: _g5,
    settingsSectionBorderWidth: 0,
    settingsSectionGlass: _g16,
    notificationPreferencesBacklightSchool: Backlight(
      offset: const Offset(0, 33),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    notificationPreferencesBacklightUniversity: Backlight(
      offset: const Offset(0, 27),
      size: const Size(100, 14),
      color: AppColors.dark.backlight,
    ),
    otpTimerInsetShadows: const [
      FigmaShadow(
        color: Color.fromRGBO(198, 198, 198, 0.25),
        offset: Offset(-0.5, 0.5),
        blur: 1.2,
        inset: true,
      ),
    ],
    // The one non-black drop shadow in the dark frames: a lavender glow, and
    // the colour is the palette's, not a second copy of the hex.
    otpCardShadows: [
      FigmaShadow(
        color: AppColors.dark.otpCardGlow!,
        offset: const Offset(0.2, 0.2),
        blur: 7.9,
      ),
    ],
    otpDigitBorderWidth: 0.5,
    otpDigitGlass: _g19,
    trackCardShadows: const [],
    trackCardGlassFirst: _g20,
    trackCardGlassSecond: _g5,
    // Not a light-only shadow: the card stays cream on the dark canvas
    // (`337:14513`), so its inner shadow is the light value unchanged.
    flashcardCardShadows: const [
      FigmaShadow(
        color: _black25,
        offset: Offset(0, -1),
        blur: 5.4,
        inset: true,
      ),
    ],
    // Notifications inbox — NO dark frame (DG-35). Stand-ins: no shadow, G5, as
    // the dark idle chips and the tree-row discs do. CW07a.
    notificationRowShadows: const [],
    notificationRowGlass: _g5,
    notificationDiscGlass: _g5,
    notificationChipIdleShadows: const [],
    notificationChipIdleGlass: _g5,
    // Support tickets — NO dark frame. Stand-ins: no shadow, and G5 on the four
    // surfaces that have a Glass token, as the inbox row does. CW12a.
    supportCreateCardShadows: const [],
    supportCreateCardGlass: _g5,
    supportAddButtonShadows: const [],
    supportRowShadows: const [],
    supportRowGlass: _g5,
    supportFieldSectionShadows: const [],
    supportFieldSectionGlass: _g5,
    supportInputShadows: const [],
    supportComposerBarShadows: const [],
    supportComposerBarGlass: _g5,
    supportComposerFieldShadows: const [],
  );

  @override
  AppElevation copyWith({
    List<FigmaShadow>? navBarShadows,
    List<FigmaShadow>? primaryCtaShadows,
    double? primaryCtaGlowLayerBlur,
    List<FigmaShadow>? outlineCtaShadows,
    List<FigmaShadow>? backChipShadows,
    GlassStyle? backChipGlass,
    GlassStyle? registrationBackChipGlass,
    GlassStyle? languagePillGlass,
    double? languagePillBorderWidth,
    GlassStyle? fieldGlass,
    double? fieldBorderWidth,
    List<FigmaShadow>? onboardingSheetShadows,
    GlassStyle? onboardingSheetGlass,
    ScrimStyle? limitSheetScrim,
    ScrimStyle? avatarActionSheetScrim,
    ScrimStyle? chooseAvatarSheetScrim,
    ScrimStyle? logoutDialogScrim,
    ScrimStyle? goToUniversityDialogScrim,
    List<FigmaShadow>? levelCardShadows,
    GlassStyle? levelCardGlass,
    Backlight? levelCardBacklightSchool,
    Backlight? levelCardBacklightUniversity,
    double? dailyTasksBorderWidth,
    GlassStyle? dailyTasksGlass,
    Backlight? dailyTasksBacklightSchool,
    Backlight? dailyTasksBacklightUniversity,
    double? topStudentBorderWidth,
    GlassStyle? topStudentGlass,
    Backlight? topStudentBacklightSchool,
    List<FigmaShadow>? continueLearningShadows,
    GlassStyle? homeBellGlass,
    List<FigmaShadow>? subjectSearchShadows,
    GlassStyle? subjectSearchGlass,
    List<FigmaShadow>? subjectCardShadows,
    List<FigmaShadow>? mistakesPillShadows,
    double? mistakesPillBorderWidth,
    GlassStyle? mistakesPillGlass,
    List<FigmaShadow>? mistakesCardShadows,
    GlassStyle? mistakesCardGlass,
    GlassStyle? treeRowBadgeGlass,
    List<FigmaShadow>? pillTrackInsetShadows,
    List<FigmaShadow>? pillTrackSelectedInsetShadows,
    List<FigmaShadow>? lengthChipShadows,
    List<FigmaShadow>? aiPanelCardShadows,
    GlassStyle? aiPanelGlass,
    Backlight? aiPanelBacklight,
    GlassStyle? aiPanelCardGlass,
    List<FigmaShadow>? quizPrevButtonShadows,
    GlassStyle? quizPrevButtonGlass,
    double? quizPrevButtonRadius,
    double? quizQuestionCardBorderWidth,
    double? quizSetupDividerWidth,
    List<FigmaShadow>? resultBucketShadows,
    GlassStyle? resultBucketGlass,
    List<FigmaShadow>? rewardsCardShadows,
    GlassStyle? rewardsCardGlass,
    Backlight? rewardsCardBacklight,
    GlassStyle? resultStarDiscGlass,
    List<FigmaShadow>? reviewFilterIdleShadows,
    GlassStyle? reviewFilterIdleGlass,
    GlassStyle? reviewRowGlass,
    List<FigmaShadow>? scopeTrackInsetShadows,
    List<FigmaShadow>? scopeSelectedInsetShadows,
    List<FigmaShadow>? leaderboardListShadows,
    GlassStyle? leaderboardRowGlass,
    GlassStyle? leaderboardRowGroupGlass,
    List<FigmaShadow>? profileHeaderShadows,
    GlassStyle? profileHeaderGlass,
    Backlight? profileHeaderBacklight,
    List<FigmaShadow>? profileEditChipShadows,
    GlassStyle? profileEditChipGlass,
    List<FigmaShadow>? profileStatShadows,
    GlassStyle? profileMenuRowGlass,
    GlassStyle? profileMenuIconDiscGlass,
    List<FigmaShadow>? avatarBadgeShadows,
    GlassStyle? avatarBadgeGlass,
    double? settingsSectionBorderWidth,
    GlassStyle? settingsSectionGlass,
    Backlight? notificationPreferencesBacklightSchool,
    Backlight? notificationPreferencesBacklightUniversity,
    List<FigmaShadow>? otpTimerInsetShadows,
    List<FigmaShadow>? otpCardShadows,
    double? otpDigitBorderWidth,
    GlassStyle? otpDigitGlass,
    List<FigmaShadow>? trackCardShadows,
    GlassStyle? trackCardGlassFirst,
    GlassStyle? trackCardGlassSecond,
    List<FigmaShadow>? flashcardCardShadows,
    List<FigmaShadow>? notificationRowShadows,
    GlassStyle? notificationRowGlass,
    GlassStyle? notificationDiscGlass,
    List<FigmaShadow>? notificationChipIdleShadows,
    GlassStyle? notificationChipIdleGlass,
    List<FigmaShadow>? supportCreateCardShadows,
    GlassStyle? supportCreateCardGlass,
    List<FigmaShadow>? supportAddButtonShadows,
    List<FigmaShadow>? supportRowShadows,
    GlassStyle? supportRowGlass,
    List<FigmaShadow>? supportFieldSectionShadows,
    GlassStyle? supportFieldSectionGlass,
    List<FigmaShadow>? supportInputShadows,
    List<FigmaShadow>? supportComposerBarShadows,
    GlassStyle? supportComposerBarGlass,
    List<FigmaShadow>? supportComposerFieldShadows,
  }) {
    // Note, as `AppColors.copyWith` already notes for its nullable borders:
    // `??` cannot CLEAR a nullable token. Dark gets its nulls from the palette
    // itself, never from a copyWith.
    return AppElevation(
      navBarShadows: navBarShadows ?? this.navBarShadows,
      primaryCtaShadows: primaryCtaShadows ?? this.primaryCtaShadows,
      primaryCtaGlowLayerBlur:
          primaryCtaGlowLayerBlur ?? this.primaryCtaGlowLayerBlur,
      outlineCtaShadows: outlineCtaShadows ?? this.outlineCtaShadows,
      backChipShadows: backChipShadows ?? this.backChipShadows,
      backChipGlass: backChipGlass ?? this.backChipGlass,
      registrationBackChipGlass:
          registrationBackChipGlass ?? this.registrationBackChipGlass,
      languagePillGlass: languagePillGlass ?? this.languagePillGlass,
      languagePillBorderWidth:
          languagePillBorderWidth ?? this.languagePillBorderWidth,
      fieldGlass: fieldGlass ?? this.fieldGlass,
      fieldBorderWidth: fieldBorderWidth ?? this.fieldBorderWidth,
      onboardingSheetShadows:
          onboardingSheetShadows ?? this.onboardingSheetShadows,
      onboardingSheetGlass: onboardingSheetGlass ?? this.onboardingSheetGlass,
      limitSheetScrim: limitSheetScrim ?? this.limitSheetScrim,
      avatarActionSheetScrim:
          avatarActionSheetScrim ?? this.avatarActionSheetScrim,
      chooseAvatarSheetScrim:
          chooseAvatarSheetScrim ?? this.chooseAvatarSheetScrim,
      logoutDialogScrim: logoutDialogScrim ?? this.logoutDialogScrim,
      goToUniversityDialogScrim:
          goToUniversityDialogScrim ?? this.goToUniversityDialogScrim,
      levelCardShadows: levelCardShadows ?? this.levelCardShadows,
      levelCardGlass: levelCardGlass ?? this.levelCardGlass,
      levelCardBacklightSchool:
          levelCardBacklightSchool ?? this.levelCardBacklightSchool,
      levelCardBacklightUniversity:
          levelCardBacklightUniversity ?? this.levelCardBacklightUniversity,
      dailyTasksBorderWidth:
          dailyTasksBorderWidth ?? this.dailyTasksBorderWidth,
      dailyTasksGlass: dailyTasksGlass ?? this.dailyTasksGlass,
      dailyTasksBacklightSchool:
          dailyTasksBacklightSchool ?? this.dailyTasksBacklightSchool,
      dailyTasksBacklightUniversity:
          dailyTasksBacklightUniversity ?? this.dailyTasksBacklightUniversity,
      topStudentBorderWidth:
          topStudentBorderWidth ?? this.topStudentBorderWidth,
      topStudentGlass: topStudentGlass ?? this.topStudentGlass,
      topStudentBacklightSchool:
          topStudentBacklightSchool ?? this.topStudentBacklightSchool,
      continueLearningShadows:
          continueLearningShadows ?? this.continueLearningShadows,
      homeBellGlass: homeBellGlass ?? this.homeBellGlass,
      subjectSearchShadows: subjectSearchShadows ?? this.subjectSearchShadows,
      subjectSearchGlass: subjectSearchGlass ?? this.subjectSearchGlass,
      subjectCardShadows: subjectCardShadows ?? this.subjectCardShadows,
      mistakesPillShadows: mistakesPillShadows ?? this.mistakesPillShadows,
      mistakesPillBorderWidth:
          mistakesPillBorderWidth ?? this.mistakesPillBorderWidth,
      mistakesPillGlass: mistakesPillGlass ?? this.mistakesPillGlass,
      mistakesCardShadows: mistakesCardShadows ?? this.mistakesCardShadows,
      mistakesCardGlass: mistakesCardGlass ?? this.mistakesCardGlass,
      treeRowBadgeGlass: treeRowBadgeGlass ?? this.treeRowBadgeGlass,
      pillTrackInsetShadows:
          pillTrackInsetShadows ?? this.pillTrackInsetShadows,
      pillTrackSelectedInsetShadows:
          pillTrackSelectedInsetShadows ?? this.pillTrackSelectedInsetShadows,
      lengthChipShadows: lengthChipShadows ?? this.lengthChipShadows,
      aiPanelCardShadows: aiPanelCardShadows ?? this.aiPanelCardShadows,
      aiPanelGlass: aiPanelGlass ?? this.aiPanelGlass,
      aiPanelBacklight: aiPanelBacklight ?? this.aiPanelBacklight,
      aiPanelCardGlass: aiPanelCardGlass ?? this.aiPanelCardGlass,
      quizPrevButtonShadows:
          quizPrevButtonShadows ?? this.quizPrevButtonShadows,
      quizPrevButtonGlass: quizPrevButtonGlass ?? this.quizPrevButtonGlass,
      quizPrevButtonRadius: quizPrevButtonRadius ?? this.quizPrevButtonRadius,
      quizQuestionCardBorderWidth:
          quizQuestionCardBorderWidth ?? this.quizQuestionCardBorderWidth,
      quizSetupDividerWidth:
          quizSetupDividerWidth ?? this.quizSetupDividerWidth,
      resultBucketShadows: resultBucketShadows ?? this.resultBucketShadows,
      resultBucketGlass: resultBucketGlass ?? this.resultBucketGlass,
      rewardsCardShadows: rewardsCardShadows ?? this.rewardsCardShadows,
      rewardsCardGlass: rewardsCardGlass ?? this.rewardsCardGlass,
      rewardsCardBacklight: rewardsCardBacklight ?? this.rewardsCardBacklight,
      resultStarDiscGlass: resultStarDiscGlass ?? this.resultStarDiscGlass,
      reviewFilterIdleShadows:
          reviewFilterIdleShadows ?? this.reviewFilterIdleShadows,
      reviewFilterIdleGlass:
          reviewFilterIdleGlass ?? this.reviewFilterIdleGlass,
      reviewRowGlass: reviewRowGlass ?? this.reviewRowGlass,
      scopeTrackInsetShadows:
          scopeTrackInsetShadows ?? this.scopeTrackInsetShadows,
      scopeSelectedInsetShadows:
          scopeSelectedInsetShadows ?? this.scopeSelectedInsetShadows,
      leaderboardListShadows:
          leaderboardListShadows ?? this.leaderboardListShadows,
      leaderboardRowGlass: leaderboardRowGlass ?? this.leaderboardRowGlass,
      leaderboardRowGroupGlass:
          leaderboardRowGroupGlass ?? this.leaderboardRowGroupGlass,
      profileHeaderShadows: profileHeaderShadows ?? this.profileHeaderShadows,
      profileHeaderGlass: profileHeaderGlass ?? this.profileHeaderGlass,
      profileHeaderBacklight:
          profileHeaderBacklight ?? this.profileHeaderBacklight,
      profileEditChipShadows:
          profileEditChipShadows ?? this.profileEditChipShadows,
      profileEditChipGlass: profileEditChipGlass ?? this.profileEditChipGlass,
      profileStatShadows: profileStatShadows ?? this.profileStatShadows,
      profileMenuRowGlass: profileMenuRowGlass ?? this.profileMenuRowGlass,
      profileMenuIconDiscGlass:
          profileMenuIconDiscGlass ?? this.profileMenuIconDiscGlass,
      avatarBadgeShadows: avatarBadgeShadows ?? this.avatarBadgeShadows,
      avatarBadgeGlass: avatarBadgeGlass ?? this.avatarBadgeGlass,
      settingsSectionBorderWidth:
          settingsSectionBorderWidth ?? this.settingsSectionBorderWidth,
      settingsSectionGlass: settingsSectionGlass ?? this.settingsSectionGlass,
      notificationPreferencesBacklightSchool:
          notificationPreferencesBacklightSchool ??
          this.notificationPreferencesBacklightSchool,
      notificationPreferencesBacklightUniversity:
          notificationPreferencesBacklightUniversity ??
          this.notificationPreferencesBacklightUniversity,
      otpTimerInsetShadows: otpTimerInsetShadows ?? this.otpTimerInsetShadows,
      otpCardShadows: otpCardShadows ?? this.otpCardShadows,
      otpDigitBorderWidth: otpDigitBorderWidth ?? this.otpDigitBorderWidth,
      otpDigitGlass: otpDigitGlass ?? this.otpDigitGlass,
      trackCardShadows: trackCardShadows ?? this.trackCardShadows,
      trackCardGlassFirst: trackCardGlassFirst ?? this.trackCardGlassFirst,
      trackCardGlassSecond: trackCardGlassSecond ?? this.trackCardGlassSecond,
      flashcardCardShadows: flashcardCardShadows ?? this.flashcardCardShadows,
      notificationRowShadows:
          notificationRowShadows ?? this.notificationRowShadows,
      notificationRowGlass: notificationRowGlass ?? this.notificationRowGlass,
      notificationDiscGlass:
          notificationDiscGlass ?? this.notificationDiscGlass,
      notificationChipIdleShadows:
          notificationChipIdleShadows ?? this.notificationChipIdleShadows,
      notificationChipIdleGlass:
          notificationChipIdleGlass ?? this.notificationChipIdleGlass,
      supportCreateCardShadows:
          supportCreateCardShadows ?? this.supportCreateCardShadows,
      supportCreateCardGlass:
          supportCreateCardGlass ?? this.supportCreateCardGlass,
      supportAddButtonShadows:
          supportAddButtonShadows ?? this.supportAddButtonShadows,
      supportRowShadows: supportRowShadows ?? this.supportRowShadows,
      supportRowGlass: supportRowGlass ?? this.supportRowGlass,
      supportFieldSectionShadows:
          supportFieldSectionShadows ?? this.supportFieldSectionShadows,
      supportFieldSectionGlass:
          supportFieldSectionGlass ?? this.supportFieldSectionGlass,
      supportInputShadows: supportInputShadows ?? this.supportInputShadows,
      supportComposerBarShadows:
          supportComposerBarShadows ?? this.supportComposerBarShadows,
      supportComposerBarGlass:
          supportComposerBarGlass ?? this.supportComposerBarGlass,
      supportComposerFieldShadows:
          supportComposerFieldShadows ?? this.supportComposerFieldShadows,
    );
  }

  @override
  AppElevation lerp(ThemeExtension<AppElevation>? other, double t) {
    if (other is! AppElevation) return this;
    return AppElevation(
      navBarShadows: FigmaShadow.lerpList(
        navBarShadows,
        other.navBarShadows,
        t,
      ),
      primaryCtaShadows: FigmaShadow.lerpList(
        primaryCtaShadows,
        other.primaryCtaShadows,
        t,
      ),
      // Snaps: a glow that fades in halfway would read as a rendering bug, not
      // as a theme change.
      primaryCtaGlowLayerBlur: t < 0.5
          ? primaryCtaGlowLayerBlur
          : other.primaryCtaGlowLayerBlur,
      outlineCtaShadows: FigmaShadow.lerpList(
        outlineCtaShadows,
        other.outlineCtaShadows,
        t,
      ),
      backChipShadows: FigmaShadow.lerpList(
        backChipShadows,
        other.backChipShadows,
        t,
      ),
      backChipGlass: GlassStyle.lerp(backChipGlass, other.backChipGlass, t),
      registrationBackChipGlass: GlassStyle.lerp(
        registrationBackChipGlass,
        other.registrationBackChipGlass,
        t,
      ),
      languagePillGlass: GlassStyle.lerp(
        languagePillGlass,
        other.languagePillGlass,
        t,
      ),
      languagePillBorderWidth: lerpDouble(
        languagePillBorderWidth,
        other.languagePillBorderWidth,
        t,
      )!,
      fieldGlass: GlassStyle.lerp(fieldGlass, other.fieldGlass, t),
      fieldBorderWidth: lerpDouble(
        fieldBorderWidth,
        other.fieldBorderWidth,
        t,
      )!,
      onboardingSheetShadows: FigmaShadow.lerpList(
        onboardingSheetShadows,
        other.onboardingSheetShadows,
        t,
      ),
      onboardingSheetGlass: GlassStyle.lerp(
        onboardingSheetGlass,
        other.onboardingSheetGlass,
        t,
      ),
      limitSheetScrim: ScrimStyle.lerp(
        limitSheetScrim,
        other.limitSheetScrim,
        t,
      ),
      avatarActionSheetScrim: ScrimStyle.lerp(
        avatarActionSheetScrim,
        other.avatarActionSheetScrim,
        t,
      ),
      chooseAvatarSheetScrim: ScrimStyle.lerp(
        chooseAvatarSheetScrim,
        other.chooseAvatarSheetScrim,
        t,
      ),
      logoutDialogScrim: ScrimStyle.lerp(
        logoutDialogScrim,
        other.logoutDialogScrim,
        t,
      ),
      goToUniversityDialogScrim: ScrimStyle.lerp(
        goToUniversityDialogScrim,
        other.goToUniversityDialogScrim,
        t,
      ),
      levelCardShadows: FigmaShadow.lerpList(
        levelCardShadows,
        other.levelCardShadows,
        t,
      ),
      levelCardGlass: GlassStyle.lerp(levelCardGlass, other.levelCardGlass, t),
      levelCardBacklightSchool: Backlight.lerp(
        levelCardBacklightSchool,
        other.levelCardBacklightSchool,
        t,
      ),
      levelCardBacklightUniversity: Backlight.lerp(
        levelCardBacklightUniversity,
        other.levelCardBacklightUniversity,
        t,
      ),
      dailyTasksBorderWidth: lerpDouble(
        dailyTasksBorderWidth,
        other.dailyTasksBorderWidth,
        t,
      )!,
      dailyTasksGlass: GlassStyle.lerp(
        dailyTasksGlass,
        other.dailyTasksGlass,
        t,
      ),
      dailyTasksBacklightSchool: Backlight.lerp(
        dailyTasksBacklightSchool,
        other.dailyTasksBacklightSchool,
        t,
      ),
      dailyTasksBacklightUniversity: Backlight.lerp(
        dailyTasksBacklightUniversity,
        other.dailyTasksBacklightUniversity,
        t,
      ),
      topStudentBorderWidth: lerpDouble(
        topStudentBorderWidth,
        other.topStudentBorderWidth,
        t,
      )!,
      topStudentGlass: GlassStyle.lerp(
        topStudentGlass,
        other.topStudentGlass,
        t,
      ),
      topStudentBacklightSchool: Backlight.lerp(
        topStudentBacklightSchool,
        other.topStudentBacklightSchool,
        t,
      ),
      continueLearningShadows: FigmaShadow.lerpList(
        continueLearningShadows,
        other.continueLearningShadows,
        t,
      ),
      homeBellGlass: GlassStyle.lerp(homeBellGlass, other.homeBellGlass, t),
      subjectSearchShadows: FigmaShadow.lerpList(
        subjectSearchShadows,
        other.subjectSearchShadows,
        t,
      ),
      subjectSearchGlass: GlassStyle.lerp(
        subjectSearchGlass,
        other.subjectSearchGlass,
        t,
      ),
      subjectCardShadows: FigmaShadow.lerpList(
        subjectCardShadows,
        other.subjectCardShadows,
        t,
      ),
      mistakesPillShadows: FigmaShadow.lerpList(
        mistakesPillShadows,
        other.mistakesPillShadows,
        t,
      ),
      mistakesPillBorderWidth: lerpDouble(
        mistakesPillBorderWidth,
        other.mistakesPillBorderWidth,
        t,
      )!,
      mistakesPillGlass: GlassStyle.lerp(
        mistakesPillGlass,
        other.mistakesPillGlass,
        t,
      ),
      mistakesCardShadows: FigmaShadow.lerpList(
        mistakesCardShadows,
        other.mistakesCardShadows,
        t,
      ),
      mistakesCardGlass: GlassStyle.lerp(
        mistakesCardGlass,
        other.mistakesCardGlass,
        t,
      ),
      treeRowBadgeGlass: GlassStyle.lerp(
        treeRowBadgeGlass,
        other.treeRowBadgeGlass,
        t,
      ),
      pillTrackInsetShadows: FigmaShadow.lerpList(
        pillTrackInsetShadows,
        other.pillTrackInsetShadows,
        t,
      ),
      pillTrackSelectedInsetShadows: FigmaShadow.lerpList(
        pillTrackSelectedInsetShadows,
        other.pillTrackSelectedInsetShadows,
        t,
      ),
      lengthChipShadows: FigmaShadow.lerpList(
        lengthChipShadows,
        other.lengthChipShadows,
        t,
      ),
      aiPanelCardShadows: FigmaShadow.lerpList(
        aiPanelCardShadows,
        other.aiPanelCardShadows,
        t,
      ),
      aiPanelGlass: GlassStyle.lerp(aiPanelGlass, other.aiPanelGlass, t),
      aiPanelBacklight: Backlight.lerp(
        aiPanelBacklight,
        other.aiPanelBacklight,
        t,
      ),
      aiPanelCardGlass: GlassStyle.lerp(
        aiPanelCardGlass,
        other.aiPanelCardGlass,
        t,
      ),
      quizPrevButtonShadows: FigmaShadow.lerpList(
        quizPrevButtonShadows,
        other.quizPrevButtonShadows,
        t,
      ),
      quizPrevButtonGlass: GlassStyle.lerp(
        quizPrevButtonGlass,
        other.quizPrevButtonGlass,
        t,
      ),
      quizPrevButtonRadius: lerpDouble(
        quizPrevButtonRadius,
        other.quizPrevButtonRadius,
        t,
      )!,
      quizQuestionCardBorderWidth: lerpDouble(
        quizQuestionCardBorderWidth,
        other.quizQuestionCardBorderWidth,
        t,
      )!,
      quizSetupDividerWidth: lerpDouble(
        quizSetupDividerWidth,
        other.quizSetupDividerWidth,
        t,
      )!,
      resultBucketShadows: FigmaShadow.lerpList(
        resultBucketShadows,
        other.resultBucketShadows,
        t,
      ),
      resultBucketGlass: GlassStyle.lerp(
        resultBucketGlass,
        other.resultBucketGlass,
        t,
      ),
      rewardsCardShadows: FigmaShadow.lerpList(
        rewardsCardShadows,
        other.rewardsCardShadows,
        t,
      ),
      rewardsCardGlass: GlassStyle.lerp(
        rewardsCardGlass,
        other.rewardsCardGlass,
        t,
      ),
      rewardsCardBacklight: Backlight.lerp(
        rewardsCardBacklight,
        other.rewardsCardBacklight,
        t,
      ),
      resultStarDiscGlass: GlassStyle.lerp(
        resultStarDiscGlass,
        other.resultStarDiscGlass,
        t,
      ),
      reviewFilterIdleShadows: FigmaShadow.lerpList(
        reviewFilterIdleShadows,
        other.reviewFilterIdleShadows,
        t,
      ),
      reviewFilterIdleGlass: GlassStyle.lerp(
        reviewFilterIdleGlass,
        other.reviewFilterIdleGlass,
        t,
      ),
      reviewRowGlass: GlassStyle.lerp(reviewRowGlass, other.reviewRowGlass, t),
      scopeTrackInsetShadows: FigmaShadow.lerpList(
        scopeTrackInsetShadows,
        other.scopeTrackInsetShadows,
        t,
      ),
      scopeSelectedInsetShadows: FigmaShadow.lerpList(
        scopeSelectedInsetShadows,
        other.scopeSelectedInsetShadows,
        t,
      ),
      leaderboardListShadows: FigmaShadow.lerpList(
        leaderboardListShadows,
        other.leaderboardListShadows,
        t,
      ),
      leaderboardRowGlass: GlassStyle.lerp(
        leaderboardRowGlass,
        other.leaderboardRowGlass,
        t,
      ),
      leaderboardRowGroupGlass: GlassStyle.lerp(
        leaderboardRowGroupGlass,
        other.leaderboardRowGroupGlass,
        t,
      ),
      profileHeaderShadows: FigmaShadow.lerpList(
        profileHeaderShadows,
        other.profileHeaderShadows,
        t,
      ),
      profileHeaderGlass: GlassStyle.lerp(
        profileHeaderGlass,
        other.profileHeaderGlass,
        t,
      ),
      profileHeaderBacklight: Backlight.lerp(
        profileHeaderBacklight,
        other.profileHeaderBacklight,
        t,
      ),
      profileEditChipShadows: FigmaShadow.lerpList(
        profileEditChipShadows,
        other.profileEditChipShadows,
        t,
      ),
      profileEditChipGlass: GlassStyle.lerp(
        profileEditChipGlass,
        other.profileEditChipGlass,
        t,
      ),
      profileStatShadows: FigmaShadow.lerpList(
        profileStatShadows,
        other.profileStatShadows,
        t,
      ),
      profileMenuRowGlass: GlassStyle.lerp(
        profileMenuRowGlass,
        other.profileMenuRowGlass,
        t,
      ),
      profileMenuIconDiscGlass: GlassStyle.lerp(
        profileMenuIconDiscGlass,
        other.profileMenuIconDiscGlass,
        t,
      ),
      avatarBadgeShadows: FigmaShadow.lerpList(
        avatarBadgeShadows,
        other.avatarBadgeShadows,
        t,
      ),
      avatarBadgeGlass: GlassStyle.lerp(
        avatarBadgeGlass,
        other.avatarBadgeGlass,
        t,
      ),
      settingsSectionBorderWidth: lerpDouble(
        settingsSectionBorderWidth,
        other.settingsSectionBorderWidth,
        t,
      )!,
      settingsSectionGlass: GlassStyle.lerp(
        settingsSectionGlass,
        other.settingsSectionGlass,
        t,
      ),
      notificationPreferencesBacklightSchool: Backlight.lerp(
        notificationPreferencesBacklightSchool,
        other.notificationPreferencesBacklightSchool,
        t,
      ),
      notificationPreferencesBacklightUniversity: Backlight.lerp(
        notificationPreferencesBacklightUniversity,
        other.notificationPreferencesBacklightUniversity,
        t,
      ),
      otpTimerInsetShadows: FigmaShadow.lerpList(
        otpTimerInsetShadows,
        other.otpTimerInsetShadows,
        t,
      ),
      otpCardShadows: FigmaShadow.lerpList(
        otpCardShadows,
        other.otpCardShadows,
        t,
      ),
      otpDigitBorderWidth: lerpDouble(
        otpDigitBorderWidth,
        other.otpDigitBorderWidth,
        t,
      )!,
      otpDigitGlass: GlassStyle.lerp(otpDigitGlass, other.otpDigitGlass, t),
      trackCardShadows: FigmaShadow.lerpList(
        trackCardShadows,
        other.trackCardShadows,
        t,
      ),
      trackCardGlassFirst: GlassStyle.lerp(
        trackCardGlassFirst,
        other.trackCardGlassFirst,
        t,
      ),
      trackCardGlassSecond: GlassStyle.lerp(
        trackCardGlassSecond,
        other.trackCardGlassSecond,
        t,
      ),
      flashcardCardShadows: FigmaShadow.lerpList(
        flashcardCardShadows,
        other.flashcardCardShadows,
        t,
      ),
      notificationRowShadows: FigmaShadow.lerpList(
        notificationRowShadows,
        other.notificationRowShadows,
        t,
      ),
      notificationRowGlass: GlassStyle.lerp(
        notificationRowGlass,
        other.notificationRowGlass,
        t,
      ),
      notificationDiscGlass: GlassStyle.lerp(
        notificationDiscGlass,
        other.notificationDiscGlass,
        t,
      ),
      notificationChipIdleShadows: FigmaShadow.lerpList(
        notificationChipIdleShadows,
        other.notificationChipIdleShadows,
        t,
      ),
      notificationChipIdleGlass: GlassStyle.lerp(
        notificationChipIdleGlass,
        other.notificationChipIdleGlass,
        t,
      ),
      supportCreateCardShadows: FigmaShadow.lerpList(
        supportCreateCardShadows,
        other.supportCreateCardShadows,
        t,
      ),
      supportCreateCardGlass: GlassStyle.lerp(
        supportCreateCardGlass,
        other.supportCreateCardGlass,
        t,
      ),
      supportAddButtonShadows: FigmaShadow.lerpList(
        supportAddButtonShadows,
        other.supportAddButtonShadows,
        t,
      ),
      supportRowShadows: FigmaShadow.lerpList(
        supportRowShadows,
        other.supportRowShadows,
        t,
      ),
      supportRowGlass: GlassStyle.lerp(
        supportRowGlass,
        other.supportRowGlass,
        t,
      ),
      supportFieldSectionShadows: FigmaShadow.lerpList(
        supportFieldSectionShadows,
        other.supportFieldSectionShadows,
        t,
      ),
      supportFieldSectionGlass: GlassStyle.lerp(
        supportFieldSectionGlass,
        other.supportFieldSectionGlass,
        t,
      ),
      supportInputShadows: FigmaShadow.lerpList(
        supportInputShadows,
        other.supportInputShadows,
        t,
      ),
      supportComposerBarShadows: FigmaShadow.lerpList(
        supportComposerBarShadows,
        other.supportComposerBarShadows,
        t,
      ),
      supportComposerBarGlass: GlassStyle.lerp(
        supportComposerBarGlass,
        other.supportComposerBarGlass,
        t,
      ),
      supportComposerFieldShadows: FigmaShadow.lerpList(
        supportComposerFieldShadows,
        other.supportComposerFieldShadows,
        t,
      ),
    );
  }

  /// Every token, in declaration order. `==` and [hashCode] are built from it,
  /// and `app_elevation_test.dart` asserts its length against the field count
  /// so a token added to the class but forgotten here cannot slip through.
  List<Object?> get props => [
    navBarShadows,
    primaryCtaShadows,
    primaryCtaGlowLayerBlur,
    outlineCtaShadows,
    backChipShadows,
    backChipGlass,
    registrationBackChipGlass,
    languagePillGlass,
    languagePillBorderWidth,
    fieldGlass,
    fieldBorderWidth,
    onboardingSheetShadows,
    onboardingSheetGlass,
    limitSheetScrim,
    avatarActionSheetScrim,
    chooseAvatarSheetScrim,
    logoutDialogScrim,
    goToUniversityDialogScrim,
    levelCardShadows,
    levelCardGlass,
    levelCardBacklightSchool,
    levelCardBacklightUniversity,
    dailyTasksBorderWidth,
    dailyTasksGlass,
    dailyTasksBacklightSchool,
    dailyTasksBacklightUniversity,
    topStudentBorderWidth,
    topStudentGlass,
    topStudentBacklightSchool,
    continueLearningShadows,
    homeBellGlass,
    subjectSearchShadows,
    subjectSearchGlass,
    subjectCardShadows,
    mistakesPillShadows,
    mistakesPillBorderWidth,
    mistakesPillGlass,
    mistakesCardShadows,
    mistakesCardGlass,
    treeRowBadgeGlass,
    pillTrackInsetShadows,
    pillTrackSelectedInsetShadows,
    lengthChipShadows,
    aiPanelCardShadows,
    aiPanelGlass,
    aiPanelBacklight,
    aiPanelCardGlass,
    quizPrevButtonShadows,
    quizPrevButtonGlass,
    quizPrevButtonRadius,
    quizQuestionCardBorderWidth,
    quizSetupDividerWidth,
    resultBucketShadows,
    resultBucketGlass,
    rewardsCardShadows,
    rewardsCardGlass,
    rewardsCardBacklight,
    resultStarDiscGlass,
    reviewFilterIdleShadows,
    reviewFilterIdleGlass,
    reviewRowGlass,
    scopeTrackInsetShadows,
    scopeSelectedInsetShadows,
    leaderboardListShadows,
    leaderboardRowGlass,
    leaderboardRowGroupGlass,
    profileHeaderShadows,
    profileHeaderGlass,
    profileHeaderBacklight,
    profileEditChipShadows,
    profileEditChipGlass,
    profileStatShadows,
    profileMenuRowGlass,
    profileMenuIconDiscGlass,
    avatarBadgeShadows,
    avatarBadgeGlass,
    settingsSectionBorderWidth,
    settingsSectionGlass,
    notificationPreferencesBacklightSchool,
    notificationPreferencesBacklightUniversity,
    otpTimerInsetShadows,
    otpCardShadows,
    otpDigitBorderWidth,
    otpDigitGlass,
    trackCardShadows,
    trackCardGlassFirst,
    trackCardGlassSecond,
    flashcardCardShadows,
    notificationRowShadows,
    notificationRowGlass,
    notificationDiscGlass,
    notificationChipIdleShadows,
    notificationChipIdleGlass,
    supportCreateCardShadows,
    supportCreateCardGlass,
    supportAddButtonShadows,
    supportRowShadows,
    supportRowGlass,
    supportFieldSectionShadows,
    supportFieldSectionGlass,
    supportInputShadows,
    supportComposerBarShadows,
    supportComposerBarGlass,
    supportComposerFieldShadows,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppElevation && _deepEquals(props, other.props);

  @override
  int get hashCode => Object.hashAll([
    for (final p in props)
      if (p is List) Object.hashAll(p) else p,
  ]);
}

/// List equality one level deep — the shadow lists are the only nesting.
bool _deepEquals(List<Object?> a, List<Object?> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    final x = a[i];
    final y = b[i];
    if (x is List && y is List) {
      if (!_deepEquals(x, y)) return false;
    } else if (x != y) {
      return false;
    }
  }
  return true;
}
