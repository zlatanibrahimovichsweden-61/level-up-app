import 'package:flutter/material.dart';

/// Brand accents. The primary accent FLIPS by theme — green in light, purple in
/// dark — so these are two distinct seeds, not one derived from the other.
/// (Verified from Figma Login: 82:819 light, 337:15652 dark.)
class Brand {
  Brand._();
  static const greenPrimary = Color(0xFF384F47); // light-theme primary
  static const purplePrimary = Color(0xFFAE87E7); // dark-theme primary
}

/// Custom design tokens that are NOT part of Material's ColorScheme
/// (cream background, field fill, link colour…). Carried as a ThemeExtension so
/// they switch automatically with theme brightness. Widgets read them via
/// `Theme.of(context).extension<AppColors>()!` — never a raw hex, never a
/// `light`/`dark` variable directly.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.fieldFill,
    required this.fieldBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.hint,
    required this.link,
    required this.secondaryButtonBorder,
    required this.legalText,
    required this.cardFill,
    required this.cardLabel,
    required this.mutedText,
    required this.progressTrack,
    required this.catalogCardFill,
    required this.catalogTrack,
    required this.sheetFill,
    required this.accentSoft,
    required this.bodyMuted,
    required this.successBadge,
    required this.quizOptionFill,
    required this.quizOptionBorder,
    required this.quizDivider,
    required this.quizCorrectFill,
    required this.quizCorrectBorder,
    required this.quizWrongFill,
    required this.quizWrongBorder,
    required this.quizWrongBadge,
    required this.quizExplanationBody,
    required this.navBarFill,
    required this.navAccent,
    required this.navCentreIdleFill,
    required this.navCentreGlyphOn,
    required this.navShadow,
    required this.languagePillBorder,
    required this.languagePillContent,
  });

  final Color background;
  final Color fieldFill;
  final Color fieldBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color hint;
  final Color link;
  final Color secondaryButtonBorder;

  /// "By continuing…" legal paragraph base text — green in light, cream in dark
  /// (the LINK spans use [link]).
  final Color legalText;

  // --- Home tokens (Figma 337:5303 / nav 59:1264) --------------------------
  //
  // Only a DARK Home frame exists in the design file; there is no light-canvas
  // Home to read light values from. So: every dark value below is Figma-verbatim,
  // and each light value reuses an already-approved light token rather than a
  // hex invented to fill the gap. Flagged to the designer — a light Home frame
  // replaces these three light values, not the widgets.

  /// Raised card surface (level card, section cards).
  final Color cardFill;

  /// The small label above a card's headline value ("current level", "Pts
  /// Balance"). Figma dark `#7070A0`.
  final Color cardLabel;

  /// De-emphasised small text: the level-range row, "x / y" progress caption,
  /// and INACTIVE bottom-nav labels. `#B3B3B3` in BOTH canvases — the light nav
  /// frame (59:1264) and the dark Home frame agree on it, so it is not a guess.
  final Color mutedText;

  /// The unfilled part of a progress bar. Figma dark `#2E2D32`.
  final Color progressTrack;

  // --- Catalog tokens (Figma Learn/Subjects 337:5702) -----------------------
  //
  // Same situation as the Home tokens above: only a DARK Learn frame exists, so
  // the dark values are Figma-verbatim and the light values reuse an approved
  // light token rather than an invented hex.

  /// The subject card / drill-down row surface. Figma dark `#27282C` — an
  /// OPAQUE raised surface, unlike [cardFill] (a 20% wash that composites to the
  /// background), so the two are genuinely different tokens, not a duplicate.
  final Color catalogCardFill;

  /// Unfilled track of the per-subject progress bar. Figma dark `#ECECEC` — a
  /// LIGHT track on a dark card, the inverse of [progressTrack] on Home. Kept
  /// separate so correcting one bar never silently restyles the other.
  final Color catalogTrack;

  // --- Onboarding + success tokens ------------------------------------------
  //
  // Unlike the Home and Learn tokens above, these DO have both canvases: the
  // onboarding sheet exists in light (459:43873) and dark (337:15643), so both
  // values below are Figma-verbatim rather than a light stand-in.

  /// The onboarding sheet's own fill — a 20% wash that composites over
  /// [background]. Figma light `rgba(252,251,249,.2)` · dark `rgba(35,38,40,.2)`.
  ///
  /// Note the dark value is `#232628`, NOT the `#232428` used everywhere else:
  /// the frame really does say 38. A 2/255 designer slip, kept verbatim and
  /// flagged (docs/DESIGN_ISSUES.md #23) rather than silently rounded to the
  /// neighbouring token.
  ///
  /// Because it is only 20% opaque, anything behind it shows through — the
  /// onboarding Stack paints [background] under it on purpose.
  final Color sheetFill;

  /// The accented word in "**Your** Learning Journey" (`459:43876` / `459:43886`).
  ///
  /// Light is a SAGE green `#A0B384` — deliberately not [Brand.greenPrimary],
  /// which would be far too dark against the 24px medium weight. Dark happens to
  /// equal [Brand.purplePrimary], but is kept as its own token so restyling the
  /// accent never silently restyles the primary button.
  final Color accentSoft;

  /// Muted body copy on the cream canvas: the onboarding tagline
  /// (`459:43887` / `459:43877`) and the success subtitle (`82:1578`).
  ///
  /// ONE token for what the frames draw as three near-identical greys — `#7C7C7C`
  /// (success subtitle), `#858585` (tagline, light) and `#ECECEC` (tagline, dark).
  /// The first two are 9/255 apart and mean the same thing, so the light value is
  /// `#858585` for both. Flagged for the designer (docs/DESIGN_ISSUES.md #24).
  final Color bodyMuted;

  /// Semantic success green — the OTP success badge (`82:1598`).
  ///
  /// **Identical in both palettes, and that is deliberate: do not "fix" it into
  /// the accent.** A success signal must not flip green→purple with the theme,
  /// which is exactly the bug this token replaces (the badge used to be tinted
  /// with `colorScheme.primary` and rendered purple in dark).
  ///
  /// The value is not a design token — there is no green anywhere in the file's
  /// variables — so it was read out of `assets/images/success_badge.svg`, whose
  /// only non-white fill is `#22C55E`. The SVG is the source of truth; if the
  /// designer re-exports it, re-read the fill.
  final Color successBadge;

  // --- Quiz tokens (Figma 135:1622 setup · 159:1851 options + AI panel) ------
  //
  // Only LIGHT quiz frames exist. The Day 7 brief says dark variants live in a
  // sibling group, but the document has exactly one page (`0:1`) and no dark
  // quiz frame was found on it — so this is the same situation as the Home and
  // Learn tokens above, in reverse: light is Figma-verbatim, and dark reuses an
  // already-approved dark token rather than an invented hex. Flagged in
  // docs/DESIGN_ISSUES.md.
  //
  // The five SEMANTIC tokens (correct/wrong fills, borders, badge) are
  // deliberately IDENTICAL in both palettes, for exactly the reason documented
  // on [successBadge]: a correctness signal must never flip colour with the
  // theme. A wrong answer is red in dark mode too.

  /// The un-chosen option tile's surface, and the AI panel's own surface.
  /// Figma light `#FCFBF9`; dark reuses [catalogCardFill], the file's approved
  /// opaque raised surface.
  final Color quizOptionFill;

  /// Hairline around an ungraded option tile and the AI panel, and the colour
  /// of the A/B/C/D badge ring. Figma `#4B675E`.
  ///
  /// Kept in BOTH palettes, the same way [secondaryButtonBorder] is — it is a
  /// desaturated green that carries on either canvas, and splitting it would
  /// mean inventing a dark value.
  final Color quizOptionBorder;

  /// The rule under the setup screen's scope header. Figma light `#CCD5D2`;
  /// dark reuses [progressTrack], the approved dark hairline.
  final Color quizDivider;

  /// The revealed correct option. Figma `#BFFFC3` fill, `#00D33C` border; its
  /// badge is [successBadge], the same `#22C55E` the OTP screen already uses.
  final Color quizCorrectFill;
  final Color quizCorrectBorder;

  /// The student's own wrong choice. Figma `rgba(255,192,192,0.3)` fill,
  /// `#921119` border, `#EF4444` badge.
  ///
  /// Note the fill is only 30% opaque — it composites over whatever is behind
  /// it, so it reads correctly on both canvases without a second value.
  final Color quizWrongFill;
  final Color quizWrongBorder;
  final Color quizWrongBadge;

  /// AI explanation body copy. Figma `#7070A0` — the same value as the dark
  /// [cardLabel], but kept separate because light [cardLabel] is `#696969` and
  /// the quiz frame really does specify the purple-grey in the LIGHT canvas.
  final Color quizExplanationBody;

  // --- Bottom-nav tokens (Figma 59:1264 light · 348:6686 dark) --------------
  //
  // BOTH canvases exist for the nav, so every value below is Figma-verbatim.
  // The nav DOES follow the green→purple accent flip (unlike Home, which is
  // purple in both canvases), but its green is the LIGHTER `#4B675E`, not
  // [Brand.greenPrimary], so `cs.primary` is the wrong source here.

  /// The bar's own fill. Light `#FCFBF9` happens to equal [background]; dark
  /// `#212226` does NOT equal the dark background `#232428` — the bar is a
  /// slightly darker sheet than the page it floats over, which is why this is
  /// its own token rather than a reuse.
  final Color navBarFill;

  /// Selected tab glyph, label and the 26×2 top rule. `#4B675E` light /
  /// `#AE87E7` dark. Inactive tabs use [mutedText] (`#B3B3B3`, both canvases).
  final Color navAccent;

  /// The centre (Learn) tab's circle when it is NOT selected — `#F3F1F8`, the
  /// first lavender wash in the light canvas, and `#3E3E3E` in dark. When the
  /// tab IS selected the circle fills with [navAccent]: on the centre tab the
  /// BACKGROUND carries selection, not the glyph tint (docs/DESIGN_ISSUES #38).
  final Color navCentreIdleFill;

  /// The centre tab's glyph while selected — white on the filled circle, in
  /// both canvases. A token rather than a bare `Colors.white` so the pair
  /// [navCentreIdleFill]/[navAccent]/[navCentreGlyphOn] reads as one rule.
  final Color navCentreGlyphOn;

  /// Drop shadow under the notched bar. The frame exports it as a filter, not a
  /// token, so colour/opacity/blur are read off the filter bounds
  /// (≈ blur 20, y+4, black 8%).
  ///
  /// TODO(design): confirm the real shadow token — docs/DESIGN_ISSUES.md #37,
  /// open question 2. 8% black is the current best reading, not a design value.
  final Color navShadow;

  // --- Language pill (Figma 82:1093 light · 337:19693 dark) -----------------

  /// The pill's outline — **`null` in dark, and that is the design**, not a
  /// missing value: the frame draws the pill as `#232428` on a `#232428` page
  /// with no outline at all. Widgets must skip the border when this is null
  /// rather than substituting one.
  ///
  /// The light value is `#4B675E`, deliberately NOT
  /// [secondaryButtonBorder] (`#384F47`): the frame uses two different greens
  /// here, the lighter one for the outline and the darker for the content.
  final Color? languagePillBorder;

  /// The pill's glyph and label — `#384F47` light / `#FCFBF9` cream dark.
  ///
  /// Numerically identical to [legalText] today, but kept separate: restyling
  /// the "By continuing…" paragraph must not silently restyle the language
  /// toggle, and light [textPrimary] (`#0E0E0E`) is the wrong colour here.
  final Color languagePillContent;

  /// Light palette — Figma Login 82:819.
  static const light = AppColors(
    background: Color(0xFFFCFBF9),
    fieldFill: Color(0xFFFDFDFD),
    fieldBorder: Color(0xFFD1D1D1),
    textPrimary: Color(0xFF0E0E0E),
    textSecondary: Color(0xFF2C2C2C),
    hint: Color(0xFF696969),
    link: Color(0xFFE67E22), // orange
    secondaryButtonBorder: Brand.greenPrimary,
    legalText: Brand.greenPrimary, // #384F47 green
    cardFill: Color(0xFFFDFDFD), // = light fieldFill (no light Home frame)
    cardLabel: Color(0xFF696969), // = light hint (no light Home frame)
    mutedText: Color(0xFFB3B3B3), // Figma — same in both canvases
    progressTrack: Color(0xFFD1D1D1), // = light fieldBorder (no light Home frame)
    catalogCardFill: Color(0xFFFDFDFD), // = light fieldFill (no light Learn frame)
    catalogTrack: Color(0xFFD1D1D1), // = light fieldBorder (no light Learn frame)
    sheetFill: Color(0x33FCFBF9), // rgba(252,251,249,0.2) — Figma 459:43873
    accentSoft: Color(0xFFA0B384), // Figma 459:43876 — sage, not greenPrimary
    bodyMuted: Color(0xFF858585), // Figma 459:43887
    successBadge: Color(0xFF22C55E), // from assets/images/success_badge.svg
    quizOptionFill: Color(0xFFFCFBF9), // Figma 308:5153
    quizOptionBorder: Color(0xFF4B675E), // Figma 308:5153
    quizDivider: Color(0xFFCCD5D2), // Figma 146:2287
    quizCorrectFill: Color(0xFFBFFFC3), // Figma 308:5166
    quizCorrectBorder: Color(0xFF00D33C), // Figma 308:5166
    quizWrongFill: Color(0x4DFFC0C0), // rgba(255,192,192,.3) — Figma 308:5158
    quizWrongBorder: Color(0xFF921119), // Figma 308:5158
    quizWrongBadge: Color(0xFFEF4444), // Figma 308:5160
    quizExplanationBody: Color(0xFF7070A0), // Figma 159:1831
    navBarFill: Color(0xFFFCFBF9), // Figma 59:1264
    navAccent: Color(0xFF4B675E), // Figma 59:1264 — NOT Brand.greenPrimary
    navCentreIdleFill: Color(0xFFF3F1F8), // Figma 59:1003
    navCentreGlyphOn: Color(0xFFFFFFFF), // Figma 59:1084 — white in both
    navShadow: Color(0x14000000), // ~8% black — TODO(design), see field doc
    languagePillBorder: Color(0xFF4B675E), // Figma 82:1093
    languagePillContent: Brand.greenPrimary, // #384F47 — Figma 82:1098/82:1100
  );

  /// Dark palette — Figma Login 337:15652.
  static const dark = AppColors(
    background: Color(0xFF232428),
    fieldFill: Color(0x33232428), // rgba(35,36,40,0.2)
    fieldBorder: Color(0xFFFCFBF9),
    textPrimary: Color(0xFFFCFBF9),
    textSecondary: Color(0xFFDCDCDC),
    hint: Color(0xFFFCFBF9),
    link: Color(0xFFAE87E7), // purple
    secondaryButtonBorder: Brand.greenPrimary, // green border kept in both
    legalText: Color(0xFFFCFBF9), // #FCFBF9 cream
    cardFill: Color(0x33232428), // rgba(35,36,40,0.2) — Figma 337:5336
    cardLabel: Color(0xFF7070A0), // Figma 337:5340
    mutedText: Color(0xFFB3B3B3), // Figma 337:5346
    progressTrack: Color(0xFF2E2D32), // Figma 337:5350
    catalogCardFill: Color(0xFF27282C), // Figma 337:5732
    catalogTrack: Color(0xFFECECEC), // Figma 337:5744
    sheetFill: Color(0x33232628), // rgba(35,38,40,0.2) — Figma 337:15643
    accentSoft: Color(0xFFAE87E7), // Figma 459:43886
    bodyMuted: Color(0xFFECECEC), // Figma 459:43877
    // Identical to light ON PURPOSE — a success badge must not follow the
    // green→purple accent flip. See the field doc above.
    successBadge: Color(0xFF22C55E),
    quizOptionFill: Color(0xFF27282C), // = dark catalogCardFill (no dark frame)
    quizOptionBorder: Color(0xFF4B675E), // Figma — kept in both, like the border above
    quizDivider: Color(0xFF2E2D32), // = dark progressTrack (no dark frame)
    // The five semantic tokens below are IDENTICAL to light on purpose: a
    // correct answer must not read purple and a wrong one must not read green.
    quizCorrectFill: Color(0xFFBFFFC3),
    quizCorrectBorder: Color(0xFF00D33C),
    quizWrongFill: Color(0x4DFFC0C0),
    quizWrongBorder: Color(0xFF921119),
    quizWrongBadge: Color(0xFFEF4444),
    quizExplanationBody: Color(0xFF7070A0),
    navBarFill: Color(0xFF212226), // Figma 348:6686 — NOT the #232428 page fill
    navAccent: Color(0xFFAE87E7), // Figma 348:6686
    navCentreIdleFill: Color(0xFF3E3E3E), // Figma 348:6686
    navCentreGlyphOn: Color(0xFFFFFFFF), // white in both canvases
    navShadow: Color(0x14000000), // ~8% black — TODO(design), see field doc
    languagePillBorder: null, // Figma 337:19693 — no outline in dark
    languagePillContent: Color(0xFFFCFBF9), // Figma 337:19693
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? fieldFill,
    Color? fieldBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? hint,
    Color? link,
    Color? secondaryButtonBorder,
    Color? legalText,
    Color? cardFill,
    Color? cardLabel,
    Color? mutedText,
    Color? progressTrack,
    Color? catalogCardFill,
    Color? catalogTrack,
    Color? sheetFill,
    Color? accentSoft,
    Color? bodyMuted,
    Color? successBadge,
    Color? quizOptionFill,
    Color? quizOptionBorder,
    Color? quizDivider,
    Color? quizCorrectFill,
    Color? quizCorrectBorder,
    Color? quizWrongFill,
    Color? quizWrongBorder,
    Color? quizWrongBadge,
    Color? quizExplanationBody,
    Color? navBarFill,
    Color? navAccent,
    Color? navCentreIdleFill,
    Color? navCentreGlyphOn,
    Color? navShadow,
    Color? languagePillBorder,
    Color? languagePillContent,
  }) {
    return AppColors(
      background: background ?? this.background,
      fieldFill: fieldFill ?? this.fieldFill,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hint: hint ?? this.hint,
      link: link ?? this.link,
      secondaryButtonBorder: secondaryButtonBorder ?? this.secondaryButtonBorder,
      legalText: legalText ?? this.legalText,
      cardFill: cardFill ?? this.cardFill,
      cardLabel: cardLabel ?? this.cardLabel,
      mutedText: mutedText ?? this.mutedText,
      progressTrack: progressTrack ?? this.progressTrack,
      catalogCardFill: catalogCardFill ?? this.catalogCardFill,
      catalogTrack: catalogTrack ?? this.catalogTrack,
      sheetFill: sheetFill ?? this.sheetFill,
      accentSoft: accentSoft ?? this.accentSoft,
      bodyMuted: bodyMuted ?? this.bodyMuted,
      successBadge: successBadge ?? this.successBadge,
      quizOptionFill: quizOptionFill ?? this.quizOptionFill,
      quizOptionBorder: quizOptionBorder ?? this.quizOptionBorder,
      quizDivider: quizDivider ?? this.quizDivider,
      quizCorrectFill: quizCorrectFill ?? this.quizCorrectFill,
      quizCorrectBorder: quizCorrectBorder ?? this.quizCorrectBorder,
      quizWrongFill: quizWrongFill ?? this.quizWrongFill,
      quizWrongBorder: quizWrongBorder ?? this.quizWrongBorder,
      quizWrongBadge: quizWrongBadge ?? this.quizWrongBadge,
      quizExplanationBody: quizExplanationBody ?? this.quizExplanationBody,
      navBarFill: navBarFill ?? this.navBarFill,
      navAccent: navAccent ?? this.navAccent,
      navCentreIdleFill: navCentreIdleFill ?? this.navCentreIdleFill,
      navCentreGlyphOn: navCentreGlyphOn ?? this.navCentreGlyphOn,
      navShadow: navShadow ?? this.navShadow,
      // Note: `??` cannot CLEAR languagePillBorder — copyWith can only set one.
      // Dark gets its null from the palette itself, not from a copyWith.
      languagePillBorder: languagePillBorder ?? this.languagePillBorder,
      languagePillContent: languagePillContent ?? this.languagePillContent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      fieldFill: Color.lerp(fieldFill, other.fieldFill, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      link: Color.lerp(link, other.link, t)!,
      secondaryButtonBorder:
          Color.lerp(secondaryButtonBorder, other.secondaryButtonBorder, t)!,
      legalText: Color.lerp(legalText, other.legalText, t)!,
      cardFill: Color.lerp(cardFill, other.cardFill, t)!,
      cardLabel: Color.lerp(cardLabel, other.cardLabel, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      catalogCardFill: Color.lerp(catalogCardFill, other.catalogCardFill, t)!,
      catalogTrack: Color.lerp(catalogTrack, other.catalogTrack, t)!,
      sheetFill: Color.lerp(sheetFill, other.sheetFill, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      bodyMuted: Color.lerp(bodyMuted, other.bodyMuted, t)!,
      // Lerps between two identical values — i.e. stays put across a theme
      // animation, which is the whole point.
      successBadge: Color.lerp(successBadge, other.successBadge, t)!,
      quizOptionFill: Color.lerp(quizOptionFill, other.quizOptionFill, t)!,
      quizOptionBorder: Color.lerp(quizOptionBorder, other.quizOptionBorder, t)!,
      quizDivider: Color.lerp(quizDivider, other.quizDivider, t)!,
      // Same as successBadge: identical endpoints, so these stay put across a
      // theme animation.
      quizCorrectFill: Color.lerp(quizCorrectFill, other.quizCorrectFill, t)!,
      quizCorrectBorder:
          Color.lerp(quizCorrectBorder, other.quizCorrectBorder, t)!,
      quizWrongFill: Color.lerp(quizWrongFill, other.quizWrongFill, t)!,
      quizWrongBorder: Color.lerp(quizWrongBorder, other.quizWrongBorder, t)!,
      quizWrongBadge: Color.lerp(quizWrongBadge, other.quizWrongBadge, t)!,
      quizExplanationBody:
          Color.lerp(quizExplanationBody, other.quizExplanationBody, t)!,
      navBarFill: Color.lerp(navBarFill, other.navBarFill, t)!,
      navAccent: Color.lerp(navAccent, other.navAccent, t)!,
      navCentreIdleFill:
          Color.lerp(navCentreIdleFill, other.navCentreIdleFill, t)!,
      navCentreGlyphOn:
          Color.lerp(navCentreGlyphOn, other.navCentreGlyphOn, t)!,
      navShadow: Color.lerp(navShadow, other.navShadow, t)!,
      // Nullable on purpose — Color.lerp fades to/from transparent when one end
      // is null, which is exactly right for a border that only exists in light.
      languagePillBorder:
          Color.lerp(languagePillBorder, other.languagePillBorder, t),
      languagePillContent:
          Color.lerp(languagePillContent, other.languagePillContent, t)!,
    );
  }
}
