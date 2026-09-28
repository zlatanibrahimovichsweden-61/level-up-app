# Edit 4 — Quiz flow & Leaderboard: setup chips, quiz page, AI panel, result, review, scope toggle, board rows

> Self-contained implementation guide. Token names refer to entries that **edit1.md** adds to
> `AppColors` / `AppElevation`. If edit1 shipped a name slightly differently, use the shipped
> equivalent; never add a parallel primitive.
>
> Figma file `P6044i0giD9TmdQ7C2AmLq`, page `design`. Written 2026-09-17.

---

## 0. Pre-flight

1. Read `CLAUDE.md`, `docs/WAVE_STATUS.md`, `docs/AGENT_WORKFLOW.md` § "Theme discipline",
   `.claude/skills/bloc/SKILL.md` (the quiz is the Bloc feature; do not touch its state logic), and
   **edit1.md §4 (rules R1–R10)**.
2. **edit1 must be in the tree:** `app_elevation.dart`, `elevated_surface.dart`, `segmented_track.dart`,
   and the guard test `raw elevation effects do not increase`. If missing, implement edit1 first.
3. `git status --short`. On 2026-09-17 these files belonged to **other uncommitted work**:
   - `lib/features/quiz/screens/quiz_result_screen.dart` (Review CTA);
   - `lib/features/quiz/screens/quiz_screen.dart` (review args);
   - the **untracked** `lib/features/quiz/screens/quiz_review_screen.dart` and
     `lib/features/leaderboard/**`, with their tests.

   The leaderboard is built but held behind its placeholder (D-008, `docs/WAVE_STATUS.md`). Confirm
   with the owner that this work is committed or safe to edit on top of. Never discard or reformat
   foreign hunks.
4. Run `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` and record the passing count.
5. Do not commit unless asked.

## 1. Scope

| # | Item | File |
|---|---|---|
| 11 | Setup length chips: shadow in both themes, border removed | `lib/features/quiz/screens/quiz_setup_screen.dart` (`_LengthChip`) |
| 45 | Quiz pool card | **BLOCKED** (`docs/seif_fight.md` S15): record the spec only |
| 49 | Setup header: Figma back chip vs Material `AppBar` | record only |
| 14 | AI explanation panel: outer Glass + back-light, inner cards Glass, black blur-3 shadow | `lib/features/quiz/widgets/ai_explanation_panel.dart` |
| 46 | Quiz previous-question button (79×58 pill) | `lib/features/quiz/screens/quiz_screen.dart` (`_ActionBar`) |
| 47 | Question card + idle option-tile dark hairlines | `lib/features/quiz/widgets/mcq_renderer.dart`, `question_option_tile.dart` |
| 15 | Result buckets | `quiz_result_screen.dart` (`_ScoreCard`) |
| 16 | Rewards card (+ back-light, + star disc) | `quiz_result_screen.dart` (`_RewardsCard`) |
| 17 | Review filter pills | `lib/features/quiz/screens/quiz_review_screen.dart` (`_FilterChip`) |
| 48 | Dark review answer rows vs DESIGN_ISSUES #53 | **UNBLOCKED 2026-09-17 — implement option (c), Glass. See the #48 section and D-010** |
| 19 | Leaderboard scope toggle → `SegmentedTrack` | `lib/features/leaderboard/widgets/scope_toggle.dart` |
| 20 | Leaderboard rows: list shadow, dark Glass | `lib/features/leaderboard/widgets/leaderboard_row.dart` |

Plus a **CTA consumer step** for #12 (primary owner edit2; primitive from edit1). Wrap Setup
"Start", Quiz "Confirm / Next / Finish" and Result "Review Questions" in `PrimaryCta` (§7.10).
This does not depend on edit2.

