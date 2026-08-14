# Agent 4 — Design System / Theme

**Scope:** Light/dark consistency, hardcoded theme-dependent values, semantic token
coverage, duplicate tokens, typography tokens, component styling, elevation,
guard-test gaps.
**Baseline:** dev @ e3651e6
**Repository areas inspected:**
- `lib/core/theme/app_colors.dart` (754 lines, read end to end)
- `lib/core/theme/app_theme.dart` (69 lines, read end to end)
- `lib/core/widgets/form_fields.dart`, `language_pill.dart`, `titled_chrome.dart`, `offline_banner.dart`
- `lib/features/**` — all 45 files containing `TextStyle(`, plus the 5 `BoxShadow(` sites
- `lib/features/shell/main_shell.dart`, `lib/app.dart`, `lib/core/router/app_router.dart`
- `test/core/theme/palette_discipline_test.dart`, `test/core/theme/app_colors_test.dart`
- `pubspec.yaml` fonts block, `assets/fonts/`
- `docs/DESIGN_ISSUES.md` (index only, to avoid re-litigating known items)

**Method note.** Every contrast figure below was computed with the WCAG 2.x sRGB
relative-luminance formula (`L = 0.2126R + 0.7152G + 0.0722B` on linearised
channels; `(L1+0.05)/(L2+0.05)`), in a Python script, with translucent tokens
(`0x33…`, `0x4D…`) composited over their real parent surface first. Not eyeballed.

---

## Headline

Colour *discipline* is genuinely strong and I am not going to re-prove it. What
the discipline does **not** cover is (a) whether the tokens it enforces are
*legible*, and (b) typography, which has no tokens at all. Both gaps are
invisible to `palette_discipline_test.dart` by construction.

---

## Findings

### F-4-01 [HIGH] [BUG] `hint` and `textPrimary` are the same colour in dark — a placeholder is indistinguishable from a typed value

**Evidence:** `lib/core/theme/app_colors.dart:504` `textPrimary: Color(0xFFFCFBF9)`
and `:506` `hint: Color(0xFFFCFBF9)`. Also `:503` `fieldBorder: Color(0xFFFCFBF9)`.
Consumed together at `lib/core/widgets/form_fields.dart:156-161`:
```dart
style: TextStyle(fontSize: 18, color: ext.textPrimary),
decoration: InputDecoration(hintStyle: TextStyle(fontSize: 18, color: ext.hint)),
```
Contrast(hint, textPrimary) in dark = **1.00:1**. In light it is 3.52:1
(`#696969` vs `#0E0E0E`) — a clear, deliberate separation that the dark palette
drops.

**Why it matters:** On the dark canvas every text field renders its placeholder
in exactly the same cream as real input, at the same 18px. A user cannot tell an
empty field from a filled one without tapping it. This is the single clearest
case of "the dark value looks copied from the light foreground rather than
designed" in the file — `#FCFBF9` is the file's generic dark foreground and has
been pasted into `fieldBorder`, `textPrimary`, `hint`, `legalText`,
`cardValue`, `bellGlyph`, `backChipGlyph`, `trackRadioRing`,
`languagePillContent`, `profileStatLabel` and `elevationShadow` — eleven tokens,
one value.

**Recommended fix:** Give dark `hint` its own value. `#B3B3B3` (already in the
palette as `mutedText`, 7.39:1 on the dark canvas, and 2.4:1 against dark
`textPrimary`) is the obvious candidate and needs no new hex. Confirm with the
designer against Figma `337:15652`.

**Risk of fixing:** Low — one value, one call site, but it changes every dark
form screen; the golden tests do not cover form fields, so a visual re-check is
needed.

**Validation required:** Read the dark Login frame `337:15652` for a distinct
placeholder colour. Toolchain: none needed.

---

### F-4-02 [HIGH] [ARCHITECTURE ISSUE] There is no `TextTheme`. 153 inline `TextStyle(` with 153 hardcoded `fontSize` — and the guard test cannot see any of them

**Evidence:**
- `lib/core/theme/app_theme.dart:42-67` — the entire `ThemeData` declares
  `appBarTheme` and `filledButtonTheme` and nothing else. **No `textTheme:`.**
- `grep -rn "textTheme" lib/` → **0 hits.** Not one widget reads a named style.
- `grep -rn "TextStyle(" lib/` → **153** (145 in `lib/features/`, 8 in `lib/core/widgets/`).
- `grep -rn "fontSize:" lib/` → **153**. `fontWeight:` → **82**.
- Size histogram: `18`×33, `14`×31, `22`×23, `16`×20, `20`×12, `13`×7, `12`×7,
  `11`×5, `32`×4, `36`×2, `13.145`×2, `10`×2, then singletons at
  44/28/24/19/15. Weight histogram: `w600`×45, `bold`×23, `w500`×13, `w700`×1.

