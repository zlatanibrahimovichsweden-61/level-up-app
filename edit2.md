# Edit 2 — Shared chrome & controls: nav bar, CTAs, back chips, language pill, fields, onboarding sheet, scrims & dialogs

> Self-contained implementation guide. Every Figma value is repeated here. Token names refer to
> `AppElevation` / `AppColors` entries that **edit1.md** adds. If edit1 shipped a name slightly
> differently, use the shipped equivalent; never add a parallel token or primitive.
>
> Figma file `P6044i0giD9TmdQ7C2AmLq`, page `design`. Written 2026-09-17.

---

## 0. Pre-flight

1. Read `CLAUDE.md`, `docs/WAVE_STATUS.md`, `docs/AGENT_WORKFLOW.md` § "Theme discipline", and the
   **Design rules R1–R10 in `edit1.md` §4**. Those rules apply here verbatim: σ = blur/2, knockout
   outer shadows, Glass = tint + frost + rim light, back-lights part of the covering surface, RTL
   handling, disabled at 0.45.
2. **edit1 must be in the tree.** Confirm that `lib/core/theme/app_elevation.dart`,
   `lib/core/widgets/elevation/elevated_surface.dart` and the guard test
   `raw elevation effects do not increase` exist. If not, stop and implement `edit1.md` first.
3. `git status --short`. Files this edit touches that other work may have dirtied:
   `lib/core/theme/app_theme.dart`, `lib/features/auth/screens/login_screen.dart`,
   `lib/features/profile/widgets/*`, `lib/features/quiz/widgets/limit_sheet.dart`. Never discard
   foreign hunks. Ask the owner if unsure.
4. Run `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` and record the passing count.
5. Do not commit unless asked (then: Conventional Commits, one concern per commit, only your files).

## 1. Scope

| # | Item | Files |
|---|---|---|
| 2 | Bottom nav bar per-theme shadow | `lib/features/shell/main_shell.dart` |
| 8 | Back chips: `CircleBackButton` + `CatalogHeader`'s inline chip | `lib/core/widgets/circle_back_button.dart`, `lib/features/catalog/widgets/catalog_scaffold.dart`, registration call sites |
| 12 | Primary CTA shadow + dark lavender glow, via edit1's `PrimaryCta` wrapper | `login_screen.dart`, `onboarding_screen.dart`, `profile_confirm_dialog.dart`, `signup_identity_screen.dart`, `signup_track_screen.dart` (CTA only), `school_detail_screen.dart`, `university_detail_screen.dart` |
| 13 | Outline CTA shadow | `lib/features/auth/screens/login_screen.dart`, `lib/features/onboarding/screens/onboarding_screen.dart` |
| 18 | Limit sheet scrim (light; dark **blocked**) | `lib/features/quiz/widgets/limit_sheet.dart` |
| 26 | Form fields (dark Glass + hairline) | `lib/core/widgets/form_fields.dart`, `login_screen.dart` `_PhoneField`, `lib/features/registration/screens/signup_identity_screen.dart` |
| 27 | Avatar-sheet & dialog scrims, dialog/sheet surfaces, dialog button shadows | new `lib/core/widgets/elevation/app_modal.dart`, `lib/features/profile/widgets/avatar_sheets.dart`, `lib/features/profile/widgets/profile_confirm_dialog.dart`, `app_theme.dart` dialog/date-picker surfaces |
| 29 | Onboarding sheet (shadow + Glass in **both** themes) | `onboarding_screen.dart` |
| 33 | Language pill (dark Glass, light hairline width) | `lib/core/widgets/language_pill.dart` |

**Owned elsewhere (do not implement here):**

| Item | Owner |
|---|---|
| OTP timer pill, OTP code card, OTP digit boxes | edit5 |
| Sign-up track card (`_TrackCard` in `signup_track_screen.dart`) | edit5. This edit only changes the `CircleBackButton` call in that file. |
| "Leave quiz?" dialog (`quiz_screen.dart`) | edit4, using the `showAppDialog` added here |
| "Discard changes?" dialog (`edit_profile_screen.dart`) | edit5, using the `showAppDialog` added here |
| Subjects "Mistakes" pill (an `OutlinedButton` with its own shadow) | edit3. Do not add a theme-wide outlined shadow. |
| Wrapping the quiz CTAs (Start, Confirm/Next/Finish, Review Questions) in `PrimaryCta` | edit4 |
| Wrapping OTP Verify/Continue and Edit Profile Save in `PrimaryCta` | edit5 |

## 2. Objective

Every piece of chrome that appears on many screens matches Figma in both themes:

- **Light:** the measured drop shadows.
- **Dark:** the black shadows Figma keeps, the lavender CTA glow, the Glass pill/chips/fields, and the
  blurred dark scrims.

All of it is built from edit1 tokens and primitives. The raw nav `MaskFilter` and the onboarding
`BoxShadow` disappear (guard ratchet −2).