Plus one **consumer step** from edit2 (#27): "Leave quiz?" dialog → `showAppDialog`, only if edit2
has landed.

**Owned elsewhere:**

| What | Owner |
|---|---|
| The `PrimaryCta` primitive itself | edit1. This edit only wraps its own CTAs (§7.10). |
| Limit sheet scrim | edit2 |
| Back chips (`CircleBackButton` used by the leaderboard header) | edit2 |
| Quiz-type tabs on the Lectures screen | edit3 |

## 2. Objective

The quiz flow (setup → question → AI explanation → result → review) and the leaderboard match Figma
in both themes:

- **Light:** exact drop shadows, hairlines removed where Figma has none.
- **Dark:** Glass on the translucent cards, lavender back-lights behind the AI panel and the rewards
  card, lavender hairlines on the question card and idle tiles, the scope toggle's inner bevels, and
  Glass leaderboard rows.
- The `Material` elevation approximation and the raw AI `BoxShadow` disappear (guard ratchet −3).

## 3. Dependencies

- **Depends on:** edit1.
- **Optional:** edit2, only for the "Leave quiz?" dialog step (§7.10). Skip it if `showAppDialog`
  does not exist yet, and say so in the completion notes.
- **Independent of:** edit3, edit5.

## 4. Design rules (plus R1–R10)

- Semantic correctness **HUES** (correct/wrong fills and borders) never change with the theme
  (`app_colors.dart` rule, DESIGN_ISSUES #54). A wrong answer is red on both canvases and this
  edit does **not** re-colour them. What the 2026-09-17 ruling (D-010) changes for the review
  rows is the **treatment** — alpha + Glass — not the hue, so #48 does not contradict this rule.
- Cards that lose their shadow in dark do not keep it "just in case". Dark buckets, rewards and idle
  review pills are shadowless Glass (R1).
- The AI panel's Figma shadow is a `drop-shadow` **filter on the wrapper** around the two inner cards.
  Draw it as each inner card's own shadow, knocked out behind the 20% fill (R4).

## 5. Figma evidence

### #11 — Setup length chips (`Frame 1000003013/14/15`, 171×45 / 176×45, r10)

| Theme | Nodes | Idle fill | Selected fill | Border | Shadow |
|---|---|---|---|---|---|
| Light | `146:2315` idle / `146:2316` selected (setup `135:1622`) | `#FCFBF9` | `#384F47` (`cs.primary`) | **none** | (0.02, 0.02) blur 2.3 black 25% |
| Dark | `337:6289` / `337:6291` (setup `337:6239`) | `#27282C` | `#AE87E7` (`cs.primary`) | none | same black shadow, no Glass |

The dark frame's second chip row repeats light colours, a designer slip (only one row is built).
Ignore it.

### #45 — Question pool card (`Frame 5`, 363×127, r15): BLOCKED, record only

- **Light:** `#FCFBF9` + (0.5, 0.5) blur 4 black 25%.
- **Dark:** `337:6275` (uni `349:15412`), `#27282C` @20% + the same black shadow + **G12** (frost 73 ·
  refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion **0.11** · splay **0.59**) +
  back-light B4 `348:7592` 100×14 at (4, 6.81) (uni B12 `349:15376`).
- Not built: nothing in the contract exposes pool size or usage (`quiz_setup_screen.dart` doc,
  DESIGN_ISSUES #31, seif_fight S15). When S15 resolves, add `poolCard*` tokens in the edit1 style
  and build it with `ElevatedSurface`.

### #49 — Setup header: record only

Figma draws the 35×35 back chip (`tdesign:service-filled`; light `#FCFBF9` + 0.02833/0.02833/1.3 black
25%, dark 20% + G5) beside the title. Flutter uses a Material `AppBar` with the default back arrow.
This is a structural divergence, not an elevation fix. Record it in DESIGN_ISSUES for an owner
decision; **do not change it here**.

### #14 — AI explanation panel (Quiz page with explanation: light `159:1851` · dark school `337:9182`, uni `349:14913`)

| Layer | Theme | Node | Geometry | Fill | Border | Effect |
|---|---|---|---|---|---|---|
| Outer container | Light | `159:1811` | 363×261.34, r16.18, padding 16.18 | `#FCFBF9` | 0.5 `#4B675E` | — |
| Outer container | Dark | `337:9270` / `349:15005` | same | `#27282C` @20% | **none** | **G18** (frost 33 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0) + back-light B5 `348:7706` / `349:14914`, 100×14 at (5, 11.02) |
| Wrapper `Container (margin)` | both | `159:1825` / `337:9278` | 324.91×201.43 | — | — | `drop-shadow(0.02px 0.02px 3px rgba(0,0,0,0.25))`, **blur 3** (not the 1.5 in code) |
| Inner card ×2 | Light | `159:1826` | 324.91×88.58, r20.22 | `#FCFBF9` | — | (the wrapper shadow) |
| Inner card ×2 | Dark | `337:9279`, `337:9286` | same | `#1A1A1A` @20% | — | the wrapper shadow + **G5** |

The build renders **one** inner card: the explanation text is a single field (seif_fight S17). That
stays. On canvas (dark) the back-light is a faint lavender haze behind the "AI EXPLANATION" header
glyph.

### #46 — Previous-question button (`tdesign:service-filled`, 79×58)

| Theme | Nodes | Radius | Fill | Shadow | Glass |
|---|---|---|---|---|---|
| Light | Quiz page light frames | **9** (CSS) | `rgba(56,79,71,0.6)` | (0.02833, 0.02833) blur 1.3 black 25% | — |
| Dark | `337:6464`, `404:8198`, `348:7607`, `348:7697`, … (13) | **10** (plugin) | `#27282C` @20% | none | **G13** (frost 45 · refraction **0.63** · depth **17** · angle **51** · intensity 0.80 · dispersion 0.50 · splay **0.48**) |

Position: x 20, width 79, and the primary CTA starts at x 114 (15 dp gap). The glyph colour was not
read (§7.3).

### #47 — Question card & option tiles (flat in both themes)

| Element | Theme | Node | Fill | Hairline |
|---|---|---|---|---|
| Question card `Container` 362×94, r16 | Light | quiz page light | `#FCFBF9` | 0.5 `#4B675E` |
| | Dark | `337:6434` | `#27282C` | **0.2** `rgba(174,135,231,0.6)` |
| Idle option `Button` 358×61, r16 | Light | quiz page light | `#FCFBF9` | 0.5 `#4B675E` |
| | Dark | `337:6440` | `#27282C` | 0.5 `rgba(174,135,231,0.5)` |

- Graded states are semantic and unchanged: correct `#BFFFC3` + 1 `#00D33C`; wrong 30% `#FFC0C0` +
  1 `#921119`.
- The dark frame draws the wrong option opaque `#FFC0C0`. The shipped rule keeps the tokens identical
  across themes (DESIGN_ISSUES #52). **Not changed here** — the 2026-09-17 Glass ruling is scoped
  to the REVIEW answer rows and gives no instruction about the quiz page's graded tiles (D-010).
- The dark A/B/C/D badge ring colour was not read, so it keeps `quizOptionBorder`.

### #15 / #16 — Result (light `159:1964`; dark school `337:6628`, uni `349:14522`)

| Element | Theme | Node | Geometry | Fill | Border | Shadow | Glass | Back-light |
|---|---|---|---|---|---|---|---|---|
| Bucket (Correct/Wrong) | Light | `159:2289` | 175.5×118, r16 | `#FCFBF9` | **none** | (0.02, 0.02) blur 2 black 25% | — | — |
| | Dark | `337:6667`, `337:6673` | same | `#27282C` @20% | none | **none** | **G5** | — |
| Rewards card `Frame 5` | Light | `159:2252` | 363×138, **r15** | `#FCFBF9` | **none** | (0.5, 0.5) blur 4 black 25% | — | — |
| | Dark | `337:6680` / `349:14575` | same | `#27282C` @20% | none | **none** | **G14** (frost 54, other values G5) | B6 `348:8971` / `349:14523`, 100×14 at (5, 11.83) |
| Star disc `Container` | Light | Result light | 33×33, r24.31 (circle) | `#F8EFFC` | — | — | — | — |
| | Dark | `337:6685` | same | `#27282C` @20% | — | — | **G5** | — |

- The Result frame also draws a Level Progress meter inside the rewards card. It was removed on
  purpose (DESIGN_ISSUES #50). Unchanged.
- Code comments cite stale nodes `159:1990` / `159:2005` / `159:2020`. The current nodes are
  `159:2289` (bucket) and `159:2252` (rewards).

### #17 — Review filter pills (Quiz Review light `162:2377`, dark `337:6705`)

| State | Theme | Node | Fill | Shadow | Glass |
|---|---|---|---|---|---|
| Idle (102×32 / 99×32, stadium) | Light | `162:2782` | `#FCFBF9` | (0.02, 0.02) blur **1.5** black 25% | — |
| Idle | Dark | `337:6827`, `337:6832` | `#27282C` @20% | **none** | **G5** |
| Selected "All" | Light | `162:2780` | `#4B675E` | none | — |
| Selected | Dark | `337:6825` | `#AE87E7` | none | — |

### #48 — Review answer rows (dark `337:6731` …): **DECIDED 2026-09-17 — build option (c)**

> ✅ **Designer ruling, 2026-09-17. This item is no longer blocked and must not be re-raised.**
> Build **(c)**: the dark rows follow the frame — semantic fills at the frame's alpha, the
> 0.5 semantic stroke, and **G5** Glass — through edit1's `ElevatedSurface` with the
> `AppElevation` Glass token. Options **(a)** and **(b)** below are **withdrawn**, and
> "default until decided: (a), no change" no longer applies.
>
> The ruling's own emphasis: the corresponding Review answer rows must use the **same Glass
> treatment consistently** — equal in treatment, rather than one opaque and one glassed
> because of the old 20% value. **Consistency beats reproducing the literal 20% number** where
> the two conflict.
>
> Two things this ruling does NOT do. It does **not** instruct a change to the quiz page's
> graded tiles — if the two screens disagree once this lands, raise it as a NEW question with
> both renders side by side. And it does **not** license deleting
> `quiz_review_screen_test.dart`'s dark-row assertion: that test encodes the superseded ruling
> and must be **rewritten** to the new one.
>
> Records: `docs/DESIGN_ISSUES.md` #53 (resolved), `docs/DECISIONS.md` **D-010**.

- **Dark Figma:** rows use the semantic fills at **20%** (`#BFFFC3` / `#FDE9E8` / `#DCFFE9`) + 0.5
  semantic stroke + **G5** Glass.
- **Shipped:** opaque semantic fills in both themes, per the owner ruling in DESIGN_ISSUES #53
  (2026-09-08; a correctness signal must not change with the canvas; asserted by
  `quiz_review_screen_test.dart`).
- **Options for the owner:**
  - (a) keep #53, no Glass (no change);
  - (b) keep #53's opaque fills and add the G5 rim light only;
  - (c) follow the dark frame (20% + Glass), which reverses #53 and must also change the quiz page's
    graded tiles.
- **Default until decided:** (a), no change.

### #19 — Scope toggle (Leaderboard: light school `133:3117` / uni `134:3626`; dark `337:5528`)

| Part | Theme | Node | Geometry | Fill | Inner shadows |
|---|---|---|---|---|---|
| Track `Frame 1000003008` | Light | `158:839` | 362×44, r32 | `#ECECEC` | — |
| | Dark | `337:5615` | same | `#232429` | inset (6, 1) blur 4 `rgba(207,179,255,0.1)` **+** inset (0, −2) blur 4 black 25% |
| Selected `Frame 1000003004` | Light | `158:840` | 181×44, r51 | `#D8B0FF` (token read 2026-09-08). The 2026-09-16 CSS export of `133:3117` shows `#DBB0FF`; **re-read `158:840` and the school frame** | — |
| | Dark | inside `337:5615` | same | `#C4A8E3` | inset (1, −2) blur 2 `rgba(255,255,255,0.6)` **+** inset (0, 3) blur 2 black 25% |
| Selected label | Light | `158:841` | Inter 500 / 18 | `#FCFBF9` | — |

### #20 — Leaderboard list & rows

| Element | Theme | Node | Fill | Shadow | Glass |
|---|---|---|---|---|---|
| List `Auto Layout Vertical` 362×496 | both | light `133:3117` child, dark twin | — | `drop-shadow(0.02 0.02 1.6 rgba(0,0,0,0.25))` on the list, i.e. on the rows' alpha | — |
| Row `Rectangle 6424` 362×48, r12 | Light | `134:3538` | `#FFFFFF` | (list shadow) | — |
| | Dark | `337:5630` (and `337:5622`, `337:5646` …) | `#232428` @20% | (list shadow) | **G5** on the rectangle + **G10** (splay **0.31**, else G5) on the wrapping `Group 20185…` (`337:5629`) |
| Caller's own row | both | `134:3554` | `#DBB0FF` (read 2026-09-25 on `134:3554` and `337:5638`, W06-3; was `#D8B0FF` / `#DBB0FF`, see #19) | (list shadow) | **none** (no group Glass on the highlighted row) |

The dark frame's 9th row is opaque `#232428` without Glass (CSS). Treat it as unverified, probably a
designer slip, and record it; do not build a special case.

## 6. Current Flutter state (SOURCE, 2026-09-17)

- **#11** `_LengthChip`: `Material(selected ? cs.primary : quizOptionFill, r10)` + `InkWell` +
  `Ink(171×45, border quizOptionBorder 0.5)`. It has a border and no shadow.
- **#14** `AiExplanationPanel`:
  - outer `Container(quizOptionFill, r16.179, border quizOptionBorder 0.5)` in both themes, opaque
    `#27282C` in dark;
  - `_Body` = `Container(quizOptionFill, r20.224, BoxShadow(elevationShadow@0.25, blurRadius 1.5,
    offset 0.02))`. The comment cites "1.5" and "a black shadow does not exist on #232428", both
    superseded.
  - Guard site: that `BoxShadow`.
- **#46** `_ActionBar`: when not on the first question,
  `IconButton.filledTonal(icon: Icon(Icons.arrow_back))` (M3 tonal colours, ~40 dp), 12 dp gap, then
  an `Expanded` `FilledButton`.
- **#47** `mcq_renderer.dart`: question card `Container(quizOptionFill, r16, border quizOptionBorder
  0.5)`. `question_option_tile.dart`: idle `(quizOptionFill, quizOptionBorder, 0.5)`; the badge ring
  uses `quizOptionBorder` 1.18. In dark `quizOptionBorder` is `#4B675E`.
- **#15** `_ScoreCard`: `Container(quizOptionFill, r16, border quizOptionBorder 0.5)`, no shadow. It
  also renders the third "Skipped" bucket (DESIGN_ISSUES #29).
- **#16** `_RewardsCard`: `Container(quizOptionFill, r16, border 0.5)`, bare `Icon(Icons.star, 22)`.
- **#17** `_FilterChip`: `Material(selected ? quizReviewFilterFill : quizOptionFill, StadiumBorder,
  elevation: selected ? 0 : 2, shadowColor: ext.elevationShadow)`, min 32 tall inside a 48 dp tap
  target. Guard sites: 2.
- **#48** `_ReviewRow`: opaque semantic fills, 0.5 border (the SUPERSEDED #53 ruling — this is what is shipped today and what the 2026-09-17 ruling replaces).
- **#19** `ScopeToggle`: `Container(progressTrack (L #ECECEC, D #2E2D32), r22)` + `Row` of
  `_Segment` (`AnimatedContainer` 150 ms, `podiumAccent` or transparent, `AppType.h3`, labels
  `podiumOnAccent` / `textSecondary`). Hides itself when fewer than 2 scopes.
- **#20** `LeaderboardRow`: `Container(height 48, padding 12/16, color isMe ? podiumAccent :
  cardFill, r12)`, no shadow, no Glass. Rows sit in `ListView.separated` (`_BoardList` in
  `leaderboard_screen.dart`).
- `quiz_screen.dart` "Leave quiz?" = `showDialog` + `AlertDialog` (no scrim blur).

## 7. Required changes

### 7.1 #11 Length chips

`_LengthChip` → `Semantics(button, selected)` + `ElevatedSurface(shape: RoundedRectangleBorder(r10),
width 171, height 45, color: selected ? cs.primary : ext.quizOptionFill, shadows:
elevation.lengthChipShadows, onTap: onTap)`.

- **Remove the border.** Keep the label style/colours and the `Wrap` layout.
- When creation is in flight, `onTap` stays null. Keep today's look; there is no Figma disabled state.

### 7.2 #14 AI panel

1. Outer → `ElevatedSurface(shape: RoundedRectangleBorder(r16.179), padding 16.679, color:
   ext.aiPanelOuterFill, side:` light `BorderSide(ext.aiPanelOuterBorder, 0.5)` / dark `null`,
   `glass: elevation.aiPanelGlass, backlights:` `[elevation.aiPanelBacklight]` when non-null`)`.
2. `_Body` → `ElevatedSurface(shape: RoundedRectangleBorder(r20.224), padding 12.134, color:
   ext.aiPanelCardFill, shadows: elevation.aiPanelCardShadows, glass: elevation.aiPanelCardGlass)`.
   The shadows are black 25%, blur **3**, knocked out.
3. Delete the raw `BoxShadow`, rewrite the stale comment, and lower the guard ratchet by 1.
4. Content, states (`Idle` / `Pending` / `Loaded` / `Failed`), header glyph and copy stay unchanged.

### 7.3 #46 Previous-question button

1. Replace `IconButton.filledTonal` with a 79×58 pill: `Semantics(button, label:
   MaterialLocalizations.of(context).previousPageTooltip` or the existing back tooltip`)` +
   `ElevatedSurface(shape: RoundedRectangleBorder(radius), width 79, height 58, color:
   ext.quizPrevButtonFill, shadows: elevation.quizPrevButtonShadows, glass:
   elevation.quizPrevButtonGlass, onTap: busy ? null : …)`. Use a directional back icon, which flips
   in RTL.
2. **Radius differs per theme** (light 9, dark 10). Add `quizPrevButtonRadius` (L 9 / D 10) to
   `AppElevation` in the edit1 style, citing the light Quiz page chip and `337:6464`. This is a
   permitted evidence-backed addition.
3. **Glyph colour:** read the chevron fill inside the chip on the Properties panel, light and dark.
   If readable, add `quizPrevButtonGlyph` (edit1 style, citation). If not, use `cs.onPrimary` in light
   (cream on the 60% green) and `ext.textPrimary` in dark, record it as unread, and check contrast.
4. Gap before the CTA: **15** (Figma x 99 → 114). Busy state: dim the pill to 0.45 (R10) and disable
   the tap.
5. Keep the `PreviousQuestionRequested` event wiring exactly as is. This is UI only; the Bloc is
   untouched.

### 7.4 #47 Hairlines

- `mcq_renderer.dart` question card border → `BorderSide(ext.quizQuestionCardBorder,
  elevation.quizQuestionCardBorderWidth)` (light 0.5 `#4B675E`, dark 0.2 lavender 60%).
- `question_option_tile.dart` idle state border → `ext.quizOptionTileBorder` (0.5). Selected/correct/
  wrong states and the badge ring (`quizOptionBorder`) are unchanged.

### 7.5 #15 Buckets

`_ScoreCard` container → `ElevatedSurface(shape: RoundedRectangleBorder(r16), padding vertical 16,
color: ext.resultCardFill, shadows: elevation.resultBucketShadows, glass: elevation.resultBucketGlass)`.
Remove the border. It applies to Correct, Wrong and the conditional Skipped bucket. Fix the node ids
in the doc comment (`159:2289`).

### 7.6 #16 Rewards card

1. `_RewardsCard` → `ElevatedSurface(shape: RoundedRectangleBorder(r15), padding 16, color:
   ext.resultCardFill, shadows: elevation.rewardsCardShadows, glass: elevation.rewardsCardGlass,
   backlights:` `[elevation.rewardsCardBacklight]` when non-null`)`. Remove the border. Radius is 15.
2. Put the star glyph on a disc: `ElevatedSurface(shape: CircleBorder(), 33×33, color:
   ext.resultStarDiscFill, glass: elevation.resultStarDiscGlass)`, with the existing `Icon(Icons.star)`
   centred and its colour unchanged (`cs.primary`). Keep the row gap 8.
3. Fix the doc comment node (`159:2252`). The `pointsAwarded` text is verbatim from the server
   (unchanged).

### 7.7 #17 Filter pills

`_FilterChip`: keep `Semantics`, the 48 dp tap target and the min height 32.

- **Idle:** `ElevatedSurface(shape: StadiumBorder(), color: ext.reviewFilterIdleFill, shadows:
  elevation.reviewFilterIdleShadows, glass: elevation.reviewFilterIdleGlass, onTap)`.
- **Selected:** `ElevatedSurface(shape: StadiumBorder(), color: ext.quizReviewFilterFill, onTap)`, no
  shadows.
- Remove `elevation:` / `shadowColor:` and lower the ratchet by 2. Glyph dot/✕ and label colours are
  unchanged.
- If `AppColors.elevationShadow` has no remaining references afterwards, delete it and its test
  group (edit1 §7.3).

### 7.8 #19 Scope toggle

`ScopeToggle` keeps its API and its `scopes.length < 2 → SizedBox.shrink()` rule. Its body becomes
`SegmentedTrack<LeaderboardScope>(segments: scopes, selected, onChanged, labelOf: labelFor, height 44,
style: SegmentedTrackStyle(…))`:

- `trackColor: ext.scopeTrackFill`, `trackRadius: 32`,
  `trackInsetShadows: elevation.scopeTrackInsetShadows`;
- `idleSegmentColor: transparent`;
- `selectedColor: ext.scopeSelectedFill`, `selectedRadius: 22`,
  `selectedInsetShadows: elevation.scopeSelectedInsetShadows`;
- `labelStyle: AppType.h3`, `idleLabelColor: ext.textSecondary`,
  `selectedLabelColor: ext.podiumOnAccent`.

Re-read `158:840` for the light selected hex (§5 #19). If it is `#DBB0FF`, correct the tokens in the
edit1 style (`scopeSelectedFill` light and, if the row highlight matches, `podiumAccent`) with a dated
citation. Keep the lavender inset's +6 x offset physical (R9).

### 7.9 #20 Rows

- **Ordinary row:** `ElevatedSurface(shape: RoundedRectangleBorder(r12), height 48, padding 12/16,
  color: ext.leaderboardRowFill, shadows: elevation.leaderboardListShadows, glass:
  elevation.leaderboardRowGlass)`.
- **Caller's row (`isMe`):** same, with `color: ext.podiumAccent` and **no** Glass.
- Keep content, rank text and semantics.
- **Group Glass G10:** the tier-1 primitive takes one `GlassStyle`. Implement G5 only. Then compare a
  dark row with `337:5629` / `337:5630` at 100%.
  - If the second rim (splay 0.31) is visibly missing, add a rim-only `GlassSurface` layer with
    `elevation.leaderboardRowGroupGlass` over the row.
  - Otherwise record "G10 not layered, no visible difference" in DESIGN_ISSUES #72.

### 7.10a CTA consumer step (#12): wrap the quiz CTAs

The design item is #12 (edit2), and the primitive is edit1's `PrimaryCta`.

Wrap these `FilledButton`s as `PrimaryCta(tone: CtaTone.primary, enabled: <onPressed != null>,
child: …)`:

- `quiz_setup_screen.dart` "Start";
- `quiz_screen.dart` `_ActionBar` primary (Confirm / Next / Finish);
- `quiz_result_screen.dart` "Review Questions".

Figma: light (0.5, 0.5) blur 4 black 25%; dark the same plus the `#AE87E7` glow layer (layer blur 8),
e.g. `Frame 427319502` / `427319511` on Setup, Quiz and Result dark frames. Leave the Retry text
buttons and error-state `FilledButton`s unwrapped (no Figma frame). Test: each CTA is wrapped, and
`enabled` follows the Bloc/notifier busy state.

### 7.10 Consumer step (edit2 #27): "Leave quiz?" dialog

If `showAppDialog` exists: in `quiz_screen.dart` `_confirmLeave` (or equivalent), replace `showDialog`
with `showAppDialog(context: context, scrim: elevation.logoutDialogScrim, builder: …)`. Keep the
`AlertDialog` and its actions unchanged. There is no Figma frame for this dialog, so it takes the
app's dialog scrim for consistency (edit2 §13). If `showAppDialog` does not exist yet, skip this step
and record it.

### 7.11 Records

In `docs/DESIGN_ISSUES.md`:

- **#31 / S15:** append the pool-card spec (#45).
- **New entry:** "Quiz setup draws a back chip; the build uses an AppBar" (#49).
- **#53:** already RESOLVED 2026-09-17 (D-010). Record what was BUILT against the ruling; do not re-open the three options.
- **#72:** leaderboard G10 outcome and the scope-toggle light hex re-read.

### 7.12 Guard

Lower the `raw elevation effects` ratchet to the real count: −3 expected (AI `BoxShadow`, review
`elevation:` + `shadowColor:`).

## 8. Architecture / tokens used

- **AppColors:**
  - Quiz page: `quizOptionFill`, `quizOptionBorder` (badge ring only), `quizQuestionCardBorder`,
    `quizOptionTileBorder`, `quizPrevButtonFill`, `aiPanelOuterFill`, `aiPanelOuterBorder`,
    `aiPanelCardFill`.
  - Result and review: `resultCardFill`, `resultStarDiscFill`, `reviewFilterIdleFill`,
    `quizReviewFilterFill`.
  - Leaderboard: `scopeTrackFill`, `scopeSelectedFill`, `leaderboardRowFill`, `podiumAccent`,
    `podiumOnAccent`.
  - Shared: `textSecondary`.
- **AppElevation:**
  - Setup and quiz page: `lengthChipShadows`, `quizPrevButtonShadows`, `quizPrevButtonGlass`
    (+ added `quizPrevButtonRadius`), `quizQuestionCardBorderWidth`.
  - AI panel: `aiPanelGlass`, `aiPanelBacklight`, `aiPanelCardShadows`, `aiPanelCardGlass`.
  - Result and review: `resultBucketShadows`, `resultBucketGlass`, `rewardsCardShadows`,
    `rewardsCardGlass`, `rewardsCardBacklight`, `resultStarDiscGlass`, `reviewFilterIdleShadows`,
    `reviewFilterIdleGlass`.
  - Leaderboard: `scopeTrackInsetShadows`, `scopeSelectedInsetShadows`, `leaderboardListShadows`,
    `leaderboardRowGlass`, `leaderboardRowGroupGlass`.
  - Dialog: `logoutDialogScrim`.
- **Primitives:** `ElevatedSurface`, `SegmentedTrack`, `PrimaryCta` / `CtaTone` (edit1),
  `GlassSurface` (conditional, #20), and `showAppDialog` (edit2, conditional).

## 9. Files expected to change

- `lib/features/quiz/screens/quiz_setup_screen.dart`
- `lib/features/quiz/widgets/ai_explanation_panel.dart`
- `lib/features/quiz/screens/quiz_screen.dart` (`_ActionBar` + optional dialog)
- `lib/features/quiz/widgets/mcq_renderer.dart`, `question_option_tile.dart`
- `lib/features/quiz/screens/quiz_result_screen.dart`
- `lib/features/quiz/screens/quiz_review_screen.dart`
- `lib/features/leaderboard/widgets/scope_toggle.dart`, `leaderboard_row.dart`
- `lib/core/theme/app_elevation.dart` (+ `quizPrevButtonRadius`; conditional glyph / hex corrections
  with citations)
- `lib/core/theme/app_colors.dart` (conditional hex corrections; conditional `elevationShadow`
  deletion)
- `test/guards/project_rules_test.dart`
- Tests:
  - `test/features/quiz/quiz_setup_screen_test.dart`, `quiz_screen_test.dart`,
    `quiz_result_screen_test.dart`, `quiz_review_screen_test.dart`
  - `test/features/leaderboard/leaderboard_screen_test.dart`
  - new widget tests (§11)
- `docs/DESIGN_ISSUES.md`

## 10. Do not change

- Quiz Bloc state and events, repository, contract behaviour (Confirm/Next/Finish logic, grading,
  points rendering).
- Semantic correct/wrong HUES (the ruling changes treatment, not hue — D-010).
- The `PrimaryCta` primitive (edit1) and the inside of the wrapped `FilledButton`s: only add the
  wrapper. Also the limit sheet (edit2), back chips (edit2), quiz-type tabs (edit3).
- `LeaderboardScreen` routing/gating (D-008) and the podium.
- Foreign uncommitted hunks in the quiz/leaderboard files.

## 11. Verification plan

1. `dart format --output=none --set-exit-if-changed lib test` and `flutter analyze`, both clean.
2. Tests:
   - Setup: chips select, a 422 inline error still shows, `LimitSheet` still opens (existing tests),
     and a new check that the chip has no border and resolves `lengthChipShadows`.
   - Quiz screen: the previous button appears only after question 1; tapping it dispatches
     `PreviousQuestionRequested`; it is disabled while busy; RTL arrow flips; 48 dp semantics tap area.
   - AI panel widget test: dark outer surface has Glass + back-light, light has the 0.5 border; inner
     card shadow blur 3 (token); all four states still render.
   - Result: buckets have no border (light shadow, dark Glass); the rewards card has the star disc;
     the Skipped bucket still appears only when `answeredCount < totalQuestions`.
   - Review: filter pills keep the 48 dp tap target (existing test at line ~246); idle shadow in light,
     Glass in dark, selected flat; the dark-theme row assertions from #53 still pass.
   - Leaderboard: `ScopeToggle` still collapses to height 0 with one scope (existing test); segments
     select; RTL order; the `isMe` row has no Glass.
3. Goldens: none of the existing golden files cover these widgets. Add goldens for the dark AI panel,
   the rewards card and the scope toggle (Windows) after visual review.
4. `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` → OVERALL: PASS, count ≥ baseline.
   `tool\verify_guards.ps1` still green.
5. Device: mock backend. Setup → quiz (answer wrong, request explanation) → finish → result → review
   → leaderboard (mount via its test route or temporarily ungated **locally only**; do not commit an
   ungating). Light and dark, EN and AR.

## 12. Visual QA checklist (compare with Figma nodes at 100%)

- [ ] Setup chips: no hairline, tight shadow in both themes; dark idle `#27282C`, selected lavender
      (`337:6289`).
- [ ] AI panel light: 0.5 green outline, inner cards with a crisp blur-3 shadow (`159:1825`). Dark: no
      outline, Glass rim on outer and inner, lavender haze behind the header glyph (`337:9270`,
      `337:9279`).
- [ ] Previous button: 79×58 rounded rect. Light translucent green with a faint shadow; dark 20% Glass
      with the rim at 51° (upper-right/lower-left); 15 dp gap to Confirm.
- [ ] Question card dark: very thin (0.2) lavender hairline. Idle options dark: 0.5 lavender hairline
      (`337:6434`, `337:6440`). Light unchanged.
- [ ] Buckets: light shadow, no border (`159:2289`); dark Glass, no shadow (`337:6667`).
- [ ] Rewards: r15, light shadow, star on a pale lilac disc (`159:2252`); dark Glass + lavender haze at
      top-start + Glass star disc (`337:6680`, `337:6685`).
- [ ] Review pills: idle light cream + tiny shadow; idle dark 20% Glass; selected flat green/lavender.
- [ ] Review rows: Glass per the 2026-09-17 ruling (#48 / D-010), consistent across row states.
- [ ] Start / Confirm / Next / Finish / Review Questions CTAs: light tight black shadow; dark black
      shadow + lavender glow (`Frame 427319502` on Setup/Quiz/Result dark); busy or disabled dims
      the glow.
- [ ] Scope toggle dark: recessed track (top inner shadow + faint lavender inner glow on the left);
      selected lilac `#C4A8E3` pill with a white top-left inner highlight (`337:5615`). Light flat.
- [ ] Leaderboard rows light white with a hairline-soft list shadow. Dark 20% Glass rows; caller row
      lilac without Glass.
- [ ] RTL: arrow/segment order mirrored; inset and rim-light directions not mirrored.
- [ ] Regression: quiz timer/progress bar, graded tile colours, explanation states, result ring, review
      filtering and empty filter state.

## 13. Known risks / assumptions

- **BLOCKED:** #45 pool card (S15). (#48 review rows was unblocked 2026-09-17 — D-010.) #49 is a record
  only.
- **Unread values:** previous-button glyph colour; light selected scope hex (`#D8B0FF` vs `#DBB0FF`);
  dark A/B/C/D ring colour. Read them or record them. Never guess.
- **G10 group Glass** is layered only if visibly needed (§7.9).
- **Previous-button radius** differs per theme in Figma (9/10), so it is kept verbatim via a token.
- **Concurrent work:** the quiz review and leaderboard files are uncommitted/untracked; coordinate
  first.
- **Leaderboard is gated (D-008):** verify it through tests or a local-only ungating.

## 14. Completion criteria

- [ ] #11, #14, #46, #47, #15, #16, #17, #19, #20 implemented per §7 in both themes with edit1
      primitives. #45, #49 recorded; #48 built per D-010.
- [ ] No raw `BoxShadow` / `elevation:` / `shadowColor:` in these files. Ratchet lowered by 3.
- [ ] Tests updated/added. `validate.ps1` OVERALL: PASS. Count not lower.
- [ ] "Leave quiz?" dialog migrated if edit2 landed, otherwise noted.
- [ ] DESIGN_ISSUES updated (#31, #53, #72, setup-header entry, any unread-value notes).