**Worst offenders (`file:line` = file, count):**
| File | `TextStyle(` |
|---|---|
| `lib/features/auth/screens/login_screen.dart` | 13 |
| `lib/features/registration/screens/signup_identity_screen.dart` | 12 |
| `lib/features/auth/screens/otp_screen.dart` | 11 |
| `lib/features/quiz/screens/quiz_result_screen.dart` | 9 |
| `lib/features/registration/widgets/reference_dropdown.dart` | 6 |
| `lib/features/profile/screens/edit_profile_screen.dart` | 6 |
| `lib/core/widgets/form_fields.dart` | 5 |

**Why it matters:** This is exactly the class of violation the palette test was
written to stop, applied to the other half of a design system. `fontSize: 18` at
33 different call sites is 33 independent decisions that will drift, and there is
no `AppTypography` for a future `fontSize` to be added *to*. Concretely:
`FontWeight.bold` (w700) and `FontWeight.w600` are both in heavy use with no rule
for which means "semibold heading"; `fontWeight: FontWeight.w700` appears exactly
once (`profile_stat_card.dart:63`) alongside 23 `FontWeight.bold` — the same
value written two ways. It also blocks text scaling (Agent-level finding: 0
`textScaler` references app-wide) because there is no single place to apply it.

**Recommended fix:** Build a `TextTheme` in `_build()` from the histogram — the
long tail (19/15/24/28/44) is 5 one-off sizes against 5 sizes that cover 119 of
153 uses. Then migrate screens to `Theme.of(context).textTheme.<name>` and add
the guard test in F-4-11.

**Risk of fixing:** Medium. 153 call sites; a `TextTheme` also changes the
default `Text` style for anything not explicitly styled, and 5 golden tests
render text. Do it feature-by-feature behind the goldens, not in one commit.

**Validation required:** `flutter test test/goldens/` after each feature migrated.
Not runnable here.

---

### F-4-03 [HIGH] [BUG] `mutedText` (`#B3B3B3`) fails WCAG AA on the light canvas by a factor of two, at 10–16px, in five places

**Evidence:** `app_colors.dart:457` / `:514` — `#B3B3B3` in **both** palettes.
Contrast on light: **2.03:1** on `background`/`navBarFill` (`#FCFBF9`), **2.06:1**
on `cardFill` (`#FDFDFD`). Threshold for text this size is 4.5:1. Call sites:
- `lib/features/shell/main_shell.dart:265,333` — every **inactive bottom-nav
  label**, styled `main_shell.dart:238-242` at `fontSize: 11, w500`.
- `lib/features/home/widgets/level_card.dart:118,125` — level-range row, 11px.
- `lib/features/home/widgets/level_card.dart:147` — "x / y points" caption, **10px**.
- `lib/features/home/widgets/coming_soon_section.dart:51,70` — "See all" and
  "Coming soon", 14px.
- `lib/features/catalog/screens/subjects_screen.dart:142` — search `hintStyle`, 16px.

On the *dark* canvas the same `#B3B3B3` measures 7.39:1 and is fine. So this is a
light-canvas-only defect in a token whose doc (`app_colors.dart:130-132`)
explicitly justifies it as "`#B3B3B3` in BOTH canvases … so it is not a guess."
It is Figma-verbatim and Figma did not check contrast.

**Why it matters:** Four of the five bottom-nav tabs are unreadable-grade at any
moment, on the app's primary navigation, in the default theme. 10px at 2.03:1 is
not a marginal call.

**Recommended fix:** Split the token — keep `#B3B3B3` for dark, take the light
value to ≈`#767676` (4.54:1 on `#FCFBF9`) or reuse `hint` (`#696969`, 5.31:1).
This is a **PRODUCT DECISION**: it contradicts a measured Figma value, so it
needs the designer, not a unilateral code change.

**Risk of fixing:** Low technically; 2 golden tests (`nav bar × 5 tabs × 2
themes`, `level card`) will need regolding.

**Validation required:** Designer sign-off on a light `mutedText`; then
`flutter test --update-goldens`.

---

### F-4-04 [MEDIUM] [BUG] `destructive` (`#EF4444`) fails AA as text on **both** canvases

**Evidence:** `app_colors.dart:494` / `:555`. As **18px** text at
`lib/features/profile/widgets/profile_menu_row.dart:69,98-99` (the Logout row
label) on `cardFill`: light **3.70:1**, dark **4.12:1**. As **13px** text at
`lib/features/settings/screens/settings_screen.dart:217-220` on `background`:
light **3.64:1**, dark **4.12:1**. Threshold 4.5:1 in all four cases.