## 3. Dependencies

- **Depends on:** edit1 (tokens, `ElevatedSurface`, `paintFigmaShadows`, glass painter, guard).
- **Independent of:** edit3, edit4, edit5, which can land before or after this one.
- **Provides to later edits:** `showAppDialog` / `showAppModalSheet` (edit4 and edit5 migrate one
  framework dialog each). CTAs are wrapped call site by call site with edit1's `PrimaryCta`: this
  edit wraps the CTAs in the files it owns, and edits 4/5 wrap theirs. No guide depends on another
  for that. Visual QA of screens owned by edits 3–5 is most meaningful after this edit.

## 4. Design rules (specific to this edit; R1–R10 from edit1 also apply)

- **CTA glow** is a same-shape copy of the button in the button's own fill with **layer blur 8**
  (σ = 4), placed behind it. It exists in **dark only** and only on the purple primary button. The red
  destructive button has the drop shadow and no glow (Figma Logout dialog).
- Shadows and glow of a button paint **outside** its shape only. The button is opaque, so this is
  visually identical to Figma and keeps the ink splash visible.
- A disabled CTA keeps the treatment at the project's 0.45 convention (R10). Figma has no disabled
  state.
- **Dark scrims** blur the page behind them. **Light scrims** never blur, except the Limitation
  sheet's.
- **Dialog and bottom-sheet panels are opaque**: `#FCFBF9` light, `#232428` dark. They are not the
  20% `cardFill`.

## 5. Figma evidence

### #2 — Nav bar

| Theme | Node | Shape | Fill | Shadow |
|---|---|---|---|---|
| Light | nav `59:1264`, `Union` (e.g. `59:1000` on Home) | notched Union (unchanged) | `#FCFBF9` | (0, 2.144) blur 16.08, `rgba(184,184,210,0.5)`, spread 0 |
| Dark | `nav bar_Dark` → `Union` `349:16719` | same | `#212226` | (0, 2.144) blur 12.5, `rgba(124,58,237,0.1)` |

Identical on every light/dark screen in the sweep: Home, Learn ×4, Setup, Quiz, Result, Leaderboard,
Profile, Edit Profile, Settings.

### #8 — Back chips (35×35 circle, `tdesign:service-filled`)

| Where | Light | Dark | Dark Glass |
|---|---|---|---|
| Learn (Subjects/Units/Chapters/Lessons/Lectures), Mistakes, Setup, Result, Leaderboard, Settings, Edit Profile | `#FCFBF9`, drop (0.02833, 0.02833) blur 1.3 black 25% (`90:208`) | `#27282C` @20%, no shadow (`404:7424`) | **G5** frost 4 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0 |
| Registration: Sign Up_1 `337:15875`, Sign Up_2 `337:15947`, School `337:5269`, University `337:10373` | same light | `#333439` @20% (`337:19690`, `337:15896`, `340:19731`, `349:16811`) | **G2** frost 20 · refraction 1.00 · depth 36 · angle 22 · intensity 0.25 · dispersion 0.70 · splay 0.16 |

The OTP frames have **no** back chip in Figma; the build added one (`otp_screen.dart`). It keeps the
standard variant (no evidence for the registration variant).

### #12 — Primary CTA (`Frame 427319502`, r20, full width × 60)

| Theme | Fill | Shadow | Glow layer |
|---|---|---|---|
| Light | `#384F47` (`cs.primary`) | (0.5, 0.5) blur 4 black 25% | none |
| Dark | `#AE87E7` (`cs.primary`) | (0.5, 0.5) blur 4 black 25% (`348:8911`) | `348:8909`: same shape, fill `#AE87E7`, **layer blur 8** (CSS `blur(4px)`) behind the button |

The glow appears on every dark full-width CTA: Onboarding, Log in, OTP, Sign Up_1/2, Setup, Quiz,
Result, Edit Profile Save, Settings Save, Go-to-University dialog. It is **absent** on the two 155×60
buttons of the Logout dialog, where red `Frame 1000003068` and purple `Frame 427319502` have the
shadow only. Flutter's `ProfileConfirmDialog` has a single full-width confirm button: `primary` tone =
Go to University (glow in dark), `destructive` tone = Logout (red, shadow only).

### #13 — Outline CTA (`Frame 427319504`, r20, 60 tall)

| Theme | Onboarding | Log in |
|---|---|---|
| Light | `#FCFBF9` + 0.5 `#384F47`, drop (0.5, 0.5) blur 4 black 25% | same |
| Dark | `#FCFBF9` + 0.5 `#AE87E7`, same drop | `#FCFBF9` + 0.5 `#384F47`, same drop |

