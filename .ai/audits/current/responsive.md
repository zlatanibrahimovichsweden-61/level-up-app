# Agent 5 — Responsive & Accessibility

**Scope:** Fixed dimensions, overflow risk, text scaling, keyboard, safe areas,
touch targets, screen-reader semantics — and a project-wide responsive strategy.
**Baseline:** dev @ e3651e6
**Repository areas inspected:**
`lib/core/widgets/*` (all 6), `lib/core/theme/app_theme.dart`, `lib/app.dart`,
`lib/features/shell/main_shell.dart`, `lib/features/shell/screens/tab_placeholder.dart`,
`lib/features/home/{screens,widgets}/*`, `lib/features/catalog/{screens,widgets}/*`,
`lib/features/quiz/{screens,widgets}/*`, `lib/features/profile/{screens,widgets}/*`,
`lib/features/auth/screens/*`, `lib/features/registration/{screens,widgets}/*`,
`lib/features/settings/{screens,widgets}/*`, `lib/features/onboarding/screens/*`,
`lib/features/account_shells/widgets/shell_body.dart`,
`lib/l10n/app_{en,ar}.arb`, `pubspec.yaml` fonts block, `assets/fonts/*.ttf`
(font metric tables read directly), `android/app/src/main/AndroidManifest.xml`,
`test/features/onboarding/onboarding_screen_test.dart`, `test/goldens/*`.

---

## Measured inventory (grounding for everything below)

`width:`/`height:` numeric literals in `lib/` (excluding generated, `l10n/`, `dev/`): **361**.

| Class | Count | Verdict |
|---|---|---|
| (a) stroke widths — `Border.all(width:)`, `BorderSide`, `Divider(height:)` | 33 | Not layout. Fine. |
| (a) `TextStyle(height: a/b)` line-height ratios | 16 | Not layout. **Good practice** — these pin the line box independent of font. |
| (a) single-line `SizedBox(width:\|height: N)` used as a gap | 220 | **Legitimate fixed spacing.** An 8px gap is 8px at any scale. No action. |
| (a) icon / spinner / ornament boxes (24×24 spinners, 20×20, 16×16, 19/9 radio ring, 8×16 chevron, 40×4 drag handle, 24 swatch…) | ~36 | Legitimate — they wrap an `Icon` or `CircularProgressIndicator`, neither of which text-scales. |
| (a) skeleton placeholder blocks (`_Block`, `CatalogBlock`) | 12 | Legitimate by intent. Minor drift vs real content at large scale; not worth fixing. |
| (b) fixed **content** dimension (image/shape, no text) | ~22 | Mostly fine. **4 are real problems** (see F-5-06, F-5-08, F-5-09). |
| (c) fixed box **wrapping scalable text** | **22** | **The whole problem.** Enumerated in F-5-02…F-5-05. |

`fontSize:` literals: **153**, across **17 distinct values**, and
**`Theme.of(context).textTheme` is referenced 0 times in `lib/`.**
`MediaQuery`: 2 uses. `LayoutBuilder`: 0. `textScaler`/`textScaleFactor`: 0.
`Row(`: 87 sites; `Expanded(`/`Flexible(`: 65 — **82 of the 87 Rows already flex
their text.** `Semantics(`/`semanticLabel`/`tooltip:`: 34.

---

## Findings

### F-5-01 [HIGH] [ARCHITECTURE ISSUE] No text-scale policy anywhere, and `app.dart` already has the one hook needed to add one

**Evidence:** `lib/app.dart:51` — `MaterialApp.router` already supplies a
`builder:` (used for `AnnotatedRegion`). It does **not** wrap `child` in a
`MediaQuery` with a bounded `textScaler`. Grep confirms **zero** references to
`textScaler`, `textScaleFactor` or `MediaQuery.textScalerOf` in all of `lib/`.
`lib/core/theme/app_theme.dart:42-67` defines no `textTheme`, so the 153 inline
`fontSize:` literals are the type scale, and there is no central place to bound
it.

**Why it matters:** Android's Settings → Display → Font size runs to **2.0×** on
stock Android 14, and OEM skins common on cheap Egyptian-market handsets ship
their own sliders. Every finding F-5-02…F-5-10 below is the *same* bug —
a box sized for `textScaler == 1.0` — and all of them are neutralised at once by
bounding the scaler. Without the bound, each of the 22 class-(c) sites must be
fixed individually and each is a fresh regression risk.

**Recommended fix:** In the existing `builder:` at `app.dart:51`, wrap `child`:
`MediaQuery.withClampedTextScaling(minScaleFactor: 1.0, maxScaleFactor: 1.3, child: …)`.
1.3 is chosen because it is the highest bound under which *every* class-(c) site
except `subject_card` and `_ProgressBar` survives (see the table in
F-5-02/F-5-03), so the clamp plus two small fixes clears the whole class.