**Why it matters:** Destructive intent and error messages are precisely the copy
a user must be able to read. Unlike F-4-03 this is a *near* miss, but it is the
only token that misses on both canvases.

**Recommended fix:** Keep `#EF4444` for the *border* and *icon* (a UI component
needs 3:1, which it clears) and introduce a darker `destructiveText` for the
label — e.g. `#D32F2F` (4.53:1 light). Two tokens, matching the pattern
`quizWrongBadge`/`quizWrongBorder` already establishes.

**Risk of fixing:** Low. Isolated to profile + settings.

**Validation required:** Designer confirmation; the value is Figma `176:1191`.

---

### F-4-05 [MEDIUM] [BUG] `#7070A0` is used for four different tokens and fails AA on the dark canvas in all four

**Evidence:** `cardLabel` (`:454`,`:511`), `profileRowBorder` (`:489`,`:550`),
`profileStatValue` (`:491`,`:552`), `quizExplanationBody` (`:476`,`:537`) —
`#7070A0` in both palettes for all four. Measured:

| Use | Size | Surface | Light | Dark |
|---|---|---|---|---|
| `cardLabel` — "current level" (`level_card.dart:174`) | 14 | `cardFill` | 4.57 ✓ | **3.33 ✗** |
| `quizExplanationBody` — AI body (`ai_explanation_panel.dart:116-119`) | 13.145 | `quizOptionFill` | **4.50 borderline** | **3.17 ✗** |
| `quizExplanationBody` — "Rewards earned" (`quiz_result_screen.dart:277`) | 12 | `quizOptionFill` | 4.50 borderline | **3.33 ✗** |
| `profileStatValue` (`profile_stat_card.dart:62-66`) | 22 w700 | `cardFill` | 4.57 ✓ | 3.33 ✓ (large-text) |
| `profileRowBorder` (`profile_menu_row.dart:67,81`) | — | `cardFill` | 4.50 ✓ | 3.33 ✓ (1.4.11) |

The two *text* uses fail dark AA outright and sit exactly on the 4.5 line in
light — no headroom for any future surface tweak.

**Why it matters:** A purple-grey chosen against a cream canvas was carried
verbatim onto a `#232428` canvas where it has 3.2–3.3:1. The palette's own
comment at `:264-267` argues the light/dark split is *deliberate* for
`quizExplanationBody`; what it does not say is that the dark side was never
measured, and the token block at `:219-231` concedes **no dark quiz frame
exists** — so the dark value here is a stand-in, not a design.

**Recommended fix:** Give the two *text* tokens a dark value ≈`#9C9CC8` (4.8:1 on
`#27282C`). Leave `profileRowBorder`/`profileStatValue` alone — they clear their
respective thresholds.

**Risk of fixing:** Low.

**Validation required:** Designer, per `docs/DESIGN_ISSUES.md #34` (only light
quiz frames exist).

---

### F-4-06 [MEDIUM] [QUALITY IMPROVEMENT] `dialogNote`, `link` and `accentSoft` fail AA/AAA-for-large on the light canvas

**Evidence:**
- `dialogNote` `#AE87E7` on `background` light = **2.74:1**, at 14px w600
  (`profile_confirm_dialog.dart:141-147`) — the "You can't go back again"
  caution line on a destructive confirmation. Dark is 5.48:1 and fine.
- `link` `#E67E22` on `background` light = **2.75:1**, at 14px w600
  (`login_screen.dart:416`) — the Terms / Privacy / Cookie links. Dark 5.48:1.
- `accentSoft` `#A0B384` on `background` light = **2.19:1**, at **24px w500**
  (`onboarding_screen.dart:209-225`). 24px regular is WCAG "large text" →
  threshold 3.0:1, so it fails even the relaxed bar. The token's own doc
  (`app_colors.dart:191-193`) says `Brand.greenPrimary` "would be far too dark",
  i.e. the *lower*-contrast option was chosen on purpose.

**Why it matters:** All three are light-canvas-only, all three are Figma values,
and all three are the "purple/orange/sage on cream" pattern. `link` is the worst
in practice — a legal link a user cannot see is a compliance surface.

**Recommended fix:** Product/design decision, not an engineering one. Darken the
light values (`#C05F0A` for `link` → 4.52:1; `#8657C4` for `dialogNote` →
4.51:1) or accept and document. Do not change unilaterally.

**Risk of fixing:** Low, but it visibly changes brand colour.

