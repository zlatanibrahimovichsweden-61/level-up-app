# Edit 1 — Elevation Foundation: tokens, Glass & back-light primitives, inset/segmented primitives, guard

> **Implement this file first.** Edits 2–5 consume the tokens and primitives defined here and must
> not create their own. This file is self-contained: every Figma value you need is in §5 and §8.
>
> Written 2026-09-17 from the Figma-vs-Flutter elevation audit (2026-09-16) plus a Glass/back-light
> reading taken 2026-09-17. Figma file `P6044i0giD9TmdQ7C2AmLq`, page `design`, sections
> `light mode` / `Dark mode` / `RTL`.

---

## 0. Pre-flight (do this before touching code)

1. Read `CLAUDE.md` (repo root), `docs/WAVE_STATUS.md`, `docs/AGENT_WORKFLOW.md` § "Theme discipline",
   `docs/ENFORCEMENT.md`. The five rules in `CLAUDE.md` §1.3 apply; in particular **never invent a
   design value** and **reading is not running**.
2. `git status --short`. The tree is intentionally dirty with other in-flight work. Files this edit
   touches that **already carried uncommitted, unrelated edits on 2026-09-17**:
   `lib/core/theme/app_colors.dart` (quiz-review + leaderboard tokens), `docs/DESIGN_ISSUES.md`,
   `docs/ENFORCEMENT.md`, `tool/verify_guards.ps1`. Do **not** discard, stash or reformat those
   hunks. If you cannot tell whose they are, ask the owner before editing (several sessions edit this
   repo concurrently).
3. Run `powershell -ExecutionPolicy Bypass -File tool\validate.ps1`. Record the passing test count;
   it must not go down.
4. Do not commit unless the owner asks. When asked: Conventional Commits, one concern per commit,
   only the files you changed, commit body carries the reasoning.

---

## 1. Scope

This edit owns the **foundation** only. No screen or component is restyled here, and no existing
token value changes (§3).

| # | Item | Summary |
|---|---|---|
| 34 | Dark shadow colour | Measured **black** dark shadow tokens; the cream "derived rim light" is withdrawn and `elevationShadow` is frozen for deletion as edits 2–5 migrate its call sites |
| 35 | Glass primitive + measured Glass tokens | Figma **Glass** effect is a required design primitive (designer-confirmed 2026-09-17) |
| 36 | Lavender back-light primitive + inventory | `#AE87E7` ellipses behind glass surfaces are required (designer-confirmed) |
| 37 | Figma → Flutter shadow/blur conversion + knockout rule | One place that maps Figma numbers to Flutter paint |
| 38 | Elevation guard (ratchet); palette-test groups frozen for later removal | Mechanise "no raw elevation outside the theme/primitives" |
| 39 | Near-identical small shadows | Resolved: implement each verbatim, never normalise |
| 40 | Inset-shadow painter + `SegmentedTrack` primitive | Shared by quiz tabs (edit3), scope toggle (edit4), Settings language + OTP timer (edit5) |
| 55 | Unbuilt screens that use Glass | Inventory only, so the values are not lost |

It also builds the `PrimaryCta` wrapper primitive (§7.4 e) that item #12 needs. The design item
itself belongs to edit2, and its call sites are wrapped by edits 2, 4 and 5.

It also defines **every palette and elevation token that is known today** for edits 2–5 (§8). Those
edits consume tokens and edit `app_colors.dart` / `app_elevation.dart` only to:

- (a) delete a token they fully retired, or
- (b) add or correct a token that their own guide names explicitly, backed by a fresh Figma reading
  with a node citation. Examples: `quizPrevButtonRadius`, unread glyph/label colours, a re-read hex.

They never re-value a token on inference.

## 2. Objective

After this edit:

- `AppElevation` (a `ThemeExtension`, light + dark) holds every Figma shadow, inset shadow, Glass
  style, back-light, scrim and theme-dependent border width that edits 2–5 need, with the Figma node
  cited per token.
- `lib/core/widgets/elevation/` holds the only code allowed to paint raw shadows/blur/glass:
  `ElevatedSurface`, `GlassSurface`, the shadow/inset painter, `SegmentedTrack` and `PrimaryCta`.
- Every dark shadow **token** is the measured black. The derived cream survives only in the frozen
  `AppColors.elevationShadow`, which existing call sites keep using until their own edit moves them to
  `AppElevation`. After edits 2–5, nothing paints cream and the token is deleted.
- A ratchet guard stops new raw `BoxShadow`/`elevation:`/`shadowColor:`/blur/backdrop code outside
  those two folders, and each later edit lowers it to 0.
- The Figma→Flutter conversion (blur → sigma, frost → sigma, light angle convention, knockout) is
  implemented once and calibrated once.

## 3. Dependencies

- **Depends on:** nothing.
- **Required by:** edit2, edit3, edit4, edit5 (all of them).
- **Visible side effect when this lands alone: none, by design.** This edit adds tokens,
  primitives, tests, the guard and docs. It changes **no existing token value**. Flipping
  `elevationShadow` to black here would darken the 20%-alpha cards that still paint an unclipped
  `BoxShadow` beneath their fill (e.g. `ProfileHeaderCard`, `ProfileStatCard`, `MistakesSubjectCard`)
  until their edit lands. Each component switches to black when it moves onto `ElevatedSurface`,
  which knocks the shadow out (R4).

## 4. Design rules — authoritative for all five edits

- **R1 — Theme mechanisms differ on purpose.** Light elevates with drop shadows. Dark elevates with
  Figma **Glass** on 20%-alpha surfaces plus lavender back-lights; where a dark surface keeps a
  shadow, it is the **same black** shadow as light. A dark node without a shadow is not a missing
  shadow.