**Risk of fixing:** A student who set 2.0× because they need it gets 1.3×. That
is a **PRODUCT DECISION**, not an engineering one — clamping is an accessibility
*regression* traded for a layout guarantee. Recommended posture: clamp at 1.3
now (ships a working app to the 2.0× user instead of a clipped one), and treat
"support 2.0× properly" as a scoped follow-up, not a silent never.

**Validation required:** `flutter test` after adding the clamp; the widget tests
in `test/features/**` pump at default scale and will not notice.

---

### F-5-02 [HIGH] [BUG] The Subjects grid overflows at textScaler ≈ 1.2 on a 360dp phone — the lowest breaking point in the app

**Evidence:** `lib/features/catalog/widgets/subject_card.dart:21`
(`static const aspectRatio = 173 / 89`) consumed at
`lib/features/catalog/screens/subjects_screen.dart:175` and `:201`
(`childAspectRatio: SubjectCard.aspectRatio`).
On a 360dp-wide device: usable = 360 − 40 (grid padding, `subjects_screen.dart:170`)
= 320; cell width = (320 − 16.5)/2 = **151.75**; cell height = 151.75 / 1.9438 =
**78.1dp**, and that height is *tight* (a `SliverGridDelegate` gives its children
tight constraints).
Card content (`subject_card.dart:36-84`): padding 11+11 = 22, name `fontSize: 16`
(Inter line box 1.21em ⇒ 19.4), gap 10, `LinearProgressIndicator(minHeight: 4)`,
gap 6, counter `fontSize: 10` ⇒ 12.1. **Total 73.5dp — 4.6dp of slack.**
At textScaler 1.2 the two text runs grow to 23.3 + 14.5 ⇒ **79.8 > 78.1**.

**Why it matters:** Subjects is the Learn tab's landing screen — the single most
visited screen after Home. It breaks at the *first notch above default* on the
exact device class the product targets. On a 412dp Pixel the same card has 18dp
of slack and survives to ≈1.55, which is why this would never be caught on a
developer's handset.

**Recommended fix:** Drop `childAspectRatio` and use
`SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisExtent: …)`
— or, minimally, keep the delegate and let the card size itself by replacing
`childAspectRatio` with `mainAxisExtent` derived from the card's own intrinsic
height. The 173/89 ratio is a Figma cell size, not a constraint the design
depends on.

**Risk of fixing:** `test/goldens/design_goldens_test.dart` has no subjects-grid
golden, so no golden churn. Card proportions change slightly at 1.0×.

**Validation required:** Pump `SubjectsScreen` at `Size(360, 640)` with
`textScaler: TextScaler.linear(1.3)` and assert `tester.takeException()` is null.

---

### F-5-03 [HIGH] [BUG] The quiz progress bar clips its counter at textScaler ≈ 1.25

**Evidence:** `lib/features/quiz/screens/quiz_screen.dart:259` —
`Size get preferredSize => const Size.fromHeight(30);` with
`:268` `padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12)` leaving **18dp**
of content box, and `:285-288` `Text(l10n.quizProgress(...), fontSize: 12)`
(line box 12 × 1.21 = 14.5dp). 18 / 14.5 = **1.24**.

**Why it matters:** This bar renders on **every question of every quiz** — the
core product loop. `AppBar.bottom` uses `preferredSize` as a hard height, so the
`Row` gets `maxHeight: 18` and the counter is clipped, not ellipsised.