**Validation required:** Designer.

---

### F-4-07 [MEDIUM] [ARCHITECTURE ISSUE] Only two component themes exist; six component families are restyled per screen

**Evidence:** `app_theme.dart:51-66` declares `appBarTheme` and
`filledButtonTheme`. Everything else is absent. Counted at call sites:

| Component | Central theme? | Call sites re-specifying |
|---|---|---|
| `FilledButton` | ✅ `app_theme.dart:57` | 2 override it: `edit_profile_screen.dart:612`, `profile_confirm_dialog.dart:161` |
| `OutlinedButton` | ❌ none | 3 × `OutlinedButton.styleFrom`: `login_screen.dart:234`, `subjects_screen.dart:102`, `onboarding_screen.dart:261` |
| `TextButton` | ❌ none | `city_field.dart:148` |
| `TextField` / `InputDecoration` | ❌ no `InputDecorationTheme` | 5: `form_fields.dart:157`, `login_screen.dart:362`, `subjects_screen.dart:138`, `signup_identity_screen.dart:259`, `signup_identity_screen.dart:355` |
| `AppBar` title style | ⚠️ colours only, **no `titleTextStyle`** | 8 `AppBar(` sites inherit Material3 `titleLarge` (Inter w400 22px) — which matches *no* other heading in the app |
| `Dialog` / `BottomSheet` | ❌ none | 2 `AlertDialog(`, 4 `showDialog`, 4 `showModalBottomSheet` |
| `Card` | n/a | **0** real `Card(` widgets — every surface is a hand-built `Container` + `BoxDecoration` (54 sites) |
| `ElevatedButton` | n/a | **0** uses — good, the app is consistently on `FilledButton` |

**Why it matters:** `OutlinedButton` is the app's secondary action and its
styling lives in three separate screens; the three will drift. The `AppBar`
gap is the sharper one — `appBarTheme` sets `backgroundColor`/`foregroundColor`
but not `titleTextStyle`, so eight screens render titles in a weight/size that
appears nowhere else in the design, and nothing flags it.

**Recommended fix:** Add `outlinedButtonTheme`, `textButtonTheme`,
`inputDecorationTheme`, `dialogTheme`, `bottomSheetTheme`, and
`appBarTheme.titleTextStyle` to `_build()`. Note the codebase already has a
partial answer for fields — `AppTextField`/`FieldShell` in
`lib/core/widgets/form_fields.dart` — so the four non-central `InputDecoration`
sites are the ones to fold in.

**Risk of fixing:** Medium — adding an `inputDecorationTheme` affects every
field, and 3 of the 5 sites deliberately use `InputBorder.none` inside
`FieldShell`. Do fields last.

**Validation required:** `flutter test test/goldens/`.

---

### F-4-08 [MEDIUM] [BUG] The Arabic fallback is correctly wired, but `Cairo-SemiBold.ttf` is dead weight and Arabic w600 renders at the wrong weight

**Evidence:** `app_theme.dart:47-48`:
```dart
fontFamily: 'Inter',
fontFamilyFallback: const ['Tajawal', 'Cairo'],
```
This is set on `ThemeData`, so it reaches `textTheme` → `DefaultTextStyle` →
every `Text`. **No call site anywhere in `lib/` sets `fontFamily`** (verified:
`grep -rn "fontFamily" lib/` returns only these two lines), and all 153 inline
`TextStyle`s use the default `inherit: true`, so they merge over the default and
keep the fallback. **There is no tofu risk — item 4 checks out.**

The real defect is weight coverage. `pubspec.yaml` declares:
- Inter: 400 / 500 / 600 / 700
- **Tajawal: 400 / 500 / 700 — no 600**
- **Cairo: 400 / 600 / 700 — no 500**

`FontWeight.w600` is used **45 times** — the most common non-default weight in
the app. Fallback resolution is per-*glyph*: an Arabic glyph misses in Inter,
resolves in Tajawal, and Cairo is **never consulted**, because Cairo only gets a
turn when Tajawal lacks the *glyph*, not when it lacks the *weight*. So every
w600 Arabic heading renders as Tajawal Medium or Bold, and `Cairo-SemiBold.ttf`
— the one file that could have rendered it correctly — never loads. Likewise the
13 `FontWeight.w500` uses can never reach `Cairo-Regular`.

**Why it matters:** Arabic is stated as the baseline locale, not an edge case.
45 headings render at a visibly different weight from their Latin counterparts,
and the app ships a font file that can never be used.

