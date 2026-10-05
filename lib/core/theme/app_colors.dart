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
    required this.quizSetupSubject,
    required this.quizSetupScope,
    required this.limitSheetTitle,
    required this.limitSheetClose,
    required this.quizHeaderGlyph,
    required this.quizHeaderRule,
    required this.quizProgressFill,
    required this.quizProgressCounter,
    required this.quizQuestionText,
    required this.aiPanelTitle,
    required this.quizResultTitle,
    required this.quizResultSubtitle,
    required this.resultRingFillFrom,
    required this.resultRingFillTo,
    required this.resultPercentText,
    required this.resultBucketLabel,
    required this.resultRewardsTitle,
    required this.resultStarGlyph,
    required this.resultPointsValue,
    required this.resultPointsUnit,
    required this.quizReviewTitle,
    required this.reviewFilterIdleLabel,
    required this.reviewRowLabel,
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
    required this.mistakesCardChevron,
    required this.mistakesRowChevron,
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
    required this.destructive,
    required this.dialogNote,
    required this.profileDialogClose,
    required this.avatarDiscInner,
    required this.avatarDiscOuter,
    required this.avatarBadgeGlyph,
    required this.avatarSheetHandle,
    required this.avatarSheetDivider,
    required this.settingsRowLabel,
    required this.settingsToggleOnTrack,
    required this.settingsToggleOffTrack,
    required this.settingsToggleKnob,
    required this.flashcardProgressFill,
    required this.flashcardCardFill,
    required this.flashcardCardText,
    required this.flashcardAgainFill,
    required this.flashcardAgainGlyph,
    required this.flashcardSetupPillFill,
    required this.flashcardSetupPillBorder,
    required this.flashcardSetupPillText,
    required this.flashcardSetupHelper,
    required this.flashcardGradeError,
    required this.podiumAccent,
    required this.podiumOnAccent,
    required this.podiumFirstRing,
    required this.podiumSecondRing,
    required this.podiumThirdRing,
    required this.podiumBadgeIdle,
    required this.podiumSecondBadgeBorder,
    required this.podiumThirdBadgeFill,
    required this.backChipSurfaceFill,
    required this.registrationBackChipFill,
    required this.languagePillFill,
    required this.brandLogo,
    required this.homeBellFill,
    required this.dailyTasksFill,
    required this.dailyTasksBorder,
    required this.topStudentFill,
    required this.topStudentBorder,
    required this.topStudentName,
    required this.topStudentPoints,
    required this.continueLearningFillSchool,
    required this.continueLearningFillUniversity,
    required this.subjectSearchFill,
    required this.subjectSearchTopBorder,
    required this.subjectCardFill,
    required this.subjectCardTitle,
    required this.subjectCardChevron,
    required this.subjectCardProgress,
    required this.mistakesPillFill,
    required this.mistakesPillAccent,
    required this.treeRowFill,
    required this.treeRowBorder,
    required this.treeRowBadgeFill,
    required this.treeRowChevron,
    required this.treeRowProgress,
    required this.pillTrackFill,
    required this.pillTrackSelectedFill,
    required this.pillTrackLabel,
    required this.pillTrackSelectedLabel,
    required this.continueLearningContent,
    required this.aiPanelOuterFill,
    required this.aiPanelOuterBorder,
    required this.aiPanelCardFill,
    required this.quizPrevButtonFill,
    required this.quizPrevButtonGlyph,
    required this.quizQuestionCardBorder,
    required this.quizOptionTileBorder,
    required this.quizOptionBadgeRing,
    required this.resultCardFill,
    required this.resultStarDiscFill,
    required this.reviewFilterIdleFill,
    required this.reviewRowCorrectFill,
    required this.reviewRowWrongFill,
    required this.reviewRowSkippedFill,
    required this.scopeTrackFill,
    required this.scopeIdleLabel,
    required this.scopeSelectedFill,
    required this.leaderboardRowFill,
    required this.leaderboardRowText,
    required this.profileHeaderFill,
    required this.profileEditChipFill,
    required this.profileStatFill,
    required this.profileMenuRowFill,
    required this.profileMenuRowBorder,
    required this.profileMenuEmphasisRowBorder,
    required this.profileMenuIconDiscFill,
    required this.profileEditChipGlyph,
    required this.avatarBadgeFill,
    required this.settingsSectionFill,
    required this.settingsSectionBorder,
    required this.otpTimerFill,
    required this.otpCardFill,
    required this.otpCardGlow,
    required this.otpDigitFill,
    required this.otpDigitBorder,
    required this.otpTimerContent,
    required this.otpErrorText,
    required this.otpDigitErrorBorder,
    required this.trackCardFill,
    required this.trackCardArtShadow,
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
  // Both canvases have a Subjects frame: light `134:3837` (school) and
  // `308:4521` (university, identical), dark `337:5702`. This note used to say
  // only the dark one existed, so the light values here reused approved light
  // tokens. API→UI Wave 07 read the light frames (2026-09-25).

  /// Unfilled track of the per-subject progress bar: `#ECECEC` on both
  /// canvases (`135:630` light, `337:5744` dark). Light carried `#D1D1D1`
  /// ([fieldBorder]) until Wave 07. The inverse of [progressTrack] on Home in
  /// dark; kept separate so correcting one bar never silently restyles the
  /// other.
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

  /// The rule under the setup screen's scope header. Figma light `#CCD5D2`
  /// (`146:2287`); dark `rgba(204,213,210,0.2)` (`337:6268`). Dark used to
  /// reuse [progressTrack], from before the dark frame was read (API→UI
  /// Wave 11). Its width is `AppElevation.quizSetupDividerWidth`.
  final Color quizDivider;

  /// The subject line over the setup screen's scope ("Biology"). Figma light
  /// `#4B675E` (`146:2289`), dark `#FCFBF9` (`337:6270`).
  final Color quizSetupSubject;

  /// The setup screen's scope name ("Cell Membrane"). Figma light `#384F47`
  /// (`146:2291`), dark `#FCFBF9` (`337:6272`). Its own token rather than
  /// `colorScheme.primary`: equal in light, but the dark primary is the
  /// lavender accent and the dark frame draws the scope in `#FCFBF9`.
  final Color quizSetupScope;

  /// The limit card's title. Figma `#EF4444` (`207:5904`). There is no dark
  /// Limitation frame (docs/DESIGN_ISSUES.md #74), so dark keeps the light
  /// value, as [quizOptionBorder] does; splitting it would mean inventing one.
  final Color limitSheetTitle;

  /// The limit card's ✕. Figma light `#3F3F3F`, the SVG stroke of
  /// `akar-icons:cross` in `207:5904`. No dark frame (#74), and `#3F3F3F`
  /// would all but vanish on the dark card, so dark takes `#FCFBF9`, the
  /// dark [textPrimary] the Profile dialog's ✕ already uses: a choice between
  /// two existing values, not a new one.
  final Color limitSheetClose;

  /// The quiz header's ✕, the frame's own 30 dp cross. Figma light
  /// `#384F47` (`159:1227`, SVG stroke), dark `#FCFBF9` (`337:9205`). It was
  /// the app bar's foreground, [textPrimary]: `#0E0E0E` in light (API→UI
  /// Wave 12).
  final Color quizHeaderGlyph;

  /// The rule under the quiz header. Figma `rgba(124,58,237,0.1)` at 1.18 on
  /// both canvases (`159:1224`, `337:9202`). Not [quizDivider]: the setup
  /// screen's header rule is a different grey-green on the frame before.
  final Color quizHeaderRule;

  /// The quiz progress bar's fill. Figma `#AE87E7` on both canvases (`308:5266`,
  /// `348:7711`). It was `colorScheme.primary`, which is the green `#384F47`
  /// in light.
  final Color quizProgressFill;

  /// The quiz header's `n/total` counter. Figma `#7070A0` on both canvases
  /// (`308:5268`, `348:7713`). It was [mutedText], `#B3B3B3`.
  final Color quizProgressCounter;

  /// The quiz question's text. Figma light `#384F47` (`159:1259`), dark
  /// `#FCFBF9` (`348:7666`). It was [textPrimary]: `#0E0E0E` in light.
  final Color quizQuestionText;

  /// The AI EXPLANATION panel's header: its glyph and its title. Figma light
  /// `#384F47` (`159:1824`, the SVG stroke of `159:1839`), dark `#FCFBF9`
  /// (`337:9277`, `337:9272`). It was `colorScheme.primary`: right in light,
  /// the lavender accent in dark.
  final Color aiPanelTitle;

  /// The result header's "Quiz Complete!". Figma light `#384F47` (`159:2248`),
  /// dark `#FCFBF9` (`337:6662`). It was [textPrimary]: `#0E0E0E` in light
  /// (API→UI Wave 13).
  final Color quizResultTitle;

  /// The result header's "Subject — Scope" line. Figma light `#4B675E`
  /// (`159:2250`), dark `#EEEEEE` (`337:6663`). It was [textSecondary].
  final Color quizResultSubtitle;

  /// The score ring's radial gradient, inner stop (offset 0.1439): `#AE87E7`
  /// on both canvases (the `159:2240` / `337:6650` SVG exports). The ring was
  /// `colorScheme.primary`, the green `#384F47` in light.
  final Color resultRingFillFrom;

  /// The score ring's radial gradient, outer stop (offset 1): `#7070A0` on
  /// both canvases, same exports as [resultRingFillFrom].
  final Color resultRingFillTo;

  /// The ring's percentage figure. Figma light `#3D3D3D` (`159:2239`), dark
  /// `#FCFBF9` (`337:6654`). It was [textPrimary]: `#0E0E0E` in light.
  final Color resultPercentText;

  /// A result bucket's "Correct" / "Wrong" label. Figma light `#384F47`
  /// (`159:2295`), dark `#FCFBF9` (`337:6672`). It was [textPrimary].
  final Color resultBucketLabel;

  /// "REWARDS EARNED". Figma `#AE87E7` on both canvases (`159:2258`,
  /// `337:6683`). It was [quizExplanationBody], `#7070A0`.
  final Color resultRewardsTitle;

  /// The rewards star, the frame's own glyph. `#7070A0` on both canvases (the
  /// `159:2331` / `337:6686` SVG exports, fill and stroke). It was
  /// `colorScheme.primary` on Material's `Icons.star`.
  final Color resultStarGlyph;

  /// The rewards line's "+N" run. Figma `#AE87E7` on both canvases
  /// (`159:2335`, `337:6689`). The one-run line was `colorScheme.primary`.
  final Color resultPointsValue;

  /// The rewards line's "Points" run. Figma light `#010101` (`159:2337`), dark
  /// `#FCFBF9` (`337:6690`).
  final Color resultPointsUnit;

  /// The review header's "Quiz Review". Figma light `#000000` (`162:2411`),
  /// dark `#FCFBF9` (`337:6823`). It was [textPrimary], `#0E0E0E` in light,
  /// under the shared `TitledChrome` (API→UI Wave 14).
  final Color quizReviewTitle;

  /// An idle review filter chip's label ("Correct", "Wrong"). Figma light
  /// `#384F47` (`162:2783`, `162:2785`), dark `#FCFBF9` (`337:6831`). It was
  /// [textPrimary], `#0E0E0E` in light. The selected chip keeps
  /// [quizReviewFilterLabel].
  final Color reviewFilterIdleLabel;

  /// A review row's "QUESTION n". Figma light `#4B675E` (`162:2492`). Dark is
  /// `#FCFBF9`, the question's own cream, NOT the frame's lavender `#AE87E7`
  /// (`337:6714`): on the dark row fills that measures about 3:1, under the
  /// 4.5:1 a 12-pt label needs (owner ruling 2026-09-27, DESIGN_ISSUES #54).
  final Color reviewRowLabel;

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
  // Until 2026-09-17 this block said the review rows added nothing here and
  // reused the five semantic correct/wrong tokens unchanged, because the dark
  // frame's 20% alpha "was decided against". The designer reversed that
  // (docs/DECISIONS.md D-010, DESIGN_ISSUES #53 RESOLVED): the dark rows take
  // the approved Glass treatment, which means the frame's alpha, the 0.5
  // semantic stroke and G5. So the rows DO have their own fills now -
  // [reviewRowCorrectFill], [reviewRowWrongFill], [reviewRowSkippedFill] -
  // which exist precisely so that changing them cannot reach the quiz page's
  // graded option tiles one tap away. The ruling was scoped to these rows and
  // gave no instruction about those tiles.
  //
  // The HUES are untouched: a correct answer is still green and a wrong one
  // still red, on both canvases. What changed is the TREATMENT.

  /// Foreground of a **correct** review row — its question text and its
  /// "QUESTION n" label. Light `#384F47` (`162:2510`), dark `#FCFBF9`.
  ///
  /// **Both values are READ, and the dark one changed on 2026-09-20.** It used
  /// to be identical to light, and the field doc said so "on purpose": the fill
  /// underneath it, [quizCorrectFill], was opaque mint on both canvases, so a
  /// foreground that followed the theme would have put cream on mint in dark at
  /// a measured **1.11:1**. That reasoning was sound while the premise held.
  ///
  /// The premise is gone. D-010 moved the dark row to [reviewRowCorrectFill] -
  /// the same mint at 20% over the `#232428` page, which composites to a DARK
  /// `#425047`. A dark green foreground on that measures **1.04:1**: the same
  /// failure the old doc warned about, arriving from the other direction.
  ///
  /// The replacement was not chosen, it was read. `337:6715` (the correct row's
  /// question text) and `337:6725` (the wrong row's) both specify `#FCFBF9`,
  /// off the Properties panel in the owner's signed-in Figma session on
  /// 2026-09-20. On the composited fill that measures **8.24:1**. This also
  /// refutes DESIGN_ISSUES #54's premise that the dark review frame specifies
  /// no foreground anywhere - it specifies four; see that entry.
  ///
  /// Numerically equal to [textPrimary] in dark and kept separate for the
  /// reason this file keeps every such pair apart: the light value is a green
  /// that [textPrimary] is not, and restyling one must not restyle the other.
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
  /// they are [quizOptionFill] under `AppElevation.reviewFilterIdleShadows`.
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

  /// Foreground on both Mistakes surfaces: card title, row name and badge
  /// numeral. The two chevrons have their own tokens since API→UI Waves 15
  /// and 16: [mistakesCardChevron] and [mistakesRowChevron].
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
  /// Light `#F4E6FF`, the lavender of the catalog's disc, read off `404:6644`
  /// in API→UI Wave 16. Until then the light disc had never been read and
  /// carried light [cardFill], `#FDFDFD`, the value the badge always shipped
  /// with.
  final Color mistakesBadgeFill;

  /// The Mistakes overview card's chevron, the frame's `weui:arrow-filled`.
  /// Figma light `#517066` (`404:6533`, the SVG's fill), dark `#FCFBF9`
  /// (`404:7651`). It was [mistakesContent], the title's `#384F47`, in light
  /// (API→UI Wave 15).
  final Color mistakesCardChevron;

  /// The Mistakes tree row's chevron. The frame draws a 1.33 stroke in
  /// `#4B675E` light (`404:6654`, the row icon's SVG) and `#FCFBF9` dark
  /// (`404:7778`). It was [mistakesContent], the name's `#384F47`, in light
  /// (API→UI Wave 16). Numerically the catalog's [treeRowChevron], and kept
  /// apart so the two drill-downs cannot restyle each other.
  final Color mistakesRowChevron;

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

  // `profileIconChip` lived here and is GONE, deleted 2026-09-20 with the
  // reading that made it wrong. It was "the lavender circle behind the
  // Go-to-University and Logout glyphs", on the belief that the other eight
  // Profile rows had a bare glyph. Three Properties-panel reads refuted
  // that: the disc is the Iconify component frame's own fill and every row
  // has one, which is why a layer walk looks like it has none. The rows now
  // take [profileMenuIconDiscFill] on all ten (edit5 #24), and its dark value
  // is READ rather than borrowed from `navCentreIdleFill`.

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

  /// The Profile dialogs' ✕ (Logout, Go to Uni). Figma light `#3F3F3F`, the
  /// SVG stroke of `akar-icons:cross` (`180:4707`, `180:4540`); dark `#FCFBF9`
  /// (`337:7786`, `337:7670`). The light ✕ used to take [textPrimary]
  /// (`#0E0E0E`); API→UI Wave 19. The same two values as [limitSheetClose],
  /// kept separate because that card has no dark frame and this one does.
  final Color profileDialogClose;

  /// The avatar disc's radial gradient, centre → edge, behind the avatar image
  /// on Edit Profile (`176:1343`, 151 dp) and on every cell of the Choose
  /// Avatar picker (`180:4277`…, 69 dp): `#4B675E` → `#95CDBB`. The same on
  /// both tracks and both canvases (`180:6437`, `337:7923`, `349:12770`,
  /// `337:8030`). API→UI Wave 20.
  final Color avatarDiscInner;

  /// See [avatarDiscInner].
  final Color avatarDiscOuter;

  /// The pencil on Edit Profile's avatar badge (`fluent:edit-16-filled`):
  /// light `#384F47` (`176:1347`, `180:6440`), dark `#FCFBF9` (`337:7926`,
  /// `349:15373`). It drew [homeAccent], purple on both canvases, until API→UI
  /// Wave 20.
  final Color avatarBadgeGlyph;

  /// The avatar action sheet's drag handle (`Rectangle 6428`, 94 x 4): light
  /// `#000000` (`216:3342`), dark `#FCFBF9` (`337:8136`). API→UI Wave 20.
  final Color avatarSheetHandle;

  /// The hairline under the action sheet's first row: `#4B675E` at 60%, 0.5
  /// dp, the same on both canvases (`216:3343`, `337:8137`). API→UI Wave 20.
  final Color avatarSheetDivider;

  /// A Settings row's label ("Show Rank", "announcements"): light `#384F47`
  /// (`642:8524`, `176:2393`), dark `#FCFBF9` (`642:8586`, `337:8198`), Inter
  /// Regular 16 on both. It was [textPrimary] at `h3` until API→UI Wave 21.
  final Color settingsRowLabel;

  /// The Settings switch's track when ON — the frame's `Button` (`642:8525`,
  /// `176:2394`), a 48 x 24 stadium in `#AE87E7` on BOTH canvases (`642:8587`,
  /// `337:8199`). API→UI Wave 21; it was Flutter's stock `Switch` before.
  final Color settingsToggleOnTrack;

  /// The switch's track when OFF. **Not designed**: every frame draws the
  /// switch ON. `#B3B3B3` is [mutedText]'s value — the app's inactive grey,
  /// the same on both canvases — used as a stand-in until the designer draws
  /// the OFF state (owner ruling 2026-09-29, docs/DESIGN_ISSUES.md #107).
  final Color settingsToggleOffTrack;

  /// The switch's knob: 16 dp, `#FFFFFF` on both canvases (`642:8526`,
  /// `642:8588`). API→UI Wave 21.
  final Color settingsToggleKnob;

  // --- Flashcards (API→UI Wave 22) ------------------------------------------
  //
  // The study screen `225:5582` (light) / `337:14475` (dark) shares the quiz's
  // header, progress row and previous button (`StudySessionHeader`,
  // `StudyPreviousButton`); only the tokens below are its own. The dark study
  // frame is OLDER than the light one (no restart button, "Confirm" instead of
  // "Got it", a 358-wide card), and no dark Setup frame exists at all, so
  // several dark values below are stand-ins, each said so on its field and
  // logged in docs/DESIGN_ISSUES.md.

  /// The study screen's progress FILL: light `#5A7F73` (`225:5616`), dark
  /// `#AE87E7` (`349:15348`, the fill inside `337:14475`). It is the one thing
  /// the flashcards header does not share with the quiz's, whose fill is
  /// [quizProgressFill] (`#AE87E7` on both canvases) — the light study frame
  /// draws a green-grey here that no quiz frame has.
  final Color flashcardProgressFill;

  /// The flashcard's face: `#FCFBF9` on BOTH canvases. The card is a light
  /// object on the dark canvas too (`337:14513`, `247:3260`; front face
  /// `I247:3260;246:3237`), so this does not flip and must not be replaced by
  /// [cardFill] or [background].
  final Color flashcardCardFill;

  /// The text on the flashcard, both faces: `#384F47` on BOTH canvases (front
  /// `246:3244`, back `246:3236`, identical in `225:5582` and `337:14475`) —
  /// the card stays light in dark mode, so its ink stays dark.
  final Color flashcardCardText;

  /// The "Again" button's disc (`1229:8739`, 38 dp circle): light `#4B675E`.
  /// **Dark is not designed** — `337:14475` has no restart button (it predates
  /// it). The dark theme's primary accent `#AE87E7` (the dark frame's primary
  /// button, `349:15308`) stands in until the designer draws it
  /// (docs/DESIGN_ISSUES.md).
  final Color flashcardAgainFill;

  /// The restart glyph inside "Again" (`1229:8745`): `#FCFBF9` on light; the
  /// same on dark, where the button itself is undesigned (see
  /// [flashcardAgainFill]) and a cream glyph reads on the accent stand-in.
  final Color flashcardAgainGlyph;

  /// Flash Card Setup's single "N Flash Cards" pill (`1234:8847`): light is
  /// pure `#FFFFFF`, not the `#FCFBF9` every other surface uses. **Dark is not
  /// designed** (no dark Setup frame): `#27282C`, the dark quiz-setup chip's
  /// fill (`337:6239`), stands in.
  final Color flashcardSetupPillFill;

  /// The pill's 0.5 stroke: light `#384F47` (`1234:8847`). **Dark is not
  /// designed**: `#FCFBF9`, the app's dark counterpart of the light ink
  /// `#384F47`, stands in.
  final Color flashcardSetupPillBorder;

  /// The pill's label: light `#384F47` (`1234:8848`), dark `#FCFBF9` — the dark
  /// quiz-setup chip's label (`337:6239`). The dark half is derived, not drawn.
  final Color flashcardSetupPillText;

  /// Setup's helper line under the pill (`1237:9845`): light `#6E7F7A`.
  /// **Dark is not designed**: `#B3B3B3` is [mutedText]'s value — the app's
  /// de-emphasised small-text grey — so the caption stays quieter than the
  /// pill's `#FCFBF9` label, as it is in light. (`textSecondary`'s dark value
  /// `#DCDCDC` would have read as loud as the label.)
  final Color flashcardSetupHelper;

  /// The study screen's grade-failure line under the card ("You are offline",
  /// "Something went wrong"…). **Not designed** — composed from existing error
  /// colours; DESIGN_ISSUES #119. Light is `#921119`, the quiz's inline-error
  /// red ([quizWrongBorder]'s light value, 8.8:1 on `#FCFBF9`). Dark is
  /// `#FF465C`, the app's dark error text ([otpErrorText]'s dark value, about
  /// 4.6:1 on `#232428`). It is NOT [quizWrongBorder] on the dark canvas: that
  /// token is `#921119` there too, which reads 1.7:1 on `#232428`.
  final Color flashcardGradeError;

  // --- Elevation ------------------------------------------------------------
  //
  // `elevationShadow` lived here and is GONE, deleted 2026-09-20 by the edit
  // that removed its last call site (edit5's OTP chunk, the resend-timer
  // pill). Its own doc comment asked for exactly that: "whoever removes the
  // LAST reference deletes this field".
  //
  // It carried a DERIVED dark value - a cream `#FCFBF9` - on the premise that
  // no dark frame existed to verify a shadow against. Thirteen dark frames
  // were measured on 2026-09-17 and every drop shadow in them is black; the
  // dark canvas elevates upward instead, with Glass over a 20% fill plus a
  // lavender back-light. The owner withdrew the derivation (edit1.md #34) and
  // the mechanism now lives in `lib/core/theme/app_elevation.dart` and
  // `lib/core/widgets/elevation/`. See docs/DESIGN_ISSUES.md #47 (superseded)
  // and #72, and docs/DECISIONS.md D-009.
  //
  // `test/core/theme/app_elevation_test.dart` still asserts that the cream
  // appears in no elevation token on either canvas. It now writes the hex out
  // rather than reading it from here, which is the point: the value survives
  // only as something to test AGAINST.

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

  /// The fill behind the caller's own board row: `#DBB0FF` in both frames
  /// (`134:3554` light, `337:5638` dark), read on the Wave 06 device walk
  /// (W06-3). It carried `#D8B0FF` from a 2026-09-08 reading until then. The
  /// scope switcher's selected segment has had its own token,
  /// [scopeSelectedFill], since 2026-09-20; in light the two now hold the same
  /// value, in dark they do not.
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

  /// Fill of the SECOND place rank badge (`134:3426` / `337:5582`). The
  /// winner's badge takes [podiumFirstRing]; third place's takes
  /// [podiumThirdBadgeFill]. Until Wave 06 this filled the third badge too.
  final Color podiumBadgeIdle;

  /// The second place rank badge's 1px stroke, `#DC4A22` in both frames
  /// (`134:3426` / `337:5582`). It is NOT [podiumSecondRing] (`#FF8228`, the
  /// avatar's ring) — the badge was drawn a deeper orange.
  final Color podiumSecondBadgeBorder;

  /// Fill of the THIRD place rank badge, `#FCFBF9` in both frames (`134:3423`
  /// / `337:5579`). Its stroke is `#DEDEDE`, the same value as
  /// [podiumThirdRing], which it reuses.
  final Color podiumThirdBadgeFill;

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

  /// The brand bird on Login — light `82:849` fills its three paths `#040404`,
  /// dark `337:15678` fills the same paths `#FCFBF9` (both read from the
  /// frames' SVG exports, 2026-09-24). The app ships ONE asset
  /// (`bird_logo.svg`, `#040404`) and tints it with this, so the dark canvas
  /// no longer draws a near-black bird on `#232428` (device walk, Wave 01).
  /// Its own token rather than [textPrimary]: equal in dark, but light
  /// [textPrimary] is `#0E0E0E`, not the logo's `#040404`.
  final Color brandLogo;

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

  /// Top Student's hairline — round all four sides and between the rows — a
  /// 10%-alpha violet, the same on both canvases. `59:2090` / `337:5460`, both
  /// `border-[1.208px]` all round (built top-only until W05-2).
  final Color topStudentBorder;

  /// A Top Student row's name. Light `#384F47` (`59:2096`), dark `#FCFBF9`
  /// (`337:5466`). Its own token: the light value is the brand green, not
  /// [textPrimary].
  final Color topStudentName;

  /// A Top Student row's points. Light orange `#E67E22` (`59:2098`), dark
  /// lavender `#AE87E7` (`337:5468`). Numerically equal to [link] on both
  /// canvases and kept separate: a score is not a link, and restyling links
  /// must not restyle the board.
  final Color topStudentPoints;

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

  /// The subject card's name. Light `#384F47` (`135:625`, and `404:6983` on
  /// the university frame), dark `#FCFBF9` (`337:5739`). Read in API→UI Wave
  /// 07; the card had drawn it in [textPrimary], near-black in light.
  final Color subjectCardTitle;

  /// The subject card's drill-in chevron, the `weui:arrow-filled` SVG's own
  /// fill: light `#517066` (`135:626`, `404:6984`), dark `#FCFBF9`
  /// (`337:5740`). A lighter green than the title, in the frame. Wave 07.
  final Color subjectCardChevron;

  /// The subject card's progress fill: `#AE87E7` on both canvases and both
  /// tracks (`135:631`, `404:6989`, `337:5745`). Until Wave 07 the card used
  /// the theme primary, which is green `#384F47` in light.
  final Color subjectCardProgress;

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

  /// The catalog row's drill-in chevron, the frame's own STROKE: light
  /// `#4B675E` (`135:1078`, the row's hairline green), dark `#FCFBF9`
  /// (`337:5938`). Read in API→UI Wave 08; the row had drawn it in
  /// [textPrimary], near-black in light. The Mistakes row keeps its content
  /// colour.
  final Color treeRowChevron;

  /// The catalog row's progress fill AND its caption: `#AE87E7` on both
  /// canvases (bar `135:1075` / `337:5936`, caption `135:1077` / `337:5937`;
  /// the Lectures rows `309:5724` / `349:15647` agree). Until API→UI Wave 08
  /// the row used the theme primary, green `#384F47` in light. Kept apart from
  /// [subjectCardProgress] so correcting one bar never restyles the other.
  final Color treeRowProgress;

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

  /// The chevron inside that button. `#FCFBF9` on BOTH canvases - light
  /// `159:1922`, dark `337:6466`, each read from the Properties panel on
  /// 2026-09-20. `edit4.md` §13 listed this as unread and offered a two-branch
  /// fallback; neither branch was needed, and the dark branch would have been
  /// wrong - it proposed [textPrimary], which is the same value in dark but is
  /// a different token with a different reason to move.
  ///
  /// Numerically equal to `ColorScheme.onPrimary` today. Kept separate because
  /// it sits on [quizPrevButtonFill], not on the primary accent, and the two
  /// fills are unrelated: light is a 60% green wash, dark a 20% neutral.
  /// Measured **4.60:1** on the light wash over the cream page and **9.26:1**
  /// on the dark composite.
  final Color quizPrevButtonGlyph;

  /// The quiz question card's hairline. Width in
  /// `AppElevation.quizQuestionCardBorderWidth`. `337:6434`.
  final Color quizQuestionCardBorder;

  /// The quiz option tile's hairline. `337:6440`. Distinct from
  /// [quizOptionBorder], which is the A/B/C/D letter ring.
  final Color quizOptionTileBorder;

  /// The ring around an UNGRADED A/B/C/D badge. The graded states draw
  /// their own semantic ring and do not use this.
  ///
  /// **Dark is READ, light is CARRIED.** `337:6447` gives the dark ring as
  /// the same lavender at 50% that the tile's own hairline uses - the frame
  /// draws the outline and the letter ring in one colour, where the build
  /// had been drawing the ring in the light canvas's green. Read from the
  /// Properties panel on 2026-09-20, together with its 1.18 stroke, which
  /// already matched.
  ///
  /// The LIGHT value was **not** separately read. It is [quizOptionBorder]'s
  /// light value carried across, which is what the badge drew before this
  /// token existed, so the light canvas is byte-identical. If the light
  /// badge ever turns out to differ from the tile hairline, this is the
  /// token to move.
  ///
  /// It exists rather than moving [quizOptionBorder] because that token is
  /// shared - the review screen's skipped row takes it for both its outline
  /// and its badge - and one node's reading must not restyle four surfaces
  /// (owner ruling, 2026-09-20; docs/DESIGN_ISSUES.md #83).
  final Color quizOptionBadgeRing;

  /// The result screen's stat buckets and rewards card. `159:2289`,
  /// `159:2252` / `337:6667`, `337:6680`.
  final Color resultCardFill;

  /// The 33x33 star disc on the rewards card. `337:6685`.
  final Color resultStarDiscFill;

  /// An UNSELECTED review filter pill. `162:2782` / `337:6827`. The selected
  /// one keeps [quizReviewFilterFill].
  final Color reviewFilterIdleFill;

  /// A CORRECT review answer row. Light keeps [quizCorrectFill]'s opaque mint
  /// verbatim; dark is the same mint at **20%**, read off `337:6731` on
  /// 2026-09-20 together with its 0.5 `#00D33C` stroke and its one Glass
  /// effect. Composites to `#425047` over the page.
  final Color reviewRowCorrectFill;

  /// A WRONG review answer row. Light keeps [quizWrongFill] verbatim (30%);
  /// dark is the same HUE at **20%**, composited `#4F4346`.
  ///
  /// Two deliberate decisions are frozen in that sentence. The alpha follows
  /// the dark frame, which reads 20% on both row states - equal treatment is
  /// what D-010 asked for above the literal number. The hue does NOT follow
  /// the frame: `337:6731`'s wrong twin draws `#FDE9E8` with a `#921019`
  /// stroke, one hex digit from the shipped pair, and the owner ruled that
  /// drift unadopted in 2026-09-08 - DESIGN_ISSUES #52, still open, untouched
  /// here.
  final Color reviewRowWrongFill;

  /// A SKIPPED review answer row - a question the student never committed.
  ///
  /// **The frame has no such state**, in either canvas, so this is the neutral
  /// ungraded surface given the same treatment as the two rows beside it
  /// rather than a third signal colour invented for it (DESIGN_ISSUES #55).
  /// Light keeps [quizOptionFill]; dark is `#27282C` at 20%, the alpha its
  /// neighbours read, composited `#242529`.
  ///
  /// That composite is **1.01:1** against the page - no colour step at all.
  /// The row is delineated by its Glass rim, not by its fill, which is the
  /// same bargain [mistakesCardFill] already documents on this canvas.
  final Color reviewRowSkippedFill;

  /// The leaderboard scope toggle's track. `158:839` / `337:5615`.
  final Color scopeTrackFill;

  /// An UNSELECTED scope segment's label. Light `158:843` is `#384F47`, a
  /// dark GREEN; dark `337:5619` is the cream. Both Inter 500 / 18 at a 100%
  /// line height, READ off the Properties panel on 2026-09-20.
  ///
  /// `edit4.md` §7.8 asked for [textSecondary] here. That is the grey
  /// `#2C2C2C`, and it is the same substitution DESIGN_ISSUES #77 had already
  /// caught on the sibling pill track five days earlier - the guide's table
  /// simply had no idle-label node in it. Measured on the track: **7.48:1**
  /// light, **14.61:1** dark.
  ///
  /// Numerically equal to [pillTrackLabel], and its own token anyway. The two
  /// controls are different Figma components - `Frame 1000003008` here,
  /// `Frame 1000003007` there - with different track fills, different
  /// selected fills and, per #77 and this edit's own finding, two different
  /// contrast problems that will not be fixed by the same edit.
  final Color scopeIdleLabel;

  /// The scope toggle's selected segment. Light `#DBB0FF` (`158:840`), dark
  /// `#C4A8E3` (`337:5616`).
  ///
  /// **The light value was re-read on 2026-09-20 and it moved.** It had been
  /// carrying the 2026-09-08 [podiumAccent] reading `#D8B0FF`; a 2026-09-16
  /// CSS export of `133:3117` disagreed, and the Properties panel settles it
  /// for `158:840` at `#DBB0FF`. Three units of red apart, which is why it
  /// survived two readings - and why it is worth pinning rather than eyeing.
  ///
  /// [podiumAccent] was deliberately NOT moved with it then, because the
  /// caller's own board row (`134:3554`) had not been re-read. The Wave 06
  /// walk read it at `#DBB0FF` too, and moved it. The two stay separate
  /// tokens: this one differs per canvas, that one is `#DBB0FF` on both.
  ///
  /// ⚠️ The selected LABEL on this fill fails AA badly - [podiumOnAccent]
  /// measures **1.74:1** here in light and **2.02:1** in dark, worse than the
  /// 2.74:1 the owner accepted for the pill track, and on a different colour
  /// pair, so #77's ruling does not cover it. Recorded as a new finding in
  /// docs/DESIGN_ISSUES.md #77; no colour is chosen here.
  final Color scopeSelectedFill;

  /// A leaderboard row. `134:3538` / `337:5630`.
  final Color leaderboardRowFill;

  /// Rank, name AND points on an ordinary board row: ONE colour per canvas.
  /// Light `#4F4F4F`, the file's "Gray 2" (`134:3541` / `134:3544` /
  /// `134:3539`); dark `#FCFBF9` (`337:5633` / `337:5636` / `337:5631`).
  /// First read on the Wave 06 device walk (W06-2). Until then the row used
  /// [textPrimary], with [textSecondary] on the points; the frame draws the
  /// points no quieter than the name. The caller's own row keeps
  /// [podiumOnAccent].
  final Color leaderboardRowText;

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

  /// The EMPHASIS row's hairline — "Go to University", `170:4921`.
  ///
  /// Its own token rather than [textPrimary], which is what the row used to
  /// borrow. Read off the Properties panel 2026-09-20: the frame's stroke is
  /// `#101010` and `textPrimary` light is `#0E0E0E` — two units of every
  /// channel apart, invisible on screen and still a different value from a
  /// different source. Dark is null: `337:7433`'s rows carry no stroke at all
  /// (edit5.md §5 #24), the same as [profileMenuRowBorder].
  final Color? profileMenuEmphasisRowBorder;

  /// The 35x35 icon disc inside a Profile menu row. `337:7480`.
  final Color profileMenuIconDiscFill;

  /// The glyph inside the 40x40 Profile edit pencil chip.
  ///
  /// Both canvases READ, 2026-09-20 / 2026-09-17: light `170:4674` is a 20x20
  /// vector at `#333333`, dark `337:7466`'s is the same box at `#FCFBF9`.
  /// Neither is [homeAccent], which is what the bare `IconButton` this chip
  /// replaced was tinted with (edit5.md §7.2.3).
  final Color profileEditChipGlyph;

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

  /// The resend-timer pill's glyph AND digits. Light `#384F47` (`82:1316`'s
  /// digits; the stopwatch export's stroke), dark `#FCFBF9` (`337:19503`'s
  /// digits and its glyph export). Not `colorScheme.primary`: that is lavender
  /// on the dark canvas, where the frame draws both in cream.
  final Color otpTimerContent;

  /// The OTP card's error line — `#FF465C` on both canvases (`82:1447`,
  /// `337:19294`). Not `colorScheme.error`, which is the M3 seed's red.
  final Color otpErrorText;

  /// A digit box's stroke in the `Type= wrong` variant — `#EB001B` at 50% on
  /// both canvases (`82:1442`, `337:19287`), drawn at the resting width.
  final Color otpDigitErrorBorder;

  /// The sign-up track card. `125:862` / `337:15981`. Dark was opaque
  /// [background]; the frame is a 20% wash under Glass.
  final Color trackCardFill;

  /// The School track illustration's own soft shadow — a black-25% silhouette
  /// of the books, blurred and dropped behind them (edit5 #54).
  ///
  /// **The same value on both canvases**, because the frames draw the same
  /// layer on both: inside `Component 2`, `Group 37219` holds the 98×98 art
  /// TWICE, and the back copy's group is one flat `#000000` at 25%, offset
  /// (1, 2), at 53% layer opacity under a 7.4 layer blur. Read on the
  /// Properties panel 2026-09-20; `docs/DESIGN_ISSUES.md` #40 recorded the
  /// same 0.53 × 0.25-black from the SVG export on 2026-08-04 and deleted it
  /// from the asset, because `flutter_svg` painted it CRISP. It comes back
  /// here, through `LayerBlur`, where the blur is real.
  ///
  /// The University card has no such layer and gets none.
  final Color trackCardArtShadow;

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
    catalogTrack: Color(0xFFECECEC), // Figma 135:630
    sheetFill: Color(0x33FCFBF9), // rgba(252,251,249,0.2) — Figma 459:43873
    // No such node in the light frame 81:92 — see the field's doc comment.
    onboardingIllustrationMask: null,
    accentSoft: Color(0xFFA0B384), // Figma 459:43876 — sage, not greenPrimary
    bodyMuted: Color(0xFF858585), // Figma 459:43887
    successBadge: Color(0xFF22C55E), // from assets/images/success_badge.svg
    quizOptionFill: Color(0xFFFCFBF9), // Figma 308:5153
    quizOptionBorder: Color(0xFF4B675E), // Figma 308:5153
    quizDivider: Color(0xFFCCD5D2), // Figma 146:2287
    quizSetupSubject: Color(0xFF4B675E), // Figma 146:2289
    quizSetupScope: Color(0xFF384F47), // Figma 146:2291
    limitSheetTitle: Color(0xFFEF4444), // Figma 207:5904
    limitSheetClose: Color(0xFF3F3F3F), // Figma 207:5904 (SVG stroke)
    quizHeaderGlyph: Color(0xFF384F47), // Figma 159:1227 (SVG stroke)
    quizHeaderRule: Color.fromRGBO(124, 58, 237, 0.1), // Figma 159:1224
    quizProgressFill: Color(0xFFAE87E7), // Figma 308:5266
    quizProgressCounter: Color(0xFF7070A0), // Figma 308:5268
    quizQuestionText: Color(0xFF384F47), // Figma 159:1259
    aiPanelTitle: Color(0xFF384F47), // Figma 159:1824
    quizResultTitle: Color(0xFF384F47), // Figma 159:2248
    quizResultSubtitle: Color(0xFF4B675E), // Figma 159:2250
    resultRingFillFrom: Color(0xFFAE87E7), // Figma 159:2240 (SVG stop 0.1439)
    resultRingFillTo: Color(0xFF7070A0), // Figma 159:2240 (SVG stop 1)
    resultPercentText: Color(0xFF3D3D3D), // Figma 159:2239
    resultBucketLabel: Color(0xFF384F47), // Figma 159:2295
    resultRewardsTitle: Color(0xFFAE87E7), // Figma 159:2258
    resultStarGlyph: Color(0xFF7070A0), // Figma 159:2331 (SVG)
    resultPointsValue: Color(0xFFAE87E7), // Figma 159:2335
    resultPointsUnit: Color(0xFF010101), // Figma 159:2337
    quizReviewTitle: Color(0xFF000000), // Figma 162:2411
    reviewFilterIdleLabel: Color(0xFF384F47), // Figma 162:2783
    reviewRowLabel: Color(0xFF4B675E), // Figma 162:2492
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
    mistakesBadgeFill: Color(0xFFF4E6FF), // Figma 404:6644
    mistakesCardChevron: Color(0xFF517066), // Figma 404:6533 (SVG fill)
    mistakesRowChevron: Color(0xFF4B675E), // Figma 404:6654 (SVG stroke)
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
    // Identical to dark ON PURPOSE — see the field doc.
    destructive: Color(0xFFEF4444), // Figma 176:1191
    dialogNote: Brand.purplePrimary, // #AE87E7 — Figma 180:4571
    profileDialogClose: Color(0xFF3F3F3F), // Figma 180:4707 (SVG stroke)
    avatarDiscInner: Color(0xFF4B675E), // Figma 176:1343 (radial, stop 0)
    avatarDiscOuter: Color(0xFF95CDBB), // Figma 176:1343 (radial, stop 1)
    avatarBadgeGlyph: Brand.greenPrimary, // #384F47 — Figma 176:1347
    avatarSheetHandle: Color(0xFF000000), // Figma 216:3342
    avatarSheetDivider: Color(0x994B675E), // #4B675E @60% — Figma 216:3343
    settingsRowLabel: Brand.greenPrimary, // #384F47 — Figma 642:8524
    settingsToggleOnTrack: Brand.purplePrimary, // #AE87E7 — Figma 642:8525
    settingsToggleOffTrack: Color(0xFFB3B3B3), // not designed — see the field
    settingsToggleKnob: Color(0xFFFFFFFF), // Figma 642:8526
    flashcardProgressFill: Color(0xFF5A7F73), // Figma 225:5616
    flashcardCardFill: Color(0xFFFCFBF9), // Figma 247:3260 — same in dark
    flashcardCardText:
        Brand.greenPrimary, // #384F47 — Figma 246:3244 / 246:3236
    flashcardAgainFill: Color(0xFF4B675E), // Figma 1229:8739
    flashcardAgainGlyph: Color(0xFFFCFBF9), // Figma 1229:8745
    flashcardSetupPillFill: Color(0xFFFFFFFF), // Figma 1234:8847
    flashcardSetupPillBorder: Brand.greenPrimary, // #384F47 — Figma 1234:8847
    flashcardSetupPillText: Brand.greenPrimary, // #384F47 — Figma 1234:8848
    flashcardSetupHelper: Color(0xFF6E7F7A), // Figma 1237:9845
    // Not designed — quizWrongBorder's light value; DESIGN_ISSUES #119.
    flashcardGradeError: Color(0xFF921119),
    podiumAccent: Color(0xFFDBB0FF), // Figma 134:3554
    podiumOnAccent: Color(0xFFFCFBF9), // Figma 158:841
    podiumFirstRing: Color(0xFFFFCA28), // Figma 134:3418 border / 134:3429
    podiumSecondRing: Color(0xFFFF8228), // Figma 134:3497 border
    podiumThirdRing: Color(0xFFDEDEDE), // Figma 134:3468 border
    podiumBadgeIdle: Color(0xFFF4F4F4), // Figma 134:3426
    podiumSecondBadgeBorder: Color(0xFFDC4A22), // Figma 134:3426 stroke
    podiumThirdBadgeFill: Color(0xFFFCFBF9), // Figma 134:3423
    // --- Elevation pass (edit1.md section 8.1) ---
    backChipSurfaceFill: Color(0xFFFCFBF9), // Figma 90:208
    registrationBackChipFill: Color(0xFFFCFBF9), // Figma 337:19690 twin
    languagePillFill: Color(0xFFFCFBF9), // Figma 82:1093
    brandLogo: Color(0xFF040404), // Figma 82:849 (SVG export fill)
    homeBellFill: Color(0xFFFCFBF9), // Figma 59:1466
    dailyTasksFill: Color(0xFFFCFBF9), // Figma 308:4305
    dailyTasksBorder: Color(0xFF4B675E), // Figma 308:4305
    topStudentFill: Color(0xFFFFFFFF), // Figma 59:2090 — pure white
    topStudentBorder: Color.fromRGBO(124, 58, 237, 0.1), // Figma 59:2090
    topStudentName: Color(0xFF384F47), // Figma 59:2096
    topStudentPoints: Color(0xFFE67E22), // Figma 59:2098
    continueLearningFillSchool: Color(0xFFF3E5FF), // school Home
    continueLearningFillUniversity: Color(0xFFDBB0FF), // university Home
    subjectSearchFill: Color(0xFFFCFBF9), // Figma 135:610
    subjectSearchTopBorder: Color(0xFFF3F4F6), // Figma 135:610
    subjectCardFill: Color(0xFFFFFFFF), // Figma 135:618 — pure white
    subjectCardTitle: Color(0xFF384F47), // Figma 135:625
    subjectCardChevron: Color(0xFF517066), // Figma 135:626 (SVG fill)
    subjectCardProgress: Color(0xFFAE87E7), // Figma 135:631
    mistakesPillFill: Color(0xFFFCFBF9), // light Subjects header
    mistakesPillAccent: Color(0xFFEF4444), // Figma 404:7421 — same in both
    treeRowFill: Color(0xFFFCFBF9), // catalog Button rows
    treeRowBorder: Color(0xFF4B675E), // catalog Button rows
    treeRowBadgeFill: Color(0xFFF4E6FF), // catalog row disc
    treeRowChevron: Color(0xFF4B675E), // Figma 135:1078 (SVG stroke)
    treeRowProgress: Color(0xFFAE87E7), // Figma 135:1075
    pillTrackFill: Color(0xFFECECEC), // Figma 180:5337
    pillTrackSelectedFill: Brand.purplePrimary, // #AE87E7 — same in both
    pillTrackLabel: Color(0xFF384F47), // Figma 180:5339
    pillTrackSelectedLabel: Color(0xFFFCFBF9), // Figma 180:5341
    continueLearningContent: Color(0xFF2B2B2B), // Figma 308:4190
    aiPanelOuterFill: Color(0xFFFCFBF9), // Figma 159:1811
    aiPanelOuterBorder: Color(0xFF4B675E), // Figma 159:1811
    aiPanelCardFill: Color(0xFFFCFBF9), // Figma 159:1826
    quizPrevButtonFill: Color.fromRGBO(56, 79, 71, 0.6), // light Quiz chip
    quizPrevButtonGlyph: Color(0xFFFCFBF9), // Figma 159:1922
    quizQuestionCardBorder: Color(0xFF4B675E), // light Container
    quizOptionTileBorder: Color(0xFF4B675E), // light Button
    quizOptionBadgeRing: Color(0xFF4B675E), // carried, not read
    resultCardFill: Color(0xFFFCFBF9), // Figma 159:2289 / 159:2252
    resultStarDiscFill: Color(0xFFF8EFFC), // light Result disc
    reviewFilterIdleFill: Color(0xFFFCFBF9), // Figma 162:2782
    // The light review rows are unchanged: the light frame draws them opaque
    // and D-010 is a DARK ruling.
    reviewRowCorrectFill: Color(0xFFBFFFC3), // = quizCorrectFill, 162:2502
    reviewRowWrongFill: Color(0x4DFFC0C0), // = quizWrongFill, 162:2563
    reviewRowSkippedFill: Color(0xFFFCFBF9), // = quizOptionFill (no frame)
    scopeTrackFill: Color(0xFFECECEC), // Figma 158:839
    scopeIdleLabel: Color(0xFF384F47), // Figma 158:843
    scopeSelectedFill: Color(0xFFDBB0FF), // Figma 158:840 — see field doc
    leaderboardRowFill: Color(0xFFFFFFFF), // Figma 134:3538
    leaderboardRowText: Color(0xFF4F4F4F), // Figma 134:3544 (Gray 2)
    profileHeaderFill: Color(0xFFFCFBF9), // Figma 169:4609
    profileEditChipFill: Color(0xFFFCFBF9), // pencil chip in 166:4416
    profileStatFill: Color(0xFFFCFBF9), // Figma 661:8571
    profileMenuRowFill: Color(0xFFFCFBF9), // Figma 170:4790
    profileMenuRowBorder: Color(0xFF7070A0), // Figma 170:4790
    profileMenuEmphasisRowBorder: Color(0xFF101010), // Figma 170:4921
    profileMenuIconDiscFill: Color(0xFFF4E6FF), // Figma 170:4861, 176:1186
    profileEditChipGlyph: Color(0xFF333333), // Figma 170:4674
    avatarBadgeFill: Color(0xFFFCFBF9), // Figma 180:3989
    settingsSectionFill: Color(0xFFFCFBF9), // Figma 176:1840
    settingsSectionBorder: Brand.purplePrimary, // #AE87E7 — Figma 176:1840
    otpTimerFill: Color(0xFFFCFBF9), // Figma 332:3391
    otpCardFill: Color(0xFFFCFBF9), // Figma 308:5114
    otpCardGlow: null, // no glow in the light frame
    otpDigitFill: Color(0xFFFDFDFD), // Rectangle 104-107
    otpDigitBorder: Color(0xFFD1D1D1), // Rectangle 104-107 — same in both
    otpTimerContent: Color(0xFF384F47), // Figma 82:1316
    otpErrorText: Color(0xFFFF465C), // Figma 82:1447
    otpDigitErrorBorder: Color(0x80EB001B), // Figma 82:1442 rgba(235,0,27,0.5)
    trackCardFill: Color(0xFFFCFBF9), // Figma 125:862
    trackCardArtShadow: Color.fromRGBO(0, 0, 0, 0.25), // 125:862
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
    quizDivider: Color(0x33CCD5D2), // Figma 337:6268, rgba(204,213,210,.2)
    quizSetupSubject: Color(0xFFFCFBF9), // Figma 337:6270
    quizSetupScope: Color(0xFFFCFBF9), // Figma 337:6272
    limitSheetTitle: Color(0xFFEF4444), // no dark frame (#74): kept
    limitSheetClose: Color(0xFFFCFBF9), // no dark frame (#74): = textPrimary
    quizHeaderGlyph: Color(0xFFFCFBF9), // Figma 337:9205 (SVG stroke)
    quizHeaderRule: Color.fromRGBO(124, 58, 237, 0.1), // Figma 337:9202
    quizProgressFill: Color(0xFFAE87E7), // Figma 348:7711
    quizProgressCounter: Color(0xFF7070A0), // Figma 348:7713
    quizQuestionText: Color(0xFFFCFBF9), // Figma 348:7666
    aiPanelTitle: Color(0xFFFCFBF9), // Figma 337:9277
    quizResultTitle: Color(0xFFFCFBF9), // Figma 337:6662
    quizResultSubtitle: Color(0xFFEEEEEE), // Figma 337:6663
    resultRingFillFrom: Color(0xFFAE87E7), // Figma 337:6650 (SVG stop 0.1439)
    resultRingFillTo: Color(0xFF7070A0), // Figma 337:6650 (SVG stop 1)
    resultPercentText: Color(0xFFFCFBF9), // Figma 337:6654
    resultBucketLabel: Color(0xFFFCFBF9), // Figma 337:6672
    resultRewardsTitle: Color(0xFFAE87E7), // Figma 337:6683
    resultStarGlyph: Color(0xFF7070A0), // Figma 337:6686 (SVG)
    resultPointsValue: Color(0xFFAE87E7), // Figma 337:6689
    resultPointsUnit: Color(0xFFFCFBF9), // Figma 337:6690
    quizReviewTitle: Color(0xFFFCFBF9), // Figma 337:6823
    reviewFilterIdleLabel: Color(0xFFFCFBF9), // Figma 337:6831
    reviewRowLabel: Color(0xFFFCFBF9), // not 337:6714's #AE87E7 — owner, #54
    // The five semantic tokens below are IDENTICAL to light on purpose: a
    // correct answer must not read purple and a wrong one must not read green.
    quizCorrectFill: Color(0xFFBFFFC3),
    quizCorrectBorder: Color(0xFF00D33C),
    quizWrongFill: Color(0x4DFFC0C0),
    quizWrongBorder: Color(0xFF921119),
    quizWrongBadge: Color(0xFFEF4444),
    quizExplanationBody: Color(0xFF7070A0),
    // NOT identical to light any more. Its fill flips now (reviewRowCorrectFill
    // is 20% here), so its foreground has to. Read off 337:6715. Field doc.
    quizReviewRowContent: Color(0xFFFCFBF9),
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
    mistakesCardChevron: Color(0xFFFCFBF9), // Figma 404:7651
    mistakesRowChevron: Color(0xFFFCFBF9), // Figma 404:7778 (stroke)
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
    // Identical to light ON PURPOSE — see the field doc.
    destructive: Color(0xFFEF4444),
    dialogNote: Brand.purplePrimary, // #AE87E7 — same in both, like homeAccent
    profileDialogClose: Color(0xFFFCFBF9), // Figma 337:7786 (SVG stroke)
    avatarDiscInner: Color(0xFF4B675E), // Figma 337:7923 — same as light
    avatarDiscOuter: Color(0xFF95CDBB), // Figma 337:7923 — same as light
    avatarBadgeGlyph: Color(0xFFFCFBF9), // Figma 337:7926
    avatarSheetHandle: Color(0xFFFCFBF9), // Figma 337:8136
    avatarSheetDivider: Color(0x994B675E), // Figma 337:8137 — same as light
    settingsRowLabel: Color(0xFFFCFBF9), // Figma 642:8586
    settingsToggleOnTrack: Brand.purplePrimary, // #AE87E7 — Figma 642:8587
    settingsToggleOffTrack: Color(0xFFB3B3B3), // not designed — same as light
    settingsToggleKnob: Color(0xFFFFFFFF), // Figma 642:8588
    flashcardProgressFill: Brand.purplePrimary, // #AE87E7 — Figma 349:15348
    flashcardCardFill: Color(0xFFFCFBF9), // Figma 337:14513 — stays light
    flashcardCardText: Brand.greenPrimary, // #384F47 — Figma 337:14513 (text)
    // Not designed — 337:14475 has no restart button. The dark primary accent
    // (its primary button, 349:15308) stands in; DESIGN_ISSUES.
    flashcardAgainFill: Brand.purplePrimary,
    flashcardAgainGlyph: Color(0xFFFCFBF9), // = light; button not designed
    // Not designed — no dark Setup frame. The dark quiz setup's chip fill
    // (337:6239) stands in.
    flashcardSetupPillFill: Color(0xFF27282C),
    // Not designed — the dark counterpart of the light ink #384F47.
    flashcardSetupPillBorder: Color(0xFFFCFBF9),
    flashcardSetupPillText: Color(0xFFFCFBF9), // the dark quiz setup chip label
    // Not designed — mutedText's value, the app's de-emphasised small text.
    flashcardSetupHelper: Color(0xFFB3B3B3),
    // Not designed — otpErrorText's dark value (337:19294), the app's existing
    // dark error text; quizWrongBorder is 1.7:1 here. DESIGN_ISSUES #119.
    flashcardGradeError: Color(0xFFFF465C),
    // Same in both palettes. The first four are semantic (selection, medal
    // order) and must not flip with the theme. podiumThirdRing is a light
    // value carried across (`337:5563` not read); the three badge values were
    // read off `337:5577` on 2026-09-25 and match light.
    podiumAccent: Color(0xFFDBB0FF), // Figma 337:5638
    podiumOnAccent: Color(0xFFFCFBF9),
    podiumFirstRing: Color(0xFFFFCA28),
    podiumSecondRing: Color(0xFFFF8228),
    podiumThirdRing: Color(0xFFDEDEDE),
    podiumBadgeIdle: Color(0xFFF4F4F4), // Figma 337:5582
    podiumSecondBadgeBorder: Color(0xFFDC4A22), // Figma 337:5582 stroke
    podiumThirdBadgeFill: Color(0xFFFCFBF9), // Figma 337:5579
    // --- Elevation pass (edit1.md section 8.1) ---
    // Most of these are a neutral at 20% alpha: the dark canvas elevates with
    // a translucent wash under Glass, not with an opaque card.
    backChipSurfaceFill: Color(0x3327282C), // #27282C @20% — Figma 404:7424
    registrationBackChipFill: Color(0x33333439), // #333439 @20% — 337:19690
    languagePillFill: Color(0x33232428), // #232428 @20% — Figma 340:19734
    brandLogo: Color(0xFFFCFBF9), // Figma 337:15678 (SVG export fill)
    homeBellFill: Color(0x33232428), // #232428 @20% — Figma 337:5330
    dailyTasksFill: Color(0x33242329), // #242329 @20% — Figma 337:5357
    dailyTasksBorder: null, // Figma 337:5357 — the dark stroke is hidden
    topStudentFill: Color(0x3326272B), // #26272B @20% — Figma 337:5460
    topStudentBorder: Color.fromRGBO(124, 58, 237, 0.1), // Figma 337:5460
    topStudentName: Color(0xFFFCFBF9), // Figma 337:5466
    topStudentPoints: Color(0xFFAE87E7), // Figma 337:5468
    continueLearningFillSchool: Color(0xFFC4A8E3), // school Home, dark
    continueLearningFillUniversity: Color(0xFFDBB0FF), // same as light
    subjectSearchFill: Color(0x33232428), // #232428 @20% — Figma 337:5724
    subjectSearchTopBorder: null, // no top hairline in the dark frame
    subjectCardFill: Color(0xFF27282C), // Figma 337:5732 — opaque
    subjectCardTitle: Color(0xFFFCFBF9), // Figma 337:5739
    subjectCardChevron: Color(0xFFFCFBF9), // Figma 337:5740 (SVG fill)
    subjectCardProgress: Color(0xFFAE87E7), // Figma 337:5745
    mistakesPillFill: Color(0x33565656), // #565656 @20% — Figma 404:7421
    mistakesPillAccent: Color(0xFFEF4444), // Figma 404:7421
    treeRowFill: Color(0xFF27282C), // Figma 337:5926
    treeRowBorder: Color(0xFFFCFBF9), // Figma 337:5926
    treeRowBadgeFill: Color(0x3327282C), // #27282C @20% — Figma 337:5926
    treeRowChevron: Color(0xFFFCFBF9), // Figma 337:5938 (SVG stroke)
    treeRowProgress: Color(0xFFAE87E7), // Figma 337:5936
    pillTrackFill: Color(0xFF232429), // Figma 337:8177
    pillTrackSelectedFill: Brand.purplePrimary, // #AE87E7 — same in both
    pillTrackLabel: Color(0xFFFCFBF9), // Figma 337:11091
    pillTrackSelectedLabel: Color(0xFFFCFBF9), // Figma 337:11095
    continueLearningContent: Color(0xFF2B2B2B), // Figma 337:5435 — as light
    aiPanelOuterFill: Color(0x3327282C), // #27282C @20% — Figma 337:9270
    aiPanelOuterBorder: null, // no outer hairline in the dark frame
    aiPanelCardFill: Color(0x331A1A1A), // #1A1A1A @20% — Figma 337:9279
    quizPrevButtonFill: Color(0x3327282C), // #27282C @20% — Figma 337:6464
    quizPrevButtonGlyph: Color(0xFFFCFBF9), // Figma 337:6466
    quizQuestionCardBorder: Color.fromRGBO(174, 135, 231, 0.6), // 337:6434
    quizOptionTileBorder: Color.fromRGBO(174, 135, 231, 0.5), // 337:6440
    quizOptionBadgeRing: Color.fromRGBO(174, 135, 231, 0.5), // 337:6447
    resultCardFill: Color(0x3327282C), // #27282C @20% — 337:6667, 337:6680
    resultStarDiscFill: Color(0x3327282C), // #27282C @20% — Figma 337:6685
    reviewFilterIdleFill: Color(0x3327282C), // #27282C @20% — Figma 337:6827
    // D-010: the frame's alpha, the frame's stroke, G5. All three rows take
    // 20% so that none of them is opaque beside a glassed neighbour.
    reviewRowCorrectFill: Color(0x33BFFFC3), // #BFFFC3 @20% — Figma 337:6731
    reviewRowWrongFill: Color(0x33FFC0C0), // shipped hue @20% — see field doc
    reviewRowSkippedFill: Color(0x3327282C), // #27282C @20% (no frame state)
    scopeTrackFill: Color(0xFF232429), // Figma 337:5615
    scopeIdleLabel: Color(0xFFFCFBF9), // Figma 337:5619
    scopeSelectedFill: Color(0xFFC4A8E3), // Figma 337:5615 segment
    leaderboardRowFill: Color(0x33232428), // #232428 @20% — Figma 337:5630
    leaderboardRowText: Color(0xFFFCFBF9), // Figma 337:5636
    profileHeaderFill: Color(0x3327282C), // #27282C @20% — Figma 337:7455
    profileEditChipFill: Color(0x33232428), // #232428 @20% — Figma 337:7466
    profileStatFill: Color(0xFF27282C), // Figma 661:8579 — opaque
    profileMenuRowFill: Color(0x3327282C), // #27282C @20% — Figma 337:7479
    profileMenuRowBorder: null, // Figma 337:7479 — no hairline in dark
    profileMenuEmphasisRowBorder: null, // Figma 337:7433 — none in dark either
    profileMenuIconDiscFill: Color(0x3327282C), // #27282C @20% — 337:7480
    profileEditChipGlyph: Color(0xFFFCFBF9), // Figma 337:7466
    avatarBadgeFill: Color(0x33FCFBF9), // #FCFBF9 @20% — Figma 337:7925
    settingsSectionFill: Color(0x3327282C), // #27282C @20% — Figma 337:8195
    settingsSectionBorder: null, // no hairline in the dark frame
    otpTimerFill: Color(0xFF232428), // Figma 337:19503
    otpCardFill: Color(0xFF232428), // Figma 337:19501
    otpCardGlow: Color.fromRGBO(174, 135, 231, 0.25), // Figma 337:19501
    otpDigitFill: Color(0x33232428), // #232428 @20% — Rectangle 104-107
    otpDigitBorder: Color(0xFFD1D1D1), // same in both canvases
    otpTimerContent: Color(0xFFFCFBF9), // Figma 337:19503
    otpErrorText: Color(0xFFFF465C), // Figma 337:19294
    otpDigitErrorBorder: Color(0x80EB001B), // Figma 337:19287
    trackCardFill: Color(0x33232428), // #232428 @20% — Figma 337:15981
    // The same black on both canvases — `337:15981` draws the identical
    // layer, which is unusual enough in this wave to be worth the comment.
    trackCardArtShadow: Color.fromRGBO(0, 0, 0, 0.25), // 337:15981
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
    Color? quizSetupSubject,
    Color? quizSetupScope,
    Color? limitSheetTitle,
    Color? limitSheetClose,
    Color? quizHeaderGlyph,
    Color? quizHeaderRule,
    Color? quizProgressFill,
    Color? quizProgressCounter,
    Color? quizQuestionText,
    Color? aiPanelTitle,
    Color? quizResultTitle,
    Color? quizResultSubtitle,
    Color? resultRingFillFrom,
    Color? resultRingFillTo,
    Color? resultPercentText,
    Color? resultBucketLabel,
    Color? resultRewardsTitle,
    Color? resultStarGlyph,
    Color? resultPointsValue,
    Color? resultPointsUnit,
    Color? quizReviewTitle,
    Color? reviewFilterIdleLabel,
    Color? reviewRowLabel,
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
    Color? mistakesCardChevron,
    Color? mistakesRowChevron,
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
    Color? destructive,
    Color? dialogNote,
    Color? profileDialogClose,
    Color? avatarDiscInner,
    Color? avatarDiscOuter,
    Color? avatarBadgeGlyph,
    Color? avatarSheetHandle,
    Color? avatarSheetDivider,
    Color? settingsRowLabel,
    Color? settingsToggleOnTrack,
    Color? settingsToggleOffTrack,
    Color? settingsToggleKnob,
    Color? flashcardProgressFill,
    Color? flashcardCardFill,
    Color? flashcardCardText,
    Color? flashcardAgainFill,
    Color? flashcardAgainGlyph,
    Color? flashcardSetupPillFill,
    Color? flashcardSetupPillBorder,
    Color? flashcardSetupPillText,
    Color? flashcardSetupHelper,
    Color? flashcardGradeError,
    Color? podiumAccent,
    Color? podiumOnAccent,
    Color? podiumFirstRing,
    Color? podiumSecondRing,
    Color? podiumThirdRing,
    Color? podiumBadgeIdle,
    Color? podiumSecondBadgeBorder,
    Color? podiumThirdBadgeFill,
    Color? backChipSurfaceFill,
    Color? registrationBackChipFill,
    Color? languagePillFill,
    Color? brandLogo,
    Color? homeBellFill,
    Color? dailyTasksFill,
    Color? dailyTasksBorder,
    Color? topStudentFill,
    Color? topStudentBorder,
    Color? topStudentName,
    Color? topStudentPoints,
    Color? continueLearningFillSchool,
    Color? continueLearningFillUniversity,
    Color? subjectSearchFill,
    Color? subjectSearchTopBorder,
    Color? subjectCardFill,
    Color? subjectCardTitle,
    Color? subjectCardChevron,
    Color? subjectCardProgress,
    Color? mistakesPillFill,
    Color? mistakesPillAccent,
    Color? treeRowFill,
    Color? treeRowBorder,
    Color? treeRowBadgeFill,
    Color? treeRowChevron,
    Color? treeRowProgress,
    Color? pillTrackFill,
    Color? pillTrackSelectedFill,
    Color? pillTrackLabel,
    Color? pillTrackSelectedLabel,
    Color? continueLearningContent,
    Color? aiPanelOuterFill,
    Color? aiPanelOuterBorder,
    Color? aiPanelCardFill,
    Color? quizPrevButtonFill,
    Color? quizPrevButtonGlyph,
    Color? quizQuestionCardBorder,
    Color? quizOptionTileBorder,
    Color? quizOptionBadgeRing,
    Color? resultCardFill,
    Color? resultStarDiscFill,
    Color? reviewFilterIdleFill,
    Color? reviewRowCorrectFill,
    Color? reviewRowWrongFill,
    Color? reviewRowSkippedFill,
    Color? scopeTrackFill,
    Color? scopeIdleLabel,
    Color? scopeSelectedFill,
    Color? leaderboardRowFill,
    Color? leaderboardRowText,
    Color? profileHeaderFill,
    Color? profileEditChipFill,
    Color? profileStatFill,
    Color? profileMenuRowFill,
    Color? profileMenuRowBorder,
    Color? profileMenuEmphasisRowBorder,
    Color? profileMenuIconDiscFill,
    Color? profileEditChipGlyph,
    Color? avatarBadgeFill,
    Color? settingsSectionFill,
    Color? settingsSectionBorder,
    Color? otpTimerFill,
    Color? otpCardFill,
    Color? otpCardGlow,
    Color? otpDigitFill,
    Color? otpDigitBorder,
    Color? otpTimerContent,
    Color? otpErrorText,
    Color? otpDigitErrorBorder,
    Color? trackCardFill,
    Color? trackCardArtShadow,
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
      quizSetupSubject: quizSetupSubject ?? this.quizSetupSubject,
      quizSetupScope: quizSetupScope ?? this.quizSetupScope,
      limitSheetTitle: limitSheetTitle ?? this.limitSheetTitle,
      limitSheetClose: limitSheetClose ?? this.limitSheetClose,
      quizHeaderGlyph: quizHeaderGlyph ?? this.quizHeaderGlyph,
      quizHeaderRule: quizHeaderRule ?? this.quizHeaderRule,
      quizProgressFill: quizProgressFill ?? this.quizProgressFill,
      quizProgressCounter: quizProgressCounter ?? this.quizProgressCounter,
      quizQuestionText: quizQuestionText ?? this.quizQuestionText,
      aiPanelTitle: aiPanelTitle ?? this.aiPanelTitle,
      quizResultTitle: quizResultTitle ?? this.quizResultTitle,
      quizResultSubtitle: quizResultSubtitle ?? this.quizResultSubtitle,
      resultRingFillFrom: resultRingFillFrom ?? this.resultRingFillFrom,
      resultRingFillTo: resultRingFillTo ?? this.resultRingFillTo,
      resultPercentText: resultPercentText ?? this.resultPercentText,
      resultBucketLabel: resultBucketLabel ?? this.resultBucketLabel,
      resultRewardsTitle: resultRewardsTitle ?? this.resultRewardsTitle,
      resultStarGlyph: resultStarGlyph ?? this.resultStarGlyph,
      resultPointsValue: resultPointsValue ?? this.resultPointsValue,
      resultPointsUnit: resultPointsUnit ?? this.resultPointsUnit,
      quizReviewTitle: quizReviewTitle ?? this.quizReviewTitle,
      reviewFilterIdleLabel:
          reviewFilterIdleLabel ?? this.reviewFilterIdleLabel,
      reviewRowLabel: reviewRowLabel ?? this.reviewRowLabel,
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
      mistakesCardChevron: mistakesCardChevron ?? this.mistakesCardChevron,
      mistakesRowChevron: mistakesRowChevron ?? this.mistakesRowChevron,
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
      destructive: destructive ?? this.destructive,
      dialogNote: dialogNote ?? this.dialogNote,
      profileDialogClose: profileDialogClose ?? this.profileDialogClose,
      avatarDiscInner: avatarDiscInner ?? this.avatarDiscInner,
      avatarDiscOuter: avatarDiscOuter ?? this.avatarDiscOuter,
      avatarBadgeGlyph: avatarBadgeGlyph ?? this.avatarBadgeGlyph,
      avatarSheetHandle: avatarSheetHandle ?? this.avatarSheetHandle,
      avatarSheetDivider: avatarSheetDivider ?? this.avatarSheetDivider,
      settingsRowLabel: settingsRowLabel ?? this.settingsRowLabel,
      settingsToggleOnTrack:
          settingsToggleOnTrack ?? this.settingsToggleOnTrack,
      settingsToggleOffTrack:
          settingsToggleOffTrack ?? this.settingsToggleOffTrack,
      settingsToggleKnob: settingsToggleKnob ?? this.settingsToggleKnob,
      flashcardProgressFill:
          flashcardProgressFill ?? this.flashcardProgressFill,
      flashcardCardFill: flashcardCardFill ?? this.flashcardCardFill,
      flashcardCardText: flashcardCardText ?? this.flashcardCardText,
      flashcardAgainFill: flashcardAgainFill ?? this.flashcardAgainFill,
      flashcardAgainGlyph: flashcardAgainGlyph ?? this.flashcardAgainGlyph,
      flashcardSetupPillFill:
          flashcardSetupPillFill ?? this.flashcardSetupPillFill,
      flashcardSetupPillBorder:
          flashcardSetupPillBorder ?? this.flashcardSetupPillBorder,
      flashcardSetupPillText:
          flashcardSetupPillText ?? this.flashcardSetupPillText,
      flashcardSetupHelper: flashcardSetupHelper ?? this.flashcardSetupHelper,
      flashcardGradeError: flashcardGradeError ?? this.flashcardGradeError,
      podiumAccent: podiumAccent ?? this.podiumAccent,
      podiumOnAccent: podiumOnAccent ?? this.podiumOnAccent,
      podiumFirstRing: podiumFirstRing ?? this.podiumFirstRing,
      podiumSecondRing: podiumSecondRing ?? this.podiumSecondRing,
      podiumThirdRing: podiumThirdRing ?? this.podiumThirdRing,
      podiumBadgeIdle: podiumBadgeIdle ?? this.podiumBadgeIdle,
      podiumSecondBadgeBorder:
          podiumSecondBadgeBorder ?? this.podiumSecondBadgeBorder,
      podiumThirdBadgeFill: podiumThirdBadgeFill ?? this.podiumThirdBadgeFill,
      backChipSurfaceFill: backChipSurfaceFill ?? this.backChipSurfaceFill,
      registrationBackChipFill:
          registrationBackChipFill ?? this.registrationBackChipFill,
      languagePillFill: languagePillFill ?? this.languagePillFill,
      brandLogo: brandLogo ?? this.brandLogo,
      homeBellFill: homeBellFill ?? this.homeBellFill,
      dailyTasksFill: dailyTasksFill ?? this.dailyTasksFill,
      // As with languagePillBorder above, `??` cannot CLEAR these light-only
      // borders — dark takes its nulls from the palette, not from a copyWith.
      dailyTasksBorder: dailyTasksBorder ?? this.dailyTasksBorder,
      topStudentFill: topStudentFill ?? this.topStudentFill,
      topStudentBorder: topStudentBorder ?? this.topStudentBorder,
      topStudentName: topStudentName ?? this.topStudentName,
      topStudentPoints: topStudentPoints ?? this.topStudentPoints,
      continueLearningFillSchool:
          continueLearningFillSchool ?? this.continueLearningFillSchool,
      continueLearningFillUniversity:
          continueLearningFillUniversity ?? this.continueLearningFillUniversity,
      subjectSearchFill: subjectSearchFill ?? this.subjectSearchFill,
      subjectSearchTopBorder:
          subjectSearchTopBorder ?? this.subjectSearchTopBorder,
      subjectCardFill: subjectCardFill ?? this.subjectCardFill,
      subjectCardTitle: subjectCardTitle ?? this.subjectCardTitle,
      subjectCardChevron: subjectCardChevron ?? this.subjectCardChevron,
      subjectCardProgress: subjectCardProgress ?? this.subjectCardProgress,
      mistakesPillFill: mistakesPillFill ?? this.mistakesPillFill,
      mistakesPillAccent: mistakesPillAccent ?? this.mistakesPillAccent,
      treeRowFill: treeRowFill ?? this.treeRowFill,
      treeRowBorder: treeRowBorder ?? this.treeRowBorder,
      treeRowBadgeFill: treeRowBadgeFill ?? this.treeRowBadgeFill,
      treeRowChevron: treeRowChevron ?? this.treeRowChevron,
      treeRowProgress: treeRowProgress ?? this.treeRowProgress,
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
      quizPrevButtonGlyph: quizPrevButtonGlyph ?? this.quizPrevButtonGlyph,
      quizQuestionCardBorder:
          quizQuestionCardBorder ?? this.quizQuestionCardBorder,
      quizOptionTileBorder: quizOptionTileBorder ?? this.quizOptionTileBorder,
      quizOptionBadgeRing: quizOptionBadgeRing ?? this.quizOptionBadgeRing,
      resultCardFill: resultCardFill ?? this.resultCardFill,
      resultStarDiscFill: resultStarDiscFill ?? this.resultStarDiscFill,
      reviewFilterIdleFill: reviewFilterIdleFill ?? this.reviewFilterIdleFill,
      reviewRowCorrectFill: reviewRowCorrectFill ?? this.reviewRowCorrectFill,
      reviewRowWrongFill: reviewRowWrongFill ?? this.reviewRowWrongFill,
      reviewRowSkippedFill: reviewRowSkippedFill ?? this.reviewRowSkippedFill,
      scopeTrackFill: scopeTrackFill ?? this.scopeTrackFill,
      scopeIdleLabel: scopeIdleLabel ?? this.scopeIdleLabel,
      scopeSelectedFill: scopeSelectedFill ?? this.scopeSelectedFill,
      leaderboardRowFill: leaderboardRowFill ?? this.leaderboardRowFill,
      leaderboardRowText: leaderboardRowText ?? this.leaderboardRowText,
      profileHeaderFill: profileHeaderFill ?? this.profileHeaderFill,
      profileEditChipFill: profileEditChipFill ?? this.profileEditChipFill,
      profileStatFill: profileStatFill ?? this.profileStatFill,
      profileMenuRowFill: profileMenuRowFill ?? this.profileMenuRowFill,
      profileMenuRowBorder: profileMenuRowBorder ?? this.profileMenuRowBorder,
      profileMenuEmphasisRowBorder:
          profileMenuEmphasisRowBorder ?? this.profileMenuEmphasisRowBorder,
      profileMenuIconDiscFill:
          profileMenuIconDiscFill ?? this.profileMenuIconDiscFill,
      profileEditChipGlyph: profileEditChipGlyph ?? this.profileEditChipGlyph,
      avatarBadgeFill: avatarBadgeFill ?? this.avatarBadgeFill,
      settingsSectionFill: settingsSectionFill ?? this.settingsSectionFill,
      settingsSectionBorder:
          settingsSectionBorder ?? this.settingsSectionBorder,
      otpTimerFill: otpTimerFill ?? this.otpTimerFill,
      otpCardFill: otpCardFill ?? this.otpCardFill,
      otpCardGlow: otpCardGlow ?? this.otpCardGlow,
      otpDigitFill: otpDigitFill ?? this.otpDigitFill,
      otpDigitBorder: otpDigitBorder ?? this.otpDigitBorder,
      otpTimerContent: otpTimerContent ?? this.otpTimerContent,
      otpErrorText: otpErrorText ?? this.otpErrorText,
      otpDigitErrorBorder: otpDigitErrorBorder ?? this.otpDigitErrorBorder,
      trackCardFill: trackCardFill ?? this.trackCardFill,
      trackCardArtShadow: trackCardArtShadow ?? this.trackCardArtShadow,
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
      quizSetupSubject: Color.lerp(
        quizSetupSubject,
        other.quizSetupSubject,
        t,
      )!,
      quizSetupScope: Color.lerp(quizSetupScope, other.quizSetupScope, t)!,
      limitSheetTitle: Color.lerp(limitSheetTitle, other.limitSheetTitle, t)!,
      limitSheetClose: Color.lerp(limitSheetClose, other.limitSheetClose, t)!,
      quizHeaderGlyph: Color.lerp(quizHeaderGlyph, other.quizHeaderGlyph, t)!,
      quizHeaderRule: Color.lerp(quizHeaderRule, other.quizHeaderRule, t)!,
      quizProgressFill: Color.lerp(
        quizProgressFill,
        other.quizProgressFill,
        t,
      )!,
      quizProgressCounter: Color.lerp(
        quizProgressCounter,
        other.quizProgressCounter,
        t,
      )!,
      quizQuestionText: Color.lerp(
        quizQuestionText,
        other.quizQuestionText,
        t,
      )!,
      aiPanelTitle: Color.lerp(aiPanelTitle, other.aiPanelTitle, t)!,
      quizResultTitle: Color.lerp(quizResultTitle, other.quizResultTitle, t)!,
      quizResultSubtitle: Color.lerp(
        quizResultSubtitle,
        other.quizResultSubtitle,
        t,
      )!,
      resultRingFillFrom: Color.lerp(
        resultRingFillFrom,
        other.resultRingFillFrom,
        t,
      )!,
      resultRingFillTo: Color.lerp(
        resultRingFillTo,
        other.resultRingFillTo,
        t,
      )!,
      resultPercentText: Color.lerp(
        resultPercentText,
        other.resultPercentText,
        t,
      )!,
      resultBucketLabel: Color.lerp(
        resultBucketLabel,
        other.resultBucketLabel,
        t,
      )!,
      resultRewardsTitle: Color.lerp(
        resultRewardsTitle,
        other.resultRewardsTitle,
        t,
      )!,
      resultStarGlyph: Color.lerp(resultStarGlyph, other.resultStarGlyph, t)!,
      resultPointsValue: Color.lerp(
        resultPointsValue,
        other.resultPointsValue,
        t,
      )!,
      resultPointsUnit: Color.lerp(
        resultPointsUnit,
        other.resultPointsUnit,
        t,
      )!,
      quizReviewTitle: Color.lerp(quizReviewTitle, other.quizReviewTitle, t)!,
      reviewFilterIdleLabel: Color.lerp(
        reviewFilterIdleLabel,
        other.reviewFilterIdleLabel,
        t,
      )!,
      reviewRowLabel: Color.lerp(reviewRowLabel, other.reviewRowLabel, t)!,
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
      mistakesCardChevron: Color.lerp(
        mistakesCardChevron,
        other.mistakesCardChevron,
        t,
      )!,
      mistakesRowChevron: Color.lerp(
        mistakesRowChevron,
        other.mistakesRowChevron,
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
      // Identical endpoints — destructive does not move across a theme
      // animation, which is the exemption made visible (as with successBadge).
      destructive: Color.lerp(destructive, other.destructive, t)!,
      dialogNote: Color.lerp(dialogNote, other.dialogNote, t)!,
      profileDialogClose: Color.lerp(
        profileDialogClose,
        other.profileDialogClose,
        t,
      )!,
      avatarDiscInner: Color.lerp(avatarDiscInner, other.avatarDiscInner, t)!,
      avatarDiscOuter: Color.lerp(avatarDiscOuter, other.avatarDiscOuter, t)!,
      avatarBadgeGlyph: Color.lerp(
        avatarBadgeGlyph,
        other.avatarBadgeGlyph,
        t,
      )!,
      avatarSheetHandle: Color.lerp(
        avatarSheetHandle,
        other.avatarSheetHandle,
        t,
      )!,
      avatarSheetDivider: Color.lerp(
        avatarSheetDivider,
        other.avatarSheetDivider,
        t,
      )!,
      settingsRowLabel: Color.lerp(
        settingsRowLabel,
        other.settingsRowLabel,
        t,
      )!,
      settingsToggleOnTrack: Color.lerp(
        settingsToggleOnTrack,
        other.settingsToggleOnTrack,
        t,
      )!,
      settingsToggleOffTrack: Color.lerp(
        settingsToggleOffTrack,
        other.settingsToggleOffTrack,
        t,
      )!,
      settingsToggleKnob: Color.lerp(
        settingsToggleKnob,
        other.settingsToggleKnob,
        t,
      )!,
      flashcardProgressFill: Color.lerp(
        flashcardProgressFill,
        other.flashcardProgressFill,
        t,
      )!,
      flashcardCardFill: Color.lerp(
        flashcardCardFill,
        other.flashcardCardFill,
        t,
      )!,
      flashcardCardText: Color.lerp(
        flashcardCardText,
        other.flashcardCardText,
        t,
      )!,
      flashcardAgainFill: Color.lerp(
        flashcardAgainFill,
        other.flashcardAgainFill,
        t,
      )!,
      flashcardAgainGlyph: Color.lerp(
        flashcardAgainGlyph,
        other.flashcardAgainGlyph,
        t,
      )!,
      flashcardSetupPillFill: Color.lerp(
        flashcardSetupPillFill,
        other.flashcardSetupPillFill,
        t,
      )!,
      flashcardSetupPillBorder: Color.lerp(
        flashcardSetupPillBorder,
        other.flashcardSetupPillBorder,
        t,
      )!,
      flashcardSetupPillText: Color.lerp(
        flashcardSetupPillText,
        other.flashcardSetupPillText,
        t,
      )!,
      flashcardSetupHelper: Color.lerp(
        flashcardSetupHelper,
        other.flashcardSetupHelper,
        t,
      )!,
      flashcardGradeError: Color.lerp(
        flashcardGradeError,
        other.flashcardGradeError,
        t,
      )!,
      // Black → cream is the widest travel of any token here, so a theme
      // animation passes through a mid grey. Correct: the shadow fades out as
      // the canvas darkens and fades back in as a rim light.
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
      podiumSecondBadgeBorder: Color.lerp(
        podiumSecondBadgeBorder,
        other.podiumSecondBadgeBorder,
        t,
      )!,
      podiumThirdBadgeFill: Color.lerp(
        podiumThirdBadgeFill,
        other.podiumThirdBadgeFill,
        t,
      )!,
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
      brandLogo: Color.lerp(brandLogo, other.brandLogo, t)!,
      homeBellFill: Color.lerp(homeBellFill, other.homeBellFill, t)!,
      dailyTasksFill: Color.lerp(dailyTasksFill, other.dailyTasksFill, t)!,
      // Nullable, like languagePillBorder: Color.lerp fades a light-only
      // border out to transparent, which is what a vanishing stroke should do.
      dailyTasksBorder: Color.lerp(dailyTasksBorder, other.dailyTasksBorder, t),
      topStudentFill: Color.lerp(topStudentFill, other.topStudentFill, t)!,
      topStudentBorder: Color.lerp(
        topStudentBorder,
        other.topStudentBorder,
        t,
      )!,
      topStudentName: Color.lerp(topStudentName, other.topStudentName, t)!,
      topStudentPoints: Color.lerp(
        topStudentPoints,
        other.topStudentPoints,
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
      subjectCardTitle: Color.lerp(
        subjectCardTitle,
        other.subjectCardTitle,
        t,
      )!,
      subjectCardChevron: Color.lerp(
        subjectCardChevron,
        other.subjectCardChevron,
        t,
      )!,
      subjectCardProgress: Color.lerp(
        subjectCardProgress,
        other.subjectCardProgress,
        t,
      )!,
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
      treeRowChevron: Color.lerp(treeRowChevron, other.treeRowChevron, t)!,
      treeRowProgress: Color.lerp(treeRowProgress, other.treeRowProgress, t)!,
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
      quizPrevButtonGlyph: Color.lerp(
        quizPrevButtonGlyph,
        other.quizPrevButtonGlyph,
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
      quizOptionBadgeRing: Color.lerp(
        quizOptionBadgeRing,
        other.quizOptionBadgeRing,
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
      reviewRowCorrectFill: Color.lerp(
        reviewRowCorrectFill,
        other.reviewRowCorrectFill,
        t,
      )!,
      reviewRowWrongFill: Color.lerp(
        reviewRowWrongFill,
        other.reviewRowWrongFill,
        t,
      )!,
      reviewRowSkippedFill: Color.lerp(
        reviewRowSkippedFill,
        other.reviewRowSkippedFill,
        t,
      )!,
      scopeTrackFill: Color.lerp(scopeTrackFill, other.scopeTrackFill, t)!,
      scopeIdleLabel: Color.lerp(scopeIdleLabel, other.scopeIdleLabel, t)!,
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
      leaderboardRowText: Color.lerp(
        leaderboardRowText,
        other.leaderboardRowText,
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
      profileMenuEmphasisRowBorder: Color.lerp(
        profileMenuEmphasisRowBorder,
        other.profileMenuEmphasisRowBorder,
        t,
      ),
      profileMenuIconDiscFill: Color.lerp(
        profileMenuIconDiscFill,
        other.profileMenuIconDiscFill,
        t,
      )!,
      profileEditChipGlyph: Color.lerp(
        profileEditChipGlyph,
        other.profileEditChipGlyph,
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
      otpTimerContent: Color.lerp(otpTimerContent, other.otpTimerContent, t)!,
      otpErrorText: Color.lerp(otpErrorText, other.otpErrorText, t)!,
      otpDigitErrorBorder: Color.lerp(
        otpDigitErrorBorder,
        other.otpDigitErrorBorder,
        t,
      )!,
      trackCardFill: Color.lerp(trackCardFill, other.trackCardFill, t)!,
      trackCardArtShadow: Color.lerp(
        trackCardArtShadow,
        other.trackCardArtShadow,
        t,
      )!,
      backlight: Color.lerp(backlight, other.backlight, t)!,
    );
  }
}
