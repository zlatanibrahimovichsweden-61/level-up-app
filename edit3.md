# Edit 3 — Home, Learn & Mistakes: level card, section cards, bell, search, subject & Mistakes cards, tree rows, quiz-type tabs

> Self-contained implementation guide. Token names refer to entries that **edit1.md** adds to
> `AppColors` / `AppElevation`. If edit1 shipped a name slightly differently, use the shipped
> equivalent; never add a parallel primitive.
>
> Figma file `P6044i0giD9TmdQ7C2AmLq`, page `design`. Written 2026-09-17.

---

## 0. Pre-flight

1. Read `CLAUDE.md`, `docs/WAVE_STATUS.md`, `docs/AGENT_WORKFLOW.md` § "Theme discipline", and
   **edit1.md §4 (rules R1–R10)**. They apply verbatim.
2. **edit1 must be in the tree:** `lib/core/theme/app_elevation.dart`,
   `lib/core/widgets/elevation/{elevated_surface,segmented_track}.dart`, and the guard test
   `raw elevation effects do not increase`. If missing, implement edit1 first.
3. `git status --short`. `lib/features/home/widgets/level_card.dart` carried an unrelated uncommitted
   doc-comment change on 2026-09-17 (contract S3 wording). Keep it, and ask the owner if its origin is
   unclear. Several sessions edit this repo concurrently; never discard foreign hunks.
4. Run `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` and record the passing count.
5. Do not commit unless asked.

## 1. Scope