**Recommended fix:** Make `preferredSize` scale-aware, or (simpler and in the
codebase's idiom) drop the fixed `12` bottom padding to `8` and raise
`preferredSize` to 36 — that buys headroom to 1.9× at the cost of 6dp. Cleanest:
`Size.fromHeight(30 * MediaQuery.textScalerOf(context).scale(1))` is not
available in `preferredSize` (no context), so the padding route is the right
one here.

**Risk of fixing:** 6dp taller app bar on the quiz screen. No golden covers it.

**Validation required:** Widget test pumping `QuizScreen` at 1.3× / 1.5×.

---

### F-5-04 [HIGH] [BUG] Five 35dp title bars clip a 22pt title from textScaler ≈ 1.3

**Evidence:** the same `SizedBox(height: 35)` + `Stack` + `Text(fontSize: 22)`
shape, copied five times:
- `lib/core/widgets/titled_chrome.dart:49-63`
- `lib/features/catalog/widgets/catalog_scaffold.dart:62-74`
- `lib/features/profile/screens/edit_profile_screen.dart:124-136`
- `lib/features/profile/widgets/avatar_sheets.dart:53-66`
- `lib/features/profile/widgets/profile_confirm_dialog.dart:90-101`

22 × 1.21 = 26.6dp; 35 / 26.6 = **1.315**. `Stack` defaults to
`clipBehavior: Clip.hardEdge`, so the title is silently cut off top and bottom
rather than throwing — no yellow stripes, no exception, just a truncated title.
`titled_chrome.dart:16-20` already documents that `EditProfileChrome` is a
knowing duplicate of `TitledChrome`; this is the cost of that duplication —
one fix has to be applied five times.

**Why it matters:** These five bars are the chrome of Settings, Edit Profile, all
four Account shells, and all four catalog drill-down screens. Silent clipping is
worse than an overflow stripe: nothing surfaces it in debug either.

**Recommended fix:** Replace `SizedBox(height: 35)` with
`ConstrainedBox(constraints: BoxConstraints(minHeight: 35))` and let the `Stack`
size to its tallest child. The 35 is a *minimum* from the frame (it is the back
chip's diameter), not a maximum. Collapse the five copies into `TitledChrome`
while doing it.

**Risk of fixing:** `test/goldens/design_goldens_test.dart:73` renders a
375×120 header golden — expect one golden to need regeneration.

**Validation required:** `flutter test --update-goldens` for that one case, then
visual review.

---

### F-5-05 [MEDIUM] [BUG] Fixed-height boxes around button labels — two sites bypass the theme's correct `minimumSize`

**Evidence:** `lib/core/theme/app_theme.dart:61` gets this right:
`minimumSize: const Size.fromHeight(60)` — a *minimum*, so a FilledButton grows
with its label. Two sites hard-cap the same 60 instead:
- `lib/features/profile/screens/edit_profile_screen.dart:605-606` —
  `SizedBox(height: 60, child: FilledButton(... fontSize: 22 ...))`
- `lib/features/account_shells/widgets/shell_body.dart:93-108` —
  `Container(height: 60, ... Text(fontSize: 22))`

22 × 1.21 = 26.6 plus the button's own vertical padding; the box runs out at
≈1.9×. `login_screen.dart:235` and `onboarding_screen.dart:262` use
`minimumSize: Size.fromHeight(60)` correctly, which is the pattern to copy.

**Why it matters:** "Save Changes" is the only write action on Edit Profile.

**Recommended fix:** Delete the `SizedBox`/replace the `Container` height with
`constraints: BoxConstraints(minHeight: 60)`. The theme already supplies the 60.

**Risk of fixing:** None — the rendered height is identical at 1.0×.

---

### F-5-06 [MEDIUM] [BUG] The quiz-length chips never render two-up on the target device

**Evidence:** `lib/features/quiz/screens/quiz_setup_screen.dart:224-225` —
`Ink(height: 45, width: 171, …)` inside
`Wrap(spacing: 15, runSpacing: 15)` (`:108-121`) with page padding 20+20
(`:95`). Two chips need 171 + 15 + 171 = **357dp**. Usable width is 320dp on a
360dp phone and 335dp on a 375dp phone — so the `Wrap` falls to **one chip per
row** on every phone narrower than ~412dp. The Figma frame draws two columns.

**Why it matters:** A pure fixed-content-dimension defect, visible at
textScaler 1.0 on the majority device. Not an overflow — the `Wrap` absorbs it —
so nothing throws and nothing is logged; the screen just silently stops matching
the design and gets twice as tall.

**Recommended fix:** Replace `width: 171` with a two-column `Row` of `Expanded`
children, or `Wrap` with chips sized by
`(constraints.maxWidth - 15) / 2` — this is the **one place a `LayoutBuilder` is
genuinely warranted** (see the strategy section).

**Risk of fixing:** Chip width changes by device. No golden covers this screen.

---

### F-5-07 [MEDIUM] [BUG] OTP boxes overflow horizontally on a 320dp phone

**Evidence:** `lib/features/auth/screens/otp_screen.dart:201-203` —
`PinTheme(width: 48, height: 56)` × `length: 6` (`:255`) = **288dp** of boxes,
inside `SingleChildScrollView(padding: fromSTEB(24, 8, 24, 24))` (`:230`).
Usable width on a 320dp device (480×800 @hdpi) = 320 − 48 = **272 < 288** →
`Pinput`'s internal `Row` overflows by 16dp.
Vertically the boxes are fine: the 22pt digit (`:205`) reaches 53dp at 2.0×,
inside 56.

**Why it matters:** OTP is the mandatory gate to the entire app — a student on a
320dp handset cannot get past it cleanly. 360dp and up are safe (312 > 288).

**Recommended fix:** Wrap the `Pinput` in a `FittedBox(fit: BoxFit.scaleDown)`,
or reduce the box width when `MediaQuery.sizeOf(context).width < 360`. The
`FittedBox` is the simplest robust option and needs no breakpoint.

**Validation required:** I cannot confirm `Pinput`'s internal layout without
running it; the 48×56 and `length: 6` are certain, the overflow behaviour of the
package's `Row` is inferred. **Pump at `Size(320, 568)` to confirm.**

---

### F-5-08 [MEDIUM] [BUG] Fixed-height content boxes that wrap text: banner, ring, language pill

**Evidence:**
- `lib/features/home/widgets/home_banner.dart:26` — `Container(height: 140)`
  wrapping `Text(l10n.learnTodayLeadTomorrow, fontSize: 20)` inside `Expanded`
  (`:42-51`). At 20pt the string wraps to 2 lines in ~250dp; at 1.5× it is 30pt
  and wraps to 4 lines = 145dp > 140. Breaks ≈**1.5**.
- `lib/features/quiz/screens/quiz_result_screen.dart:163-165` —
  `SizedBox(width: 180, height: 180)` with `Text('100%', fontSize: 44)` at
  `:177-188`. Four bold glyphs at ~0.6em ≈ 106dp at 1.0×; 180/106 ⇒ breaks
  ≈**1.7** horizontally (the `Stack` clips).
- `lib/core/widgets/language_pill.dart:34` — `Container(height: _height)` where
  `_height = 36.10`, wrapping `Text(fontSize: 14, height: 21/14)` ⇒ 21dp line
  box. 36.1/21 ⇒ breaks ≈**1.71**. The pill appears on Onboarding, Login, OTP
  success and both registration screens.

**Recommended fix:** All three: `minHeight` instead of `height`. The ring needs
`FittedBox` around its label as well.

---

### F-5-09 [MEDIUM] [QUALITY IMPROVEMENT] Touch targets below the 48×48 Material minimum

**Evidence:**
| Site | Size |
|---|---|
| `lib/core/widgets/circle_back_button.dart:20,40-42` | 35 × 35 |
| `lib/features/catalog/widgets/catalog_scaffold.dart:83-85` | 35 × 35 |
| `lib/features/profile/widgets/avatar_sheets.dart:69-75` | `BoxConstraints.tightFor(35, 35)` + `padding: EdgeInsets.zero` |
| `lib/features/profile/widgets/profile_confirm_dialog.dart:105-111` | same 35 × 35 |
| `lib/features/catalog/screens/subjects_screen.dart:103` | `minimumSize: Size(0, 35)` |
| `lib/features/catalog/widgets/quiz_type_tabs.dart:84-87` | vertical padding 9 + 14pt text ⇒ ~35dp tall |
| `lib/features/auth/screens/login_screen.dart:418-421` | `GestureDetector` on bare 14pt `Text` ⇒ **~17dp tall** |

`CircleBackButton` is the app's shared back affordance and is on nearly every
non-tab route; the three legal links on Login are the smallest targets in the
app by a wide margin.

**Recommended fix:** The 35dp chips are a design constant (Figma `90:208`) — do
**not** resize the painted circle. Wrap each in
`SizedBox(width: 48, height: 48, child: Center(child: <35dp chip>))` so the
*hit area* is 48 and the *paint* stays 35. For the legal links, replace
`GestureDetector` with `InkWell` + `Semantics(link: true)` + 8dp vertical
padding (this also fixes F-5-10).

**Risk of fixing:** The 48dp hit boxes on `catalog_scaffold`/`titled_chrome` sit
inside a `SizedBox(height: 35)` — F-5-04's fix must land first or the hit box is
clipped.

---

### F-5-10 [MEDIUM] [BUG] Interactive elements with no accessible name

**Evidence:** 34 semantics sites exist and the *hard* ones are done well
(nav tabs `main_shell.dart:267,335`; disabled rows
`profile_menu_row.dart:114-121`; `settings_rows.dart:200-228`'s
`ExcludeSemantics`/`MergeSemantics` pair, which is **correct** and well
reasoned). The gaps are all icon-only or role-only controls:

| Site | Gap |
|---|---|
| `lib/features/quiz/screens/quiz_screen.dart:122-129` | `IconButton(icon: Icon(Icons.close))`, no `tooltip` → announces as an unnamed button. This is the **quit-quiz** control. |
| `lib/features/quiz/screens/quiz_result_screen.dart:53-56` | `IconButton(icon: Icon(Icons.arrow_back))`, no `tooltip`. |
| `lib/features/catalog/widgets/catalog_scaffold.dart:78-80` | `Semantics(button: true, child: InkWell(child: … Icon(backChevron)))` — `button: true` with **no `label:`** and no text descendant. Announces "button", nothing more. Compare `circle_back_button.dart:31-33`, which does it right with `MaterialLocalizations.backButtonTooltip`. |
| `lib/features/auth/screens/login_screen.dart:418-421` | Three legal links: `GestureDetector` + `Text`, no `button`/`link` role. |
| `lib/core/widgets/language_pill.dart:30` | `InkWell` with no `Semantics(button: true)` — the language toggle reads as static text. |
| `lib/features/catalog/widgets/subject_card.dart:34` | `InkWell` on the whole card, no button role. |
| `lib/features/catalog/widgets/tree_list_row.dart:56` | same — the Units/Chapters/Lessons row. |
| `lib/features/home/widgets/home_header.dart:161-171` | avatar `CachedNetworkImage`, no `semanticLabel`. Same at `profile_header_card.dart:125-135`. |

`home_header.dart:123-129` labels the bell `l10n.notifications` on the SVG while
the chip is deliberately inert (`:11-14`) — that is *correct*: it announces as a
labelled image, not a button.

**Recommended fix:** `tooltip:` on the two `IconButton`s (one line each);
`label:` on `catalog_scaffold.dart:78`; `Semantics(button: true, ...)` around the
three `InkWell`s; `Semantics(link: true)` on the legal links.

**Why it matters:** Egyptian schools have a real assistive-tech population and
this is an education product. Half the app's navigation currently announces as
unnamed buttons.

---

### F-5-11 [LOW] [QUALITY IMPROVEMENT] Only 5 `Row`s in 87 have an unflexed `Text` — and none is an RTL overflow

**Evidence:** a brace-matched scan of every `Row(` in `lib/` finds exactly five
whose subtree contains a `Text` and no `Expanded`/`Flexible`/`Spacer`:
- `lib/core/widgets/language_pill.dart:41` — `mainAxisSize.min`, one short
  endonym. Cannot overflow horizontally.
- `lib/features/home/widgets/coming_soon_section.dart:63` — centred icon +
  `l10n.comingSoon` (EN "Coming soon" / AR "قريبًا"). ~226dp at 2.0× in ≥320dp.
- `lib/features/home/widgets/level_card.dart:113-128` — two 11pt `Text`s with
  `spaceBetween` in a ~294dp card. ~180dp at 2.0×.
- `lib/features/quiz/screens/quiz_result_screen.dart:280-295` — star icon +
  `l10n.pointsAwarded` at `fontSize: 20`. **~230dp at 2.0× in a ~248dp card —
  the only one that is genuinely tight.**
- `lib/features/registration/widgets/reference_dropdown.dart:98-111` — 20dp
  spinner + `l10n.selectHint` ("Select" / "اختر"). Trivially short.

**On the RTL premise:** I checked the ARB pairs directly and **Arabic is not
systematically longer in this app**. `See All`→`عرض الكل`, `Coming soon`→`قريبًا`,
`Select`→`اختر`, `Leaderboard`→`المتصدرون` are all equal or *shorter*. The two
strings where Arabic is materially longer — `retry` (`إعادة المحاولة`, 5→14
chars) and `profileGoToUniversity` (`التحويل إلى الجامعة`) — both already sit in
`Expanded`/ellipsised slots (`profile_menu_row.dart:93-105`). **There is no
Arabic-length Row overflow in this codebase.** Row discipline here is good and
should be recorded as such rather than "fixed".

**Recommended fix:** Wrap only `quiz_result_screen.dart:284` in `Flexible`. Leave
the other four.

---

### F-5-12 [LOW] [BUG — latent] Cairo's line box is 1.87em; every fixed-height box is tuned to Inter's 1.21em

**Evidence:** read directly from the bundled font tables
(`assets/fonts/*.ttf`, `hhea`/`OS/2`):

| Family | unitsPerEm | ascent − descent + gap | line box |
|---|---|---|---|
| Inter 18pt (all 4 weights) | 2048 | 1984 − (−494) | **1.210 em** |
| Tajawal (all 3 weights) | 1000 | 643 − (−357) + 200 | **1.200 em** |
| **Cairo** (all 3 weights) | 1000 | 1303 − (−571) | **1.874 em** |

`app_theme.dart:47-48` sets `fontFamily: 'Inter'` with
`fontFamilyFallback: ['Tajawal', 'Cairo']`. Arabic resolves to Tajawal (1.20em ≈
Inter's 1.21em), which is why Arabic does **not** currently break the 22 fixed
boxes. But any run that falls through to **Cairo** gets a line box **55% taller**,
and every one of those boxes then overflows at scale 1.0. There is **no
`strutStyle` anywhere in `lib/`** (grep: 0 hits) to normalise this.

Secondary: Tajawal ships no weight-600 file (`pubspec.yaml` declares 400/500/700)
while `FontWeight.w600` is used in ~20 places — Arabic silently renders at a
synthesised or rounded weight.

**Why it matters:** This is a tripwire, not a live bug. It fires the day someone
reorders the fallback list, drops Tajawal, or ships a glyph Tajawal lacks.

**Recommended fix:** Either set an app-wide
`strutStyle: StrutStyle(forceStrutHeight: true, height: 1.25)` on the
`DefaultTextStyle` at the app root, or — better and cheaper — apply F-5-04's
`minHeight` change so no box depends on the line box at all.

**Validation required:** Requires the toolchain to confirm which font actually
resolves for a given Arabic string. The metric numbers above are exact.

---

### F-5-13 [LOW] [QUALITY IMPROVEMENT] No `textTheme`; 153 inline `fontSize` literals

**Evidence:** `app_theme.dart:42-67` defines `colorScheme`, `fontFamily`,
`appBarTheme` and `filledButtonTheme` — no `textTheme`. `grep textTheme lib/` →
**0**. The 17 distinct `fontSize` values (18 ×33, 14 ×31, 22 ×23, 16 ×20,
20 ×12, …) are the de-facto type scale, declared 153 times.

**Why it matters:** Not a rendering bug — inline `fontSize` scales with
`textScaler` exactly like a `textTheme` value would. It is a *changeability*
problem: there is nowhere to adjust the type scale, and it is the reason the
project has 5 copies of the same 22pt title bar. Contrast the theme discipline
for colour, which is exemplary (`app_colors.dart`, 0 hex literals outside it,
enforced by `palette_discipline_test.dart`).

**Recommended fix:** Not now, and not as a blanket migration. Add a `textTheme`
only when a second consumer needs it. Record the 17 values in `docs/RESPONSIVE.md`
so the next new screen picks from the list instead of inventing an 18th.

---

### F-5-14 [INFO] Keyboard handling is clean — no action required

**Evidence:** `android/app/src/main/AndroidManifest.xml:22` sets
`android:windowSoftInputMode="adjustResize"`. Every screen carrying a text field
puts it inside a scrollable:

| Screen | Scrollable | Line |
|---|---|---|
| `login_screen.dart` | `Expanded > SingleChildScrollView` | `:131-133` |
| `otp_screen.dart` | `SingleChildScrollView` in `_InputView` | `:229-230` |
| `signup_identity_screen.dart` | `Expanded > SingleChildScrollView` | `:110-112` |
| `school_detail_screen.dart` | `Expanded > SingleChildScrollView` | `:100-102` |
| `university_detail_screen.dart` | `Expanded > SingleChildScrollView` | `:91-94` |
| `edit_profile_screen.dart` | `SingleChildScrollView` in `_Form` | `:299-300` |
| `subjects_screen.dart` (search field) | field is above an `Expanded` grid; both shrink | `:57-78` |
| `school_picker_field.dart` (search sheet) | `Padding(bottom: viewInsets.bottom)` + `Expanded > ListView` | `:190-193`, `:215-262` |

`school_picker_field.dart:192` is one of the app's only two `MediaQuery` uses and
it is used correctly. **Zero keyboard-overflow screens found.** This is the
strongest area of the audit.

---

### F-5-15 [INFO] Safe areas are consistent and deliberate — no action required

**Evidence:** 25 `SafeArea` sites. Every full-screen route either wraps its body
(`login`, `otp`, `home`, `profile`, `edit_profile`, `settings`, all 4 account
shells, all 4 registration screens, all 3 quiz screens, `catalog_scaffold`) or
uses a Material `AppBar`+`Scaffold` that handles it (`tab_placeholder.dart:21-22`).
The tab-root screens correctly pass `bottom: false` with the comment
"the nav shell owns the bottom inset" (`home_screen.dart:46`,
`profile_screen.dart:68`, `catalog_scaffold.dart:29`), and the shell then adds
that inset itself at `main_shell.dart:49,87,99` via `MediaQuery.viewPaddingOf` —
the app's other `MediaQuery` use, also correct. Both bottom sheets use
`SafeArea(top: false)` (`avatar_sheets.dart:41-42`, `limit_sheet.dart:55`).
Nothing to fix.

---

### F-5-16 [INFO] The bottom nav bar survives 2.5× text scale — no action required

**Evidence:** I traced `main_shell.dart:273-304` and `:341-368` arithmetically
because the brief flagged it as a suspect. `_NavTab`'s column is
15 + 2 + 25 + 24 + 4 + label, where the label is `fontSize: 11, height: 14/11`
(`:238-242`) — an **explicit ratio**, so the line box is exactly `11 × scale ×
(14/11) = 14 × scale`. Content = 70 + 14·s inside `kNavTotalHeight = 111`
(`:137`). Overflow needs `s > 2.9`. `_CentreTab` is 6 + 52 + 12 + 14·s = same.
Labels ellipsise (`maxLines: 1, overflow: TextOverflow.ellipsis`, `:300-301`)
rather than overflow when "Leaderboard" outgrows the 72dp tab.
**The nav bar is the best-built widget in the app for text scaling**, and the
reason is the explicit `height: 14/11` — the pattern the rest of the app should
copy (see F-5-12).

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

---

## Proposed project-wide responsive strategy

The brief says "do not blindly add responsive abstractions everywhere; use the
simplest robust solution". This app is a **single-form-factor phone app for one
market**. It does not need breakpoints, a sizing utility package, or a
`ResponsiveBuilder`. It needs four things.

**1. No breakpoints. One `LayoutBuilder`.**
Every screen is a single column that already stretches. The only place a
breakpoint would earn its keep is `quiz_setup_screen.dart:225`'s fixed-width
chips (F-5-06), and even there the answer is a `LayoutBuilder` computing
`(maxWidth - 15) / 2`, not a `if (width > 600)`. Adopt: **`LayoutBuilder` is
allowed only where a child's width must be derived from the parent's; it is not
a general layout tool.** Target the 320–430dp band; treat tablets as
"must not crash", not "must be designed for" — which is already what
`onboarding_screen.dart:44-50` documents.

**2. Clamp `textScaler` at 1.3, in `app.dart`'s existing `builder:`.**
One insertion, ~3 lines, at `lib/app.dart:51`. This neutralises 20 of the 22
class-(c) sites outright. It is a **PRODUCT DECISION** (it caps a real
accessibility feature) and must be logged in `docs/DECISIONS.md`, not shipped
silently. 1.3 rather than 1.5 because `subject_card` and `_ProgressBar` break
below 1.3 and must be fixed regardless — 1.3 is the bound at which the *rest* of
the app is provably safe.

**3. `minHeight`, never `height`, around anything that contains text.**
This is the whole fix for F-5-04, F-5-05, F-5-08. Nine sites. Fixed `height:`
stays legal for icons, spinners, images, ornaments and gaps — where it is 90% of
the current 361 uses and entirely correct.

**4. Specific widgets to change (the complete list, ranked):**

| Priority | File:line | Change |
|---|---|---|
| 1 | `catalog/widgets/subject_card.dart:21` + `screens/subjects_screen.dart:175,201` | Drop `childAspectRatio`; use `mainAxisExtent` |
| 2 | `quiz/screens/quiz_screen.dart:259,268` | `preferredSize` 30 → 36, bottom padding 12 → 8 |
| 3 | `core/widgets/titled_chrome.dart:49` + 4 duplicates | `SizedBox(height: 35)` → `ConstrainedBox(minHeight: 35)`; collapse the 5 copies |
| 4 | `app.dart:51` | Clamp `textScaler` to 1.3 |
| 5 | `quiz/screens/quiz_setup_screen.dart:224` | `LayoutBuilder`, drop `width: 171` |
| 6 | `profile/screens/edit_profile_screen.dart:605`, `account_shells/widgets/shell_body.dart:94` | `height: 60` → theme's `minimumSize` |
| 7 | `home/widgets/home_banner.dart:26`, `quiz/screens/quiz_result_screen.dart:164`, `core/widgets/language_pill.dart:34` | `height` → `minHeight` (+ `FittedBox` on the ring's label) |
| 8 | `auth/screens/otp_screen.dart:254` | `FittedBox(fit: BoxFit.scaleDown)` around `Pinput` |
| 9 | `core/widgets/circle_back_button.dart:40` + 4 more (F-5-09) | 48dp hit box around the 35dp paint |
| 10 | 8 sites in F-5-10 | `tooltip:` / `label:` / `Semantics(button\|link:)` |
| 11 | `quiz/screens/quiz_result_screen.dart:284` | Wrap in `Flexible` |

**5. The guard test.** The pattern already exists in this repo —
`test/features/onboarding/onboarding_screen_test.dart:209-231` sweeps three
`Size`s and asserts `tester.takeException()` is null. Generalise it to a
matrix and put it in `test/responsive/layout_matrix_test.dart`:

```dart
const sizes = [Size(320, 568), Size(360, 640), Size(412, 915)];
const scales = [1.0, 1.3, 1.5];
for (final size in sizes) {
  for (final scale in scales) {
    for (final locale in ['en', 'ar']) {
      testWidgets('$size @${scale}x $locale', (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(harness(
          locale: Locale(locale),
          textScaler: TextScaler.linear(scale),
          child: const SubjectsScreen(),   // one entry per top-level screen
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);   // catches RenderFlex overflow
      });
    }
  }
}
```

18 cases per screen. Start with the six screens that carry the findings above
(Subjects, Quiz, Quiz Setup, Quiz Result, Edit Profile, Home) — 108 cases,
cheap, and it converts "someone eyeballed it on a Pixel" into a fact. Note that
`takeException()` catches `RenderFlex` overflow but **not** the silent `Stack`
clipping in F-5-04 — for those, assert
`tester.getSize(find.byType(TitledChrome)).height >= expected` explicitly.

---

## Responsive rules — lift verbatim into `docs/RESPONSIVE.md`

> ### Target
> This is a phone app for one market. Design and test against **320–430dp wide**.
> Tablets must not crash; they are not designed for. There are **no breakpoints**
> in this codebase and adding one requires a note in `DECISIONS.md`.
>
> ### Text scale
> The app clamps `textScaler` to **1.3×** at the root (`lib/app.dart`). That is a
> product decision recorded in `DECISIONS.md`, not a technical limit. Every screen
> must render correctly at **1.0×, 1.3× and 1.5×** in both `en` and `ar` — 1.5 is
> tested even though it is clamped, so the clamp can be raised later without a
> rewrite.
>
> ### Fixed dimensions
> A hardcoded `width:` or `height:` is **correct** for: gaps (`SizedBox`), icons,
> spinners, images, borders, ornaments, avatars and skeleton blocks.
> A hardcoded `height:` is **forbidden on any box whose subtree contains a `Text`
> or a `TextField`.** Use `ConstrainedBox(constraints: BoxConstraints(minHeight: N))`
> or the theme's `minimumSize`. A Figma height is a *minimum*, not a maximum.
>
> ### Line boxes
> When a Figma frame gives you both a font size and a line height, write it as a
> ratio: `TextStyle(fontSize: 11, height: 14 / 11)`. That pins the line box
> independent of which font resolves — the bundled families disagree by 55%
> (Inter 1.21em, Tajawal 1.20em, **Cairo 1.87em**). Do not rely on the font's
> default metrics inside a constrained box.
>
> ### Rows
> A `Text` inside a `Row` is wrapped in `Expanded` or `Flexible` unless it is
> provably shorter than the narrowest slot it can occupy. 82 of the app's 87 Rows
> already do this; keep it that way.
>
> ### Width
> Never hardcode the width of a content box. If a child's width must follow its
> parent, use `LayoutBuilder` — that is the *only* sanctioned use of
> `LayoutBuilder` in this codebase.
>
> ### Keyboard
> `adjustResize` is set in the manifest. **Every screen containing a `TextField`
> puts it inside a `SingleChildScrollView` or a `ListView`.** No exceptions; a
> form in a bare `Column` overflows the moment the keyboard opens.
>
> ### Safe areas
> Full-screen routes wrap their body in `SafeArea`. Tab-root screens pass
> `bottom: false` — the nav shell owns the bottom inset and adds it itself. Bottom
> sheets use `SafeArea(top: false)`.
>
> ### Touch targets
> Every tappable element has a **48×48dp hit area**. If the design draws something
> smaller, keep the paint and enlarge the hit box:
> `SizedBox(width: 48, height: 48, child: Center(child: <35dp chip>))`.
>
> ### Semantics
> Every icon-only control carries a `tooltip:` (on `IconButton`) or an explicit
> `Semantics(label:)`. `Semantics(button: true)` without a `label:` and without a
> `Text` descendant is a bug — it announces "button" and nothing else. A tappable
> `InkWell` or `GestureDetector` that is not a Material button declares its role
> (`button: true` / `link: true`).

---

## Remaining Risks

- **The 1.3 clamp is a product decision I cannot make.** If product rejects it,
  every one of the 22 class-(c) sites needs an individual fix and the guard test
  matrix has to run to 2.0×.
- **F-5-07's Pinput overflow is inferred, not observed** — the package's internal
  `Row` behaviour is unverified without the toolchain.
- **Silent `Stack` clipping (F-5-04) is invisible to `takeException()`.** The
  guard test must assert sizes explicitly for those five sites or the regression
  will come back.
- **No golden covers Subjects, Quiz Setup or Quiz Result** — the three screens
  with the worst fixed-dimension defects. Fixing them is unprotected.
- Cheap Android handsets often ship OEM display-size ("screen zoom") settings
  *in addition to* font size; screen zoom changes the effective dp width, which
  can push a 360dp phone to 320dp. F-5-02 and F-5-07 both fire in that
  configuration. Not modelled here.

## Deferred Improvements

- A `textTheme` in `app_theme.dart` (F-5-13) — worthwhile, but only after the
  five title-bar duplicates are collapsed, not before.
- App-wide `StrutStyle` (F-5-12) — the `minHeight` fixes make it unnecessary;
  revisit only if Cairo ever becomes the primary Arabic face.
- Tajawal weight-600 file (F-5-12 secondary) — typography, out of this scope.
- `integration_test/` device sweep across 320/360/412 at 1.0/1.3 — the widget-test
  matrix covers the same ground at a fraction of the cost; do that first.

## Recommendations (ranked)

1. **`subject_card` aspect ratio** (F-5-02) — breaks at 1.2× on the target device,
   on the app's second-most-visited screen. Fix first regardless of the clamp.
2. **Quiz progress bar `preferredSize`** (F-5-03) — breaks at 1.25× on every
   question of every quiz. One-line fix.
3. **Clamp `textScaler` to 1.3 in `app.dart:51`** (F-5-01) — three lines, kills
   20 of 22 remaining defects. Needs a `DECISIONS.md` entry.
4. **`SizedBox(height: 35)` → `minHeight` in the five title bars** (F-5-04), and
   collapse the duplicates while you are in there.
5. **Semantics labels on the eight unnamed controls** (F-5-10) — one line each,
   and this is an education product.
6. **48dp hit boxes** (F-5-09) — mechanical, low risk, do it in the same pass.
7. **`quiz_setup` chip width** (F-5-06) — the one legitimate `LayoutBuilder`.
8. **Write `test/responsive/layout_matrix_test.dart`** before any of the above
   lands, so each fix is provably a fix.
9. **Write `docs/RESPONSIVE.md`** from the prose block above — the project has no
   written responsive rule at all, which is the actual root cause of this report.
10. Leave the 220 `SizedBox` gaps, the 33 border widths and the 36 icon boxes
    alone. They are correct. This codebase's fixed-dimension problem is 22 sites,
    not 257.