**Recommended fix:** Either (a) add `Tajawal-*` at 600 — Tajawal ships an
ExtraBold/Bold set; or (b) drop `Cairo` from the fallback and the bundle
(saves an asset), accepting Tajawal's 400/500/700 and standardising the app on
those three weights. (b) is cheaper and aligns with F-4-02's typography ramp.

**Risk of fixing:** Low, but it changes Arabic rendering everywhere; needs an
Arabic screenshot pass.

**Validation required:** Render an Arabic screen at w600 on device. Not possible
here (no toolchain).

---

### F-4-09 [LOW] [QUALITY IMPROVEMENT] Nine duplicate token groups — all documented as deliberate, but the `#7070A0` and `#384F47` families are worth collapsing

**Duplicate-token table** (distinct token names resolving to the *identical*
light+dark pair):

| Light | Dark | Tokens sharing the pair | Verdict |
|---|---|---|---|
| `#7070A0` | `#7070A0` | `cardLabel`, `profileRowBorder`, `profileStatValue`, `quizExplanationBody` | 4-way. Documented at `:265,:365,:376`. Collapse to 2 (a text token + a border token) — see F-4-05 |
| `#384F47` | `#FCFBF9` | `legalText`, `languagePillContent`, `profileStatLabel`, `trackRadioRing` | 4-way. Documented at `:319-321`, `:371-373`. Reasonable to keep — four independent restyle surfaces |
| `#FDFDFD` | `#232428`(20%) | `cardFill`, `fieldFill` | `cardFill` carries a `TODO(design)` at `:453` saying it should be `#FCFBF9` — resolving that TODO breaks the duplicate |
| `#FCFBF9` | `#232428` | `background`, `backChipFill` | `backChipFill` dark is an admitted fallback (`:344-346`) |
| `#E67E22` | `#AE87E7` | `link`, `bellUnreadDot` | Documented at `:147-149` |
| `#AE87E7` | `#AE87E7` | `homeAccent`, `dialogNote` | Documented at `:397-400` |
| `#4B675E` | `#4B675E` | `bellRing`, `quizOptionBorder` | Documented at `:241-243` |
| `#4B675E` | `#FCFBF9` | `bellGlyph`, `backChipGlyph` | `backChipGlyph` dark is an admitted fallback (`:350-354`) |
| `#EF4444` | `#EF4444` | `destructive`, `quizWrongBadge` | Documented at `:388-391` |

Nine groups covering 24 of 52 tokens. **This is not a finding against the
palette** — every group has a written justification and I am not re-litigating
them. The one actionable item is the `#7070A0` group, because the collapse falls
out of the F-4-05 contrast fix anyway.

Separately: **19 of 52 tokens are byte-identical across the two canvases**
(`bellRing`, `cardLabel`, `destructive`, `dialogNote`, `homeAccent`, `mutedText`,
`navCentreGlyphOn`, `navShadow`, `profileRowBorder`, `profileStatValue`,
`quizCorrectBorder`, `quizCorrectFill`, `quizExplanationBody`, `quizOptionBorder`,
`quizWrongBadge`, `quizWrongBorder`, `quizWrongFill`, `secondaryButtonBorder`,
`successBadge`). Ten of those are *semantically* required to stay fixed
(success/wrong/destructive/nav-glyph) and are correct. The other nine
(`bellRing`, `cardLabel`, `mutedText`, `navShadow`, `profileRowBorder`,
`profileStatValue`, `quizExplanationBody`, `quizOptionBorder`,
`secondaryButtonBorder`) are the ones that were never given a dark value — and
**eight of those nine appear in the contrast failure table.** That correlation
is the finding: "same in both canvases" is a reliable predictor of "was never
measured on the dark canvas."

---

### F-4-10 [LOW] [QUALITY IMPROVEMENT] Elevation is consistent; radii and un-rounded Figma numbers are not

**Elevation — clean.** All 5 `BoxShadow(` sites use the token, none use a raw
colour:
`onboarding_screen.dart:122/128` (α 0.15), `edit_profile_screen.dart:549/551`,
`profile_header_card.dart:41/44`, `profile_stat_card.dart:36/39`,
`ai_explanation_panel.dart:144/145` (all α 0.25). `navShadow` has exactly one
consumer, `main_shell.dart:89`. Nothing to fix here — the `elevationShadow`
design (colour in the token, depth at the call site) is well executed and
already guard-tested at `palette_discipline_test.dart:62-128`.

**Radii — not tokenised.** 61 `BorderRadius.` sites across **11 distinct
values**: `16`×17, `20`×12, `15`×5, `52`×4, `10`×3, `22`, `9`, `2`, and three
un-rounded Figma leaks: **`20.224`, `16.179`, `10.7`**. Same pattern in
typography: `fontSize: 13.145` (×2, `ai_explanation_panel.dart:117`).