The dark fill/border inconsistency is already a documented decision (DESIGN_ISSUES #21/#22): the build
keeps the shipped Login styling on both screens. Do not change colours here, only add the shadow.

### #18 — Limit sheet scrim (Limitation notification, **light only**)

- `Rectangle 6427`: `rgba(49,49,49,0.5)` + `backdrop-filter: blur(5.75px)` (CSS). σ = 5.75 (the CSS
  value is already σ).
- The sheet panel `limitation` (345×515, r22, `#FCFBF9`) has **no** shadow.
- Its benefits card (`Frame 5`, shadow 0.4325/0.4325/3.46) and upgrade CTA are **not built**: the app is
  purchase-silent (adr-049 §3, D-007). Ignore them.
- **Dark: no Limitation frame exists → BLOCKED.** Keep the current default barrier in dark and record
  it (§13).

### #26 — Form fields (`Rectangle 9`, 363×60, r20)

| Theme | Fill | Stroke | Glass |
|---|---|---|---|
| Light | `#FDFDFD` | 1.17338 `#D1D1D1` | none |
| Dark | `#232428` @20% | **0.03** `#FCFBF9` | **G4** frost 0 · refraction 1.00 · depth 53 · angle 28 · intensity 0.25 · dispersion 0.50 · splay 0.97 |

Dark nodes: Edit Profile `348:8659`, `348:8664`, `348:8671`, `348:8716`, `348:8825`; Log in
`337:15718`; Sign Up_1 `337:19636`, `337:19548`, `337:19593`, `337:19679`; School Sign Up_2
`I345:7098;345:6956` … (19 total).

Variants present in Figma but not used by any built field: four Edit Profile fields with a hidden
stroke on G5 (`348:8864` …), and University Sign Up_2 fields `#27282C` @20% on G5 (`337:10408` …).
Use G4 for all built fields and record the variance.

### #27 — Avatar sheets & dialogs

| Surface | Light scrim | Dark scrim | Panel light / dark |
|---|---|---|---|
| Avatar action sheet (Edit Profile #1) | `rgba(49,49,49,0.3)`, no blur | `rgba(49,49,49,0.3)`, σ **14.7** | `Frame 1000003004` 402×246 r22: `#FCFBF9` / `#232428` |
| Choose-avatar sheet (Edit Profile #2) | `rgba(49,49,49,0.3)`, no blur | `rgba(49,49,49,0.3)`, σ **13.4** | `Frame 427319513` 402×246 r22: `#FCFBF9` / `#232428` |
| Logout dialog | `rgba(49,49,49,0.3)`, no blur | `rgba(49,49,49,0.6)`, σ **9.95** | 345×239 r22: `#FCFBF9` / `#232428` |
| Go-to-University dialog | `rgba(49,49,49,0.3)`, no blur | `rgba(49,49,49,0.6)`, σ **10.05** | 345×278 r22: `#FCFBF9` / `#232428` |

- Dialog buttons: drop (0.5, 0.5) blur 4 black 25%, both themes.
- Blur values come from the CSS export (`backdrop-filter: blur(Npx)` = σ); the panel was not readable.

### #29 — Onboarding sheet (`on boarding screen_1`: light `81:92`, dark `337:15146`, RTL `549:28910`)

| Theme | Node | Geometry | Fill | Shadow | Glass |
|---|---|---|---|---|---|
| Light | `459:43873` | 402×413 at y 529, top corners r25 | `#FCFBF9` @20% | (0, −1.5) blur 9.2 black **15%** | **G1** |
| Dark | `337:15643` | same | `#232628` @20% | same black 15% | **G1** |
| RTL (light) | `549:29406` | same | `#FCFBF9` @20% | same | **G1** (same `lightAngle` 37) |

- **G1:** frost 80 · refraction 0.73 · depth 27 · angle 37 · intensity 0.95 · dispersion 0.62 · splay
  0.76.
- The illustration `image 79 [Vectorized]` (419×682 at y −39 light / −19 dark) runs **behind the top of
  the sheet**, down to y 643 / 663.
- The existing code documents a Figma rect `337:19256` (622×138 at (−140, 540)) that blocks the
  illustration behind most of that overlap. Only the sheet's top ~11 px sees the illustration directly;
  the frost blurs it into the sheet.
- The dark CTA glow `337:19258` / `Frame 427319505` is covered by #12.

### #33 — Language pill (`Button / Light`, 78.13×36.1, stadium)

| Theme | Fill | Stroke | Glass |
|---|---|---|---|
| Light (`82:1093`) | `#FCFBF9` | 0.629032 `#4B675E` | none |
| Dark (7 instances) | `#232428` @20% | none | **G3** frost 4 · refraction 0.80 · depth 20 · angle −45 · intensity **0.25** · dispersion 0.50 · splay 0 |

- Dark instances: `340:19734`, `349:16814`, `337:19540` (Log in), `337:19535` and `337:19530` (OTP),
  `337:19522` (Sign Up_1), `337:19693` (Sign Up_2).
- **Resolves** the 2026-09-16 open question "dark language pill drawn two ways". The plugin read shows
  all 7 dark pills with identical fill and Glass; the earlier "solid on OTP" reading was wrong.

## 6. Current Flutter state (SOURCE, 2026-09-17)

- **#2** `main_shell.dart`:
  - `_NavBarPainter` translates by `_shadowOffsetY = 4` and draws with
    `MaskFilter.blur(normal, _shadowSigma = 10)`, colour `ext.navShadow`.
  - `navShadow` is `0x14000000` in both themes, marked "TODO(design), DESIGN_ISSUES #37 open
    question 2".
  - Guard site: the `MaskFilter.blur` line.
  - Goldens: `test/goldens/nav_bar_golden_test.dart` → `nav_bar_{light,dark}_tab{0..4}.png`.
- **#8** back chips:
  - `CircleBackButton`: `Material(color: ext.backChipFill (dark #232428 fallback), CircleBorder)` +
    `InkWell`, 35×35, SVG chevron, no shadow, no Glass. Used by `titled_chrome.dart` (Settings +
    account shells), `leaderboard_screen.dart`, `edit_profile_screen.dart`, `otp_screen.dart`,
    `registration_chrome.dart`, `signup_identity_screen.dart`, `signup_track_screen.dart`.
  - `CatalogHeader` (`catalog_scaffold.dart`) draws its own chip: `Container(cardFill circle)` with a
    Material `Icon(backChevron)` and a `TODO(design-asset)` for the glyph. Tests tap it via
    `find.byIcon(Icons.arrow_back_ios_new)` (`test/features/catalog/catalog_navigation_test.dart:89,93`,
    `test/features/mistakes/mistakes_screens_test.dart:82`).
- **#12** `app_theme.dart` `filledButtonTheme`: fill `primary`, label `#FCFBF9`, disabled at 0.45 /
  0.7, height 60, r20, **no shadow, no glow**. `onboarding_screen.dart` carries a comment that the dark
  glow layer is "Not rendered".
- **#13** Outline CTAs (`login_screen.dart` Create New Account, `onboarding_screen.dart`
  `_LogInButton`): `OutlinedButton.styleFrom(backgroundColor: fieldFill, side 0.5
  secondaryButtonBorder, r20)`, no shadow.
- **#18** `LimitSheet.show`: `showModalBottomSheet(isScrollControlled, showDragHandle)` with the
  default barrier and no blur.
- **#26** fields:
  - `FieldShell`: `Container(fieldFill, Border.all(fieldBorder, 1.17), r20)`; `hasError` → 1.5
    `cs.error`; disabled → `Opacity 0.6`.
  - `login_screen.dart` `_PhoneField` and two inline containers in `signup_identity_screen.dart`
    duplicate that decoration.
  - Dark: opaque-looking 1.17 cream border, no Glass.
- **#27** dialogs and sheets:
  - `ProfileConfirmDialog.show` → `showDialog` (default barrier); `Dialog(backgroundColor:
    ext.cardFill …)`, which in dark is **20% translucent**, a see-through dialog.
  - `dialogTheme` and `datePickerTheme` also use `cardFill`.
  - Avatar sheets → `showModalBottomSheet(backgroundColor: transparent)` + `_SheetCard(color:
    ext.cardFill)`: a 20% translucent panel in dark.
  - No scrim blur anywhere.
- **#29** `_Sheet`:
  - `Container(color: ext.background, BoxShadow(0,−1.5, blurRadius 9.2, elevationShadow@0.15))` →
    `DecoratedBox(sheetFill)`.
  - The opaque full-height background hides the illustration entirely, so no frost can show.
  - Guard site: that `BoxShadow`.
- **#33** `LanguagePill`: `InkWell` → `Container(color: ext.background, Border.all(languagePillBorder)`
  (default width **1.0**; dark border null), stadium r18.05. Goldens
  `language_pill_{light,dark}.png`.

## 7. Required changes

### 7.1 #2 Nav bar

1. In `_NavBarPainter`, replace the translate + `MaskFilter` with
   `paintFigmaShadows(canvas, navBarPath(size), elevation.navBarShadows)`. Keep the path, the fill,
   the clipper and the tab rhythm unchanged. Pass the shadows list into the painter (like `fill`
   today) and include it in `shouldRepaint`.
2. Delete `_shadowOffsetY` / `_shadowSigma`.
3. Delete `AppColors.navShadow`: its only consumer is gone. Remove its field, both palette values, and
   its `copyWith`/`lerp` lines.
4. Update DESIGN_ISSUES #37 open question 2: resolved by the measured values above.
5. Guard: lower the elevation ratchet baseline by 1.

### 7.2 #8 Back chips

1. `CircleBackButton`:
   - Add `final BackChipVariant variant` (enum `standard`, `registration`; default `standard`).
   - Render with `ElevatedSurface(shape: CircleBorder(), width 35, height 35, color:` `standard` →
     `ext.backChipSurfaceFill`, `registration` → `ext.registrationBackChipFill`;
     `shadows: elevation.backChipShadows;` `glass:` `standard` → `elevation.backChipGlass`,
     `registration` → `elevation.registrationBackChipGlass;` `onTap: onPressed)`.
   - Keep the semantics label, chevron asset, RTL flip and size.
2. Pass `variant: BackChipVariant.registration` in `registration_chrome.dart`,
   `signup_identity_screen.dart` and `signup_track_screen.dart`. Change **only** that call.
   `_TrackCard` in the same file belongs to edit5.
3. `CatalogHeader`: replace the inline `Container` chip with
   `CircleBackButton(onPressed: () => context.pop())` (standard). This retires the
   `TODO(design-asset)` Material icon in favour of the shared SVG chevron, as `CircleBackButton`'s doc
   asks ("shared rather than re-declared per screen").
4. Update tests that tapped `Icons.arrow_back_ios_new` to `find.byType(CircleBackButton)`
   (`catalog_navigation_test.dart`, `mistakes_screens_test.dart`).
5. Delete `AppColors.backChipFill` once no reference remains. Keep `backChipGlyph`.

### 7.3 #12 Primary CTA (call-site wrapper)

**Do not use `ButtonStyle.backgroundBuilder` in the theme.** Setting it makes `ButtonStyleButton`
default to `Clip.antiAlias` (SDK 3.44.7), which clips any shadow or glow painted outside the button.
Use edit1's `PrimaryCta` wrapper instead.

1. Wrap each Figma-backed full-width `FilledButton` in the files this edit owns:
   - `login_screen.dart`: Send OTP;
   - `onboarding_screen.dart`: Get Started;
   - `signup_identity_screen.dart`, `signup_track_screen.dart`, `school_detail_screen.dart`,
     `university_detail_screen.dart`: Continue/Submit CTAs;
   - `profile_confirm_dialog.dart`: confirm, with `tone:` destructive → `CtaTone.destructive`
     (shadow, no glow), primary → `CtaTone.primary`.

   Pattern: `PrimaryCta(tone: …, enabled: <same condition as onPressed != null>, child:
   FilledButton(…))`. Change nothing inside the `FilledButton`.
2. **Do not wrap** buttons with no Figma frame: error-state "Retry" buttons (`state_widget.dart`,
   `catalog_states.dart`, `home_screen.dart`, `profile_screen.dart`, `leaderboard_screen.dart`,
   `school_picker_field.dart`), `registration_expired_view.dart`, and the `app_router.dart` fallback.
   Record that list.
3. Confirm no ancestor clips the glow (e.g. dialog padding, a `ClipRRect`). The dialog has 18 dp side
   padding, and the glow extends ~12 dp (3σ). Check the dialog CTA visually.
4. `onboarding_screen.dart`: replace the "glow layer … Not rendered" comment with a pointer to
   `PrimaryCta`.

### 7.4 #13 Outline CTA

Wrap the two `OutlinedButton`s in `PrimaryCta(tone: CtaTone.outline, enabled: …)`:
`login_screen.dart` "Create New Account" and `onboarding_screen.dart` `_LogInButton`. It draws shadows
only. Colours are unchanged (#21/#22). **No** `outlinedButtonTheme` change (the Subjects Mistakes pill
is also an `OutlinedButton`, edit3).

### 7.5 #27 Scrim helpers + dialogs/sheets

1. New `lib/core/widgets/elevation/app_modal.dart`:
   - `Future<T?> showAppDialog<T>({required BuildContext context, required WidgetBuilder builder, ScrimStyle? scrim, bool barrierDismissible = true})`
   - `Future<T?> showAppModalSheet<T>({required BuildContext context, required WidgetBuilder builder, ScrimStyle? scrim, bool isScrollControlled = false, bool showDragHandle = false, Color? backgroundColor})`

   Behaviour contract (test each):
   - `scrim == null` → identical to today's `showDialog` / `showModalBottomSheet`;
   - barrier colour = `scrim.color`;
   - when `scrim.sigma > 0`, the area behind the modal is blurred with that σ (e.g. a full-screen
     `IgnorePointer(BackdropFilter)` layer inside the route, above the barrier colour);
   - barrier tap, system back and drag-to-dismiss (sheets) behave exactly as before;
   - the barrier keeps `MaterialLocalizations.modalBarrierDismissLabel` semantics;
   - route animations unchanged.
2. `ProfileConfirmDialog.show` → `showAppDialog(scrim: tone == destructive ?
   elevation.logoutDialogScrim : elevation.goToUniversityDialogScrim)`. Dialog `backgroundColor` →
   `ext.background` (opaque `#FCFBF9` / `#232428`, Figma panels).
3. `AvatarActionSheet.show` → `showAppModalSheet(scrim: elevation.avatarActionSheetScrim, …)`;
   `ChooseAvatarSheet.show` → `elevation.chooseAvatarSheetScrim`. `_SheetCard` colour → `ext.background`.
4. `app_theme.dart`: `dialogTheme.backgroundColor` and `datePickerTheme.backgroundColor` →
   `ext.background`. Update the existing comments, which explain the unification: the dark value was a
   20% wash, and Figma dialogs are opaque.
5. Dialog button shadows come from 7.3 (full-width confirm button). Nothing else to do.

### 7.6 #18 Limit sheet

`LimitSheet.show` → `showAppModalSheet(isScrollControlled: true, showDragHandle: true, scrim:
elevation.limitSheetScrim)`. `limitSheetScrim` is `null` in dark (**blocked**), so dark stays exactly
as today. Record the gap in DESIGN_ISSUES (§13).

### 7.7 #26 Form fields

1. `FieldShell`: render with `ElevatedSurface(shape: RoundedRectangleBorder(r20), height 60, padding
   start/end 14, color: ext.fieldFill, side: BorderSide(color: hasError ? cs.error : ext.fieldBorder,
   width: hasError ? 1.5 : elevation.fieldBorderWidth), glass: elevation.fieldGlass)`. Keep the
   `DefaultTextStyle`, the `Opacity 0.6` disabled behaviour, the `InkWell` (r20) for `onTap`, and
   semantics.
2. Migrate the duplicated decorations to the same tokens, via `FieldShell` where behaviour-identical,
   otherwise `ElevatedSurface`:
   - `login_screen.dart` `_PhoneField`;
   - `signup_identity_screen.dart`, both inline 60-tall containers.
3. Leave `reference_dropdown.dart` `dropdownColor` and the `school_picker_field.dart` drag handle alone
   (not field surfaces).

### 7.8 #29 Onboarding sheet

1. Reproduce Figma's layering in the onboarding `Stack`: illustration → an opaque `ext.background`
   strip behind the sheet, from the sheet's top edge **+11** to **+149** dp (the documented
   `337:19256` rect, 138 tall starting 11 below the sheet's y 529), full width → the sheet.
   - **Before relying on it, read `337:19256`'s fill on the Properties panel** (Figma desktop, view seat
     works). The code comment assumes the page background. If the fill differs, add it as a token in
     the edit1 style with a node citation. If the node cannot be read, keep today's full-height opaque
     background, skip the `content` backdrop, and record that the frost is not visible.
2. `_Sheet` → `ElevatedSurface(shape: RoundedRectangleBorder(top r25), color: ext.sheetFill, shadows:
   elevation.onboardingSheetShadows, glass: elevation.onboardingSheetGlass, backdrop:
   GlassBackdrop.content)`. The shadow is knocked out behind the 20% fill (R4). **Both themes get
   Glass G1.**
3. Remove the old `Container(BoxShadow …)` and lower the guard ratchet by 1.
4. Keep the language pill overlay and the CTA layout unchanged.

### 7.9 #33 Language pill

`LanguagePill` → `ElevatedSurface(shape: StadiumBorder(), height 36.10, padding 14.47, color:
ext.languagePillFill, side: ext.languagePillBorder == null ? null : BorderSide(color:
ext.languagePillBorder!, width: elevation.languagePillBorderWidth), glass: elevation.languagePillGlass,
onTap: onTap)`.

- Keep the glyph, gap, label and metrics.
- Update the `languagePillBorder` doc comment in `app_colors.dart`: dark = 20% + Glass G3 on all 7 dark
  instances, not "#232428 on #232428". This is a doc-comment-only change to a token doc.

### 7.10 Guard & cleanup

- Lower the `raw elevation effects` ratchet to the new real count: −2 expected (nav `MaskFilter`,
  onboarding `BoxShadow`). New code in `lib/core/widgets/elevation/` is exempt.
- If `AppColors.elevationShadow` has **no** remaining references after this edit (only possible if
  edits 3–5 already landed), delete it and its `palette_discipline_test.dart` group, per edit1 §7.3.
  Otherwise leave it.

## 8. Architecture / tokens used

- **AppColors:** `backChipSurfaceFill`, `registrationBackChipFill`, `languagePillFill`,
  `languagePillBorder`, `fieldFill`, `fieldBorder`, `sheetFill`, `background`, `secondaryButtonBorder`.
- **AppElevation:**
  - Nav bar and back chips: `navBarShadows`, `backChipShadows`, `backChipGlass`,
    `registrationBackChipGlass`.
  - Language pill and fields: `languagePillGlass`, `languagePillBorderWidth`, `fieldGlass`,
    `fieldBorderWidth`.
  - Onboarding sheet: `onboardingSheetShadows`, `onboardingSheetGlass`.
  - Scrims: `limitSheetScrim`, `avatarActionSheetScrim`, `chooseAvatarSheetScrim`,
    `logoutDialogScrim`, `goToUniversityDialogScrim`.
  - CTAs, read inside `PrimaryCta`: `primaryCtaShadows`, `primaryCtaGlowLayerBlur`,
    `outlineCtaShadows`. The dialog confirm button uses the same tokens.
- **Primitives (edit1):** `ElevatedSurface`, `paintFigmaShadows`, `GlassBackdrop`, `PrimaryCta`
  (`CtaTone`).
- **New shared code (this edit):** `app_modal.dart` in `lib/core/widgets/elevation/`.
- **Deleted tokens:** `navShadow`, `backChipFill`.

## 9. Files expected to change

Modified:

- `lib/features/shell/main_shell.dart`
- `lib/core/widgets/circle_back_button.dart`
- `lib/features/catalog/widgets/catalog_scaffold.dart`
- `lib/features/registration/widgets/registration_chrome.dart`
- `lib/features/registration/screens/signup_identity_screen.dart`
- `lib/features/registration/screens/signup_track_screen.dart` (the `CircleBackButton` call and the
  CTA wrap only)
- `lib/features/registration/screens/school_detail_screen.dart`,
  `lib/features/registration/screens/university_detail_screen.dart` (CTA wrap only)
- `lib/core/theme/app_theme.dart` (dialog / date-picker surface only)
- `lib/core/theme/app_colors.dart` (deletions + one doc comment)
- `lib/features/auth/screens/login_screen.dart`
- `lib/features/onboarding/screens/onboarding_screen.dart`
- `lib/features/quiz/widgets/limit_sheet.dart`
- `lib/core/widgets/form_fields.dart`
- `lib/core/widgets/language_pill.dart`
- `lib/features/profile/widgets/profile_confirm_dialog.dart`
- `lib/features/profile/widgets/avatar_sheets.dart`
- `test/guards/project_rules_test.dart`

New:

- `lib/core/widgets/elevation/app_modal.dart`
- tests (§11)

Tests/goldens:

- `test/features/catalog/catalog_navigation_test.dart`
- `test/features/mistakes/mistakes_screens_test.dart`
- `test/goldens/*.png` (nav bar, language pill, track screen)
- Docs: `docs/DESIGN_ISSUES.md` (#37 resolution, limit-sheet dark gap, language-pill resolution).

## 10. Do not change

- Colours of the outline CTA (#21/#22 decisions), the nav geometry, tab rhythm, labels.
- `otp_screen.dart`, `quiz_screen.dart`, `edit_profile_screen.dart` (other edits).
- `_TrackCard` and anything else in `signup_track_screen.dart` besides the back-chip call and the
  CTA wrap.
- `FilledButtonThemeData` / `OutlinedButtonThemeData` (no `backgroundBuilder`, see §7.3), and CTAs in
  quiz, OTP and Edit Profile files (edits 4/5).
- The Subjects Mistakes pill, level card, placeholders, catalog cards (edit3).
- Any token value (only the deletions listed in §8).
- `pubspec.yaml`, `contract/**`, typography.

## 11. Verification plan

1. `dart format --output=none --set-exit-if-changed lib test` and `flutter analyze`, both clean.
2. New/updated tests:
   - CTA call sites (widget tests on Login, Onboarding, a registration screen and
     `ProfileConfirmDialog`):
     - each Figma CTA is wrapped in `PrimaryCta` with the right tone;
     - the Logout confirm is `CtaTone.destructive`;
     - `enabled` mirrors `onPressed != null`.

     The primitive's own paint behaviour is tested in edit1.
   - `test/core/widgets/elevation/app_modal_test.dart`:
     - `scrim == null` equals today's behaviour;
     - barrier colour;
     - a `BackdropFilter` exists only when σ > 0;
     - barrier tap and back dismiss;
     - sheet drag-dismiss still works;
     - barrier semantics label present.
   - `circle_back_button` test: both variants resolve the right fill/Glass tokens per theme; RTL chevron
     still flips.
   - `form_fields` test: dark border width 0.03, light 1.17338; error 1.5 `cs.error`; disabled opacity.
   - `language_pill` test: light border width 0.629032; dark no border + Glass.
   - Existing: `onboarding_screen_test.dart`, `quiz_setup_screen_test.dart` (LimitSheet),
     `quiz_screen_test.dart` (LimitSheet), `settings_screen_test.dart` / `shell_screens_test.dart` (back
     chip), `leaderboard_screen_test.dart:213` (taps `CircleBackButton`), `otp_screen_test.dart`,
     `profile_screen_test.dart` (dialogs).
3. Goldens (Windows):
   - Regenerate `nav_bar_{light,dark}_tab{0..4}.png`, `language_pill_{light,dark}.png`,
     `track_screen_{light,dark}.png` with `flutter test --tags golden --update-goldens`, **after**
     reviewing the new renders against Figma (§12).
   - Add a CTA golden (light/dark, enabled/disabled).
4. `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` → OVERALL: PASS, count ≥ baseline.
   `tool\verify_guards.ps1` still detects every probe.
5. Device (DEVICE VERIFIED only if actually run): `flutter run` on the dev entrypoint. Walk Onboarding →
   Log in → OTP → Sign Up_1/2 → Home tabs → Settings → Profile → Logout dialog → Edit Profile avatar
   sheets → quiz limit sheet (mock backend) in **light and dark** (Settings → Mode) and **EN and AR**.

## 12. Visual QA checklist (compare against Figma, same node, 100% zoom, Copy as PNG)

- [ ] Nav bar light: soft lilac-grey halo above the bar top edge and notch (`59:1264`). Dark: faint
      purple halo (`349:16719`). Both are smaller and cooler than the old 8% black blur.
- [ ] Every CTA wrapped in this edit (Log in, Onboarding, registration Continue/Submit, confirm
      dialog), light: tight dark shadow bottom-right. Dark: black shadow plus a lavender glow ~12 px
      around the button (`348:8909`). A disabled Continue (incomplete form) dims glow and shadow.
      Retry buttons are unchanged.
- [ ] Logout dialog red button: shadow, **no** glow. Go-to-University dialog purple button: glow in
      dark.
- [ ] Outline CTAs (Onboarding Log in, Login Create account): shadow in both themes, colours unchanged.
- [ ] Back chips light: faint 1.3-blur ring (`90:208`). Dark Learn/Settings/Leaderboard/Edit Profile:
      near-invisible 20% disc with rim highlights top-left/bottom-right (`404:7424`). Dark registration
      screens: slightly lighter `#333439` disc with a weaker rim at 22° (`337:19690`).
- [ ] `CatalogHeader` back chip now matches the shared chip, including the SVG chevron. RTL: chevron
      points right.
- [ ] Language pill light: 0.63 hairline (thinner than before). Dark: no outline, 20% fill, weak rim
      (intensity 0.25) on every pre-auth screen.
- [ ] Fields dark: nearly invisible 0.03 cream hairline plus rim light at 28°, not the old solid cream
      border. Error state still red 1.5.
- [ ] Onboarding sheet, light and dark: shadow above the top edge. The top edge of the sheet shows the
      illustration's colours frosted (`337:15643`, `459:43873`). No hard illustration edge inside the
      sheet.
- [ ] Dialogs and avatar sheets dark: opaque `#232428` panel (no longer see-through), page behind
      blurred (σ 9.95 / 10.05 / 14.7 / 13.4) under a 60% / 30% scrim. Light: no blur, 30% scrim.
- [ ] Limit sheet light: 50% scrim + blur 5.75. Dark: unchanged (blocked).
- [ ] RTL: shadows do not mirror; pills and chips sit at the correct edge.
- [ ] Regression: the date picker in registration uses the opaque background in dark.

## 13. Known risks / assumptions

- **BLOCKED — dark Limitation sheet:** no dark frame exists. Dark keeps the framework barrier. Record
  it in DESIGN_ISSUES as a designer request.
- **Framework dialogs** ("Leave quiz?", "Discard changes?") have no Figma frame. Edits 4/5 give them
  the Logout dialog scrim for consistency with the existing single-dialog-system rule
  (`app_theme.dart` comment).
- **OTP back chip** uses the standard variant (no Figma chip on OTP).
- **Onboarding strip** geometry comes from an existing code comment. Read `337:19256` before relying
  on it (§7.8).
- **Glow clipping**: `PrimaryCta` paints outside the button, so any clipping ancestor cuts the glow
  (e.g. a `ClipRRect`, or `Dialog`'s default `clipBehavior`). Check the dialog and bottom-bar CTAs
  visually. If a dialog clips, add padding inside the dialog, not a new primitive.
- **Performance:** dialog/sheet blur is one `BackdropFilter` per open modal (fine). Do not use
  `GlassBackdrop.content` anywhere except the onboarding sheet.
- **Goldens are platform-specific** (Windows baselines). Regenerate only on Windows.

## 14. Completion criteria

- [ ] Nav bar, CTAs, outline CTAs, back chips, language pill, fields, onboarding sheet, dialogs and
      sheets use edit1 tokens and primitives, matching §5 in both themes.
- [ ] `navShadow` and `backChipFill` deleted. No hardcoded shadow/blur outside
      `lib/core/widgets/elevation/`.
- [ ] Dark dialog, date-picker and avatar-sheet panels are opaque.
- [ ] `showAppDialog` / `showAppModalSheet` exist with behaviour tests (used by edits 4/5 later).
- [ ] Elevation ratchet lowered (−2) to the real count.
- [ ] Goldens regenerated after visual review. `validate.ps1` OVERALL: PASS. Count not lower.
- [ ] DESIGN_ISSUES updated: #37 resolved, language-pill question resolved, limit-sheet dark gap
      recorded.