- **R2 — Verbatim values.** Every offset/blur/spread/alpha comes from Figma. The five near-identical
  small shadows (0.02/0.02 with blur 1.5, 1.6, 2, 2.3, 3) stay five tokens (#39).
- **R3 — Blur conversion** (`lib/core/theme/glass_mapping.dart`, §7.5):
  - Drop/inner shadow "Blur" `B` (Figma panel = CSS blur radius) → Gaussian **σ = B / 2** (CSS spec).
    Do **not** use `BoxShadow(blurRadius: B)`: Flutter converts it to σ = 0.57735·B + 0.5
    (`dart:ui` `Shadow.convertRadiusToSigma`, verified in the pinned SDK 3.44.7), which renders
    small Figma shadows up to 2× too soft.
  - Layer blur panel value `P` → σ = P / 2 (Figma's own CSS export halves it: panel 8 → `blur(4px)`).
  - CSS-exported `backdrop-filter: blur(X)` → σ = X (the export already halved the panel value).
  - Glass `radius` (frost) `R` → σ = R × `kGlassFrostToSigma` (starts at 0.5, same convention as
    Figma's background blur; confirmed by calibration §12).
- **R4 — Knockout.** Every drop shadow in the file has `showShadowBehindNode: false`: an outer shadow
  is never visible through the surface's own fill. Paint outer shadows clipped to *outside* the
  shape. This matters on every 20%/30% surface.
- **R5 — Glass = tint + frost + rim light (+ refraction/dispersion).** Over a uniform backdrop (the
  flat page, or an opaque parent row) frost, refraction and dispersion are visually a no-op, so a
  surface renders as tint + rim light (+ frosted back-light). Only surfaces with real content behind
  them (the onboarding sheet over its illustration) need a real `BackdropFilter`.
- **R6 — Back-lights are background shapes.** Solid `#AE87E7` ellipses, no blur, no opacity,
  locked, placed entirely behind one glass surface. The visible lavender glow is that ellipse seen
  through the surface's frost. Implement them as part of the covering surface (they scroll with it),
  frosted with that surface's frost σ, clipped to its shape.
- **R7 — Inner shadows are real insets**, never an outer `BoxShadow` imitation.
- **R8 — Colour discipline.** Colours live only in `lib/core/theme/`; widgets reach effects only
  through `lib/core/widgets/elevation/` primitives.
- **R9 — RTL.** Shadow offsets and Glass `lightAngle` stay physical (Figma evidence: the RTL
  onboarding sheet `549:29406` carries the same `lightAngle 37` as LTR `459:43873`). Back-light
  offsets are **directional** (mirrored in RTL so the glow stays behind the leading content), an
  assumption consistent with the build's "mirror structurally" precedent (DESIGN_ISSUES #58/#64).
  No dark RTL frames exist to confirm it.
- **R10 — Disabled.** Figma draws no disabled states. Where a control's elevation must dim, reuse
  the project convention: the whole treatment at 0.45 opacity (`kProfileDisabledOpacity`, the
  FilledButton theme).

## 5. Figma evidence

### 5.1 Glass parameters — measured 2026-09-17

The view-only seat hides Glass everywhere: Design panel (icon only), Dev Mode inspect, CSS / SwiftUI /
UIKit export, Copy properties and Copy as SVG. The design-mode Plugins menu is "Unavailable in
view-only". With owner approval, a local read-only **Dev Mode development plugin** (no network, read
of `node.effects` only, removed afterwards) read every node on `design`. The plugin API reports
`{type:"GLASS", radius, refraction, depth, lightAngle, lightIntensity, dispersion, splay}`. 2169 nodes
have effects and 20 distinct Glass settings exist. Values are Figma UI values (the API returns
float32, e.g. `0.7300000190734863` = 0.73).

| Group | Token (§8.2) | frost `radius` | refraction | depth | lightAngle° | lightIntensity | dispersion | splay | Nodes (examples) | Built consumer |
|---|---|---|---|---|---|---|---|---|---|---|
| G1 | `onboardingSheetGlass` (**both themes**) | 80 | 0.73 | 27 | 37 | 0.95 | 0.62 | 0.76 | light `459:43873`, RTL `549:29406`, dark `337:15643` | onboarding sheet (edit2) |
| G2 | `registrationBackChipGlass` | 20 | 1.00 | 36 | 22 | 0.25 | 0.70 | 0.16 | `340:19731`, `349:16811`, `337:15896`, `337:19690` (Sign Up_1/2) | registration back chip (edit2) |
| G3 | `languagePillGlass` | 4 | 0.80 | 20 | −45 | 0.25 | 0.50 | 0 | `340:19734`, `349:16814`, `337:19540`, `337:19535`, `337:19530`, `337:19522`, `337:19693` | language pill, **all 7 dark instances incl. OTP** (edit2) |
| G4 | `fieldGlass` | 0 | 1.00 | 53 | 28 | 0.25 | 0.50 | 0.97 | `348:8659`, `348:8664`, `337:15718`, `337:19636` … (19) | form fields (edit2) |
| G5 | `surfaceGlass` (Figma default) | 4 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | 363 nodes, see §5.1.1 | many (edits 2–5) |
| G6 | `levelCardGlass` | 62 | 0.80 | 78 | −45 | 0.80 | 0.50 | 1.00 | `337:5336` (school), `349:16593` (uni) | level card (edit3) |
| G7 | `dailyTasksGlass` | 39 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:5357`, `349:16615` | Daily Tasks placeholder (edit3) |
| G8 | — (not built) | 4 | 0.80 | 20 | −45 | 0.80 | 0.43 | 0 | Home task discs `337:5359` … | none |
| G9 | `topStudentGlass` | 34 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:5460`, `349:16690` | Top Student placeholder (edit3) |
| G10 | `leaderboardRowGroupGlass` | 4 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0.31 | Group nodes `337:5621`, `337:5629` … (wrap each row) | leaderboard rows (edit4) |
| G11 | — (not built) | 76 | 0.87 | 38 | −45 | 0.80 | 0.48 | 0.27 | drill-down search fields `348:7436`, `348:7449` … | none (#17: not built) |
| G12 | — (blocked) | 73 | 0.80 | 20 | −45 | 0.80 | 0.11 | 0.59 | pool card `337:6275`, `349:15412` | none (S15) |
| G13 | `quizPrevButtonGlass` | 45 | 0.63 | 17 | 51 | 0.80 | 0.50 | 0.48 | `337:6464`, `404:8198` … (13) | quiz previous button (edit4) |
| G14 | `rewardsCardGlass` | 54 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:6680`, `349:14575` | rewards card (edit4) |
| G15 | `profileHeaderGlass` | 57 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:7455`, `349:12941` | profile header (edit5) |
| G16 | `settingsSectionGlass` | 63 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `642:8583`, `337:8195`, `349:12171` | settings sections (edit5) |
| G17 | — (not built) | 48 | 0.82 | 58 | −45 | 0.80 | 0.50 | 0 | Customer Support `337:8543`, `349:11054` | none |
| G18 | `aiPanelGlass` | 33 | 0.80 | 20 | −45 | 0.80 | 0.50 | 0 | `337:9270`, `349:15005` | AI panel outer container (edit4) |
| G19 | `otpDigitGlass` | 56 | 0.80 | 100 | −45 | 0.80 | 0.65 | 0.50 | `I337:19295;337:19276`–`…19279`, `I337:19501;337:19276`–`…19279` | OTP digit boxes (edit5) |
| G20 | `trackCardGlass` | 4 | 0.80 | 20 | 25 | 0.80 | 0.50 | 0 | `337:15981` (Sign Up_2, first card) | track card (edit5) |

Only G1 exists in **light** mode. Every other Glass node is in `Dark mode`.

#### 5.1.1 G5 (default Glass) — built consumers

| Component | Fill | Nodes |
|---|---|---|
| Back chip (Learn, Settings, Result, Leaderboard, Mistakes, …) | `#27282C` @20% | `404:7424`, `337:5694` … (55) |
| Tree-row index disc (Units/Chapters/Lessons/Lectures/Mistakes) | `#27282C` @20% | `404:7767`, `404:7781` … (52) |
| Profile menu row | `#27282C` @20%, no stroke | `337:7479` … (17); Logout row `337:7545` keeps 0.5 `#EF4444` |
| Profile menu icon disc (35×35) | `#27282C` @20% | `337:7480`, `337:7487`, `337:7494`, `337:7501`, `337:7515`, `337:7522`, `337:7536`, `337:7546` |
| Profile edit chip (40×40) | `#232428` @20% + black shadow | `337:7466` |
| Edit Profile avatar badge (34×34) | `#FCFBF9` @20% + black shadow | `337:7925` |
| Leaderboard row rectangle | `#232428` @20% | `337:5622`, `337:5630` … (14) |
| Subjects search field | `#232428` @20% | `337:5724` |
| Mistakes pill (Subjects header) | `#565656` @20% + 0.2667 `#EF4444` + black shadow | `404:7421` |
| Mistakes overview card | `#27282C` @30% + 2 black shadows | `404:7637`, `404:7652` |
| Home bell | `#232428` @20% + 0.5 `#4B675E` | `337:5330`, `349:16567` |
| Result bucket | `#27282C` @20% | `337:6667`, `337:6673` |
| Result star disc (33×33) | `#27282C` @20% | `337:6685` |
| Review filter pill (idle) | `#27282C` @20% | `337:6827`, `337:6832` |
| Review answer row | `#BFFFC3`/`#FDE9E8` @20% + 0.5 semantic stroke | `337:6731` … — **see edit4 #48 (DESIGN_ISSUES #53)** |
| AI explanation inner card | `#1A1A1A` @20% | `337:9279`, `337:9286` |
| Second track card | `#232428` @20% | `I337:15982;125:727` |
| University Sign Up_2 fields | `#27282C` @20% | `337:10408` … |

### 5.2 Lavender back-lights — complete inventory (#36)

All 16 are `ELLIPSE`, fill `#AE87E7` 100%, opacity 1, blend `PASS_THROUGH`, **no effects**, all in
`Dark mode`. Geometry is `[x, y, w, h]` inside the 402-wide dark frame; *offset* = ellipse origin
minus covering-surface origin.

| # | Track | Dark frame | Ellipse | Ellipse `[x,y,w,h]` | Covering glass surface | Surface `[x,y,w,h]` | Offset in surface | Used by |
|---|---|---|---|---|---|---|---|---|
| B1 | School | Home `337:5303` | `348:6951` | `[43,175,133,21]` | level card `337:5336` (G6) | `[20,150,362,171]` | (23, 25) | edit3 |
| B2 | School | Home | `348:6952` | `[23,383,100,14]` | Daily Tasks `337:5357` (G7) | `[20,383,362,200.03]` | (3, 0) | edit3 |
| B3 | School | Home | `348:6954` | `[23,833,100,14]` | Top Student `337:5460` (G9) | `[20,825.43,362,204.79]` | (3, 7.57) | edit3 |
| B4 | School | Setup `337:6239` | `348:7592` | `[24,206,100,14]` | pool card `337:6275` (G12) | `[20,199.19,363,127]` | (4, 6.81) | **blocked** (edit4 #45) |
| B5 | School | Quiz page `337:9182` | `348:7706` | `[25,619,100,14]` | AI outer container `337:9270` (G18) | `[20,607.98,363,260.34]` | (5, 11.02) | edit4 |
| B6 | School | Result `337:6628` | `348:8971` | `[24,526,100,14]` | rewards card `337:6680` (G14) | `[19,514.17,363,138]` | (5, 11.83) | edit4 |
| B7 | School | Profile `337:7433` | `348:8973` | `[24,131,100,14]` | header `337:7455` (G15) | `[20,120,363,104]` | (4, 11) | edit5 |
| B8 | School | Settings `337:8141` | `348:8975` | `[20,543,100,14]` | Notification Preferences `337:8195` (G16) | `[20,510,362,209]` | (0, 33) | edit5 |
| B9 | Uni | Home `337:10447` | `349:16784` | `[43,173,133,21]` | level card `349:16593` (G6) | `[20,150,362,171]` | (23, 23) | edit3 |
| B10 | Uni | Home | `349:16786` | `[33,383,133,21]` | Daily Tasks `349:16615` (G7) | `[20,383,362,200.03]` | (13, 0) | edit3 |
| B11 | Uni | Home | `349:16788` | `[33,993,133,21]` | **none** (no glass surface covers it) | — | — | not built (edit3 #44) |
| B12 | Uni | Setup `349:15375` | `349:15376` | `[24,206,100,14]` | pool card `349:15412` | same as B4 | (4, 6.81) | **blocked** |
| B13 | Uni | Quiz page `349:14913` | `349:14914` | `[25,619,100,14]` | AI outer `349:15005` | same as B5 | (5, 11.02) | edit4 |
| B14 | Uni | Result `349:14522` | `349:14523` | `[24,526,100,14]` | rewards `349:14575` | same as B6 | (5, 11.83) | edit4 |
| B15 | Uni | Settings `349:12113` | `349:12114` | `[20,537,100,14]` | Notification Preferences `349:12171` | `[20,510,362,209]` | (0, 27) | edit5 |
| B16 | Uni | Profile `349:12919` | `349:12920` | `[24,131,100,14]` | header `349:12941` | same as B7 | (4, 11) | edit5 |

No light or RTL frame has a back-light. On canvas (100% zoom, 2026-09-17) the glow is a soft lavender
haze inside the card near its top-start corner, with no hard ellipse edge visible anywhere, which
confirms R6.

### 5.3 Dark shadow colour — evidence for #34

Every dark node that keeps a drop shadow uses **black** at the light alpha. Read on Properties panels
or from the plugin's raw effect objects:

| Dark node | Shadow |
|---|---|
| Subject card `337:5732` | 2 × black 25% (same as light `135:618`) |
| Profile stat card `661:8579` | 0.02/0.02/2 black 25% |
| Profile header `337:7455` | 0.5/0.5/4 black 25% |
| Profile edit chip `337:7466` | 0.02833/0.02833/1.3 black 25% |
| AI panel wrapper `337:9278` | drop-shadow 0.02/0.02/3 black 25% |
| Setup length chips `337:6289`, `337:6291` | 0.02/0.02/2.3 black 25% |
| Mistakes card `404:7637` | 0.5285/0/1.061/−0.5305 + 0/0.5305/1.5915, black 25% |
| Mistakes pill `404:7421` | 0.2667/0.2667/2.1333 black 25% |
| Pool card `337:6275` | 0.5/0.5/4 black 25% |
| Primary CTA `348:8911` | 0.5/0.5/4 black 25% |
| Onboarding sheet `337:15643` | 0/−1.5/9.2 black 15% |
| Avatar badge `337:7925` | 0.02408/0.02408/1.105 black 25% |

No dark node in the file has a cream or white **drop** shadow. White and lavender appear only as
**inner** shadows (scope toggle, Settings swatches, University tiles) or as coloured glows (nav bar,
OTP card).

### 5.4 Other shadow facts used by §7

- Every drop shadow: `blendMode NORMAL`, `showShadowBehindNode false` (R4).
- The panel "Blur" equals the CSS export value for drop/inner shadows. Layer blur is halved in CSS.
- Figma `lightAngle` convention, inferred from the canvas: at −45° the rim highlight sits on the
  **top-left and bottom-right** corners (level card `337:5336`, profile header `337:7455`). That means
  a y-up angle, so Flutter's direction vector is `(cos θ, −sin θ)`. Confirm during calibration with
  `337:15643` (37°) and `337:6464` (51°).

### 5.5 Unbuilt screens that use Glass (#55) — record only

Customer Support (`337:8390`, G5 ×46 + G17 container), Notifications (G5 ×46), Messages / message /
Customer support chat (G5, G11 search), Friends (G5 chips `Frame 427319502` 47.5×19 #384F47@20%,
G11 search), Create Ticket (G5), Your progress (G5), Refer a Friend (G5), University Learning Tools
tiles (inner shadows, see edit3 #43). When any of these is built, use the tokens/primitives from this
edit and read the node's values from this file or a new plugin pass. **Do not build them in this
edit.**

## 6. Current Flutter state (verified 2026-09-17, SOURCE level)

- **Theme.** `lib/core/theme/app_colors.dart`: `AppColors extends ThemeExtension`, `light`/`dark`,
  hand-written `copyWith`/`lerp`. `lib/core/theme/app_theme.dart`: `extensions: [ext]`,
  FilledButton theme without elevation, dialog/date-picker surfaces on `cardFill`.
- **`elevationShadow`** (`app_colors.dart`): light `#000000`, dark `#FCFBF9`, doc comment says "derived,
  not measured, no dark frame exists" (DESIGN_ISSUES #47). **Superseded:** dark frames exist and are
  black (§5.3).
- **`navShadow`**: `0x14000000` in both themes, "~8% black, TODO(design)". Replaced by edit2 using
  §8 tokens.
- **Raw elevation sites outside `lib/core/theme/`** (11 matching lines, the guard's starting
  baseline):

  | File:line | Construct | Owner edit |
  |---|---|---|
  | `lib/features/auth/screens/otp_screen.dart:389` | `BoxShadow` (timer pill) | edit5 |
  | `lib/features/mistakes/widgets/mistakes_subject_card.dart:59` | `shadowColor:` | edit3 |
  | `lib/features/mistakes/widgets/mistakes_subject_card.dart:60` | `elevation: 1.06` | edit3 |
  | `lib/features/onboarding/screens/onboarding_screen.dart:152` | `BoxShadow` (sheet) | edit2 |
  | `lib/features/profile/screens/edit_profile_screen.dart:561` | `BoxShadow` (avatar badge) | edit5 |
  | `lib/features/profile/widgets/profile_header_card.dart:42` | `BoxShadow` | edit5 |
  | `lib/features/profile/widgets/profile_stat_card.dart:33` | `BoxShadow` | edit5 |
  | `lib/features/quiz/screens/quiz_review_screen.dart:249` | `elevation: selected ? 0 : 2` | edit4 |
  | `lib/features/quiz/screens/quiz_review_screen.dart:250` | `shadowColor:` | edit4 |
  | `lib/features/quiz/widgets/ai_explanation_panel.dart:134` | `BoxShadow` | edit4 |
  | `lib/features/shell/main_shell.dart:203` | `MaskFilter.blur` (nav) | edit2 |

  Line numbers drift. Re-run the detector rather than trusting them.
- **No Glass / backdrop implementation exists.** There is no `BackdropFilter` in `lib/`.
- **Tests pinning the old behaviour:** `test/core/theme/palette_discipline_test.dart` group
  `elevationShadow` asserts light ≠ dark, and group `a card on each canvas` asserts `ProfileStatCard`
  uses `blurRadius 1` with the cream dark colour. Both stay true after this edit. They are deleted
  by the edits that migrate those call sites (see §7.3 and §7.7).
- **SDK:** `.flutter-version` 3.44.7. `BackdropGroup` / `BackdropFilter.grouped` exist.
  `ImageFilter.shader` exists but throws `UnsupportedError` unless Impeller is on. There are no Impeller
  flags in `AndroidManifest.xml` / `Info.plist`.
- **Guards:** `test/guards/rules.dart` (pure detectors), `rules_test.dart` (fixtures),
  `project_rules_test.dart` (policy + ratchets), `tool/verify_guards.ps1` (break-each-rule proof,
  ASCII only).

## 7. Required changes

### 7.1 `lib/core/theme/app_elevation.dart` (new)

Value classes. All `@immutable`, with `const` constructors, `==`/`hashCode`, and static `lerp`.

```dart
/// One Figma drop or inner shadow, values verbatim from the Properties panel.
class FigmaShadow {
  const FigmaShadow({
    required this.color,   // alpha included, e.g. Color.fromRGBO(0, 0, 0, 0.25)
    required this.offset,  // physical px, never mirrored (R9)
    required this.blur,    // Figma "Blur" = CSS blur radius; σ = blur × kFigmaBlurToSigma
    this.spread = 0,
    this.inset = false,
  });
}

/// Figma Glass effect, field names as the Plugin API reports them.
class GlassStyle {
  const GlassStyle({
    required this.frost,          // plugin `radius`
    required this.refraction,     // 0..1
    required this.depth,          // px
    required this.lightAngle,     // degrees, Figma convention (y-up), physical (R9)
    required this.lightIntensity, // 0..1
    required this.dispersion,     // 0..1
    required this.splay,          // 0..1
  });
}

/// A lavender back-light: a solid ellipse behind a glass surface (R6).
class Backlight {
  const Backlight({required this.offset, required this.size, required this.color});
  // offset: from the covering surface's top-START corner, in Figma px (LTR frame). Mirrored in RTL (R9).
}

/// A modal scrim: colour plus backdrop blur σ (0 = no blur).
class ScrimStyle {
  const ScrimStyle({required this.color, this.sigma = 0});
}
```

`AppElevation extends ThemeExtension<AppElevation>` with `light` and `dark` const instances holding
**every token in §8.2**. Nullable fields express theme mechanisms (e.g. `GlassStyle?` null in light).
`copyWith` and `lerp` cover every field:

- lists lerp element-wise when lengths match, else snap at t = 0.5;
- `GlassStyle?` / `Backlight?` / `ScrimStyle?` snap at t = 0.5 when either side is null;
- numbers use `lerpDouble`.

Doc comment per token: the Figma node(s) and whether light/dark were read or are "none in Figma".

### 7.2 `lib/core/theme/app_theme.dart`

Add `AppElevation elevation` to `_build`: `light` passes `AppElevation.light`, `dark` passes
`AppElevation.dark`, and `extensions: [ext, elevation]`. Change nothing else here:
- edit2 owns the dialog / date-picker surface change;
- button themes are **not** changed by any edit, because CTAs use the `PrimaryCta` wrapper (§7.4 e).

### 7.3 `lib/core/theme/app_colors.dart`

1. **Freeze `elevationShadow`; do not change its values.** Rewrite its doc comment:
   - *SUPERSEDED 2026-09-17 (owner ruling, #34).* Dark frames exist, and every dark shadow is the
     measured black (§5.3). The cream value is the withdrawn #47 derivation.
   - Do not use in new code; use `AppElevation` tokens.
   - The token is kept only for call sites not yet migrated. List the 8 files and their owner edits
     (§6).
   - Each migrating edit moves its sites to `AppElevation`. The edit that removes the **last**
     reference deletes this field, its light/dark values, its `copyWith`/`lerp` lines, and the
     `elevationShadow` group in `palette_discipline_test.dart`.
2. Add the new palette tokens in **§8.1**, each with light + dark value, node citation, and
   `copyWith` + `lerp` wiring. **Every §8.1 row is a new token**, so no existing value changes and
   nothing on screen moves in this edit.
3. Do **not** remove or re-value any existing token in this edit.

### 7.4 Primitives — `lib/core/widgets/elevation/` (new folder)

This folder, together with `lib/core/theme/`, is the only place the guard (§7.6) allows raw shadow,
blur and backdrop code.

**(a) `figma_shadow_painter.dart`.** A pure painting helper, e.g.
`void paintFigmaShadows(Canvas canvas, Path shape, List<FigmaShadow> shadows)`:

- **Outer shadow:** path = shape shifted by `offset` and outset by `spread` (negative spread insets).
  Paint = `color` + `MaskFilter.blur(BlurStyle.normal, σ)` (skip the filter when σ = 0). Clip to
  *outside* the unshifted shape (`Path.combine(PathOperation.difference, bounds, shape)`) — R4.
- **Inner shadow** (`inset: true`): clip to the shape, fill `(large rect) − (shape shifted by
  offset, inset by spread)` with `color` + blur σ. CSS inset semantics.
- σ = `blur × kFigmaBlurToSigma` (R3). Offsets physical.

**Glass implementation options considered** (the decision is recorded in D-009, §7.8):

| Option | What it renders | Cost / constraints | Verdict |
|---|---|---|---|
| Plain 20% fill (no Glass) | tint only | free | **Rejected.** Loses the rim light and frosted back-light, which are the visible Figma effect (designer-confirmed). |
| `BackdropFilter` blur on every glass surface | frost | one backdrop pass per surface, including list rows; blurs a uniform page for no visible change | **Rejected** as a default. Kept only for `content` backdrops. |
| **Tier 1**: tint + frosted back-light (`MaskFilter` blur) + normal-based rim light; `BackdropFilter` only over real content | everything visible over this app's uniform backdrops | cheap; works on Skia and Impeller | **Chosen** |
| Tier 2: Impeller `ImageFilter.shader` refraction/dispersion shader | adds edge refraction and chromatic dispersion over content | throws without Impeller (verified in SDK 3.44.7); needs a Skia fallback and a `flutter: shaders:` entry | **Optional**, owner approval required |
| Third-party glass package (e.g. `liquid_glass_renderer`) | refraction + light | new dependency ("no new dependencies without asking"); Impeller-only | **Rejected** |

**(b) `glass_surface.dart`.** A private-to-folder rim-light painter plus `enum GlassBackdrop {
uniform, content }`.

- `uniform` (default): no `BackdropFilter`. Use it for every surface over the flat page or an
  opaque parent.
- `content`: wraps the clipped surface in `BackdropFilter(filter: ImageFilter.blur(sigmaX: σf,
  sigmaY: σf))` with σf = `frost × kGlassFrostToSigma`. Only the onboarding sheet needs it today.
  When a screen has more than one, wrap the screen in `BackdropGroup` and use
  `BackdropFilter.grouped`.
- **Back-lights:** inside the shape clip and below the tint, paint each `Backlight` as an oval at
  its directional offset (mirror x in RTL: `x' = width − x − w`) with
  `MaskFilter.blur(normal, σf)`. Assert in debug that back-lights are only passed with a non-null
  `GlassStyle`.
- **Rim light** (tier-1 model; constants in `glass_mapping.dart`, calibrated in §12):
  - light direction `L = (cos θ, −sin θ)`, θ = `lightAngle` in radians;
  - sample the shape's outline with `PathMetric` every ~2 px, get the outward normal `n` from the
    tangent, and compute `a = kGlassRimMaxAlpha × lightIntensity × pow(|n·L|, e)` with
    `e = lerp(kGlassRimExponentNarrow, kGlassRimExponentWide, splay)`;
  - stroke a `kGlassRimStrokeWidth`-wide segment in white at alpha `a` just inside the edge.
  - Cache the result: `shouldRepaint` only when size/style/direction change.
- `refraction`, `dispersion`, `depth`: carried in the token. In tier 1 they are not rendered, because
  they are invisible over a uniform backdrop (R5). **Tier 2** (optional, not part of this edit's
  completion) is an Impeller-only `ImageFilter.shader` fragment shader for `content` backdrops, with
  a tier-1 fallback. It needs owner approval because it adds a `flutter: shaders:` entry and is a
  rendering-engine-dependent path.

**(c) `elevated_surface.dart`.** `ElevatedSurface` is the one widget components use:

```dart
const ElevatedSurface({
  required Widget child,
  required ShapeBorder shape,          // RoundedRectangleBorder / StadiumBorder / CircleBorder (directional radii OK)
  Color? color,                        // fill, may be translucent
  BorderSide? side,                    // uniform hairline (any width, including 0.03)
  BorderSide? topSide,                 // top-only hairline (search field light, Top Student)
  List<FigmaShadow> shadows = const [],// outer and inset
  GlassStyle? glass,
  List<Backlight> backlights = const [],
  GlassBackdrop backdrop = GlassBackdrop.uniform,
  VoidCallback? onTap,                 // optional ink, splash visible above the fill
  Clip clipBehavior = Clip.antiAlias,
  EdgeInsetsGeometry? padding,
  double? width, double? height,
});
```

Paint order, bottom to top:

1. outer shadows (knockout);
2. clip to shape;
3. `BackdropFilter` if `content`;
4. back-lights;
5. fill;
6. inset shadows;
7. Glass rim light;
8. hairline border(s);
9. `Material(type: transparency)` + `InkWell` (when `onTap`) + child.

No semantics of its own. Surface geometry constants (radius, size) stay at the call site as today;
effects come from tokens.

**(d) `segmented_track.dart`.** `SegmentedTrack<T>` + `SegmentedTrackStyle`:

- Props: `List<T> segments`, `T selected`, `ValueChanged<T> onChanged`, `String Function(T)
  labelOf`, `Key? Function(T)? keyOf` (so screens keep their test keys), `SegmentedTrackStyle
  style`, `double height = 44`.
- Style: `trackColor`, `trackRadius`, `trackInsetShadows`, `idleSegmentColor` (transparent or a
  fill), `selectedColor`, `selectedRadius`, `selectedInsetShadows`, `labelStyle`, `idleLabelColor`,
  `selectedLabelColor`.
- Behaviour:
  - equal-width segments in a `Row`, so RTL order is automatic;
  - selected fill animates over 150 ms (the existing `ScopeToggle` duration);
  - labels single-line, `maxLines 1`, `FittedBox(fit: BoxFit.scaleDown)`;
  - each segment carries `Semantics(button: true, selected:, inMutuallyExclusiveGroup: true,
    label:)`;
  - the tap target covers the whole segment.
- Uses `paintFigmaShadows` for insets.

**(e) `primary_cta.dart`.** `PrimaryCta` is the CTA elevation wrapper (Figma #12/#13).

```dart
enum CtaTone { primary, destructive, outline }
const PrimaryCta({required Widget child, CtaTone tone = CtaTone.primary, bool enabled = true});
```

- A `CustomPaint` behind `child`, sized to the child, paints **outside** an `RRect` of the child's
  bounds with radius 20 (the FilledButton theme shape):
  - `primaryCtaShadows` (tones `primary` / `destructive`) or `outlineCtaShadows` (`outline`);
  - for tone `primary` only, when `primaryCtaGlowLayerBlur != null` (dark): the RRect filled with
    `colorScheme.primary`, blurred with σ = `blur × kFigmaBlurToSigma`.
- `enabled: false` multiplies every alpha by 0.45 (R10).
- The child is untouched, so ink and semantics are unaffected.
- **Why a wrapper, not the button theme:** `ButtonStyle.backgroundBuilder` makes
  `ButtonStyleButton` default to `Clip.antiAlias`. Anything painted outside the button would be
  clipped (verified in the SDK 3.44.7 source, `button_style_button.dart`).
- Call sites are wrapped by the edit that owns each file: edit2 auth/onboarding/registration/dialog,
  edit4 quiz, edit5 OTP/Edit Profile. Error-state "Retry" buttons have no Figma frame and stay
  unwrapped.

### 7.5 `lib/core/theme/glass_mapping.dart` (new)

```dart
/// CSS: a blur radius B is a Gaussian with σ = B/2. Figma drop/inner-shadow Blur == CSS blur radius.
const kFigmaBlurToSigma = 0.5;       // definition, not tunable
/// Figma exports background blur `radius` R as CSS blur(R/2); Glass frost uses the same field name.
const kGlassFrostToSigma = 0.5;      // CALIBRATION CHECK (§12) — change only with recorded evidence
/// Tier-1 rim-light model. Starting points, NOT design values. Calibrate once (§12), record results.
const kGlassRimStrokeWidth = 1.0;
const kGlassRimMaxAlpha = 0.5;
const kGlassRimExponentNarrow = 6.0; // splay 0
const kGlassRimExponentWide = 1.0;   // splay 1
```

Per-component Glass values are never tuned. Only these constants move, and only with side-by-side
evidence (§12).

### 7.6 Guard — mechanise the rule (#38)

1. **`test/guards/rules.dart`**: add a pure detector, e.g.
   `List<String> rawElevationEffects(List<Source> sources)`, returning `path:line` for lines (after
   `stripComments`) matching any of:
   - `BoxShadow(`;
   - `elevation:` with a value other than a literal `0` (catch `elevation: selected ? 0 : 2`);
   - `shadowColor:`;
   - `MaskFilter.blur`, `ImageFilter.blur`, `BackdropFilter`, `PhysicalModel(`.

   Exempt paths containing `lib/core/theme/` or `lib/core/widgets/elevation/`. Doc comment explains
   why the rule exists: a shadow decided at a call site is the same defect class the palette guard
   stopped (DESIGN_ISSUES #47).
2. **`test/guards/rules_test.dart`**: fixtures proving it
   - catches each construct,
   - ignores the same text inside a comment,
   - ignores `elevation: 0`,
   - ignores both exempt folders.
3. **`test/guards/project_rules_test.dart`**: new test
   `'raw elevation effects do not increase (ratchet)'` with `const baseline = 11` (re-count at
   implementation time and use the real number), failure message pointing at `ElevatedSurface` and
   `AppElevation`. Comment:
   - frozen date;
   - "edits 2–5 lower this in the same change that removes a site";
   - "at 0, convert to a zero-enforcement test that names the offending file:line".
4. **`tool/verify_guards.ps1`**: add a scratch-file probe to `$fileProbes`:
   `@{ Name = 'Elevation effects ratchet'; Body = "var s = BoxShadow(blurRadius: 1);"; Test = 'raw
   elevation effects do not increase' }`. ASCII only (the workflow guard enforces it). Re-run the
   script and confirm the new probe goes red then green.
5. **`docs/ENFORCEMENT.md`**: add a rule row and a ratchet row (baseline + date).

### 7.7 Tests

- **`test/core/theme/app_elevation_test.dart`** (new):
  - pin every token value in §8.2 (group per consuming edit, node id in a trailing comment);
  - dark kept shadows are black;
  - light Glass is null except `onboardingSheetGlass`;
  - `copyWith` round-trips; `lerp(t=0)` == light, `lerp(t=1)` == dark;
  - `kFigmaBlurToSigma == 0.5`.
- **`test/core/theme/palette_discipline_test.dart`: leave it unchanged in this edit.** Its
  `elevationShadow` and `a card on each canvas` groups describe code that still ships.
  - edit5 replaces `a card on each canvas` when it migrates `ProfileStatCard`.
  - The edit that deletes `elevationShadow` deletes that group.
  - Add a comment above both groups: "Frozen per edit1.md #34 — removed by the migrating edit".
    That is the only change here.
- **`test/core/theme/app_colors_test.dart`**: pin the new §8.1 tokens (same style as the Mistakes
  group).
- **`test/core/widgets/elevation/`** (new):
  - `figma_shadow_painter_test.dart`: σ mapping, and that knockout leaves the interior untouched.
    Use a `PictureRecorder` render and read pixels, or a golden.
  - `elevated_surface_test.dart`: renders every shape; `onTap` ink appears; back-light mirrors in
    RTL; asserts no `BackdropFilter` in `uniform`.
  - `segmented_track_test.dart`: tap selects; semantics flags; keys preserved; RTL order; no
    overflow at text scale 1.3 in `ar` and `en`.
  - `primary_cta_test.dart`:
    - light: shadow, no glow;
    - dark primary: shadow + glow;
    - destructive and outline: no glow;
    - disabled: alphas × 0.45;
    - the wrapped `FilledButton` still shows its ink splash and keeps its semantics.
- **Goldens** (`test/goldens/elevation_primitives_test.dart`, `@Tags(['golden'])`, Windows
  baselines): a level-card-shaped glass surface with back-light, a 20% row, an inset track, and a
  two-shadow card, in light + dark.

### 7.8 Docs (record the reasoning, per project practice)

- **`docs/DESIGN_ISSUES.md` #47**: addendum "✅ Superseded 2026-09-17".
  - Dark frames exist and are black (§5.3). The cream derivation is withdrawn by owner ruling.
  - Glass + back-lights are the dark elevation mechanism (designer-confirmed).
  - Call sites move to the black `AppElevation` tokens component by component (edits 2–5), and the
    token is deleted with the last one.
- **`docs/DESIGN_ISSUES.md` new #72**: "Glass and lavender back-lights".
  - Include the §5.1 and §5.2 tables in short form.
  - Record the reading method: a local Dev Mode plugin, because the view seat hides Glass.
  - Record the tier-1 model and the calibration results from §12.
- **`docs/DECISIONS.md` D-009**: the elevation system.
  - Content: AppElevation + primitives, dark black, tier-1 Glass, back-lights part of the covering
    surface, blur mapping.
  - Rejected alternatives: `BoxShadow.blurRadius = Figma blur` (2× too soft); a `BackdropFilter` on
    every glass surface (cost with no visual gain over a uniform backdrop); a third-party glass
    package (new dependency, Impeller-only).

## 8. Architecture / tokens (the known set; edits 2–5 consume, and add only as allowed in §1)

Notation: `rgba(r,g,b,a)` → `Color.fromRGBO(r,g,b,a)`; `#RRGGBB@p%` → the same colour at alpha p.
"—" means none in Figma for that theme.

### 8.1 `AppColors` — new palette tokens (no existing value changes)

| Token | Light | Dark | Figma | Consumer | Note |
|---|---|---|---|---|---|
| `backChipSurfaceFill` | `#FCFBF9` | `#27282C@20%` | `90:208` / `404:7424` | edit2 | replaces `backChipFill`, whose dark `#232428` is a TODO(design) fallback. edit2 deletes `backChipFill` once unused |
| `registrationBackChipFill` | `#FCFBF9` | `#333439@20%` | `337:19690` | edit2 | |
| `languagePillFill` | `#FCFBF9` | `#232428@20%` | `82:1093` / `340:19734` | edit2 | pill used `background` |
| `homeBellFill` | `#FCFBF9` | `#232428@20%` | `59:1466` / `337:5330` | edit3 | |
| `dailyTasksFill` | `#FCFBF9` | `#242329@20%` | `308:4305` / `337:5357` | edit3 | |
| `dailyTasksBorder` | `#4B675E` | — (dark stroke hidden) | `308:4305` / `337:5357` | edit3 | width in §8.2 |
| `topStudentFill` | `#FFFFFF` | `#26272B@20%` | `59:2090` / `337:5460` | edit3 | |
| `topStudentTopBorder` | `rgba(124,58,237,0.1)` | `rgba(124,58,237,0.1)` | `59:2090` / `337:5460` | edit3 | top side only, 1.20791 |
| `continueLearningFillSchool` | `#F3E5FF` | `#C4A8E3` | school Home "Continue Learning" `Container` | edit3 | |
| `continueLearningFillUniversity` | `#DBB0FF` | `#DBB0FF` | uni Home `Container` | edit3 | |
| `subjectSearchFill` | `#FCFBF9` | `#232428@20%` | `135:610` / `337:5724` | edit3 | |
| `subjectSearchTopBorder` | `#F3F4F6` | — | `135:610` | edit3 | top only, 0.8 |
| `subjectCardFill` | `#FFFFFF` | `#27282C` | `135:618` / `337:5732` | edit3 | replaces `catalogCardFill` for the card |
| `mistakesPillFill` | `#FCFBF9` | `#565656@20%` | light Subjects header / `404:7421` | edit3 | |
| `mistakesPillAccent` | `#EF4444` | `#EF4444` | `404:7421` stroke | edit3 | label + 0.266667 border (the pill used `cs.error`) |
| `treeRowFill` | `#FCFBF9` | `#27282C` | catalog `Button` rows / `337:5926` | edit3 | |
| `treeRowBorder` | `#4B675E` | `#FCFBF9` | same | edit3 | light was `fieldBorder #D1D1D1` |
| `treeRowBadgeFill` | `#F4E6FF` | `#27282C@20%` | catalog row disc / `337:5926` disc | edit3 | |
| `pillTrackFill` | `#ECECEC` | `#232429` | `180:5337` / dark Lecture & Settings `337:8177` | edit3, edit5 | same Figma component |
| `pillTrackSelectedFill` | `#AE87E7` | `#AE87E7` | same | edit3, edit5 | |
| `aiPanelOuterFill` | `#FCFBF9` | `#27282C@20%` | `159:1811` / `337:9270` | edit4 | |
| `aiPanelOuterBorder` | `#4B675E` | — | same | edit4 | 0.5 light only |
| `aiPanelCardFill` | `#FCFBF9` | `#1A1A1A@20%` | `159:1826` / `337:9279` | edit4 | |
| `quizPrevButtonFill` | `rgba(56,79,71,0.6)` | `#27282C@20%` | light Quiz page chip / `337:6464` | edit4 | |
| `quizQuestionCardBorder` | `#4B675E` | `rgba(174,135,231,0.6)` | light `Container` / `337:6434` | edit4 | width §8.2 |
| `quizOptionTileBorder` | `#4B675E` | `rgba(174,135,231,0.5)` | light `Button` / `337:6440` | edit4 | keep `quizOptionBorder` for the A/B/C/D ring |
| `resultCardFill` | `#FCFBF9` | `#27282C@20%` | `159:2289`, `159:2252` / `337:6667`, `337:6680` | edit4 | buckets + rewards |
| `resultStarDiscFill` | `#F8EFFC` | `#27282C@20%` | light Result disc / `337:6685` | edit4 | |
| `reviewFilterIdleFill` | `#FCFBF9` | `#27282C@20%` | `162:2782` / `337:6827` | edit4 | |
| `scopeTrackFill` | `#ECECEC` | `#232429` | `158:839` / `337:5615` | edit4 | |
| `scopeSelectedFill` | `#D8B0FF` | `#C4A8E3` | `158:840` / `337:5615` segment | edit4 | light = current `podiumAccent` read; the 2026-09-16 CSS export showed `#DBB0FF` — edit4 re-reads `158:840` |
| `leaderboardRowFill` | `#FFFFFF` | `#232428@20%` | `134:3538` / `337:5630` | edit4 | |
| `profileHeaderFill` | `#FCFBF9` | `#27282C@20%` | `169:4609` / `337:7455` | edit5 | dark was `#232428@20%` |
| `profileEditChipFill` | `#FCFBF9` | `#232428@20%` | pencil chip in light Profile `166:4416` / `337:7466` | edit5 | |
| `profileStatFill` | `#FCFBF9` | `#27282C` | `661:8571` / `661:8579` | edit5 | dark was 20% |
| `profileMenuRowFill` | `#FCFBF9` | `#27282C@20%` | `170:4790` / `337:7479` | edit5 | |
| `profileMenuRowBorder` | `#7070A0` | — | `170:4790` / `337:7479` | edit5 | Logout keeps `destructive` in both |
| `profileMenuIconDiscFill` | `#F4E6FF` | `#27282C@20%` | light rows / `337:7480` | edit5 | conditional use, see edit5 #24 |
| `avatarBadgeFill` | `#FCFBF9` | `#FCFBF9@20%` | `180:3989` / `337:7925` | edit5 | |
| `settingsSectionFill` | `#FCFBF9` | `#27282C@20%` | light Setting `176:1840` / `642:8583`, `337:8195` | edit5 | |
| `settingsSectionBorder` | `#AE87E7` | — | same | edit5 | light was `profileRowBorder #7070A0` |
| `otpTimerFill` | `#FCFBF9` | `#232428` | `332:3391` / `337:19503` | edit5 | |
| `otpCardFill` | `#FCFBF9` | `#232428` | `308:5114` / `337:19501` | edit5 | |
| `otpCardGlow` | — | `rgba(174,135,231,0.25)` | `337:19501` | edit5 | glow colour, used in the §8.2 shadow |
| `otpDigitFill` | `#FDFDFD` | `#232428@20%` | `Rectangle 104–107` | edit5 | |
| `otpDigitBorder` | `#D1D1D1` | `#D1D1D1` | same | edit5 | width §8.2 |
| `trackCardFill` | `#FCFBF9` | `#232428@20%` | `125:862` / `337:15981` | edit5 | dark was opaque `background` |
| `backlight` | `#AE87E7` | `#AE87E7` | all B1–B16 | edits 3–5 | back-light colour |

Label and glyph colours for the rebuilt segmented tracks were not read. Edits 3/5 read them from
`180:5337` and `337:8177` (and their light twins) and add them in the same style **only** with a
node citation. If unread, keep the current label tokens and record that.

### 8.2 `AppElevation` tokens

"Black 25%" = `Color.fromRGBO(0,0,0,0.25)`. Offsets `(x, y)`. `σ` derives from blur (R3).

| Token | Light | Dark | Figma | Consumer |
|---|---|---|---|---|
| `navBarShadows` | `rgba(184,184,210,0.5)` (0, 2.144) blur 16.08 | `rgba(124,58,237,0.1)` (0, 2.144) blur 12.5 | light nav `Union` (`59:1264`) / `349:16719` | edit2 |
| `primaryCtaShadows` | black 25% (0.5, 0.5) blur 4 | same | `Frame 427319502` / `348:8911`; red dialog button `Frame 1000003068` | `PrimaryCta` (primary + destructive tones); call sites edits 2/4/5 |
| `primaryCtaGlowLayerBlur` | `null` | `8` (layer-blur panel value → σ 4; colour = the button's own fill) | `348:8909` | `PrimaryCta` (primary tone) |
| `outlineCtaShadows` | black 25% (0.5, 0.5) blur 4 | same | `Frame 427319504` (onboarding/login) | `PrimaryCta` (outline tone); call sites edit2 |
| `backChipShadows` | black 25% (0.02833, 0.02833) blur 1.3 | `[]` | `90:208` / `404:7424` | edit2 |
| `backChipGlass` | `null` | G5 | `404:7424` | edit2 |
| `registrationBackChipGlass` | `null` | G2 | `337:19690` | edit2 |
| `languagePillGlass` | `null` | G3 | `340:19734` | edit2 |
| `languagePillBorderWidth` | `0.629032` | `0` (no border) | `82:1093` | edit2 |
| `fieldGlass` | `null` | G4 | `348:8659` | edit2 |
| `fieldBorderWidth` | `1.17338` | `0.03` | `Rectangle 9` / `348:8659` | edit2 |
| `onboardingSheetShadows` | black 15% (0, −1.5) blur 9.2 | same | `459:43873` / `337:15643` | edit2 |
| `onboardingSheetGlass` | G1 | G1 | same | edit2 |
| `limitSheetScrim` | `#313131@50%`, σ 5.75 | `null` (**blocked**: no dark frame) | `Rectangle 6427` in Limitation notification | edit2 |
| `avatarActionSheetScrim` | `#313131@30%`, σ 0 | `#313131@30%`, σ 14.7 | Edit Profile sheet frames | edit2 |
| `chooseAvatarSheetScrim` | `#313131@30%`, σ 0 | `#313131@30%`, σ 13.4 | Edit Profile sheet frames | edit2 |
| `logoutDialogScrim` | `#313131@30%`, σ 0 | `#313131@60%`, σ 9.95 | Logout frame | edit2 (+ framework dialogs in edits 4/5) |
| `goToUniversityDialogScrim` | `#313131@30%`, σ 0 | `#313131@60%`, σ 10.05 | Go to Uni frame | edit2 |
| `levelCardShadows` | black 25% (0.5, 0.5) blur 4 | `[]` | `308:4209` / `337:5336` | edit3 |
| `levelCardGlass` | `null` | G6 | `337:5336` | edit3 |
| `levelCardBacklightSchool` / `…University` | `null` | offset (23,25) / (23,23), size 133×21 | B1 / B9 | edit3 |
| `dailyTasksBorderWidth` | `0.302507` | `0` | `308:4305` | edit3 |
| `dailyTasksGlass` | `null` | G7 | `337:5357` | edit3 |
| `dailyTasksBacklightSchool` / `…University` | `null` | (3,0) 100×14 / (13,0) 133×21 | B2 / B10 | edit3 |
| `topStudentTopBorderWidth` | `1.20791` | `1.20791` | `59:2090` / `337:5460` | edit3 |
| `topStudentGlass` | `null` | G9 | `337:5460` | edit3 |
| `topStudentBacklightSchool` | `null` | (3,7.57) 100×14 | B3 (uni has none) | edit3 |
| `continueLearningShadows` | black 25% (0, 0.425436) blur 1.27631 **+** black 25% (0.423807, 0) blur 0.850872 spread −0.425436 | same | Home "Continue Learning" `Container` | edit3 |
| `homeBellGlass` | `null` | G5 | `337:5330` | edit3 |
| `subjectSearchShadows` | black 10% (0,1) blur 3 **+** black 10% (0,1) blur 2 spread −1 | `[]` | `135:610` / `337:5724` | edit3 |
| `subjectSearchGlass` | `null` | G5 | `337:5724` | edit3 |
| `subjectCardShadows` | black 25% (0, 0.530516) blur 1.59155 **+** black 25% (0.528485, 0) blur 1.06103 spread −0.530516 | same | `135:618` / `337:5732` | edit3 |
| `mistakesPillShadows` | black 25% (0.266667, 0.266667) blur 2.13333 | same | light Subjects / `404:7421` | edit3 |
| `mistakesPillBorderWidth` | `0.266667` | `0.266667` | `404:7421` | edit3 |
| `mistakesPillGlass` | `null` | G5 | `404:7421` | edit3 |
| `mistakesCardShadows` | black 25% (0.528485, 0) blur 1.06103 spread −0.530516 **+** black 25% (0, 0.530516) blur 1.59155 | same | `404:6322` / `404:7637` | edit3 |
| `mistakesCardGlass` | `null` | G5 | `404:7637` | edit3 |
| `treeRowBadgeGlass` | `null` | G5 | `337:5926` disc / `404:7767` | edit3 |
| `pillTrackInsetShadows` | `[]` | inset black 25% (0, −3) blur 4 | dark `Frame 1000003007` (Lecture, `337:8177`) | edit3, edit5 |
| `pillTrackSelectedInsetShadows` | `[]` | inset black 25% (0, 4) blur 4 | dark `Frame 1000003006` / `1000003004` | edit3, edit5 |
| `lengthChipShadows` | black 25% (0.02, 0.02) blur 2.3 | same | `146:2315/2316` / `337:6289`, `337:6291` | edit4 |
| `aiPanelCardShadows` | black 25% (0.02, 0.02) blur 3 | same | wrapper `159:1825` / `337:9278` | edit4 |
| `aiPanelGlass` | `null` | G18 | `337:9270` | edit4 |
| `aiPanelBacklight` | `null` | (5, 11.02) 100×14 | B5 / B13 | edit4 |
| `aiPanelCardGlass` | `null` | G5 | `337:9279` | edit4 |
| `quizPrevButtonShadows` | black 25% (0.02833, 0.02833) blur 1.3 | `[]` | light chip / `337:6464` | edit4 |
| `quizPrevButtonGlass` | `null` | G13 | `337:6464` | edit4 |
| `quizQuestionCardBorderWidth` | `0.5` | `0.2` | light `Container` / `337:6434` | edit4 |
| `resultBucketShadows` | black 25% (0.02, 0.02) blur 2 | `[]` | `159:2289` / `337:6667` | edit4 |
| `resultBucketGlass` | `null` | G5 | `337:6667` | edit4 |
| `rewardsCardShadows` | black 25% (0.5, 0.5) blur 4 | `[]` | `159:2252` / `337:6680` | edit4 |
| `rewardsCardGlass` | `null` | G14 | `337:6680` | edit4 |
| `rewardsCardBacklight` | `null` | (5, 11.83) 100×14 | B6 / B14 | edit4 |
| `resultStarDiscGlass` | `null` | G5 | `337:6685` | edit4 |
| `reviewFilterIdleShadows` | black 25% (0.02, 0.02) blur 1.5 | `[]` | `162:2782` / `337:6827` | edit4 |
| `reviewFilterIdleGlass` | `null` | G5 | `337:6827` | edit4 |
| `scopeTrackInsetShadows` | `[]` | inset `rgba(207,179,255,0.1)` (6, 1) blur 4 **+** inset black 25% (0, −2) blur 4 | `337:5615` | edit4 |
| `scopeSelectedInsetShadows` | `[]` | inset `rgba(255,255,255,0.6)` (1, −2) blur 2 **+** inset black 25% (0, 3) blur 2 | `337:5615` segment | edit4 |
| `leaderboardListShadows` | black 25% (0.02, 0.02) blur 1.6 | same | list `Auto Layout Vertical` (`133:3117` light / dark twin) | edit4 |
| `leaderboardRowGlass` | `null` | G5 (rect) | `337:5630` | edit4 |
| `leaderboardRowGroupGlass` | `null` | G10 (group) | `337:5629` | edit4 |
| `profileHeaderShadows` | black 25% (0.5, 0.5) blur 4 | same | `169:4609` / `337:7455` | edit5 |
| `profileHeaderGlass` | `null` | G15 | `337:7455` | edit5 |
| `profileHeaderBacklight` | `null` | (4, 11) 100×14 | B7 / B16 | edit5 |
| `profileEditChipShadows` | black 25% (0.02833, 0.02833) blur 1.3 | same | pencil chip in `166:4416` / `337:7466` | edit5 |
| `profileEditChipGlass` | `null` | G5 | `337:7466` | edit5 |
| `profileStatShadows` | black 25% (0.02, 0.02) blur 2 | same | `661:8571` / `661:8579` | edit5 |
| `profileMenuRowGlass` | `null` | G5 | `337:7479` | edit5 |
| `profileMenuIconDiscGlass` | `null` | G5 | `337:7480` | edit5 |
| `avatarBadgeShadows` | black 25% (0.0240833, 0.0240833) blur 1.105 | same | `180:3989` / `337:7925` | edit5 |
| `avatarBadgeGlass` | `null` | G5 | `337:7925` | edit5 |
| `settingsSectionBorderWidth` | `0.5` | `0` | light Setting / `642:8583` | edit5 |
| `settingsSectionGlass` | `null` | G16 | `642:8583`, `337:8195` | edit5 |
| `notificationPreferencesBacklightSchool` / `…University` | `null` | (0,33) / (0,27), 100×14 | B8 / B15 | edit5 |
| `otpTimerInsetShadows` | inset black 25% (0, −1) blur 4 | inset `rgba(198,198,198,0.25)` (−0.5, 0.5) blur 1.2 | `332:3391` / `337:19503` | edit5 |
| `otpCardShadows` | black 25% (0.2, 0.2) blur 4 | `otpCardGlow` colour (0.2, 0.2) blur 7.9 | `308:5114` / `337:19501` | edit5 |
| `otpDigitBorderWidth` | `1.17333` | `0.5` | `Rectangle 104` light / dark | edit5 |
| `otpDigitGlass` | `null` | G19 | `I337:19295;337:19276` | edit5 |
| `trackCardShadows` | black 25% (0.5, 0.5) blur 4 | `[]` | `125:862` / `337:15981` | edit5 |
| `trackCardGlassFirst` | `null` | G20 | `337:15981` | edit5 |
| `trackCardGlassSecond` | `null` | G5 | `I337:15982;125:727` | edit5 |

Back-lights are `Backlight(offset: …, size: …, color: AppColors.backlight)`. The dark `otpCardShadows`
colour is `AppColors.otpCardGlow`. Reference both colours from the palette rather than repeating the
hex: build the two `AppElevation` instances in `AppTheme` from the matching `AppColors`, or give
`AppElevation` colour fields set from `AppColors`. Pick one approach; do not duplicate the values.
Shadow colours that are plain black/alpha may live in `app_elevation.dart` itself (theme folder).

## 9. Files expected to change

New:

- `lib/core/theme/app_elevation.dart`
- `lib/core/theme/glass_mapping.dart`
- `lib/core/widgets/elevation/figma_shadow_painter.dart`
- `lib/core/widgets/elevation/glass_surface.dart`
- `lib/core/widgets/elevation/elevated_surface.dart`
- `lib/core/widgets/elevation/segmented_track.dart`
- `lib/core/widgets/elevation/primary_cta.dart`
- `test/core/theme/app_elevation_test.dart`
- `test/core/widgets/elevation/*_test.dart`
- `test/goldens/elevation_primitives_test.dart` + PNGs

Modified:

- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_colors.dart` (additions + `elevationShadow` doc comment only)
- `test/core/theme/palette_discipline_test.dart` (one comment only)
- `test/core/theme/app_colors_test.dart`
- `test/guards/rules.dart`
- `test/guards/rules_test.dart`
- `test/guards/project_rules_test.dart`
- `tool/verify_guards.ps1`
- `docs/ENFORCEMENT.md`
- `docs/DESIGN_ISSUES.md` (#47 addendum, new #72)
- `docs/DECISIONS.md` (D-009)

## 10. Do not change

- Any widget under `lib/features/**` or `lib/core/widgets/` outside the new `elevation/` folder:
  component migration belongs to edits 2–5.
- `contract/**` (vendored).
- Typography (`AppType`) and the `fontSize` ratchet.
- Any existing token value, including `elevationShadow` and `navShadow`, and any token removal.
- `pubspec.yaml`: no new dependency, no shader asset (tier 2 needs owner approval).
- Unrelated uncommitted hunks in the files listed in §0.

## 11. Verification plan

1. `dart format --output=none --set-exit-if-changed lib test` (validate runs this) — clean.
2. `flutter analyze` — zero issues.
3. Targeted:
   - `flutter test test/core/theme`
   - `flutter test test/core/widgets/elevation`
   - `flutter test test/guards`
4. `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` → **OVERALL: PASS**, test count ≥
   the pre-flight count.
5. `powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1` → the new elevation probe is
   detected and restored (SHA-256 verified).
6. Goldens: `flutter test --tags golden --update-goldens test/goldens/elevation_primitives_test.dart`
   on Windows, then review each PNG by eye before keeping it. Existing goldens must still pass. None
   of the existing golden subjects changes in this edit.
7. Report verification levels honestly: SOURCE / BUILD for code; calibration is a visual (DEVICE-like)
   check.

## 12. Visual QA checklist — Glass calibration (do once, record the evidence)

References come from the Figma desktop app on the view seat. Right-click the layer row → **Copy as
PNG**, paste into an image editor, and save outside the repo. Render the matching Flutter surface
with `ElevatedSurface` at the same size in a golden harness (`golden_harness.dart`, device pixel
ratio 3).

| Ref | Node | What it calibrates |
|---|---|---|
| C1 | level card `337:5336` + back-light B1 | `kGlassFrostToSigma` (glow spread, frost 62), rim at splay 1 / depth 78 |
| C2 | Notification Preferences `337:8195` + B8 | frost 63, back-light at the edge (offset x 0) |
| C3 | profile menu row `337:7479` | default Glass on the flat page: rim only (`kGlassRimMaxAlpha`, narrow exponent) |
| C4 | language pill `340:19734` | intensity 0.25 at the same angle |
| C5 | field `348:8659` | frost 0, angle 28, splay 0.97 (wide exponent) |
| C6 | quiz previous button `337:6464` | angle 51 (confirms the y-up angle convention) |
| C7 | onboarding sheet `337:15643` over the illustration | `content` backdrop, frost 80, angle 37 |

- [ ] Rim highlight sits on the same corners as Figma for C1, C4, C5, C6 (angle convention holds).
- [ ] Glow size and softness match C1 and C2 within visual tolerance. Adjust only `kGlassFrostToSigma`.
- [ ] Rim brightness matches C3 (0.8) and C4 (0.25). Adjust only `kGlassRimMaxAlpha` / exponents.
- [ ] C7 frost looks like Figma at the sheet's top edge.
- [ ] Final constants and the comparison notes are recorded in DESIGN_ISSUES #72.
- [ ] Light mode: a light surface with the same tokens renders no Glass. G1 is the only light Glass.

## 13. Known risks and assumptions

- **Tier-1 Glass is a model, not Figma's renderer.** Refraction and dispersion are not drawn.
  Justification: they are invisible over the uniform backdrops every current surface sits on (R5).
  The onboarding sheet (C7) is the one place the difference could show. Record the visual result,
  and propose tier 2 only if the owner wants it.
- **`kGlassFrostToSigma = 0.5`** rests on Figma's background-blur export convention. Calibration C1/C2
  is the proof.
- **Light-angle convention** is inferred from two canvases. C6 confirms it or corrects it.
- **Back-light RTL mirroring** is an assumption (R9). No dark RTL frame exists.
- **CSS-only readings**: scrim blur σ values (§8.2 scrims) come from the CSS export, which already
  expresses σ, so no halving applies.
- **Two near-duplicate subject-card shadow variants** exist in the dark frame (0.530516 vs 0.536246,
  scaled instances of the same card). `135:618`/`337:5732` values are used.
- **Performance:** `uniform` Glass costs a few cached path strokes per surface. `content` Glass costs a
  `BackdropFilter`; keep it to the onboarding sheet.
- **Concurrent edits:** `app_colors.dart` carries another session's uncommitted tokens. Additive
  hunks only.

## 14. Completion criteria

- [ ] `AppElevation` light/dark hold every §8.2 token, and `AppColors` holds every §8.1 token, each
      with a node citation and full `copyWith`/`lerp` wiring, pinned by tests.
- [ ] Every dark shadow token in `AppElevation` is black. `elevationShadow` is frozen with the
      superseded/retirement doc comment. The cream derivation is withdrawn in DESIGN_ISSUES #47
      (the addendum records that call sites migrate in edits 2–5). No existing token value changed.
- [ ] `ElevatedSurface`, `GlassSurface`, `paintFigmaShadows`, `SegmentedTrack`, `PrimaryCta` exist
      in `lib/core/widgets/elevation/` with tests. The σ mapping is implemented once.
- [ ] Guard ratchet in place (baseline = real count), fixture-proven, probe added to
      `verify_guards.ps1`, rows in ENFORCEMENT.md.
- [ ] Calibration §12 done and recorded (or explicitly recorded as pending with reason).
- [ ] `validate.ps1` OVERALL: PASS, test count not lower. `verify_guards.ps1` all detected.
- [ ] D-009 and DESIGN_ISSUES #72 written. No feature widget changed.

---

## Appendix A — Master item map (all 55 items, one primary edit each)

Items #1–#34 are the 2026-09-16 audit table rows. Items #35–#55 were added during the 2026-09-17
re-verification so nothing in the audit narrative is lost.

| # | Item | Primary | Consumers / notes |
|---|---|---|---|
| 1 | Level card (light shadow, dark Glass + back-light) | edit3 | tokens edit1 |
| 2 | Nav bar per-theme shadow | edit2 | |
| 3 | Home placeholders (Daily Tasks / Top Student / Continue Learning) → per-section Figma surface | edit3 | owner decision 2026-09-17 |
| 4 | Home banner drop-shadow | edit3 | **BLOCKED** (artwork) |
| 5 | Subjects search field | edit3 | |
| 6 | Subject card (2 shadows both themes, light fill `#FFFFFF`) | edit3 | |
| 7 | Mistakes pill (Subjects header) | edit3 | |
| 8 | Back chips (CircleBackButton + CatalogHeader chip) | edit2 | |
| 9 | Quiz-type tabs → SegmentedTrack rebuild | edit3 | primitive edit1; owner decision |
| 10 | Mistakes subject card (exact shadows, Glass) | edit3 | |
| 11 | Setup length chips | edit4 | |
| 12 | Primary CTA shadow + dark glow | edit2 | primitive `PrimaryCta` edit1; call sites wrapped by edit2 (auth, onboarding, registration, confirm dialog), edit4 (quiz setup/quiz/result), edit5 (OTP, Edit Profile) |
| 13 | Outline CTA shadow | edit2 | `PrimaryCta(tone: outline)` |
| 14 | AI explanation panel | edit4 | |
| 15 | Result buckets | edit4 | |
| 16 | Rewards card (+ star disc) | edit4 | |
| 17 | Review filter pill | edit4 | |
| 18 | Limit sheet scrim | edit2 | dark **BLOCKED** (no frame) |
| 19 | Leaderboard scope toggle → SegmentedTrack | edit4 | primitive edit1 |
| 20 | Leaderboard list + rows | edit4 | |
| 21 | Profile header card (+ back-light) | edit5 | |
| 22 | Profile edit pencil chip | edit5 | |
| 23 | Profile stat card | edit5 | |
| 24 | Profile menu rows (+ icon discs) | edit5 | |
| 25 | Edit Profile avatar badge | edit5 | |
| 26 | Form fields (FieldShell + login phone field) | edit2 | OTP digit boxes are #52 (edit5) |
| 27 | Avatar sheet + dialog scrims, dialog buttons | edit2 | framework dialogs: edit4 (leave quiz), edit5 (discard changes) |
| 28 | Settings section cards (+ back-light) | edit5 | |
| 29 | Onboarding sheet | edit2 | |
| 30 | OTP timer pill (inner shadow, size) | edit5 | inset painter edit1 |
| 31 | OTP code card (+ dark lavender glow) | edit5 | |
| 32 | Sign-up track card | edit5 | |
| 33 | Language pill | edit2 | two-treatment question resolved: all dark pills are G3 |
| 34 | Dark shadow colour → black | **edit1** | consumers 2–5 |
| 35 | Glass primitive + measured tokens | **edit1** | consumers 2–5 |
| 36 | Lavender back-light primitive + inventory | **edit1** | consumers 3, 4, 5 |
| 37 | Figma→Flutter blur/shadow conversion + knockout | **edit1** | |
| 38 | Elevation guard ratchet + palette-test rewrite | **edit1** | each edit lowers the ratchet |
| 39 | Near-identical small shadows → verbatim | **edit1** | resolved |
| 40 | Inset painter + SegmentedTrack | **edit1** | consumers 3, 4, 5 |
| 41 | Home bell chip (dark Glass) | edit3 | |
| 42 | Catalog tree rows: index-disc Glass, light hairline, fills | edit3 | Mistakes rows' disc too |
| 43 | University Learning Tools tiles | edit3 | not built; record only |
| 44 | University Home Ellipse 123 without cover | edit3 | record only |
| 45 | Quiz pool card | edit4 | **BLOCKED** (seif_fight S15) |
| 46 | Quiz previous-question button | edit4 | |
| 47 | Quiz question card + option tile hairlines | edit4 | |
| 48 | Dark review answer rows (Glass vs DESIGN_ISSUES #53) | edit4 | **DECIDED 2026-09-17 — Glass, option (c); D-010** |
| 49 | Quiz setup header (AppBar vs back chip) | edit4 | record only |
| 50 | Settings → Languages → SegmentedTrack rebuild | edit5 | owner decision |
| 51 | Settings → Mode swatches | edit5 | **BLOCKED** (DESIGN_ISSUES #45) |
| 52 | OTP digit boxes | edit5 | |
| 53 | OTP success badge drop shadow | edit5 | **BLOCKED** (DESIGN_ISSUES #28) |
| 54 | Track card art blur layer | edit5 | verify-then-implement |
| 55 | Unbuilt screens using Glass | **edit1** | record only |

Ratchet ownership (guard baseline 11 → 0): edit2 −2 (nav, onboarding), edit3 −2 (Mistakes card),
edit4 −3 (AI panel, review pill), edit5 −4 (OTP timer, avatar badge, profile header, stat card).