**Why it matters:** `15` vs `16` (5 sites vs 17) is almost certainly one radius
written two ways; `20.224` is a Figma auto-layout artefact that no designer
intended as a spec. There is no `AppRadii`/`AppSpacing` for these to live in.

**Recommended fix:** Add a `Radii`/`Spacing` const class next to `Brand`, seed it
from the histogram, round the three fractional values, and guard-test
`BorderRadius.circular(<literal>)` at call sites the way colours are guarded.

**Risk of fixing:** Low; radii are visually forgiving. Golden tests cover 5
components.

---

### F-4-11 [MEDIUM] [QUALITY IMPROVEMENT] What the guard tests cannot catch, and the four tests that would close the gap

`palette_discipline_test.dart` greps `lib/` (minus `lib/core/theme/`) for
`0xFF|Color\(0x`, `Colors\.black|Colors\.white`, and `SystemUiOverlayStyle`.
`app_colors_test.dart` covers only the four Day-00 tokens' wiring plus the
success-badge SVG. **Neither test looks at a single number that is not a colour,
and neither computes contrast.**

Blind spots, in descending value:

1. **Inline `TextStyle` / hardcoded `fontSize`, `fontWeight`, `height`** — 153,
   82 and ~20 occurrences respectively, none caught. *This is the same class of
   violation as a hardcoded colour.* Proposed test: no `fontSize:` literal
   outside `lib/core/theme/`, once F-4-02's `TextTheme` lands.
2. **Contrast** — nothing in the suite measures it. Proposed test: a pure-Dart
   `contrastRatio()` over a declared list of (fg, bg, minRatio) pairs, asserting
   ≥4.5 for text pairs and ≥3.0 for UI-component pairs. This is ~40 lines,
   needs no widget pump, and would have caught F-4-01, F-4-03, F-4-04 and F-4-05
   the day they were written.
3. **Raw `BorderRadius.circular(<literal>)`** — 61 sites, 11 values, 3 of them
   fractional. Not caught.
