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
    required this.catalogTrack,
    required this.sheetFill,
    required this.onboardingIllustrationMask,
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
    required this.quizReviewRowContent,
    required this.quizReviewFilterFill,
    required this.quizReviewFilterLabel,
    required this.mistakesCardFill,
    required this.mistakesContent,
    required this.mistakesCount,
    required this.mistakesRowBorder,
    required this.mistakesRowFill,
    required this.mistakesBadgeFill,
    required this.navBarFill,
    required this.navAccent,
    required this.navCentreIdleFill,
    required this.navCentreGlyphOn,
    required this.languagePillBorder,
    required this.languagePillContent,
    required this.trackCardBorderStart,
    required this.trackCardBorderEnd,
    required this.trackRadioRing,
    required this.backChipGlyph,
    required this.profileRowBorder,
    required this.profileStatLabel,
    required this.profileStatValue,
    required this.profileIconChip,
    required this.destructive,
    required this.dialogNote,
    required this.elevationShadow,
    required this.podiumAccent,
    required this.podiumOnAccent,
    required this.podiumFirstRing,
    required this.podiumSecondRing,
    required this.podiumThirdRing,
    required this.podiumBadgeIdle,
    required this.backChipSurfaceFill,
    required this.registrationBackChipFill,
    required this.languagePillFill,
    required this.homeBellFill,
    required this.dailyTasksFill,
    required this.dailyTasksBorder,
    required this.topStudentFill,
    required this.topStudentTopBorder,
    required this.continueLearningFillSchool,
    required this.continueLearningFillUniversity,
    required this.subjectSearchFill,
    required this.subjectSearchTopBorder,
    required this.subjectCardFill,
    required this.mistakesPillFill,
    required this.mistakesPillAccent,
    required this.treeRowFill,
    required this.treeRowBorder,
    required this.treeRowBadgeFill,
    required this.pillTrackFill,
    required this.pillTrackSelectedFill,
    required this.pillTrackLabel,
    required this.pillTrackSelectedLabel,
    required this.continueLearningContent,
    required this.aiPanelOuterFill,
    required this.aiPanelOuterBorder,
    required this.aiPanelCardFill,
    required this.quizPrevButtonFill,
    required this.quizQuestionCardBorder,
    required this.quizOptionTileBorder,
    required this.resultCardFill,
    required this.resultStarDiscFill,
    required this.reviewFilterIdleFill,
    required this.scopeTrackFill,
    required this.scopeSelectedFill,
    required this.leaderboardRowFill,
    required this.profileHeaderFill,
    required this.profileEditChipFill,
    required this.profileStatFill,
    required this.profileMenuRowFill,
    required this.profileMenuRowBorder,
    required this.profileMenuIconDiscFill,
    required this.avatarBadgeFill,
    required this.settingsSectionFill,
    required this.settingsSectionBorder,
    required this.otpTimerFill,
    required this.otpCardFill,
    required this.otpCardGlow,
    required this.otpDigitFill,
    required this.otpDigitBorder,
    required this.trackCardFill,
    required this.backlight,
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

  /// The opaque strip Figma slides between the onboarding illustration and the
  /// sheet - **`null` in light, and that is the design**, not a gap.
  ///
  /// The dark frame draws `Rectangle 6429` (`337:19256`), a 622x138 rect at
  /// (-140, 540) filled `#232428` at 100% - the page background, read from the
  /// Properties panel of the signed-in desktop app on 2026-09-18. It sits ABOVE
  /// `image 79 [Vectorized]` and BELOW the sheet, starting 11pt below the
  /// sheet's top edge, so only that top 11pt of illustration is ever seen
  /// through the frost.
  ///
  /// The light frame (`81:92`) has **no equivalent node** - its three children
  /// are the sheet, the illustration and the status bar. Its illustration
  /// (419x682 at (-19, -39)) runs to y 643 against a sheet top of y 529, so
  /// light frosts 114pt of artwork through the sheet where dark frosts 11. The
  /// two canvases really do differ here; a light strip would be invented.
  final Color? onboardingIllustrationMask;

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
  /// Figma light `#FCFBF9`; dark is the same opaque `#27282C` the subject card
  /// and the tree rows use — it had no dark frame of its own to read.
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

  // --- Quiz Review tokens (Figma 162:2377 light · 337:6705 dark) -----------
  //
  // The review rows themselves add NOTHING here: they reuse the five semantic
  // correct/wrong tokens above unchanged, which is the whole point of those
  // being canvas-independent. The dark frame draws the rows at 20% alpha
  // instead; that was decided against, because a correctness signal must not
  // change with the canvas (see the note above [quizOptionFill]). Logged as
  // docs/DESIGN_ISSUES.md #53.

  /// Foreground of a **correct** review row — its question text (`162:2510`)
  /// and "QUESTION n" label. Figma-verbatim `#384F47`, and **identical in both
  /// palettes on purpose**.
  ///
  /// The reason is the fill it sits on. [quizCorrectFill] is opaque `#BFFFC3`
  /// in BOTH canvases (a correctness signal must not follow the theme — see the
  /// note above [quizOptionFill]), so a foreground that DID follow the theme
  /// would put cream on mint in dark: measured **1.11:1**, which is not dim, it
  /// is gone. A fill that never changes needs a foreground that never changes.
  ///
  /// This is why the wrong and skipped rows deliberately do NOT use this token:
  /// [quizWrongFill] is 30% alpha and [quizOptionFill] follows the canvas, so
  /// those two composite differently per theme and take [textPrimary], which
  /// flips with them. Logged as docs/DESIGN_ISSUES.md #54.
  final Color quizReviewRowContent;

  /// Label on the SELECTED filter chip, over [quizReviewFilterFill].
  ///
  /// Not `colorScheme.onPrimary`: that is `#FCFBF9` in both themes, which is
  /// right on the light chip's `#4B675E` (5.97:1) and wrong on the dark chip's
  /// `#AE87E7` (**2.74:1**). The dark frame specifies no label colour, so — the
  /// convention the Learn tokens set — dark reuses an approved dark value, the
  /// `#232428` page fill, for 5.48:1. Logged as docs/DESIGN_ISSUES.md #54.

  /// The SELECTED filter chip's fill — "All (n)" (`162:2780` light,
  /// `337:6825` dark). Both canvases are Figma-verbatim.
  ///
  /// Numerically equal to [navAccent], and kept separate for the reason the
  /// rest of this file keeps such pairs apart: restyling the bottom nav must
  /// not silently restyle a quiz filter. The unselected chips need no token —
  /// they are [quizOptionFill] over [elevationShadow].
  final Color quizReviewFilterFill;

  final Color quizReviewFilterLabel;

  // --- Mistakes tokens (Figma 404:6292 / 404:6539 light · 404:7428 dark) ----
  //
  // 🔴 CORRECTED 2026-09-12. These tokens first shipped IDENTICAL in both
  // palettes, on the belief that the dark overview `404:7428` drew "the same
  // pink cards and red counts" on `#232428`. That belief was an observation,
  // never a measurement - the dark hexes had not been read - and it was
  // wrong: the dark family draws dark cards with cream text. The ratios taken
  // on the pink premise (11.06 / 6.30 / 2.68 in dark) were correct arithmetic
  // about a surface the dark design does not have. docs/DESIGN_ISSUES.md #70
  // keeps that history; do not re-derive it.
  //
  // Every dark value below is now read off a Properties panel in the dark
  // family - both overviews and the Units, Chapters, Lessons and Lectures rows
  // all agree - and every light value is unchanged. Two tokens are new
  // because dark separates what light had merged: the card and the row share
  // `#EAD5D5` in light but NOT in dark (a 30% wash against an opaque fill),
  // and the badge disc has a measured dark fill of its own.
  //
  // What still holds from the first version: these surfaces take their
  // foreground from THIS palette, never [textPrimary]. In light, the pink
  // needs the green.

  /// The overview card's ground - `404:6322` light, `404:7637` dark.
  ///
  /// Light `#EAD5D5`. Dark `#27282C` at **30%**, a wash rather than an opaque
  /// fill: over the `#232428` canvas it composites to `#242529`, **1.01:1**
  /// against the page, so in dark the card is delineated by its shadow, not by
  /// a colour step. That is the frame's own value, not a defect to correct.
  final Color mistakesCardFill;

  /// The tree row's ground - `404:6642` light, `404:7765` dark.
  ///
  /// Light `#EAD5D5`, the same value as [mistakesCardFill], which is why the
  /// first build used one token for both. Dark `#27282C`, OPAQUE, where the
  /// card is a 30% wash - the two surfaces diverge in dark, so they cannot
  /// share a token. The row is delineated by [mistakesRowBorder].
  final Color mistakesRowFill;

  /// Foreground on both Mistakes surfaces: card title, row name, badge numeral
  /// and both chevrons.
  ///
  /// Light `#384F47` (card title `404:6329`; the row-name frame `404:6648`
  /// says `#000000`, mapped to this per docs/DESIGN_ISSUES.md #57 and #68).
  /// Dark `#FCFBF9`, read off the row name `404:7771` and the numeral
  /// `404:7768`; the card title and both chevrons carry the same value.
  /// Measured **14.24:1** on the dark row and **14.80:1** on the dark card.
  ///
  /// Numerically equal to [quizReviewRowContent] in light and to [textPrimary]
  /// in dark, and kept separate for the reason this file keeps every such pair
  /// apart: restyling one surface must not silently restyle the Mistakes flow.
  final Color mistakesContent;

  /// The count caption - "20 questions" in the frames, MISTAKES in the build.
  /// `#EF4444` in both palettes: light `404:6338`, dark `404:7884`. This one
  /// genuinely does not change; it was read in both, not carried across.
  ///
  /// ⚠️ **Fails WCAG AA (4.5:1) for a 14px caption in BOTH palettes, on
  /// different grounds:** **2.68:1** on the light pink, **3.91:1** on the dark
  /// row, **4.07:1** on the dark card. Recorded rather than corrected:
  /// darkening the red would be inventing a token the designer did not supply.
  /// docs/DESIGN_ISSUES.md #71 carries it to the designer.
  ///
  /// Numerically equal to [destructive] and [quizWrongBadge]; separate because
  /// a count of outstanding mistakes is neither a destructive action nor a
  /// wrong-answer badge.
  final Color mistakesCount;

  /// The tree row's 0.5px inner hairline - `404:6642` light, `404:7765` dark.
  /// Light `#4B675E`, dark `#FCFBF9`. It carries no text.
  ///
  /// Deliberately NOT [fieldBorder], which the catalog's `TreeListRow` uses:
  /// its light value `#D1D1D1` would vanish against the pink.
  final Color mistakesRowBorder;

  /// The 40dp numbered disc on a Mistakes row.
  ///
  /// Dark `#27282C` at **20%**, `404:7767`. On the opaque `#27282C` row that
  /// composites to the row colour itself, so in dark the disc is not a colour
  /// step; the frame also gives it one effect whose type a view seat did not
  /// expose (docs/DESIGN_ISSUES.md #70). The numeral on it measures 14.24:1.
  ///
  /// Light: the light frames' disc colour was never read, so this carries the
  /// value the badge has always shipped with there - light [cardFill],
  /// `#FDFDFD` - rather than a new unmeasured one. Light rendering does not
  /// change.
  final Color mistakesBadgeFill;

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

  // --- Language pill (Figma 82:1093 light · 337:19693 dark) -----------------

  /// The pill's outline — **`null` in dark, and that is the design**, not a
  /// missing value: the dark frame (`340:19734`) draws the pill as `#232428`
  /// at **20% alpha** under Glass G3 and with no outline at all — the rim
  /// light, not a border, is what gives it an edge. All seven dark instances
  /// read the same way. Widgets must skip the border when this is null rather
  /// than substituting one. (This supersedes the older note that the pill was
  /// "#232428 on #232428", which described an opaque fill.)
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

  /// **SUPERSEDED 2026-09-17 (owner ruling, edit1.md #34). Frozen; do not use
  /// in new code.** Reach for an `AppElevation` token instead.
  ///
  /// The dark value here is a *derivation*, and the premise it rested on was
  /// wrong. It read "there is no dark frame for any of the five components, so
  /// black cannot be verified and cream is the defensible stand-in". The dark
  /// frames **do** exist, and thirteen of them were measured on 2026-09-17:
  /// the subject card (`337:5732`), the profile stat card (`661:8579`), the
  /// profile header (`337:7455`), the Mistakes card (`404:7637`), the AI panel
  /// wrapper (`337:9278`), the pool card, the primary CTA, the onboarding
  /// sheet, the avatar badge and more. **Every one of them is black at the
  /// light alpha.** No dark node in the file has a cream or white DROP shadow;
  /// cream and lavender appear only as INNER shadows and as glows.
  ///
  /// What the dark canvas actually does instead is elevate *upward* by a
  /// different mechanism — Figma's Glass effect over a 20%-alpha fill, plus a
  /// lavender back-light — which is why the black shadow reads correctly there
  /// rather than disappearing. That mechanism is now
  /// `lib/core/theme/app_elevation.dart` and the primitives in
  /// `lib/core/widgets/elevation/`. See docs/DESIGN_ISSUES.md #47 (superseded)
  /// and #72, and docs/DECISIONS.md D-009.
  ///
  /// **Why the value is still cream.** Flipping it to black here, alone, would
  /// darken the components that still paint an unclipped `BoxShadow`
  /// *underneath* a translucent fill — the shadow shows through the 20% wash
  /// until the component moves onto `ElevatedSurface`, which knocks it out.
  /// So each call site switches to the measured black in the edit that
  /// migrates it, not before:
  ///
  /// | Call site | Owner |
  /// | --- | --- |
  /// | `lib/features/onboarding/screens/onboarding_screen.dart` | edit2 |
  /// | `lib/features/mistakes/widgets/mistakes_subject_card.dart` | edit3 |
  /// | `lib/features/quiz/screens/quiz_review_screen.dart` | edit4 |
  /// | `lib/features/quiz/widgets/ai_explanation_panel.dart` | edit4 |
  /// | `lib/features/auth/screens/otp_screen.dart` | edit5 |
  /// | `lib/features/profile/screens/edit_profile_screen.dart` | edit5 |
  /// | `lib/features/profile/widgets/profile_header_card.dart` | edit5 |
  /// | `lib/features/profile/widgets/profile_stat_card.dart` | edit5 |
  ///
  /// **Whoever removes the LAST reference deletes this field** — both values,
  /// its `copyWith` and `lerp` lines, and the `elevationShadow` group in
  /// `test/core/theme/palette_discipline_test.dart`, which pins the behaviour
  /// this comment supersedes.
  ///
  /// Historical note, kept because it is the reasoning the ruling overturned:
  /// the token carries no alpha, because the five original shadows were
  /// measured at two depths (0.15 for the onboarding sheet, 0.25 for the rest)
  /// and depth belongs to the component. `AppElevation` keeps that split, but
  /// puts the alpha in the token where the frame put it.
  ///
  /// `navShadow` used to sit beside it with the same disclaimer and is now
  /// gone: edit2 replaced it with `AppElevation.navBarShadows`, which has both
  /// canvases measured (DESIGN_ISSUES #37, open question 2 — resolved).
  final Color elevationShadow;

  // --- Leaderboard tokens ----------------------------------------------------
  //
  // Read from the frames themselves (Figma `133:3117` school-light,
  // `134:3626` uni-light) via the Inspect panel — NOT eyeballed off a
  // screenshot. The first version of this block was, and every value in it was
  // wrong; the node ids are recorded per token so the next person can re-read
  // them instead of re-guessing.
  //
  // A dark frame DOES exist (`337:5528`) and has not been measured yet, so the
  // dark values below are the light ones carried across. For the three ring
  // colours and the badge that is defensible on its own terms — see the note on
  // [podiumFirstRing] — but it is an assumption, not a reading.

  /// The board's selection colour: the active segment of the scope switcher
  /// (`158:840`) and the fill behind the caller's own row (`134:3554`). The
  /// frame uses ONE value for both, which is why this is one token.
  ///
  /// **Identical in both palettes, deliberately** — same reasoning as
  /// [successBadge] and [dialogNote]: "this row is you" is a semantic
  /// highlight, and it must not flip colour with the theme.
  final Color podiumAccent;

  /// Foreground on [podiumAccent] — the selected segment's label (`158:841`).
  ///
  /// `#FCFBF9`, not white: it is the file's standard cream, already this
  /// palette's [background], dark [textPrimary], [legalText] and [navBarFill].
  final Color podiumOnAccent;

  /// The winner's avatar ring (`134:3418`, 5.23px inner) and the fill of their
  /// rank badge (`134:3429`).
  ///
  /// The three podium rings are gold / orange / grey — a medal order, not a
  /// theme accent. **Identical in both palettes for the reason spelled out on
  /// [successBadge]:** first place is first place on either canvas, and a
  /// medal that flips colour with the theme is a bug, not a feature.
  final Color podiumFirstRing;

  /// Second place's avatar ring (`134:3497`, 3px inner). See [podiumFirstRing].
  final Color podiumSecondRing;

  /// Third place's avatar ring (`134:3468`, 2px inner). See [podiumFirstRing].
  final Color podiumThirdRing;

  /// Fill of the rank badge for second and third place (`134:3426`) — the
  /// winner's badge takes [podiumFirstRing] instead.
  final Color podiumBadgeIdle;

  // --- Elevation-pass surfaces (edit1.md section 8.1, read 2026-09-16/17) ---
  //
  // The 2026-09-16 Figma elevation audit re-read every raised surface in the
  // file on BOTH canvases, so — unlike the Home/Learn/quiz blocks above — these
  // dark values are measured, not carried across. Most are the same neutral at
  // 20% alpha: dark elevation in this design is a translucent wash under a
  // Glass effect (see [AppElevation]), not an opaque card.
  //
  // Every token here is NEW. No existing value moved in the edit that added
  // them, so nothing on screen changed when they landed; each is consumed by
  // the later edit named against it in edit1.md section 8.1.

  /// The circular back chip's surface. `90:208` light · `404:7424` dark.
  ///
  /// It superseded `backChipFill`, whose dark `#232428` was a TODO(design)
  /// fallback rather than a reading; that token was deleted by edit2, which
  /// moved `CircleBackButton` — its last consumer — onto this one.
  final Color backChipSurfaceFill;

  /// The registration flow's back chip — a DIFFERENT neutral from every other
  /// back chip, `#333439` rather than `#27282C`. `337:19690`.
  final Color registrationBackChipFill;

  /// The language pill's surface. `82:1093` / `340:19734`. The pill used to
  /// paint [background], which is why it vanished into the page in dark.
  final Color languagePillFill;

  /// The Home header bell chip. `59:1466` / `337:5330`.
  final Color homeBellFill;

  /// The Home "Daily Tasks" block. `308:4305` / `337:5357`. Its dark neutral
  /// `#242329` is one digit off the page fill and is kept verbatim.
  final Color dailyTasksFill;

  /// Daily Tasks' hairline — light only; the dark frame hides the stroke.
  /// Width in `AppElevation.dailyTasksBorderWidth`.
  final Color? dailyTasksBorder;

  /// The Home "Top Student" block. `59:2090` / `337:5460`. Pure white in
  /// light, which is why it is not [cardFill].
  final Color topStudentFill;

  /// Top Student's TOP-only hairline — a 10%-alpha violet, the same on both
  /// canvases. `59:2090` / `337:5460`.
  final Color topStudentTopBorder;

  /// Home "Continue Learning", school track.
  final Color continueLearningFillSchool;

  /// Home "Continue Learning", university track. Identical on both canvases —
  /// the university frame draws one colour.
  final Color continueLearningFillUniversity;

  /// The Subjects search field. `135:610` / `337:5724`.
  final Color subjectSearchFill;

  /// The search field's TOP-only hairline — light only. `135:610`.
  final Color? subjectSearchTopBorder;

  /// The subject card. `135:618` / `337:5732`. Light is pure `#FFFFFF`, not
  /// the cream — which is why it replaced the shared `catalogCardFill` the card
  /// used to borrow, and why that token no longer exists: its last three
  /// consumers each turned out to have a frame value of their own (edit3.md
  /// §7.9.4).
  final Color subjectCardFill;

  /// The Mistakes pill in the Subjects header. `404:7421`.
  final Color mistakesPillFill;

  /// The Mistakes pill's label and hairline — the same red on both canvases.
  /// The pill used to read `colorScheme.error`, which is not this value.
  final Color mistakesPillAccent;

  /// A catalog / Mistakes drill-down row. `337:5926`.
  final Color treeRowFill;

  /// The drill-down row's hairline. Light was [fieldBorder] `#D1D1D1`; the
  /// frame says `#4B675E`, and dark says cream.
  final Color treeRowBorder;

  /// The index disc inside a drill-down row. `337:5926`.
  final Color treeRowBadgeFill;

  /// The segmented pill track (quiz-type tabs, Settings language) — ONE Figma
  /// component, two consumers. `180:5337` / `337:8177`.
  final Color pillTrackFill;

  /// The selected segment of that track. `#AE87E7` on both canvases.
  final Color pillTrackSelectedFill;

  /// An UNSELECTED segment's label. Light `180:5339` is a dark green, NOT the
  /// grey [textSecondary] the hand-rolled chips used to draw; dark `337:11091`
  /// is the cream. Both are Inter 500 / 14 with a 100% line height.
  final Color pillTrackLabel;

  /// The SELECTED segment's label — `#FCFBF9` on both canvases (`180:5341`,
  /// `337:11095`).
  ///
  /// It is the same value `colorScheme.onPrimary` carries, and it is still its
  /// own token: this one is a reading off `Frame 1000003007`, and the day the
  /// designer fixes the 2.74:1 contrast it fails against `#AE87E7`
  /// (DESIGN_ISSUES #77) it must move WITHOUT dragging every filled CTA in the
  /// app with it.
  final Color pillTrackSelectedLabel;

  /// Foreground on Home's Continue Learning card — `#2B2B2B` on both canvases
  /// and both tracks, read off all four frames (light school `308:4190`, dark
  /// school `337:5435`/`337:5436`, light university `309:5633`).
  ///
  /// A near-black on a lilac card, which is why it cannot be [mutedText]: that
  /// grey measures **1.00:1** against the dark school fill `#C4A8E3` — the same
  /// luminance, i.e. invisible — where this measures 6.78:1. See
  /// DESIGN_ISSUES #79.
  final Color continueLearningContent;

  /// The AI explanation panel's outer container. `159:1811` / `337:9270`.
  final Color aiPanelOuterFill;

  /// The AI panel's outer hairline — light only.
  final Color? aiPanelOuterBorder;

  /// The AI panel's inner explanation card. `159:1826` / `337:9279`.
  final Color aiPanelCardFill;

  /// The quiz previous-question button. Light is a 60% green wash.
  /// `337:6464` dark.
  final Color quizPrevButtonFill;

  /// The quiz question card's hairline. Width in
  /// `AppElevation.quizQuestionCardBorderWidth`. `337:6434`.
  final Color quizQuestionCardBorder;

  /// The quiz option tile's hairline. `337:6440`. Distinct from
  /// [quizOptionBorder], which is the A/B/C/D letter ring.
  final Color quizOptionTileBorder;

  /// The result screen's stat buckets and rewards card. `159:2289`,
  /// `159:2252` / `337:6667`, `337:6680`.
  final Color resultCardFill;

  /// The 33x33 star disc on the rewards card. `337:6685`.
  final Color resultStarDiscFill;

  /// An UNSELECTED review filter pill. `162:2782` / `337:6827`. The selected
  /// one keeps [quizReviewFilterFill].
  final Color reviewFilterIdleFill;

  /// The leaderboard scope toggle's track. `158:839` / `337:5615`.
  final Color scopeTrackFill;

  /// The scope toggle's selected segment. `158:840` / `337:5615`. The light
  /// value is the existing [podiumAccent] reading; a 2026-09-16 CSS export
  /// showed `#DBB0FF` instead, and edit4 re-reads `158:840` before consuming
  /// it. Recorded rather than silently picked.
  final Color scopeSelectedFill;

  /// A leaderboard row. `134:3538` / `337:5630`.
  final Color leaderboardRowFill;

  /// The Profile header card. `169:4609` / `337:7455`.
  final Color profileHeaderFill;

  /// The Profile edit pencil chip. `337:7466`.
  final Color profileEditChipFill;

  /// A Profile stat card. `661:8571` / `661:8579` — OPAQUE in dark, unlike
  /// most of this block.
  final Color profileStatFill;

  /// A Profile menu row. `170:4790` / `337:7479`.
  final Color profileMenuRowFill;

  /// The menu row's hairline — light only. The Logout row keeps
  /// [destructive] on both canvases.
  final Color? profileMenuRowBorder;

  /// The 35x35 icon disc inside a Profile menu row. `337:7480`.
  final Color profileMenuIconDiscFill;

  /// The Edit Profile avatar badge. `180:3989` / `337:7925`.
  final Color avatarBadgeFill;

  /// A Settings section card. `176:1840` / `642:8583`, `337:8195`.
  final Color settingsSectionFill;

  /// The Settings section's hairline — light only. It used to read
  /// [profileRowBorder] `#7070A0`; the frame says `#AE87E7`.
  final Color? settingsSectionBorder;

  /// The OTP resend-timer pill. `332:3391` / `337:19503`.
  final Color otpTimerFill;

  /// The OTP code card. `308:5114` / `337:19501`.
  final Color otpCardFill;

  /// The OTP card's lavender GLOW — dark only, and the colour of the one
  /// non-black drop shadow in the dark frames
  /// (`AppElevation.otpCardShadows`). `337:19501`.
  final Color? otpCardGlow;

  /// An OTP digit box. `Rectangle 104`–`107`.
  final Color otpDigitFill;

  /// The digit box's border — the same grey on both canvases; only the width
  /// changes (`AppElevation.otpDigitBorderWidth`).
  final Color otpDigitBorder;

  /// The sign-up track card. `125:862` / `337:15981`. Dark was opaque
  /// [background]; the frame is a 20% wash under Glass.
  final Color trackCardFill;

  /// The lavender back-light ellipse behind a dark glass surface — all
  /// sixteen of them, B1..B16. Same value on both canvases because no light
  /// frame has one; light simply passes no `Backlight`.
  final Color backlight;

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
    catalogTrack: Color(
      0xFFD1D1D1,
    ), // = light fieldBorder (no light Learn frame)
    sheetFill: Color(0x33FCFBF9), // rgba(252,251,249,0.2) — Figma 459:43873
    // No such node in the light frame 81:92 — see the field's doc comment.
    onboardingIllustrationMask: null,
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
    quizReviewRowContent: Brand.greenPrimary, // #384F47 — Figma 162:2510
    quizReviewFilterFill: Color(0xFF4B675E), // Figma 162:2780
    quizReviewFilterLabel: Color(0xFFFCFBF9), // Figma 162:2781
    mistakesCardFill: Color(0xFFEAD5D5), // Figma 404:6322
    mistakesContent: Brand.greenPrimary, // #384F47 — Figma 404:6329
    mistakesCount: Color(0xFFEF4444), // Figma 404:6338
    mistakesRowBorder: Color(0xFF4B675E), // Figma 404:6642
    mistakesRowFill: Color(0xFFEAD5D5), // Figma 404:6642
    // The light disc was never read: the value the badge always shipped
    // with (= light cardFill). See the field doc.
    mistakesBadgeFill: Color(0xFFFDFDFD),
    navBarFill: Color(0xFFFCFBF9), // Figma 59:1264
    navAccent: Color(0xFF4B675E), // Figma 59:1264 — NOT Brand.greenPrimary
    navCentreIdleFill: Color(0xFFF3F1F8), // Figma 59:1003
    navCentreGlyphOn: Color(0xFFFFFFFF), // Figma 59:1084 — white in both
    languagePillBorder: Color(0xFF4B675E), // Figma 82:1093
    languagePillContent: Brand.greenPrimary, // #384F47 — Figma 82:1098/82:1100
    trackCardBorderStart: Brand.greenPrimary, // #384F47 — Figma 82:1785
    trackCardBorderEnd: Color(0xFF95CDBB), // Figma 82:1785
    trackRadioRing: Brand.greenPrimary, // #384F47 — Figma 82:1785
    backChipGlyph: Color(0xFF4B675E), // Figma 90:209
    profileRowBorder: Color(0xFF7070A0), // Figma 170:4790
    profileStatLabel: Brand.greenPrimary, // #384F47 — Figma 661:8572
    profileStatValue: Color(0xFF7070A0), // Figma 661:8573
    profileIconChip: Color(0xFFF4E6FF), // Figma 176:1186
    // Identical to dark ON PURPOSE — see the field doc.
    destructive: Color(0xFFEF4444), // Figma 176:1191
    dialogNote: Brand.purplePrimary, // #AE87E7 — Figma 180:4571
    elevationShadow: Color(0xFF000000), // the five frames' rgba(0,0,0,α)
    podiumAccent: Color(0xFFD8B0FF), // Figma 158:840 / 134:3554
    podiumOnAccent: Color(0xFFFCFBF9), // Figma 158:841
    podiumFirstRing: Color(0xFFFFCA28), // Figma 134:3418 border / 134:3429
    podiumSecondRing: Color(0xFFFF8228), // Figma 134:3497 border
    podiumThirdRing: Color(0xFFDEDEDE), // Figma 134:3468 border
    podiumBadgeIdle: Color(0xFFF4F4F4), // Figma 134:3426
    // --- Elevation pass (edit1.md section 8.1) ---
    backChipSurfaceFill: Color(0xFFFCFBF9), // Figma 90:208
    registrationBackChipFill: Color(0xFFFCFBF9), // Figma 337:19690 twin
    languagePillFill: Color(0xFFFCFBF9), // Figma 82:1093
    homeBellFill: Color(0xFFFCFBF9), // Figma 59:1466
    dailyTasksFill: Color(0xFFFCFBF9), // Figma 308:4305
    dailyTasksBorder: Color(0xFF4B675E), // Figma 308:4305
    topStudentFill: Color(0xFFFFFFFF), // Figma 59:2090 — pure white
    topStudentTopBorder: Color.fromRGBO(124, 58, 237, 0.1), // Figma 59:2090
    continueLearningFillSchool: Color(0xFFF3E5FF), // school Home
    continueLearningFillUniversity: Color(0xFFDBB0FF), // university Home
    subjectSearchFill: Color(0xFFFCFBF9), // Figma 135:610
    subjectSearchTopBorder: Color(0xFFF3F4F6), // Figma 135:610
    subjectCardFill: Color(0xFFFFFFFF), // Figma 135:618 — pure white
    mistakesPillFill: Color(0xFFFCFBF9), // light Subjects header
    mistakesPillAccent: Color(0xFFEF4444), // Figma 404:7421 — same in both
    treeRowFill: Color(0xFFFCFBF9), // catalog Button rows
    treeRowBorder: Color(0xFF4B675E), // catalog Button rows
    treeRowBadgeFill: Color(0xFFF4E6FF), // catalog row disc
    pillTrackFill: Color(0xFFECECEC), // Figma 180:5337
    pillTrackSelectedFill: Brand.purplePrimary, // #AE87E7 — same in both
    pillTrackLabel: Color(0xFF384F47), // Figma 180:5339
    pillTrackSelectedLabel: Color(0xFFFCFBF9), // Figma 180:5341
    continueLearningContent: Color(0xFF2B2B2B), // Figma 308:4190
    aiPanelOuterFill: Color(0xFFFCFBF9), // Figma 159:1811
    aiPanelOuterBorder: Color(0xFF4B675E), // Figma 159:1811
    aiPanelCardFill: Color(0xFFFCFBF9), // Figma 159:1826
    quizPrevButtonFill: Color.fromRGBO(56, 79, 71, 0.6), // light Quiz chip
    quizQuestionCardBorder: Color(0xFF4B675E), // light Container
    quizOptionTileBorder: Color(0xFF4B675E), // light Button
    resultCardFill: Color(0xFFFCFBF9), // Figma 159:2289 / 159:2252
    resultStarDiscFill: Color(0xFFF8EFFC), // light Result disc
    reviewFilterIdleFill: Color(0xFFFCFBF9), // Figma 162:2782
    scopeTrackFill: Color(0xFFECECEC), // Figma 158:839
    scopeSelectedFill: Color(0xFFD8B0FF), // Figma 158:840 — see field doc
    leaderboardRowFill: Color(0xFFFFFFFF), // Figma 134:3538
    profileHeaderFill: Color(0xFFFCFBF9), // Figma 169:4609
    profileEditChipFill: Color(0xFFFCFBF9), // pencil chip in 166:4416
    profileStatFill: Color(0xFFFCFBF9), // Figma 661:8571
    profileMenuRowFill: Color(0xFFFCFBF9), // Figma 170:4790
    profileMenuRowBorder: Color(0xFF7070A0), // Figma 170:4790
    profileMenuIconDiscFill: Color(0xFFF4E6FF), // light menu rows
    avatarBadgeFill: Color(0xFFFCFBF9), // Figma 180:3989
    settingsSectionFill: Color(0xFFFCFBF9), // Figma 176:1840
    settingsSectionBorder: Brand.purplePrimary, // #AE87E7 — Figma 176:1840
    otpTimerFill: Color(0xFFFCFBF9), // Figma 332:3391
    otpCardFill: Color(0xFFFCFBF9), // Figma 308:5114
    otpCardGlow: null, // no glow in the light frame
    otpDigitFill: Color(0xFFFDFDFD), // Rectangle 104-107
    otpDigitBorder: Color(0xFFD1D1D1), // Rectangle 104-107 — same in both
    trackCardFill: Color(0xFFFCFBF9), // Figma 125:862
    backlight: Brand.purplePrimary, // #AE87E7 — B1..B16, dark frames only
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
    catalogTrack: Color(0xFFECECEC), // Figma 337:5744
    sheetFill: Color(0x33232628), // rgba(35,38,40,0.2) — Figma 337:15643
    // Figma 337:19256 `Rectangle 6429` — #232428 at 100%, i.e. [background].
    onboardingIllustrationMask: Color(0xFF232428),
    accentSoft: Color(0xFFAE87E7), // Figma 459:43886
    bodyMuted: Color(0xFFECECEC), // Figma 459:43877
    // Identical to light ON PURPOSE — a success badge must not follow the
    // green→purple accent flip. See the field doc above.
    successBadge: Color(0xFF22C55E),
    quizOptionFill: Color(0xFF27282C), // = the dark card fill (no dark frame)
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
    // Identical to light ON PURPOSE, like the five semantic tokens above: it
    // sits on quizCorrectFill, which does not flip either. See the field doc.
    quizReviewRowContent: Brand.greenPrimary,
    quizReviewFilterFill: Brand.purplePrimary, // #AE87E7 — Figma 337:6825
    // Dark counterpart unspecified in 337:6825 — the page fill, for contrast
    // on the purple chip. See the field doc.
    quizReviewFilterLabel: Color(0xFF232428),
    // Read off the dark Mistakes family on 2026-09-12 - NOT carried over from
    // light. The first version of this block carried all four light values
    // across on an unmeasured observation; see docs/DESIGN_ISSUES.md #70.
    mistakesCardFill: Color(0x4D27282C), // #27282C @ 30% — Figma 404:7637
    mistakesContent: Color(0xFFFCFBF9), // Figma 404:7771 / 404:7768
    mistakesCount: Color(0xFFEF4444), // Figma 404:7884
    mistakesRowBorder: Color(0xFFFCFBF9), // Figma 404:7765 (stroke)
    mistakesRowFill: Color(0xFF27282C), // Figma 404:7765 (fill)
    mistakesBadgeFill: Color(0x3327282C), // #27282C @ 20% — Figma 404:7767
    navBarFill: Color(0xFF212226), // Figma 348:6686 — NOT the #232428 page fill
    navAccent: Color(0xFFAE87E7), // Figma 348:6686
    navCentreIdleFill: Color(0xFF3E3E3E), // Figma 348:6686
    navCentreGlyphOn: Color(0xFFFFFFFF), // white in both canvases
    languagePillBorder: null, // Figma 337:19693 — no outline in dark
    languagePillContent: Color(0xFFFCFBF9), // Figma 337:19693
    trackCardBorderStart: null, // Figma 337:15947 — no outline in dark
    trackCardBorderEnd: null,
    trackRadioRing: Color(0xFFFCFBF9), // Figma 337:15947
    backChipGlyph: Color(0xFFFCFBF9), // TODO(design) fallback — see field doc
    profileRowBorder: Color(0xFF7070A0), // Figma — kept in both, like cardLabel
    profileStatLabel: Color(0xFFFCFBF9), // = dark legalText (no dark frame)
    profileStatValue: Color(0xFF7070A0), // Figma — kept in both
    profileIconChip: Color(0xFF3E3E3E), // = navCentreIdleFill (no dark frame)
    // Identical to light ON PURPOSE — see the field doc.
    destructive: Color(0xFFEF4444),
    dialogNote: Brand.purplePrimary, // #AE87E7 — same in both, like homeAccent
    elevationShadow: Color(0xFFFCFBF9), // TODO(design) derived — see field doc
    // Same in both palettes. The first four are semantic (selection, medal
    // order) and must not flip with the theme; the last two are light values
    // carried across because `337:5528` has not been measured yet.
    podiumAccent: Color(0xFFD8B0FF),
    podiumOnAccent: Color(0xFFFCFBF9),
    podiumFirstRing: Color(0xFFFFCA28),
    podiumSecondRing: Color(0xFFFF8228),
    podiumThirdRing: Color(0xFFDEDEDE),
    podiumBadgeIdle: Color(0xFFF4F4F4),
    // --- Elevation pass (edit1.md section 8.1) ---
    // Most of these are a neutral at 20% alpha: the dark canvas elevates with
    // a translucent wash under Glass, not with an opaque card.
    backChipSurfaceFill: Color(0x3327282C), // #27282C @20% — Figma 404:7424
    registrationBackChipFill: Color(0x33333439), // #333439 @20% — 337:19690
    languagePillFill: Color(0x33232428), // #232428 @20% — Figma 340:19734
    homeBellFill: Color(0x33232428), // #232428 @20% — Figma 337:5330
    dailyTasksFill: Color(0x33242329), // #242329 @20% — Figma 337:5357
    dailyTasksBorder: null, // Figma 337:5357 — the dark stroke is hidden
    topStudentFill: Color(0x3326272B), // #26272B @20% — Figma 337:5460
    topStudentTopBorder: Color.fromRGBO(124, 58, 237, 0.1), // Figma 337:5460
    continueLearningFillSchool: Color(0xFFC4A8E3), // school Home, dark
    continueLearningFillUniversity: Color(0xFFDBB0FF), // same as light
    subjectSearchFill: Color(0x33232428), // #232428 @20% — Figma 337:5724
    subjectSearchTopBorder: null, // no top hairline in the dark frame
    subjectCardFill: Color(0xFF27282C), // Figma 337:5732 — opaque
    mistakesPillFill: Color(0x33565656), // #565656 @20% — Figma 404:7421
    mistakesPillAccent: Color(0xFFEF4444), // Figma 404:7421
    treeRowFill: Color(0xFF27282C), // Figma 337:5926
    treeRowBorder: Color(0xFFFCFBF9), // Figma 337:5926
    treeRowBadgeFill: Color(0x3327282C), // #27282C @20% — Figma 337:5926
    pillTrackFill: Color(0xFF232429), // Figma 337:8177
    pillTrackSelectedFill: Brand.purplePrimary, // #AE87E7 — same in both
    pillTrackLabel: Color(0xFFFCFBF9), // Figma 337:11091
    pillTrackSelectedLabel: Color(0xFFFCFBF9), // Figma 337:11095
    continueLearningContent: Color(0xFF2B2B2B), // Figma 337:5435 — as light
    aiPanelOuterFill: Color(0x3327282C), // #27282C @20% — Figma 337:9270
    aiPanelOuterBorder: null, // no outer hairline in the dark frame
    aiPanelCardFill: Color(0x331A1A1A), // #1A1A1A @20% — Figma 337:9279
    quizPrevButtonFill: Color(0x3327282C), // #27282C @20% — Figma 337:6464
    quizQuestionCardBorder: Color.fromRGBO(174, 135, 231, 0.6), // 337:6434
    quizOptionTileBorder: Color.fromRGBO(174, 135, 231, 0.5), // 337:6440
    resultCardFill: Color(0x3327282C), // #27282C @20% — 337:6667, 337:6680
    resultStarDiscFill: Color(0x3327282C), // #27282C @20% — Figma 337:6685
    reviewFilterIdleFill: Color(0x3327282C), // #27282C @20% — Figma 337:6827
    scopeTrackFill: Color(0xFF232429), // Figma 337:5615
    scopeSelectedFill: Color(0xFFC4A8E3), // Figma 337:5615 segment
    leaderboardRowFill: Color(0x33232428), // #232428 @20% — Figma 337:5630
    profileHeaderFill: Color(0x3327282C), // #27282C @20% — Figma 337:7455
    profileEditChipFill: Color(0x33232428), // #232428 @20% — Figma 337:7466
    profileStatFill: Color(0xFF27282C), // Figma 661:8579 — opaque
    profileMenuRowFill: Color(0x3327282C), // #27282C @20% — Figma 337:7479
    profileMenuRowBorder: null, // Figma 337:7479 — no hairline in dark
    profileMenuIconDiscFill: Color(0x3327282C), // #27282C @20% — 337:7480
    avatarBadgeFill: Color(0x33FCFBF9), // #FCFBF9 @20% — Figma 337:7925
    settingsSectionFill: Color(0x3327282C), // #27282C @20% — Figma 337:8195
    settingsSectionBorder: null, // no hairline in the dark frame
    otpTimerFill: Color(0xFF232428), // Figma 337:19503
    otpCardFill: Color(0xFF232428), // Figma 337:19501
    otpCardGlow: Color.fromRGBO(174, 135, 231, 0.25), // Figma 337:19501
    otpDigitFill: Color(0x33232428), // #232428 @20% — Rectangle 104-107
    otpDigitBorder: Color(0xFFD1D1D1), // same in both canvases
    trackCardFill: Color(0x33232428), // #232428 @20% — Figma 337:15981
    backlight: Brand.purplePrimary, // #AE87E7 — B1..B16
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
    Color? catalogTrack,
    Color? sheetFill,
    Color? onboardingIllustrationMask,
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
    Color? quizReviewRowContent,
    Color? quizReviewFilterFill,
    Color? quizReviewFilterLabel,
    Color? mistakesCardFill,
    Color? mistakesContent,
    Color? mistakesCount,
    Color? mistakesRowBorder,
    Color? mistakesRowFill,
    Color? mistakesBadgeFill,
    Color? navBarFill,
    Color? navAccent,
    Color? navCentreIdleFill,
    Color? navCentreGlyphOn,
    Color? languagePillBorder,
    Color? languagePillContent,
    Color? trackCardBorderStart,
    Color? trackCardBorderEnd,
    Color? trackRadioRing,
    Color? backChipGlyph,
    Color? profileRowBorder,
    Color? profileStatLabel,
    Color? profileStatValue,
    Color? profileIconChip,
    Color? destructive,
    Color? dialogNote,
    Color? elevationShadow,
    Color? podiumAccent,
    Color? podiumOnAccent,
    Color? podiumFirstRing,
    Color? podiumSecondRing,
    Color? podiumThirdRing,
    Color? podiumBadgeIdle,
    Color? backChipSurfaceFill,
    Color? registrationBackChipFill,
    Color? languagePillFill,
    Color? homeBellFill,
    Color? dailyTasksFill,
    Color? dailyTasksBorder,
    Color? topStudentFill,
    Color? topStudentTopBorder,
    Color? continueLearningFillSchool,
    Color? continueLearningFillUniversity,
    Color? subjectSearchFill,
    Color? subjectSearchTopBorder,
    Color? subjectCardFill,
    Color? mistakesPillFill,
    Color? mistakesPillAccent,
    Color? treeRowFill,
    Color? treeRowBorder,
    Color? treeRowBadgeFill,
    Color? pillTrackFill,
    Color? pillTrackSelectedFill,
    Color? pillTrackLabel,
    Color? pillTrackSelectedLabel,
    Color? continueLearningContent,
    Color? aiPanelOuterFill,
    Color? aiPanelOuterBorder,
    Color? aiPanelCardFill,
    Color? quizPrevButtonFill,
    Color? quizQuestionCardBorder,
    Color? quizOptionTileBorder,
    Color? resultCardFill,
    Color? resultStarDiscFill,
    Color? reviewFilterIdleFill,
    Color? scopeTrackFill,
    Color? scopeSelectedFill,
    Color? leaderboardRowFill,
    Color? profileHeaderFill,
    Color? profileEditChipFill,
    Color? profileStatFill,
    Color? profileMenuRowFill,
    Color? profileMenuRowBorder,
    Color? profileMenuIconDiscFill,
    Color? avatarBadgeFill,
    Color? settingsSectionFill,
    Color? settingsSectionBorder,
    Color? otpTimerFill,
    Color? otpCardFill,
    Color? otpCardGlow,
    Color? otpDigitFill,
    Color? otpDigitBorder,
    Color? trackCardFill,
    Color? backlight,
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
      catalogTrack: catalogTrack ?? this.catalogTrack,
      sheetFill: sheetFill ?? this.sheetFill,
      // As with languagePillBorder, `??` cannot CLEAR this one; light takes
      // its null from the palette, not from a copyWith.
      onboardingIllustrationMask:
          onboardingIllustrationMask ?? this.onboardingIllustrationMask,
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
      quizReviewRowContent: quizReviewRowContent ?? this.quizReviewRowContent,
      quizReviewFilterFill: quizReviewFilterFill ?? this.quizReviewFilterFill,
      quizReviewFilterLabel:
          quizReviewFilterLabel ?? this.quizReviewFilterLabel,
      mistakesCardFill: mistakesCardFill ?? this.mistakesCardFill,
      mistakesContent: mistakesContent ?? this.mistakesContent,
      mistakesCount: mistakesCount ?? this.mistakesCount,
      mistakesRowBorder: mistakesRowBorder ?? this.mistakesRowBorder,
      mistakesRowFill: mistakesRowFill ?? this.mistakesRowFill,
      mistakesBadgeFill: mistakesBadgeFill ?? this.mistakesBadgeFill,
      navBarFill: navBarFill ?? this.navBarFill,
      navAccent: navAccent ?? this.navAccent,
      navCentreIdleFill: navCentreIdleFill ?? this.navCentreIdleFill,
      navCentreGlyphOn: navCentreGlyphOn ?? this.navCentreGlyphOn,
      // Note: `??` cannot CLEAR languagePillBorder — copyWith can only set one.
      // Dark gets its null from the palette itself, not from a copyWith.
      languagePillBorder: languagePillBorder ?? this.languagePillBorder,
      languagePillContent: languagePillContent ?? this.languagePillContent,
      trackCardBorderStart: trackCardBorderStart ?? this.trackCardBorderStart,
      trackCardBorderEnd: trackCardBorderEnd ?? this.trackCardBorderEnd,
      trackRadioRing: trackRadioRing ?? this.trackRadioRing,
      backChipGlyph: backChipGlyph ?? this.backChipGlyph,
      profileRowBorder: profileRowBorder ?? this.profileRowBorder,
      profileStatLabel: profileStatLabel ?? this.profileStatLabel,
      profileStatValue: profileStatValue ?? this.profileStatValue,
      profileIconChip: profileIconChip ?? this.profileIconChip,
      destructive: destructive ?? this.destructive,
      dialogNote: dialogNote ?? this.dialogNote,
      elevationShadow: elevationShadow ?? this.elevationShadow,
      podiumAccent: podiumAccent ?? this.podiumAccent,
      podiumOnAccent: podiumOnAccent ?? this.podiumOnAccent,
      podiumFirstRing: podiumFirstRing ?? this.podiumFirstRing,
      podiumSecondRing: podiumSecondRing ?? this.podiumSecondRing,
      podiumThirdRing: podiumThirdRing ?? this.podiumThirdRing,
      podiumBadgeIdle: podiumBadgeIdle ?? this.podiumBadgeIdle,
      backChipSurfaceFill: backChipSurfaceFill ?? this.backChipSurfaceFill,
      registrationBackChipFill:
          registrationBackChipFill ?? this.registrationBackChipFill,
      languagePillFill: languagePillFill ?? this.languagePillFill,
      homeBellFill: homeBellFill ?? this.homeBellFill,
      dailyTasksFill: dailyTasksFill ?? this.dailyTasksFill,
      // As with languagePillBorder above, `??` cannot CLEAR these light-only
      // borders — dark takes its nulls from the palette, not from a copyWith.
      dailyTasksBorder: dailyTasksBorder ?? this.dailyTasksBorder,
      topStudentFill: topStudentFill ?? this.topStudentFill,
      topStudentTopBorder: topStudentTopBorder ?? this.topStudentTopBorder,
      continueLearningFillSchool:
          continueLearningFillSchool ?? this.continueLearningFillSchool,
      continueLearningFillUniversity:
          continueLearningFillUniversity ?? this.continueLearningFillUniversity,
      subjectSearchFill: subjectSearchFill ?? this.subjectSearchFill,
      subjectSearchTopBorder:
          subjectSearchTopBorder ?? this.subjectSearchTopBorder,
      subjectCardFill: subjectCardFill ?? this.subjectCardFill,
      mistakesPillFill: mistakesPillFill ?? this.mistakesPillFill,
      mistakesPillAccent: mistakesPillAccent ?? this.mistakesPillAccent,
      treeRowFill: treeRowFill ?? this.treeRowFill,
      treeRowBorder: treeRowBorder ?? this.treeRowBorder,
      treeRowBadgeFill: treeRowBadgeFill ?? this.treeRowBadgeFill,
      pillTrackFill: pillTrackFill ?? this.pillTrackFill,
      pillTrackSelectedFill:
          pillTrackSelectedFill ?? this.pillTrackSelectedFill,
      pillTrackLabel: pillTrackLabel ?? this.pillTrackLabel,
      pillTrackSelectedLabel:
          pillTrackSelectedLabel ?? this.pillTrackSelectedLabel,
      continueLearningContent:
          continueLearningContent ?? this.continueLearningContent,
      aiPanelOuterFill: aiPanelOuterFill ?? this.aiPanelOuterFill,
      aiPanelOuterBorder: aiPanelOuterBorder ?? this.aiPanelOuterBorder,
      aiPanelCardFill: aiPanelCardFill ?? this.aiPanelCardFill,
      quizPrevButtonFill: quizPrevButtonFill ?? this.quizPrevButtonFill,
      quizQuestionCardBorder:
          quizQuestionCardBorder ?? this.quizQuestionCardBorder,
      quizOptionTileBorder: quizOptionTileBorder ?? this.quizOptionTileBorder,
      resultCardFill: resultCardFill ?? this.resultCardFill,
      resultStarDiscFill: resultStarDiscFill ?? this.resultStarDiscFill,
      reviewFilterIdleFill: reviewFilterIdleFill ?? this.reviewFilterIdleFill,
      scopeTrackFill: scopeTrackFill ?? this.scopeTrackFill,
      scopeSelectedFill: scopeSelectedFill ?? this.scopeSelectedFill,
      leaderboardRowFill: leaderboardRowFill ?? this.leaderboardRowFill,
      profileHeaderFill: profileHeaderFill ?? this.profileHeaderFill,
      profileEditChipFill: profileEditChipFill ?? this.profileEditChipFill,
      profileStatFill: profileStatFill ?? this.profileStatFill,
      profileMenuRowFill: profileMenuRowFill ?? this.profileMenuRowFill,
      profileMenuRowBorder: profileMenuRowBorder ?? this.profileMenuRowBorder,
      profileMenuIconDiscFill:
          profileMenuIconDiscFill ?? this.profileMenuIconDiscFill,
      avatarBadgeFill: avatarBadgeFill ?? this.avatarBadgeFill,
      settingsSectionFill: settingsSectionFill ?? this.settingsSectionFill,
      settingsSectionBorder:
          settingsSectionBorder ?? this.settingsSectionBorder,
      otpTimerFill: otpTimerFill ?? this.otpTimerFill,
      otpCardFill: otpCardFill ?? this.otpCardFill,
      otpCardGlow: otpCardGlow ?? this.otpCardGlow,
      otpDigitFill: otpDigitFill ?? this.otpDigitFill,
      otpDigitBorder: otpDigitBorder ?? this.otpDigitBorder,
      trackCardFill: trackCardFill ?? this.trackCardFill,
      backlight: backlight ?? this.backlight,
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
      catalogTrack: Color.lerp(catalogTrack, other.catalogTrack, t)!,
      sheetFill: Color.lerp(sheetFill, other.sheetFill, t)!,
      // Nullable like languagePillBorder, mirrored: Color.lerp fades the
      // DARK-only strip out to transparent on the way to light.
      onboardingIllustrationMask: Color.lerp(
        onboardingIllustrationMask,
        other.onboardingIllustrationMask,
        t,
      ),
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
      quizReviewRowContent: Color.lerp(
        quizReviewRowContent,
        other.quizReviewRowContent,
        t,
      )!,
      quizReviewFilterFill: Color.lerp(
        quizReviewFilterFill,
        other.quizReviewFilterFill,
        t,
      )!,
      quizReviewFilterLabel: Color.lerp(
        quizReviewFilterLabel,
        other.quizReviewFilterLabel,
        t,
      )!,
      mistakesCardFill: Color.lerp(
        mistakesCardFill,
        other.mistakesCardFill,
        t,
      )!,
      mistakesContent: Color.lerp(mistakesContent, other.mistakesContent, t)!,
      mistakesCount: Color.lerp(mistakesCount, other.mistakesCount, t)!,
      mistakesRowBorder: Color.lerp(
        mistakesRowBorder,
        other.mistakesRowBorder,
        t,
      )!,
      mistakesRowFill: Color.lerp(mistakesRowFill, other.mistakesRowFill, t)!,
      mistakesBadgeFill: Color.lerp(
        mistakesBadgeFill,
        other.mistakesBadgeFill,
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
      // Identical endpoints — the "this row is you" highlight does not move
      // across a theme change, for the reason on the field docs.
      podiumAccent: Color.lerp(podiumAccent, other.podiumAccent, t)!,
      podiumOnAccent: Color.lerp(podiumOnAccent, other.podiumOnAccent, t)!,
      podiumFirstRing: Color.lerp(podiumFirstRing, other.podiumFirstRing, t)!,
      podiumSecondRing: Color.lerp(
        podiumSecondRing,
        other.podiumSecondRing,
        t,
      )!,
      podiumThirdRing: Color.lerp(podiumThirdRing, other.podiumThirdRing, t)!,
      podiumBadgeIdle: Color.lerp(podiumBadgeIdle, other.podiumBadgeIdle, t)!,
      backChipSurfaceFill: Color.lerp(
        backChipSurfaceFill,
        other.backChipSurfaceFill,
        t,
      )!,
      registrationBackChipFill: Color.lerp(
        registrationBackChipFill,
        other.registrationBackChipFill,
        t,
      )!,
      languagePillFill: Color.lerp(
        languagePillFill,
        other.languagePillFill,
        t,
      )!,
      homeBellFill: Color.lerp(homeBellFill, other.homeBellFill, t)!,
      dailyTasksFill: Color.lerp(dailyTasksFill, other.dailyTasksFill, t)!,
      // Nullable, like languagePillBorder: Color.lerp fades a light-only
      // border out to transparent, which is what a vanishing stroke should do.
      dailyTasksBorder: Color.lerp(dailyTasksBorder, other.dailyTasksBorder, t),
      topStudentFill: Color.lerp(topStudentFill, other.topStudentFill, t)!,
      topStudentTopBorder: Color.lerp(
        topStudentTopBorder,
        other.topStudentTopBorder,
        t,
      )!,
      continueLearningFillSchool: Color.lerp(
        continueLearningFillSchool,
        other.continueLearningFillSchool,
        t,
      )!,
      continueLearningFillUniversity: Color.lerp(
        continueLearningFillUniversity,
        other.continueLearningFillUniversity,
        t,
      )!,
      subjectSearchFill: Color.lerp(
        subjectSearchFill,
        other.subjectSearchFill,
        t,
      )!,
      subjectSearchTopBorder: Color.lerp(
        subjectSearchTopBorder,
        other.subjectSearchTopBorder,
        t,
      ),
      subjectCardFill: Color.lerp(subjectCardFill, other.subjectCardFill, t)!,
      mistakesPillFill: Color.lerp(
        mistakesPillFill,
        other.mistakesPillFill,
        t,
      )!,
      mistakesPillAccent: Color.lerp(
        mistakesPillAccent,
        other.mistakesPillAccent,
        t,
      )!,
      treeRowFill: Color.lerp(treeRowFill, other.treeRowFill, t)!,
      treeRowBorder: Color.lerp(treeRowBorder, other.treeRowBorder, t)!,
      treeRowBadgeFill: Color.lerp(
        treeRowBadgeFill,
        other.treeRowBadgeFill,
        t,
      )!,
      pillTrackFill: Color.lerp(pillTrackFill, other.pillTrackFill, t)!,
      pillTrackSelectedFill: Color.lerp(
        pillTrackSelectedFill,
        other.pillTrackSelectedFill,
        t,
      )!,
      pillTrackLabel: Color.lerp(pillTrackLabel, other.pillTrackLabel, t)!,
      pillTrackSelectedLabel: Color.lerp(
        pillTrackSelectedLabel,
        other.pillTrackSelectedLabel,
        t,
      )!,
      continueLearningContent: Color.lerp(
        continueLearningContent,
        other.continueLearningContent,
        t,
      )!,
      aiPanelOuterFill: Color.lerp(
        aiPanelOuterFill,
        other.aiPanelOuterFill,
        t,
      )!,
      aiPanelOuterBorder: Color.lerp(
        aiPanelOuterBorder,
        other.aiPanelOuterBorder,
        t,
      ),
      aiPanelCardFill: Color.lerp(aiPanelCardFill, other.aiPanelCardFill, t)!,
      quizPrevButtonFill: Color.lerp(
        quizPrevButtonFill,
        other.quizPrevButtonFill,
        t,
      )!,
      quizQuestionCardBorder: Color.lerp(
        quizQuestionCardBorder,
        other.quizQuestionCardBorder,
        t,
      )!,
      quizOptionTileBorder: Color.lerp(
        quizOptionTileBorder,
        other.quizOptionTileBorder,
        t,
      )!,
      resultCardFill: Color.lerp(resultCardFill, other.resultCardFill, t)!,
      resultStarDiscFill: Color.lerp(
        resultStarDiscFill,
        other.resultStarDiscFill,
        t,
      )!,
      reviewFilterIdleFill: Color.lerp(
        reviewFilterIdleFill,
        other.reviewFilterIdleFill,
        t,
      )!,
      scopeTrackFill: Color.lerp(scopeTrackFill, other.scopeTrackFill, t)!,
      scopeSelectedFill: Color.lerp(
        scopeSelectedFill,
        other.scopeSelectedFill,
        t,
      )!,
      leaderboardRowFill: Color.lerp(
        leaderboardRowFill,
        other.leaderboardRowFill,
        t,
      )!,
      profileHeaderFill: Color.lerp(
        profileHeaderFill,
        other.profileHeaderFill,
        t,
      )!,
      profileEditChipFill: Color.lerp(
        profileEditChipFill,
        other.profileEditChipFill,
        t,
      )!,
      profileStatFill: Color.lerp(profileStatFill, other.profileStatFill, t)!,
      profileMenuRowFill: Color.lerp(
        profileMenuRowFill,
        other.profileMenuRowFill,
        t,
      )!,
      profileMenuRowBorder: Color.lerp(
        profileMenuRowBorder,
        other.profileMenuRowBorder,
        t,
      ),
      profileMenuIconDiscFill: Color.lerp(
        profileMenuIconDiscFill,
        other.profileMenuIconDiscFill,
        t,
      )!,
      avatarBadgeFill: Color.lerp(avatarBadgeFill, other.avatarBadgeFill, t)!,
      settingsSectionFill: Color.lerp(
        settingsSectionFill,
        other.settingsSectionFill,
        t,
      )!,
      settingsSectionBorder: Color.lerp(
        settingsSectionBorder,
        other.settingsSectionBorder,
        t,
      ),
      otpTimerFill: Color.lerp(otpTimerFill, other.otpTimerFill, t)!,
      otpCardFill: Color.lerp(otpCardFill, other.otpCardFill, t)!,
      // Dark-only, so this fades in from transparent rather than snapping.
      otpCardGlow: Color.lerp(otpCardGlow, other.otpCardGlow, t),
      otpDigitFill: Color.lerp(otpDigitFill, other.otpDigitFill, t)!,
      otpDigitBorder: Color.lerp(otpDigitBorder, other.otpDigitBorder, t)!,
      trackCardFill: Color.lerp(trackCardFill, other.trackCardFill, t)!,
      backlight: Color.lerp(backlight, other.backlight, t)!,
    );
  }
}
