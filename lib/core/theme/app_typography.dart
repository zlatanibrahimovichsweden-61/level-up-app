import 'package:flutter/material.dart';

/// The type scale — **transcribed verbatim** from the designer's handoff,
/// `typography-style-inter.md`, received 2026-08-21.
///
/// This file closes `docs/RISKS.md` **R-1**, which had blocked Wave 3D since
/// 2026-08-15 with "Figma defines ONE text style; twelve day-briefs carry no
/// scale". It is the anchor that was missing. Nothing here is derived,
/// interpolated or inferred: every size, weight, line-height and letter-spacing
/// below appears literally in that document.
///
/// ## The rules this file exists to enforce
///
/// 1. **No `fontSize:` outside this file.** Guard-enforced in
///    `test/core/theme/typography_discipline_test.dart`, with the ratchet in
///    `test/guards/project_rules_test.dart` pinned at zero. The old ratchet
///    counted 153 inline sizes across 49 files; the guard now holds the line
///    at zero in `lib/` outside `lib/core/theme/`.
/// 2. **Sizes come only from the scale** `28 → 24 → 20 → 18 → 16 → 14 → 12 → 10`
///    (plus `11`, which the handoff defines for bottom navigation only). The
///    designer's own closing rule: "Do not create random font sizes inside
///    individual screens."
/// 3. **Colour is NOT part of a type style.** Colour stays in [AppColors] and is
///    applied at the call site with `.copyWith(color: ext.something)`. Keeping
///    the two axes separate is why these can be `const` and why the palette
///    guard keeps working unchanged.
///
/// ## Why no `fontFamily` here
///
/// Deliberately absent. `AppTheme` sets `fontFamily: 'Inter'` with
/// `fontFamilyFallback: ['Tajawal', 'Cairo']`, and Arabic has no Inter glyphs.
/// Naming the family on each style would pin it to Inter and silently drop the
/// fallback chain — Arabic would render tofu or hit the platform default. The
/// handoff says "Primary Font: Inter"; the theme already says exactly that, in
/// the one place that can also say what happens when Inter has nothing to draw.
///
/// ## Line heights
///
/// Flutter's `height` is a MULTIPLIER; the handoff gives pixels. Each is written
/// as the division so the source still shows the designer's two numbers — the
/// same convention already used in `profile_menu_row.dart` (`21 / 18`).
abstract final class AppType {
  // ---------------------------------------------------------------------
  // 01 — Display
  // ---------------------------------------------------------------------

  /// Display / Large — 28/34, 700, −0.5.
  /// Handoff usage: "Main dashboard numbers, important statistics, major
  /// promotional content."
  static const displayLarge = TextStyle(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  // ---------------------------------------------------------------------
  // 02 — Headings
  // ---------------------------------------------------------------------

  /// Heading / H1 — 24/30, 700, −0.3. Usage: "Main page titles."
  static const h1 = TextStyle(
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  /// Heading / H2 — 20/26, 700, −0.2. Usage: "Major sections and screen titles."
  static const h2 = TextStyle(
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  /// Heading / H3 — 18/24, 600. Usage: "Card titles, section titles, course
  /// names."
  static const h3 = TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Heading / H4 — 16/20, 600. Usage: "Smaller section headings and important
  /// content titles."
  ///
  /// Metrically identical to [buttonLarge]. That is the handoff's doing, not a
  /// mistake here: the two are separate NAMES for the same measurements, so the
  /// choice between them is about intent and costs no pixels either way.
  static const h4 = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------
  // 03 — Body
  // ---------------------------------------------------------------------

  /// Body / Large — 16/24, 400. Usage: "Primary descriptive text."
  static const bodyLarge = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Body / Medium — 14/20, 400. Usage: "General application content,
  /// descriptions and supporting information."
  static const bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Body / Medium Strong — 14/20, 500. Usage: "Important supporting text and
  /// highlighted information."
  static const bodyMediumStrong = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------
  // 04 — Labels
  // ---------------------------------------------------------------------

  /// Label / Large — 14/18, 600. Usage: "Form labels, important labels and card
  /// metadata."
  ///
  /// Metrically identical to [buttonMedium] — see the note on [h4].
  static const labelLarge = TextStyle(
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Label / Medium — 12/16, 500. Usage: "Secondary labels, tabs and small UI
  /// elements."
  static const labelMedium = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Label / Small — 10/14, 500. Usage: "Very small metadata and compact UI
  /// information."
  static const labelSmall = TextStyle(
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------
  // 05 — Buttons
  // ---------------------------------------------------------------------

  /// Button / Large — 16/20, 600.
  static const buttonLarge = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Button / Medium — 14/18, 600.
  static const buttonMedium = TextStyle(
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Button / Small — 12/16, 600.
  static const buttonSmall = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------
  // 06 — Navigation
  // ---------------------------------------------------------------------

  /// Navigation / Active — 11/14, 600. The one place `11` is legal.
  static const navActive = TextStyle(
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Navigation / Default — 11/14, 500.
  static const navDefault = TextStyle(
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------
  // 07 — Captions & metadata
  // ---------------------------------------------------------------------

  /// Caption / Regular — 12/16, 400. Usage: "Secondary descriptions, dates and
  /// supporting information."
  static const captionRegular = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Caption / Small — 10/14, 400. Usage: "Progress information, small
  /// timestamps and compact metadata."
  static const captionSmall = TextStyle(
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------
  // Material bridge
  // ---------------------------------------------------------------------

  /// The scale projected onto Material's fifteen [TextTheme] slots.
  ///
  /// Framework widgets do not know these names — they read [TextTheme]. Without
  /// this, an `AlertDialog` title, a `FilledButton` label or an `AppBar` title
  /// would still be drawing Material's stock Roboto-derived sizes while the
  /// screens around them used the handoff. Two type systems in one app, which is
  /// the same failure mode `dialogTheme` was added to fix for surfaces.
  ///
  /// The mappings that actually matter in this app:
  /// - `labelLarge` is what every Material button renders its child with, so it
  ///   carries **Button / Large**.
  /// - `titleLarge` is the `AppBar` title slot → **H2** ("screen titles").
  /// - `headlineSmall` is the `AlertDialog` title slot → **H3**.
  /// - `bodyMedium` is the `AlertDialog` content slot and the global default.
  static const textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayLarge,
    displaySmall: h1,
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: h2,
    titleMedium: h3,
    titleSmall: h4,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: captionRegular,
    labelLarge: buttonLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
