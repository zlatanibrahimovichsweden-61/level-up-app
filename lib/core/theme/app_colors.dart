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
    required this.cardValue,
    required this.homeAccent,
    required this.mutedText,
    required this.progressTrack,
    required this.bellRing,
    required this.bellGlyph,
    required this.bellUnreadDot,
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
    required this.trackCardBorderStart,
    required this.trackCardBorderEnd,
    required this.trackRadioRing,
    required this.backChipFill,
    required this.backChipGlyph,
    required this.profileRowBorder,
    required this.profileStatLabel,
    required this.profileStatValue,
    required this.profileIconChip,
    required this.destructive,
    required this.dialogNote,
    required this.elevationShadow,
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

  // --- Home tokens (Figma 59:1439 light · 337:5303 dark) --------------------
  //
  // A light Home frame DOES exist — `59:1439`. Day 7b re-derived these against
  // it (docs/DESIGN_ISSUES.md #42). What that turned up is not one wrong
  // colour but a wrong RULE: **Home is exempt from the green-in-light /
  // purple-in-dark accent flip.** Its accent is `#AE87E7` on both canvases —
  // see [homeAccent] — so `colorScheme.primary` must not appear anywhere under
  // lib/features/home/.
  //
  // [cardFill]'s light value is the one token here still carrying the old
  // "no light Home frame" derivation: the frame says `#FCFBF9`, the palette
  // says `#FDFDFD`. Left alone deliberately — it was outside Day 7b's D1
  // change list — and reported rather than silently corrected.

  /// Raised card surface (level card, section cards).
  ///
  /// TODO(design): light is `#FDFDFD`, derived from `fieldFill` back when no
  /// light Home frame was known. `59:1439` says `#FCFBF9`. Not changed in
  /// Day 7b — see the block comment above.
  final Color cardFill;

  /// The small label above a card's headline value ("current level", "Pts
  /// Balance"). Figma `#7070A0` — the SAME on both canvases (`59:1439` and
  /// `337:5340`). The light value used to be `#696969`, derived from `hint`.
  final Color cardLabel;

  /// A card's headline value ("LEVEL 8", the points balance). Figma light
  /// `#393939` / dark `#FCFBF9` — deliberately NOT [textPrimary], whose light
  /// value `#0E0E0E` is considerably harder than the frame's.
  final Color cardValue;

  /// Home's accent: the level progress bar's fill and the divider between the
  /// two stats. `#AE87E7` in BOTH canvases.
  ///
  /// **This is the app's one documented exemption from the accent flip.** The
  /// rest of the app runs [Brand.greenPrimary] in light and
  /// [Brand.purplePrimary] in dark via `colorScheme.primary`; the light Home
  /// frame `59:1439` draws purple. It is a distinct token rather than a
  /// `Brand.purplePrimary` reference at the call site so the exemption is
  /// visible in the palette instead of hidden in a widget.
  final Color homeAccent;

  /// De-emphasised small text: the level-range row, "x / y" progress caption,
  /// and INACTIVE bottom-nav labels. `#B3B3B3` in BOTH canvases — the light nav
  /// frame (59:1264) and the dark Home frame agree on it, so it is not a guess.
  final Color mutedText;

  /// The unfilled part of a progress bar. Figma light `#ECECEC` (`59:1439`) /
  /// dark `#2E2D32` (`337:5350`). The light value used to be `#D1D1D1`,
  /// derived from `fieldBorder`.
  final Color progressTrack;

  // --- Home header bell (Figma 59:1466 light · 337:5330 dark) --------------

  /// The bell chip's 0.5px ring. `#4B675E` on both canvases.
  final Color bellRing;

  /// The bell glyph itself. `#4B675E` light / `#FCFBF9` dark.
  final Color bellGlyph;

  /// The unread dot over the bell — `#E67E22` light / `#AE87E7` dark. Note it
  /// changes hue between canvases: it is not a fixed "notification orange",
  /// even though it happens to share both values with [link].
  ///
  /// The dot is STATE, not decoration, and there is no notifications endpoint
  /// in the contract — see the gate on `HomeHeader`.
  final Color bellUnreadDot;

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

  // --- Track picker (Figma 82:1785 light · 337:15947 dark) ------------------

  /// The two stops of the track card's 1px GRADIENT outline, `#384F47` at the
  /// top-end corner running to `#95CDBB` at the bottom-start one.
  ///
  /// Both are `null` in dark — the same light-only-border rule as
  /// [languagePillBorder]. Flutter has no gradient `Border`, so the card paints
  /// a gradient-filled box with a 1px-inset fill on top; a null pair means the
  /// card skips that wrapper entirely rather than drawing a flat stand-in.
  final Color? trackCardBorderStart;
  final Color? trackCardBorderEnd;

  /// The track card's r=9.5 radio ring — 1px, transparent fill.
  /// `#384F47` light / `#FCFBF9` dark.
  final Color trackRadioRing;

  /// The 35×35 circular back chip's fill. Light `#FCFBF9` is Figma `90:208`;
  /// the frame's ring around it reads as a shadow, not a stroke, so there is
  /// no border token here.
  ///
  /// TODO(design): the dark canvas has no back-chip frame. `#232428` (the dark
  /// page fill, matching how the language pill and track card behave in dark)
  /// is a FALLBACK, not a measured value — docs/DESIGN_ISSUES.md #40.
  final Color backChipFill;

  /// The back chip's chevron. Light `#4B675E` is Figma `90:209`.
  ///
  /// TODO(design): dark is a FALLBACK — cream, following
  /// [languagePillContent], because `#4B675E` on a `#232428` chip is too low
  /// contrast for a navigation control. Not measured.
  final Color backChipGlyph;

  // --- Profile tokens (Figma 166:4416 · dialog 180:4445) --------------------
  //
  // Only a LIGHT Profile frame exists — the same situation as the Home, Learn
  // and quiz tokens above. Light values are Figma-verbatim; each dark value
  // reuses an already-approved dark token rather than an invented hex, and says
  // which one. Flagged in docs/DESIGN_ISSUES.md.

  /// The 0.5px outline around each Profile menu row. Figma `#7070A0`.
  ///
  /// Numerically equal to [cardLabel], and kept separate for the reason that
  /// token's own doc gives: restyling Home's "current level" caption must not
  /// silently restyle nine navigation rows.
  final Color profileRowBorder;

  /// A stat card's label ("Points"). Figma light `#384F47`; dark follows
  /// [legalText]'s green→cream mapping, because `#384F47` on a `#232428` card
  /// is unreadable.
  final Color profileStatLabel;

  /// A stat card's value (the points figure). Figma `#7070A0` — kept in both
  /// canvases, like [cardLabel], which the file uses at the same value.
  final Color profileStatValue;

  /// The lavender circle behind the Go-to-University and Logout glyphs. Figma
  /// light `#F4E6FF`; dark reuses [navCentreIdleFill] (`#3E3E3E`), the file's
  /// approved dark chip fill.
  final Color profileIconChip;

  /// Destructive intent — the Logout row's outline and label, and the Logout
  /// dialog's confirm button. Figma `#EF4444`.
  ///
  /// **Identical in both palettes on purpose**, for the reason documented on
  /// [successBadge]: a destructive signal must not follow the green→purple
  /// accent flip. It happens to equal [quizWrongBadge]; the two are separate
  /// because "you got this one wrong" and "this button ends your session" are
  /// different meanings that must be restylable independently.
  final Color destructive;

  /// A confirmation dialog's secondary caution line ("You can't go back
  /// again") — Figma `180:4571`, `#AE87E7`.
  ///
  /// Purple in BOTH canvases, like [homeAccent] and for the same reason: the
  /// value is what the light frame draws, and there is no dark frame that says
  /// otherwise. Separate from [homeAccent] so restyling Home's progress bar
  /// does not restyle a dialog's warning copy.
  final Color dialogNote;

  // --- Elevation ------------------------------------------------------------

  /// The BASE colour of a raised surface's drop shadow. Five call sites use it:
  /// the onboarding sheet, the Edit Profile avatar badge, the Profile header
  /// card, a Profile stat card and the quiz AI panel.
  ///
  /// **It carries no alpha — the call site applies the frame's own.** Those
  /// five shadows are measured at two different depths (0.15 for the onboarding
  /// sheet, 0.25 for the other four) with different blurs and offsets. How deep
  /// a component floats is a property of that component, not of the palette;
  /// what the palette owns is what the shadow is made of, which is exactly the
  /// part that was wrong. Every one of them used to be a literal
  /// `Colors.black`.
  ///
  /// **A black shadow is invisible on the dark canvas, so this flips.** Black
  /// at 25% over light `#FCFBF9` drops L\* from ≈98 to ≈77 — a 21-point step,
  /// which is what a shadow is for. The same black over dark `#232428` moves
  /// L\* from ≈13.8 to ≈8.7: a 5-point step, under a 1–4px blur, i.e. nothing.
  /// The dark canvas has almost no room left below it, so elevation there has
  /// to be expressed upward. Cream at the same alphas over `#232428` gives
  /// ≈+25 L\* — the same magnitude in the only available direction, rendering
  /// as a rim light rather than a shadow.
  ///
  /// TODO(design): the dark value is DERIVED, not measured — there is no dark
  /// frame for any of the five components, and the light frames export a filter
  /// rather than a token. `#FCFBF9` is the file's already-approved dark
  /// foreground (dark [textPrimary], [legalText], [fieldBorder]), chosen over
  /// an invented hex for the reason the Home/Learn/quiz/Profile token blocks
  /// above all give. Rejected alternative: keep black and raise the alpha —
  /// arithmetically it cannot reach a comparable step, because `#232428` is
  /// only ≈14 L\* off the floor to begin with. See docs/DESIGN_ISSUES.md #47;
  /// one value here overrules it.
  ///
  /// [navShadow] is deliberately NOT pointed at this: it has its own measured
  /// derivation and its own open question, and folding the two together would
  /// restyle the bottom nav on the strength of a decision about card shadows.
  /// It has the same dark-canvas problem — same issue entry.
  final Color elevationShadow;

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
    cardFill: Color(0xFFFDFDFD), // TODO(design): 59:1439 says #FCFBF9
    cardLabel: Color(0xFF7070A0), // Figma 59:1439 — same in both canvases
    cardValue: Color(0xFF393939), // Figma 59:1439
    homeAccent: Brand.purplePrimary, // #AE87E7 — Figma 59:1439, PURPLE in light
    mutedText: Color(0xFFB3B3B3), // Figma — same in both canvases
    progressTrack: Color(0xFFECECEC), // Figma 59:1439
    bellRing: Color(0xFF4B675E), // Figma 59:1466 — same in both canvases
    bellGlyph: Color(0xFF4B675E), // Figma 59:1466
    bellUnreadDot: Color(0xFFE67E22), // Figma 59:1466
    catalogCardFill: Color(
      0xFFFDFDFD,
    ), // = light fieldFill (no light Learn frame)
    catalogTrack: Color(
      0xFFD1D1D1,
    ), // = light fieldBorder (no light Learn frame)
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
    trackCardBorderStart: Brand.greenPrimary, // #384F47 — Figma 82:1785
    trackCardBorderEnd: Color(0xFF95CDBB), // Figma 82:1785
    trackRadioRing: Brand.greenPrimary, // #384F47 — Figma 82:1785
    backChipFill: Color(0xFFFCFBF9), // Figma 90:208
    backChipGlyph: Color(0xFF4B675E), // Figma 90:209
    profileRowBorder: Color(0xFF7070A0), // Figma 170:4790
    profileStatLabel: Brand.greenPrimary, // #384F47 — Figma 661:8572
    profileStatValue: Color(0xFF7070A0), // Figma 661:8573
    profileIconChip: Color(0xFFF4E6FF), // Figma 176:1186
    // Identical to dark ON PURPOSE — see the field doc.
    destructive: Color(0xFFEF4444), // Figma 176:1191
    dialogNote: Brand.purplePrimary, // #AE87E7 — Figma 180:4571
    elevationShadow: Color(0xFF000000), // the five frames' rgba(0,0,0,α)
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
    cardValue: Color(0xFFFCFBF9), // Figma 337:5342
    homeAccent: Brand.purplePrimary, // #AE87E7 — Figma 337:5350
    mutedText: Color(0xFFB3B3B3), // Figma 337:5346
    progressTrack: Color(0xFF2E2D32), // Figma 337:5350
    bellRing: Color(0xFF4B675E), // Figma 337:5330
    bellGlyph: Color(0xFFFCFBF9), // Figma 337:5330
    bellUnreadDot: Brand.purplePrimary, // #AE87E7 — Figma 337:5330
    catalogCardFill: Color(0xFF27282C), // Figma 337:5732
    catalogTrack: Color(0xFFECECEC), // Figma 337:5744
    sheetFill: Color(0x33232628), // rgba(35,38,40,0.2) — Figma 337:15643
    accentSoft: Color(0xFFAE87E7), // Figma 459:43886
    bodyMuted: Color(0xFFECECEC), // Figma 459:43877
    // Identical to light ON PURPOSE — a success badge must not follow the
    // green→purple accent flip. See the field doc above.
    successBadge: Color(0xFF22C55E),
    quizOptionFill: Color(0xFF27282C), // = dark catalogCardFill (no dark frame)
    quizOptionBorder: Color(
      0xFF4B675E,
    ), // Figma — kept in both, like the border above
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
    trackCardBorderStart: null, // Figma 337:15947 — no outline in dark
    trackCardBorderEnd: null,
    trackRadioRing: Color(0xFFFCFBF9), // Figma 337:15947
    backChipFill: Color(0xFF232428), // TODO(design) fallback — see field doc
    backChipGlyph: Color(0xFFFCFBF9), // TODO(design) fallback — see field doc
    profileRowBorder: Color(0xFF7070A0), // Figma — kept in both, like cardLabel
    profileStatLabel: Color(0xFFFCFBF9), // = dark legalText (no dark frame)
    profileStatValue: Color(0xFF7070A0), // Figma — kept in both
    profileIconChip: Color(0xFF3E3E3E), // = navCentreIdleFill (no dark frame)
    // Identical to light ON PURPOSE — see the field doc.
    destructive: Color(0xFFEF4444),
    dialogNote: Brand.purplePrimary, // #AE87E7 — same in both, like homeAccent
    elevationShadow: Color(0xFFFCFBF9), // TODO(design) derived — see field doc
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
    Color? cardValue,
    Color? homeAccent,
    Color? mutedText,
    Color? progressTrack,
    Color? bellRing,
    Color? bellGlyph,
    Color? bellUnreadDot,
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
    Color? trackCardBorderStart,
    Color? trackCardBorderEnd,
    Color? trackRadioRing,
    Color? backChipFill,
    Color? backChipGlyph,
    Color? profileRowBorder,
    Color? profileStatLabel,
    Color? profileStatValue,
    Color? profileIconChip,
    Color? destructive,
    Color? dialogNote,
    Color? elevationShadow,
  }) {
    return AppColors(
      background: background ?? this.background,
      fieldFill: fieldFill ?? this.fieldFill,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hint: hint ?? this.hint,
      link: link ?? this.link,
      secondaryButtonBorder:
          secondaryButtonBorder ?? this.secondaryButtonBorder,
      legalText: legalText ?? this.legalText,
      cardFill: cardFill ?? this.cardFill,
      cardLabel: cardLabel ?? this.cardLabel,
      cardValue: cardValue ?? this.cardValue,
      homeAccent: homeAccent ?? this.homeAccent,
      mutedText: mutedText ?? this.mutedText,
      progressTrack: progressTrack ?? this.progressTrack,
      bellRing: bellRing ?? this.bellRing,
      bellGlyph: bellGlyph ?? this.bellGlyph,
      bellUnreadDot: bellUnreadDot ?? this.bellUnreadDot,
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
      trackCardBorderStart: trackCardBorderStart ?? this.trackCardBorderStart,
      trackCardBorderEnd: trackCardBorderEnd ?? this.trackCardBorderEnd,
      trackRadioRing: trackRadioRing ?? this.trackRadioRing,
      backChipFill: backChipFill ?? this.backChipFill,
      backChipGlyph: backChipGlyph ?? this.backChipGlyph,
      profileRowBorder: profileRowBorder ?? this.profileRowBorder,
      profileStatLabel: profileStatLabel ?? this.profileStatLabel,
      profileStatValue: profileStatValue ?? this.profileStatValue,
      profileIconChip: profileIconChip ?? this.profileIconChip,
      destructive: destructive ?? this.destructive,
      dialogNote: dialogNote ?? this.dialogNote,
      elevationShadow: elevationShadow ?? this.elevationShadow,
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
      secondaryButtonBorder: Color.lerp(
        secondaryButtonBorder,
        other.secondaryButtonBorder,
        t,
      )!,
      legalText: Color.lerp(legalText, other.legalText, t)!,
      cardFill: Color.lerp(cardFill, other.cardFill, t)!,
      cardLabel: Color.lerp(cardLabel, other.cardLabel, t)!,
      cardValue: Color.lerp(cardValue, other.cardValue, t)!,
      // Identical endpoints — Home's accent does not move across a theme
      // animation, which is the exemption made visible.
      homeAccent: Color.lerp(homeAccent, other.homeAccent, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      bellRing: Color.lerp(bellRing, other.bellRing, t)!,
      bellGlyph: Color.lerp(bellGlyph, other.bellGlyph, t)!,
      bellUnreadDot: Color.lerp(bellUnreadDot, other.bellUnreadDot, t)!,
      catalogCardFill: Color.lerp(catalogCardFill, other.catalogCardFill, t)!,
      catalogTrack: Color.lerp(catalogTrack, other.catalogTrack, t)!,
      sheetFill: Color.lerp(sheetFill, other.sheetFill, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      bodyMuted: Color.lerp(bodyMuted, other.bodyMuted, t)!,
      // Lerps between two identical values — i.e. stays put across a theme
      // animation, which is the whole point.
      successBadge: Color.lerp(successBadge, other.successBadge, t)!,
      quizOptionFill: Color.lerp(quizOptionFill, other.quizOptionFill, t)!,
      quizOptionBorder: Color.lerp(
        quizOptionBorder,
        other.quizOptionBorder,
        t,
      )!,
      quizDivider: Color.lerp(quizDivider, other.quizDivider, t)!,
      // Same as successBadge: identical endpoints, so these stay put across a
      // theme animation.
      quizCorrectFill: Color.lerp(quizCorrectFill, other.quizCorrectFill, t)!,
      quizCorrectBorder: Color.lerp(
        quizCorrectBorder,
        other.quizCorrectBorder,
        t,
      )!,
      quizWrongFill: Color.lerp(quizWrongFill, other.quizWrongFill, t)!,
      quizWrongBorder: Color.lerp(quizWrongBorder, other.quizWrongBorder, t)!,
      quizWrongBadge: Color.lerp(quizWrongBadge, other.quizWrongBadge, t)!,
      quizExplanationBody: Color.lerp(
        quizExplanationBody,
        other.quizExplanationBody,
        t,
      )!,
      navBarFill: Color.lerp(navBarFill, other.navBarFill, t)!,
      navAccent: Color.lerp(navAccent, other.navAccent, t)!,
      navCentreIdleFill: Color.lerp(
        navCentreIdleFill,
        other.navCentreIdleFill,
        t,
      )!,
      navCentreGlyphOn: Color.lerp(
        navCentreGlyphOn,
        other.navCentreGlyphOn,
        t,
      )!,
      navShadow: Color.lerp(navShadow, other.navShadow, t)!,
      // Nullable on purpose — Color.lerp fades to/from transparent when one end
      // is null, which is exactly right for a border that only exists in light.
      languagePillBorder: Color.lerp(
        languagePillBorder,
        other.languagePillBorder,
        t,
      ),
      languagePillContent: Color.lerp(
        languagePillContent,
        other.languagePillContent,
        t,
      )!,
      // Nullable for the same reason as languagePillBorder — light-only border.
      trackCardBorderStart: Color.lerp(
        trackCardBorderStart,
        other.trackCardBorderStart,
        t,
      ),
      trackCardBorderEnd: Color.lerp(
        trackCardBorderEnd,
        other.trackCardBorderEnd,
        t,
      ),
      trackRadioRing: Color.lerp(trackRadioRing, other.trackRadioRing, t)!,
      backChipFill: Color.lerp(backChipFill, other.backChipFill, t)!,
      backChipGlyph: Color.lerp(backChipGlyph, other.backChipGlyph, t)!,
      profileRowBorder: Color.lerp(
        profileRowBorder,
        other.profileRowBorder,
        t,
      )!,
      profileStatLabel: Color.lerp(
        profileStatLabel,
        other.profileStatLabel,
        t,
      )!,
      profileStatValue: Color.lerp(
        profileStatValue,
        other.profileStatValue,
        t,
      )!,
      profileIconChip: Color.lerp(profileIconChip, other.profileIconChip, t)!,
      // Identical endpoints — destructive does not move across a theme
      // animation, which is the exemption made visible (as with successBadge).
      destructive: Color.lerp(destructive, other.destructive, t)!,
      dialogNote: Color.lerp(dialogNote, other.dialogNote, t)!,
      // Black → cream is the widest travel of any token here, so a theme
      // animation passes through a mid grey. Correct: the shadow fades out as
      // the canvas darkens and fades back in as a rim light.
      elevationShadow: Color.lerp(elevationShadow, other.elevationShadow, t)!,
    );
  }
}