| # | Item | File |
|---|---|---|
| 1 | Level card: light shadow; dark Glass G6 + back-light | `lib/features/home/widgets/level_card.dart`, `home_screen.dart` (pass track) |
| 3 | Home "Coming soon" placeholders take their section's Figma surface (**owner decision 2026-09-17**) | `lib/features/home/widgets/coming_soon_section.dart`, `lib/features/home/screens/home_screen.dart` |
| 4 | Home banner drop-shadow | `lib/features/home/widgets/home_banner.dart`: **BLOCKED**, record only |
| 5 | Subjects search field | `lib/features/catalog/screens/subjects_screen.dart` (`_SearchField`) |
| 6 | Subject card: two shadows in both themes, light fill `#FFFFFF` | `lib/features/catalog/widgets/subject_card.dart` |
| 7 | Mistakes pill in the Subjects header | `subjects_screen.dart` (`_MistakesButton`) |
| 9 | Quiz-type tabs rebuilt as a segmented track (**owner decision**) | `lib/features/catalog/widgets/quiz_type_tabs.dart` |
| 10 | Mistakes overview card: exact two shadows, dark Glass | `lib/features/mistakes/widgets/mistakes_subject_card.dart` |
| 41 | Home bell chip: dark Glass | `lib/features/home/widgets/home_header.dart` (`_BellChip`) |
| 42 | Tree rows: catalog fills/hairline, index-disc Glass (catalog + Mistakes) | `lib/features/catalog/widgets/tree_list_row.dart` |
| 43 | University "Learning Tools" tiles | not built (DESIGN_ISSUES #20): record the spec only |
| 44 | University Home Ellipse 123 has no glass cover | record only |

**Owned elsewhere:**

| What | Owner |
|---|---|
| `CatalogHeader` back chip | edit2 |
| Retry buttons in Home/catalog error states | no Figma frame; stay unwrapped (edit2 §7.3). Do not add `PrimaryCta` here. |
| Bottom nav bar | edit2 |
| Quiz setup / quiz / result / review screens | edit4 |
| Leaderboard | edit4 |
| Profile / settings | edit5 |

## 2. Objective

Home, the Learn drill-down and the Mistakes overview match Figma in both themes.

- **Light:** the measured drop shadows and hairlines.
- **Dark:** Glass surfaces, lavender back-lights behind the level card and the Daily Tasks / Top
  Student cards, and exact black shadows on the solid and 30% cards.
- The quiz-type selector becomes Figma's segmented track with dark inner bevels.
- The Mistakes card's `Material` elevation approximation is removed (guard ratchet −2).

## 3. Dependencies

- **Depends on:** edit1 (tokens, `ElevatedSurface`, `SegmentedTrack`, Glass painter, back-lights).
- **Independent of:** edit2, edit4, edit5 (any order). Screens show edit2's chrome only once edit2
  lands. Do the final visual QA after edit2 if possible, but it is not required for completion.
- `lib/features/home/screens/home_screen.dart` and `subjects_screen.dart` are touched only by this
  edit.

## 4. Design rules (plus R1–R10)

- Back-lights are part of the covering card (R6). They are frosted with **that card's** frost and
  mirrored in RTL. Dark only. School and University offsets differ, so pick by `profile.track`.
- The Home placeholders take only the **surface** of their section (fill, border, radius, shadows,
  Glass, back-light). Their "Coming soon" content, 96 dp height and inertness are unchanged. The
  sections still have no endpoints (see `ComingSoonSection` doc).
- Solid (`#27282C`) and 30% cards keep **black** shadows in dark (R1). Glass sits on top of the 30%
  Mistakes card.

## 5. Figma evidence

### #1 — Level card (`Frame 427319501`, 362×171, r15)

| Theme | Node | Fill | Shadow | Glass | Back-light |
|---|---|---|---|---|---|
| Light | `308:4209` (Home `59:1439`) | `#FCFBF9` | (0.5, 0.5) blur 4 black 25% | — | — |
| Dark school | `337:5336` (Home `337:5303`) | `#232428` @20% | none | **G6** | B1 `348:6951`: 133×21 at (23, 25) in the card |
| Dark university | `349:16593` (Home `337:10447`) | `#232428` @20% | none | **G6** | B9 `349:16784`: 133×21 at (23, 23) |

**G6:** frost 62 · refraction 0.80 · depth 78 · angle −45 · intensity 0.80 · dispersion 0.50 ·
splay 1.00.

On canvas (100%): a soft lavender haze behind the medal, and rim highlights on the top-left and
bottom-right corners.

### #3 — Home sections (school `337:5303` / uni `337:10447`; light `59:1439` / uni `125:2373`)

| Section | Theme | Node | Radius | Fill | Border | Shadow | Glass | Back-light |
|---|---|---|---|---|---|---|---|---|
| Daily Tasks `Container` 362×200.03 | Light | `308:4305` | 15 | `#FCFBF9` | 0.302507 `#4B675E` (all sides) | — | — | — |
| | Dark | `337:5357` / uni `349:16615` | 15 | `#242329` @20% | none (stroke hidden) | — | **G7** | school B2 `348:6952` 100×14 at (3, 0); uni B10 `349:16786` 133×21 at (13, 0) |
| Top Student `Container` 362×204.79 | Light | `59:2090` | 16.374941 | `#FFFFFF` | **all four sides** 1.20791 `rgba(124,58,237,0.1)` (corrected 2026-09-25, W05-2: first read as top only) | — | — | — |
| | Dark | `337:5460` / uni `349:16690` | 16.374941 | `#26272B` @20% | all four sides 1.20791 `rgba(124,58,237,0.1)` (corrected, W05-2) | — | **G9** | school B3 `348:6954` 100×14 at (3, 7.57); **uni: none** |
| Continue Learning `Container` 362×136.39 | Light | school / uni | 13.7251 | school `#F3E5FF`; uni `#DBB0FF` | — | (0, 0.425436) blur 1.27631 black 25% **+** (0.423807, 0) blur 0.850872 spread −0.425436 black 25% | — | — |
| | Dark | school / uni | 13.7251 | school `#C4A8E3`; uni `#DBB0FF` | — | same two black shadows | — | — |
| Learning Tools (uni only) | — | — | — | — | — | — | — | — |

- **G7:** frost 39 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0.
- **G9:** frost 34, other values the same as G7.
- Learning Tools: owner decision is to keep the plain placeholder (spec in #43).

### #4 — Banner (`banner` 361×192.53, r19.25): BLOCKED

`filter: drop-shadow(0.5px 0.5px 4px rgba(0,0,0,0.25))` in light and dark, on both tracks. The
artwork is export-blocked, and the app renders a themed placeholder (`HomeBanner` doc,
DESIGN_ISSUES #1 / #43 pattern). **No change now.** When the real artwork lands: add a
`bannerShadows` token (black 25% (0.5, 0.5) blur 4, both themes) in the edit1 style and wrap the image
in `ElevatedSurface(shape: r19.25)`.

### #5 — Subjects search (`Text Input`, 362×56, r15)

| Theme | Node | Fill | Border | Shadows | Glass |
|---|---|---|---|---|---|
| Light | `135:610` | `#FCFBF9` | **top only** 0.8 `#F3F4F6` (panel read; the CSS export wrongly showed all sides) | (0, 1) blur 3 black 10% **+** (0, 1) blur 2 spread −1 black 10% | — |
| Dark | `337:5724` | `#232428` @20% | none | none | **G5** (frost 4 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0) |

The drill-down screens' search fields (G11) are not built (DESIGN_ISSUES #17). Ignore them.

### #6 — Subject card (`Container`, 173×89, r10.697)

| Theme | Node | Fill | Shadows |
|---|---|---|---|
| Light | `135:618` | `#FFFFFF` | (0, 0.530516) blur 1.59155 black 25% **+** (0.528485, 0) blur 1.06103 spread −0.530516 black 25% |
| Dark | `337:5732` | `#27282C` (solid) | same two black shadows, no Glass |

Lower rows of the frame use a scaled variant (0.536246 / 1.60874, r10.8125) of the same card. The
first card's values are canonical (edit1 §13).

### #7 — Mistakes pill (Subjects header, `Frame 427319504`, 63.67×35, r9)

| Theme | Node | Fill | Border | Shadow | Glass |
|---|---|---|---|---|---|
| Light | light Subjects header | `#FCFBF9` | 0.266667 `#EF4444` | (0.266667, 0.266667) blur 2.13333 black 25% | — |
| Dark | `404:7421` | `#565656` @20% | 0.266667 `#EF4444` | same black shadow | **G5** |

The label colour is `#EF4444` in both themes. The widget uses `cs.error`, which `ColorScheme.fromSeed`
does **not** set to `#EF4444`.

### #9 — Quiz-type tabs (`Frame 1000003007`, 362×44, r32; segments 72.4×44)

| Theme | Node | Track | Idle segment | Selected segment |
|---|---|---|---|---|
| Light | `180:5337` (University Lectures `180:5208`) | `#ECECEC`, flat | `#ECECEC` | `#AE87E7`, r51/72 (≥ half height), flat |
| Dark | dark Lectures frames (`Learn(Lecture)` `337:11059` / `349:15962`) | `#232429` + **inset** (0, −3) blur 4 black 25% | `#232429` | `#AE87E7` + **inset** (0, 4) blur 4 black 25% |

- Figma draws five segments including "Flashcard". The build omits Flashcard deliberately
  (DESIGN_ISSUES #18); tabs come from `tree.quizTypes`.
- Label colours were **not read**. See §7.6.
- The same component (`Frame 1000003007`) is Settings → Languages (edit5); both use `pillTrack*`
  tokens.

### #10 — Mistakes overview card (`Container`, 173×89, r10.697)

| Theme | Node | Fill | Shadows | Glass |
|---|---|---|---|---|
| Light | `404:6322` | `#EAD5D5` | (0.528485, 0) blur 1.06103 spread −0.530516 black 25% **+** (0, 0.530516) blur 1.59155 black 25% | — |
| Dark | `404:7637` (and `404:7652`) | `#27282C` @30% | same two black shadows | **G5** |

The dark card's "Border 0.63px" in Layout exposes no stroke colour, and nothing is drawn
(DESIGN_ISSUES #70).

### #41 — Home bell (`mingcute:notification-fill` ring, 36×36)

| Theme | Node | Fill | Border | Glass |
|---|---|---|---|---|
| Light | `59:1466` | `#FCFBF9` | 0.5 `#4B675E` | — |
| Dark | `337:5330` (uni `349:16567`) | `#232428` @20% | 0.5 `#4B675E` | **G5** |

### #42 — Tree rows (catalog `Button`, 363×78, r16) and index disc (`Container`, 40×40, r20)

| Palette | Theme | Row fill | Row hairline | Disc fill | Disc Glass |
|---|---|---|---|---|---|
| Catalog | Light (Units/Chapters/Lessons/Lectures) | `#FCFBF9` | 0.5 `#4B675E` | `#F4E6FF` | — |
| Catalog | Dark `337:5926` | `#27282C` | 0.5 `#FCFBF9` | `#27282C` @20% | **G5** (rim only; the row is opaque) |
| Mistakes | Light `404:6642` | `#EAD5D5` | 0.5 `#4B675E` | not read (unchanged) | — |
| Mistakes | Dark `404:7765` / disc `404:7767` | `#27282C` | 0.5 `#FCFBF9` | `#27282C` @20% | **G5** (DESIGN_ISSUES #70 recorded "1 effect" of unknown type; it is Glass) |

Rows are flat (no shadow) in both themes.

### #43 — University "Learning Tools" tiles (`Frame 1000002992`–`96`, 110×85, r8): record only

- **Light:** `#FCFBF9` + 0.1 `#4B675E` + (0.02, 0.02) blur 5.4 black 25%.
- **Dark:** `#27282C` + (0.02, 0.02) blur 0.8 black 25% **+ inset** (1, 1) blur 4 `rgba(255,255,255,0.25)`
  **+ inset** (−2, −2) blur 4 black 25%.
- Not built. DESIGN_ISSUES #20 has no endpoint; the owner decision keeps the plain placeholder.

### #44 — University Home Ellipse 123 (`349:16788`, 133×21 at (33, 993)): record only

No glass surface covers it (plugin overlap test), so there is nothing for it to light. Do not
implement it. Record it for the designer as a probable leftover.

## 6. Current Flutter state (SOURCE, 2026-09-17)

- **#1** `LevelCard`: `Container(padding 13/9/13/16, BoxDecoration(color: ext.cardFill, r15))`, no
  shadow, no Glass. `cardFill` light is `#FDFDFD` (an existing `TODO(design)`: Figma `#FCFBF9`, left
  alone since Day 7b), dark `#232428` @20%. `HomeScreen` builds `LevelCard(level, totalPoints)` and has
  `profile.track`. Golden: `test/goldens/design_goldens_test.dart` → `level_card_{light,dark}.png`.
- **#3** `ComingSoonSection(title)`: header row + `Container(height 96, cardFill, r15)` with a
  schedule icon + "Coming soon". The same box is used for Daily Tasks, Learning Tools (uni),
  Continue Learning and Top Student.
- **#4** `HomeBanner`: 140-tall placeholder, `cardFill` + 0.5 `homeAccent` border.
- **#5** `_SearchField`: `TextField` with `InputDecoration(filled, fillColor: cardFill,
  OutlineInputBorder(r15, BorderSide.none))`, no shadow.
- **#6** `SubjectCard`: `Material(color: catalogCardFill (L #FDFDFD, D #27282C), r10.7, antiAlias)`
  + `InkWell`, no shadow.
- **#7** `_MistakesButton`: `OutlinedButton.styleFrom(minimumSize (0,35), padding h10, foreground
  cs.error, side cs.error 0.5, r9)`. Transparent fill, no shadow, no Glass.
- **#9** `QuizTypeTabs`: horizontal `SingleChildScrollView` of `_Tab` chips: `Material(selected ?
  cs.primary : catalogCardFill, r16)` + `Border.all(fieldBorder, 0.5)`, `AppType.labelMedium`
  (selected `cs.onPrimary`, idle `textSecondary`), 8 dp gaps.
- **#10** `MistakesSubjectCard`: `Material(color: mistakesCardFill, r10.7, shadowColor:
  ext.elevationShadow @0.25, elevation: 1.06)`. The comment says the two Figma shadows were "collapsed
  into one" (DESIGN_ISSUES #69). Guard sites: 2 lines.
- **#41** `_BellChip`: `Container(36.5 circle, color: ext.background, Border.all(bellRing, 0.5))` +
  SVG + unread dot. Goldens `home_header_bell_{light,dark}.png`.
- **#42** `TreeListRow`: catalog palette = (`catalogCardFill`, `fieldBorder`, `textPrimary`,
  `cardFill`); Mistakes palette = (`mistakesRowFill`, `mistakesRowBorder`, `mistakesContent`,
  `mistakesBadgeFill`). `_IndexBadge` = `Container(40 circle, color: fill)`, no Glass.
- `catalogCardFill` consumers: `SubjectCard`, `QuizTypeTabs`, `TreeListRow`. All three move off it in
  this edit.

## 7. Required changes

### 7.1 #1 Level card

1. Add `required Track track` to `LevelCard`. `HomeScreen` passes `profile.track`. Update the golden
   test call (`LevelCard(level: 8, totalPoints: 3700, track: Track.school)`) and any other callers.
2. Build with `ElevatedSurface(shape: RoundedRectangleBorder(r15), padding: as today, color:
   ext.cardFill, shadows: elevation.levelCardShadows, glass: elevation.levelCardGlass, backlights:`
   the track's `levelCardBacklight…` when non-null`)`.
3. Do **not** change `cardFill` (the light `#FDFDFD` vs `#FCFBF9` question is an existing, separately
   tracked `TODO(design)`).

### 7.2 #3 Home section surfaces

1. Add a `ComingSoonSurface` enum to `coming_soon_section.dart`: `dailyTasks`, `continueLearning`,
   `topStudent`, `plain`. Add `required ComingSoonSurface surface` and `required Track track` to
   `ComingSoonSection`.
2. Resolve per surface:
   - `dailyTasks`:
     - shape r15, `ext.dailyTasksFill`;
     - light border `BorderSide(ext.dailyTasksBorder, elevation.dailyTasksBorderWidth)`;
     - dark no border (`dailyTasksBorderWidth` 0);
     - glass `elevation.dailyTasksGlass`;
     - back-light `dailyTasksBacklightSchool` / `…University` by track.
   - `topStudent`:
     - shape r16.374941, `ext.topStudentFill`;
     - `side: BorderSide(ext.topStudentBorder, elevation.topStudentBorderWidth)` in both (was `topSide`, corrected in W05-2)
       themes;
     - glass `elevation.topStudentGlass`;
     - back-light `topStudentBacklightSchool` on the school track only.
   - `continueLearning`:
     - shape r13.7251;
     - fill `continueLearningFillSchool` / `…University` by track;
     - shadows `elevation.continueLearningShadows`;
     - no Glass.
   - `plain`: today's box, unchanged.
3. `HomeScreen`: Daily Tasks → `dailyTasks`, Learning Tools → `plain`, Continue Learning →
   `continueLearning`, Top Student → `topStudent`. Pass `profile.track`.
4. **Foreground contrast (accessibility):** the placeholder's icon/text use `ext.mutedText`
   (`#B3B3B3`). Measure it on each new surface (e.g. `#B3B3B3` on `#F3E5FF` and on `#C4A8E3`).
   - If a pair falls below 3:1 (large/icon) or 4.5:1 (caption), read the text colours of the matching
     Figma card (Continue Learning "Physics" title/caption) on the Properties panel.
   - Add them as tokens in the edit1 style, with a node citation and both themes.
   - If unreadable, keep `mutedText`, record the measured ratio in DESIGN_ISSUES, and flag it to the
     owner. **Never guess a colour.**
5. Keep: header row, "See All" inert, 96 height, "Coming soon" copy, and the documented reasons.

### 7.3 #5 Search field

Wrap the `TextField` in `ElevatedSurface(shape: RoundedRectangleBorder(r15), height 56, color:
ext.subjectSearchFill, topSide:` light `BorderSide(ext.subjectSearchTopBorder, 0.8)`, dark `null`
`(subjectSearchTopBorder` is `null` in dark`), shadows: elevation.subjectSearchShadows, glass:
elevation.subjectSearchGlass)`.

In the `TextField`'s `InputDecoration`:

- set `filled: false`;
- keep `border: InputBorder.none` (the surface draws the shape), the hint, the prefix icon and
  `contentPadding` (vertical 16, height stays 56).

Keep behaviour (setState filter, search action) unchanged.

### 7.4 #6 Subject card

`SubjectCard` → `ElevatedSurface(shape: RoundedRectangleBorder(r10.7), color: ext.subjectCardFill,
shadows: elevation.subjectCardShadows, onTap: onTap)` around the existing `Padding(9,11,9,11)` column.
Keep `aspectRatio`, text, progress bar and counter unchanged.

### 7.5 #7 Mistakes pill

Replace the `OutlinedButton` with a pill that keeps the same semantics: button, label
`l10n.mistakes`, `onTap: context.push('/learn/mistakes')`, min height 35, horizontal padding 10,
`AppType.buttonSmall`.

- Surface: `ElevatedSurface(shape: RoundedRectangleBorder(r9), color: ext.mistakesPillFill, side:
  BorderSide(ext.mistakesPillAccent, elevation.mistakesPillBorderWidth), shadows:
  elevation.mistakesPillShadows, glass: elevation.mistakesPillGlass, onTap: …)`.
- Label colour: `ext.mistakesPillAccent`.
- Keep a ≥ 48 dp touch target (as other chips do) without changing the drawn 35 dp pill.
- Update the doc comment. "Styling unchanged — already matched the frame" is no longer true: fill,
  hairline width, colour source, shadow and Glass all change.

### 7.6 #9 Quiz-type tabs → `SegmentedTrack`

1. `QuizTypeTabs` keeps its public API (`types`, `selected`, `onSelected`) and class name (tests use
   `find.byType(QuizTypeTabs)`). Its body becomes `Padding(horizontal 20)` →
   `SegmentedTrack<QuizType>(segments: types, selected: selected, onChanged: onSelected, labelOf: (t)
   => t.label(l10n), height: 44, style: SegmentedTrackStyle(…))`, where the style is:
   - `trackColor: ext.pillTrackFill`, `trackRadius: 32`,
     `trackInsetShadows: elevation.pillTrackInsetShadows`;
   - `idleSegmentColor: ext.pillTrackFill`;
   - `selectedColor: ext.pillTrackSelectedFill`, `selectedRadius: 22`,
     `selectedInsetShadows: elevation.pillTrackSelectedInsetShadows`;
   - `labelStyle: AppType.labelMedium`;
   - label colours per step 2.
2. **Label colours:** read the selected and idle label fills in `180:5337` (light) and the dark
   Lectures frame (`337:11059` / `349:15962`) on the Properties panel.
   - If readable, add `pillTrackLabel` / `pillTrackSelectedLabel` tokens (edit1 style, node citation,
     both themes). edit5 reuses them for Settings → Languages.
   - If not readable, keep today's `ext.textSecondary` (idle) / `cs.onPrimary` (selected), record that
     in DESIGN_ISSUES, and check contrast (≥ 4.5:1) in both themes.
3. The server-driven types, the Flashcard omission and the `/quiz/setup` hand-off stay unchanged. Keep
   the doc comment's contract notes.
4. Equal-width segments replace the scrolling chips. Verify that the longest labels fit
   (`منتصف الترم`, "Practice") at text scale 1.0 and 1.3 in AR and EN (`FittedBox` scale-down is in
   the primitive).

### 7.7 #10 Mistakes card

1. `MistakesSubjectCard` → `ElevatedSurface(shape: RoundedRectangleBorder(r10.7), color:
   ext.mistakesCardFill, shadows: elevation.mistakesCardShadows, glass: elevation.mistakesCardGlass,
   onTap: onTap)`. Remove `shadowColor:` / `elevation:`. Lower the guard ratchet by 2.
2. Update the widget's shadow comment: both Figma shadows are now drawn exactly, black in both
   canvases, knocked out behind the 30% fill, with Glass in dark. Record in DESIGN_ISSUES #69 that it
   is built exactly.
3. If `AppColors.elevationShadow` has no remaining references afterwards, delete it and its
   `palette_discipline_test.dart` group (edit1 §7.3 rule).

### 7.8 #41 Bell chip

`_BellChip` ring → `ElevatedSurface(shape: CircleBorder(), width/height 36.5, color: ext.homeBellFill,
side: BorderSide(ext.bellRing, 0.5), glass: elevation.homeBellGlass)`. Keep the SVG glyph, the 37 dp
layout box and the unread-dot gate unchanged.

### 7.9 #42 Tree rows

1. Catalog palette tuple → (`ext.treeRowFill`, `ext.treeRowBorder`, `ext.textPrimary`,
   `ext.treeRowBadgeFill`). The Mistakes tuple is unchanged.
2. `_IndexBadge` → `ElevatedSurface(shape: CircleBorder(), width/height 40, color: fill, glass:
   elevation.treeRowBadgeGlass)` for **both** palettes (dark Glass on the 20% disc).
3. Row structure unchanged: `Material(fill) + InkWell + 0.5 border`, flat.
4. Delete `AppColors.catalogCardFill` once `SubjectCard`, `QuizTypeTabs` and `TreeListRow` no longer
   reference it (allowed deletion). `catalogTrack` stays.

### 7.10 #4, #43, #44 — records

In `docs/DESIGN_ISSUES.md`:

- **#20:** append the Learning Tools tile spec (§5 #43).
- **New entry:** "University Home Ellipse 123 `349:16788` lights nothing".
- **Banner:** append the drop-shadow spec to the banner/asset entry.

No code changes for these three.

### 7.11 Guard

Lower the `raw elevation effects` ratchet to the new real count (−2 expected, `MistakesSubjectCard`).

## 8. Architecture / tokens used

- **AppColors:**
  - `cardFill`, `dailyTasksFill`, `dailyTasksBorder`, `topStudentFill`, `topStudentTopBorder`,
    `continueLearningFillSchool`, `continueLearningFillUniversity`;
  - `subjectSearchFill`, `subjectSearchTopBorder`, `subjectCardFill`, `mistakesPillFill`,
    `mistakesPillAccent`, `mistakesCardFill`;
  - `homeBellFill`, `bellRing`, `treeRowFill`, `treeRowBorder`, `treeRowBadgeFill`,
    `mistakesBadgeFill`, `pillTrackFill`, `pillTrackSelectedFill`;
  - (conditional) `pillTrackLabel`, `pillTrackSelectedLabel`.
- **AppElevation:**
  - `levelCardShadows`, `levelCardGlass`, `levelCardBacklightSchool`, `levelCardBacklightUniversity`;
  - `dailyTasksBorderWidth`, `dailyTasksGlass`, `dailyTasksBacklightSchool`,
    `dailyTasksBacklightUniversity`;
  - `topStudentTopBorderWidth`, `topStudentGlass`, `topStudentBacklightSchool`,
    `continueLearningShadows`;
  - `subjectSearchShadows`, `subjectSearchGlass`, `subjectCardShadows`;
  - `mistakesPillShadows`, `mistakesPillBorderWidth`, `mistakesPillGlass`, `mistakesCardShadows`,
    `mistakesCardGlass`;
  - `homeBellGlass`, `treeRowBadgeGlass`, `pillTrackInsetShadows`, `pillTrackSelectedInsetShadows`.
- **Primitives:** `ElevatedSurface`, `SegmentedTrack` / `SegmentedTrackStyle` (edit1).
- **Deleted token:** `catalogCardFill`. Conditionally also `elevationShadow`.

## 9. Files expected to change

- `lib/features/home/widgets/level_card.dart`, `coming_soon_section.dart`, `home_header.dart`
- `lib/features/home/screens/home_screen.dart`
- `lib/features/catalog/screens/subjects_screen.dart`
- `lib/features/catalog/widgets/subject_card.dart`, `quiz_type_tabs.dart`, `tree_list_row.dart`
- `lib/features/mistakes/widgets/mistakes_subject_card.dart`
- `lib/core/theme/app_colors.dart`: deletions only (`catalogCardFill`; conditionally
  `elevationShadow`); optional label tokens per §7.6 with Figma citation
- `test/guards/project_rules_test.dart` (ratchet)
- Tests: `test/features/home/home_screen_test.dart`, `test/features/catalog/*`,
  `test/features/mistakes/mistakes_screens_test.dart`, `test/goldens/design_goldens_test.dart` +
  `level_card_*.png`, `home_header_bell_*.png`
- `docs/DESIGN_ISSUES.md` (#20, #69, banner, Ellipse 123; label/contrast notes if any)

## 10. Do not change

- `HomeBanner` (blocked), `cardFill` values, the level-card content/contract logic (`kPointsPerLevel`
  etc.).
- `CatalogHeader` / back chip (edit2), nav bar (edit2), quiz or leaderboard widgets (edit4), profile or
  settings (edit5).
- The Mistakes row palette values (DESIGN_ISSUES #70 ruling) other than adding disc Glass.
- `quiz_type_tabs.dart` contract behaviour (types from `tree.quizTypes`, no Flashcard).
- The unrelated uncommitted doc-comment hunk in `level_card.dart`.

## 11. Verification plan

1. `dart format --output=none --set-exit-if-changed lib test` and `flutter analyze`, both clean.
2. Tests:
   - `home_screen_test.dart`: the four sections render with the right `ComingSoonSurface` per track
     (school: no Learning Tools; uni: Learning Tools `plain`); the level card receives the track.
   - New `coming_soon_section_test.dart`: fill/border/radius per surface and theme; back-light only in
     dark and only where Figma has one (uni Top Student none).
   - `subjects_screen_test.dart`: `SubjectCard` count unchanged; the Mistakes pill still navigates to
     `/learn/mistakes`; search still filters.
   - `lectures_screen_test.dart`: `QuizTypeTabs` present/absent as before; tapping a segment selects it
     (semantics `selected`); RTL segment order; no overflow at text scale 1.3 (AR + EN).
   - `mistakes_screens_test.dart`: `MistakesSubjectCard` count and navigation unchanged.
   - Tree row test: catalog light hairline `#4B675E`, disc `#F4E6FF`; dark disc Glass present.
3. Goldens (Windows): regenerate `level_card_{light,dark}.png` and `home_header_bell_{light,dark}.png`
   **after** visual review (§12). Consider adding goldens for a dark Home section card and the dark
   segmented tabs.
4. `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` → OVERALL: PASS, count ≥ baseline.
   `tool\verify_guards.ps1` still green.
5. Device: Home (school and university accounts via the mock backend), Learn → Subjects → a subject →
   Units/Chapters/Lessons, a University subject's Lectures (tabs), Mistakes overview + tree. Light and
   dark, EN and AR.

## 12. Visual QA checklist (compare with the listed Figma node at 100%)

- [ ] Level card light: soft 0.5/0.5/4 shadow (`308:4209`). Dark: no shadow; lavender haze behind the
      medal; rim highlights top-left + bottom-right (`337:5336`). In AR the haze sits behind the medal
      on the right (mirrored).
- [ ] Daily Tasks placeholder light: 0.3 green hairline, flat (`308:4305`). Dark: Glass, lavender
      glow at the top-start edge (`337:5357`).
- [ ] Top Student placeholder light: white with a faint purple top hairline (`59:2090`). Dark: Glass
      + top hairline + glow (school only).
- [ ] Continue Learning placeholder: lilac (school `#F3E5FF` / dark `#C4A8E3`; uni `#DBB0FF`) with a
      tight two-shadow edge. "Coming soon" readable (contrast recorded).
- [ ] Learning Tools (uni): unchanged plain box.
- [ ] Subjects search light: top hairline + soft shadow. Dark: Glass rim, no border.
- [ ] Subject cards: crisp two-shadow edge in **both** themes, white in light, `#27282C` in dark.
- [ ] Mistakes pill: thin red hairline, small shadow; dark 20% grey fill + Glass rim; label `#EF4444`.
- [ ] Tabs light: grey track, lavender selected pill, flat (`180:5337`). Dark: dark track with a top
      inner shadow; the selected pill looks pressed (inner shadow at top) (`Frame 1000003007` dark).
- [ ] Mistakes cards: exact two shadows, no Material shadow halo. Dark: 30% card with Glass rim +
      black edge shadow (`404:7637`).
- [ ] Bell dark: 20% disc with rim light, green ring (`337:5330`).
- [ ] Tree rows light: green hairline (not grey), lavender disc. Dark: cream hairline, Glass disc rim
      (`337:5926`).
- [ ] RTL: back-lights mirrored; shadows not mirrored; tabs ordered right-to-left.
- [ ] Regression: Home skeleton, error and offline states unchanged. Retry buttons show the edit2 CTA
      treatment if edit2 landed.

## 13. Known risks / assumptions

- **BLOCKED:** banner (#4, artwork), Learning Tools tiles (#43, no endpoint), Ellipse 123 (#44,
  designer check).
- **Placeholder surfaces** are an owner decision: the placeholders are not Figma components, so only
  the section surface is applied.
- **Label colours** for the tabs may still be unread (§7.6). Contrast is the fallback gate.
- **Back-light RTL mirroring** is an assumption (edit1 R9).
- **Track-specific offsets** (school vs university) are Figma-verbatim, not normalised.
- **`cardFill` light `#FDFDFD`** stays on the level card, which keeps the existing, separately
  tracked `TODO(design)` (Figma `#FCFBF9`). The Home section placeholders use their own §8 fills.
- **Goldens are Windows-only baselines.**

## 14. Completion criteria

- [ ] Items #1, #3, #5, #6, #7, #9, #10, #41, #42 implemented per §7 in both themes with edit1
      primitives. Items #4, #43, #44 recorded.
- [ ] Owner decisions honoured: tabs are a `SegmentedTrack`; placeholders use per-section surfaces.
- [ ] `catalogCardFill` deleted. No raw shadow or elevation left in these files. Ratchet lowered by 2.
- [ ] Tests and goldens updated after visual review. `validate.ps1` OVERALL: PASS. Count not lower.
- [ ] DESIGN_ISSUES updated (#20, #69, banner note, Ellipse 123, any contrast/label notes).