4. **Direct `AppColors.light.*` / `AppColors.dark.*` at a call site** — bypasses
   `Theme.of(context)` entirely and so pins a colour to one canvas. Two hits
   today, both legitimate (`settings_screen.dart:144,151`, which paint the theme
   *picker*'s preview swatches and must show the non-active theme), but nothing
   would stop a third, illegitimate one. Proposed test: allowlist those two lines.
5. **`Colors.*` beyond black/white.** The orchestrator's 15 hits, judged
   individually:
   - `app.dart:80,83,90,93` — `Colors.transparent` for
     `statusBarColor`/`systemNavigationBarColor`. **Correct**; edge-to-edge
     requires it and it is theme-independent.
   - `avatar_sheets.dart:106,222,248`, `profile_menu_row.dart:127`,
     `settings_rows.dart:49,222` — `Colors.transparent` on `Material`/sheet
     backgrounds so the custom `Container` shows through. **Correct** — this is
     the idiomatic way to get an inkwell without a Material surface.
   - `main_shell.dart:281` — `selected ? ext.navAccent : Colors.transparent`
     for the 26×2 selection rule. **Correct** — "absent" is not a colour.
   - `otp_screen.dart:419`, `profile_stat_card.dart:38` — **false positives**,
     both inside doc comments referencing `AppColors`.
   **Verdict: all 15 are benign.** `Colors.transparent` is genuinely
   canvas-independent and the current regex is right to exclude it. No change
   needed; worth stating explicitly so a future pass does not re-flag them.
6. **Missing-token drift** — `app_colors_test.dart` asserts `copyWith`/`lerp`
   wiring for only 4 of 52 tokens plus `elevationShadow`. A 53rd token added to
   the constructor but forgotten in `lerp` would still ship silently for the
   other 47. Proposed test: reflect over the two palettes by asserting
   `light.lerp(dark, 0.5)` differs from `light` for *every* token whose two
   values differ — as a single loop over a hand-maintained list, so adding a
   token forces a test edit.

---

### F-4-12 [LOW] [QUALITY IMPROVEMENT] `Brand` is correctly quarantined; token names are semantic with two exceptions

**Evidence:** `grep -rn "Brand\." lib/ | grep -v lib/core/theme/` → **zero
hits.** `Brand.greenPrimary`/`Brand.purplePrimary` appear only inside
`app_colors.dart` (7 uses) and `app_theme.dart:18,24`, plus two assertions in
`test/core/theme/app_colors_test.dart:86-87`. The seeds are properly sealed
behind `colorScheme.primary` and the semantic tokens. This is exactly right and
worth recording as a *positive* finding.

The two presentational names left are `Brand.greenPrimary`/`Brand.purplePrimary`
themselves — acceptable, since they are literally the seeds and never reach a
widget. Every one of the 52 `AppColors` fields is semantic (`textPrimary`,
`quizWrongBorder`, `navCentreIdleFill`), with the mild exception of `accentSoft`
and `bodyMuted`, which describe a *degree* rather than a role.

---

## Contrast table (full)

WCAG 2.x, sRGB relative luminance, translucent tokens composited over their real
parent. `✗` = below the applicable threshold. Text threshold 4.5:1; large text
(≥24px, or ≥18.66px bold) 3.0:1; non-text UI component 3.0:1.

### Text and glyph pairings

| Foreground | Background | Size / weight at call site | Light | Dark |
|---|---|---|---|---|
| `textPrimary` | `background` | various | 18.67 ✓ | 14.99 ✓ |
| `textSecondary` | `background` | various | 13.50 ✓ | 11.31 ✓ |
| `textPrimary` | `fieldFill` | 18 | 18.98 ✓ | 14.99 ✓ |
| `hint` | `fieldFill` | 18 | 5.40 ✓ | **14.99 — but == `textPrimary`, F-4-01** |
| `cardValue` | `cardFill` | 22 w600 | 11.35 ✓ | 14.99 ✓ |
| `legalText` | `background` | 14 | 8.54 ✓ | 14.99 ✓ |
| `languagePillContent` | `background` | — | 8.54 ✓ | 14.99 ✓ |
| `profileStatLabel` | `cardFill` | 18 w600 | 8.68 ✓ | 14.99 ✓ |
| `navAccent` | `navBarFill` | 11 w500 | 5.97 ✓ | 5.61 ✓ |
| `bellGlyph` / `backChipGlyph` | `background` / `backChipFill` | icon | 5.97 ✓ | 14.99 ✓ |
| `profileStatValue` | `cardFill` | 22 **w700** (large) | 4.57 ✓ | 3.33 ✓ |
| `cardLabel` | `cardFill` | 14 | 4.57 ✓ | **3.33 ✗** |
| `quizExplanationBody` | `quizOptionFill` | 13.145 | **4.50 ⚠ borderline** | **3.17 ✗** |
| `quizExplanationBody` | `quizOptionFill` | 12 | 4.50 ⚠ | **3.33 ✗** |
| `destructive` | `cardFill` | 18 | **3.70 ✗** | **4.12 ✗** |
| `destructive` | `background` | 13 | **3.64 ✗** | **4.12 ✗** |
| `bodyMuted` | `background` | 20 | **3.57 ✗** | 13.12 ✓ |
| `bodyMuted` | `sheetFill` | 16 w500 | **3.57 ✗** | 13.12 ✓ |
| `link` | `background` | 14 w600 | **2.75 ✗** | 5.48 ✓ |
| `dialogNote` | `background` | 14 w600 | **2.74 ✗** | 5.48 ✓ |
| `accentSoft` | `background` | 24 w500 (large, thr. 3.0) | **2.19 ✗** | 5.48 ✓ |
| `mutedText` | `cardFill` | 10, 11 | **2.06 ✗** | 7.39 ✓ |
| `mutedText` | `navBarFill` | 11 w500 | **2.03 ✗** | 7.58 ✓ |
| `mutedText` | `background` | 14, 16 | **2.03 ✗** | 7.39 ✓ |
| `navCentreGlyphOn` | `navAccent` | 24 glyph (thr. 3.0) | 6.17 ✓ | **2.83 ✗** |

**Text/glyph failures: 17** (counting each canvas separately), of which 8 are
also below 3.0:1 and so fail even the large-text threshold.

### Non-text / UI-component pairings (WCAG 1.4.11, 3.0:1)

| Pair | Light | Dark |
|---|---|---|
| `profileRowBorder` / `background` | 4.50 ✓ | 3.33 ✓ |
| `quizWrongBorder` / `quizWrongFill` | 7.77 ✓ | **1.26 ✗** |
| `quizOptionBorder` / `quizOptionFill` | 5.97 ✓ | **2.38 ✗** |
| `bellRing` / `background` | 5.97 ✓ | **2.51 ✗** |
| `secondaryButtonBorder` / `background` | 8.54 ✓ | **1.76 ✗** (cf. DESIGN_ISSUES #21/#22) |
| `homeAccent` / `progressTrack` (bar fill vs track) | **2.40 ✗** | 4.83 ✓ |
| `quizCorrectBorder` / `quizCorrectFill` | **1.76 ✗** | **1.76 ✗** |
| `catalogTrack` / `catalogCardFill` | **1.50 ✗** | 12.46 ✓ |
| `trackCardBorderEnd` / `background` | **1.73 ✗** | n/a (null) |
| `fieldBorder` / `background` | **1.48 ✗** | 14.99 ✓ |
| `quizDivider` / `background` | **1.45 ✗** | **1.14 ✗** |
| `progressTrack` / `background` | **1.14 ✗** | **1.14 ✗** |
| `cardFill` / `background` | **1.02 ✗** | **1.00 ✗** |
| `catalogCardFill` / `background` | **1.02 ✗** | **1.05 ✗** |
| `navBarFill` / `background` | **1.00 ✗** | **1.02 ✗** |

**Non-text failures: 21.** Read these with judgement — a `progressTrack` or
`quizDivider` is decorative and 1.4.11 does not require 3:1 for it. The ones that
matter are the top five: `quizWrongBorder`/`quizOptionBorder`/`bellRing` and
`secondaryButtonBorder` in dark (a hairline that carries *state* and is
effectively invisible on `#232428`), and `homeAccent`/`progressTrack` in light
(the level bar's own fill against its own track, at 2.40:1 — a user with low
vision cannot read their progress).

Also note `cardFill`/`catalogCardFill`/`navBarFill` at ≈1.0:1 against
`background`: **surface hierarchy on both canvases is carried entirely by the
`elevationShadow` rim, not by the fill.** That is a defensible design (and
`elevationShadow` is well built for it), but it means any component that forgets
its shadow becomes literally invisible as a surface. Worth a note in the
component checklist rather than a code change.

**Grand total: 38 pairings below threshold** (17 text/glyph + 21 non-text).

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment. All contrast arithmetic
was done in a throwaway Python script in the Linux workspace against values read
out of `app_colors.dart`; nothing in the repo was executed or modified.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

- **F-4-01 is the only finding I would call shippable-blocking.** A dark-mode
  form where the placeholder is the same colour as the value is a functional
  defect, not an aesthetic one.
- Every contrast number here is arithmetic on declared token values. It does not
  account for the platform's own text rendering (gamma, subpixel AA) or for
  `TextStyle.height`, which slightly changes perceived weight. A device check on
  the worst offenders (F-4-03) is still worth doing.
- F-4-08's weight-fallback claim rests on how Flutter/Skia resolve
  `fontFamilyFallback` per-glyph rather than per-weight. That is documented
  behaviour, but I could not run a device render to confirm the Arabic w600
  output. **Validation required.**
- I did not audit `lib/dev/mock_backend.dart` or `test/goldens/` for theme use —
  out of scope and unlikely to matter.

## Deferred Improvements

- A `Spacing`/`Radii` token class (F-4-10) — real, but low value until the
  `TextTheme` (F-4-02) exists to sit beside it.
- Collapsing the `#384F47`/`#FCFBF9` four-token family. Documented as
  deliberate; leave it.
- `ThemeData.visualDensity` and `materialTapTargetSize` are unset — relevant to
  the responsive/a11y gap the orchestrator already flagged, and better owned by
  whichever agent has responsiveness.

## Recommendations (ranked)

1. **Fix dark `hint`** (F-4-01). One line, functional bug, no design debate.
2. **Add a contrast guard test** (F-4-11 item 2). ~40 lines of pure Dart, no
   pump, and it converts every finding in the table above into a standing
   assertion. Highest leverage per line of code in this report.
3. **Take the light `mutedText` above 4.5:1** (F-4-03). Needs the designer, but
   it is the app's primary navigation at 2.03:1.
4. **Build a `TextTheme`** (F-4-02) and migrate feature-by-feature behind the
   goldens. Then guard `fontSize:` at call sites the way colours are guarded.
5. **Split `destructive` into fill and text** (F-4-04) — the only token that
   fails on both canvases.
6. **Give the `#7070A0` text tokens a dark value** (F-4-05).
7. **Add `outlinedButtonTheme`, `textButtonTheme`, `dialogTheme` and
   `appBarTheme.titleTextStyle`** (F-4-07). Cheap, and stops the drift before
   there are six `OutlinedButton.styleFrom` sites instead of three.
8. **Resolve the Arabic w600 gap** (F-4-08) — preferably by dropping Cairo and
   standardising on Tajawal's 400/500/700, which folds into recommendation 4.
9. **Escalate `link`, `dialogNote` and `accentSoft` to the designer** (F-4-06) as
   a single contrast question, not three separate ones.
10. Radius/spacing tokens (F-4-10), last.
