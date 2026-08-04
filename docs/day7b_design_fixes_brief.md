# Day 7b Brief — design fixes from the on-device debug pass

> Repo `level_up_app`, branch `dev`. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq` · Contract: `contract/openapi.yaml` (pinned 23f0535).
> Prereq: Day 7 committed, `dev` clean.
>
> **This is not a feature day.** It inserts between Day 7 (quiz) and Day 8 (Profile / Settings) and
> corrects screens already built in Days 00–7 against what the app actually looks like on a device.
> No endpoint is added; endpoint coverage is unchanged at 21/36.
>
> Findings are recorded as `DESIGN_ISSUES.md` **#36–#43**. Every section below closes its entries.

---

# Assumptions this brief is built on

Locked with the owner before writing. If any of these is wrong, stop and say so rather than
improvising around it.

1. **Sections A–D, one commit each.** Each commit flips its `DESIGN_ISSUES.md` entries to RESOLVED
   in the same commit.
2. **Home is purple-accented in the light canvas too.** The light Home frame `59:1439` exists and
   contradicts the derived light palette. Take the frame as truth (#42).
3. **The language pill keeps its current wording.** "English" / "العربية" stay; no ARB change, no
   semantic change. Only the glyph, border, radius and padding are wrong (#39).
4. **The two track illustrations are already committed** at `assets/images/track_school.svg` and
   `assets/images/track_university.svg` (exported by the owner 2026-08-03).
5. **The level medallion stays a placeholder.** There is no server source (see D3) and no asset set
   yet. Keep `Icons.emoji_events` + its `TODO(design-asset)` (#43).
6. **Golden tests** are added for the touched surfaces, using Flutter's built-in
   `matchesGoldenFile`. **No new package.**
7. **One cleanup is in scope**: delete the duplicate `_LanguagePill` in `login_screen.dart`. The
   orphan `/track-select` route at `app_router.dart:121` **stays** — out of scope this day.
8. **Dark values below are measured, not guessed.** Where a dark value genuinely does not exist in
   the file it is marked; nothing else is derived.

---

# Rules for this day

1. **The frame wins**, unless the deviation is already recorded in `DESIGN_ISSUES.md` as a
   deliberate contract-over-design call — then leave it and say so.
2. **Do not invent states the design does not draw.** Two are missing (the track card's selected
   state, the nav's pressed state). Where code already invented one, leave it and flag it; do not
   replace one invention with another.
3. **No new packages.** `flutter_svg` is already a dependency.
4. **No logic changes.** Quiz, catalog, registration and routing behaviour stay exactly as they are.
   The one exception is the bell's unread dot, which must be gated (D2).
5. **Every new colour becomes a token** in `AppColors`. No hex at a call site.
6. Work the sections in order — **D1 first inside section D**, because the palette change under it
   affects what the goldens capture.

---

# Colour reference — measured from both canvases

Everything below was read out of the file, light and dark. Light frames: nav `59:1264`, pill
`82:1093`, track `82:1785`, Home `59:1439`. Dark frames: nav `348:6686`, pill `337:19693`, track
`337:15947`, Home `337:5303`.

| element | light | dark |
|---|---|---|
| nav bar fill | `#FCFBF9` | `#212226` |
| nav corner radius | 30 | 30 |
| nav centre circle — idle | `#F3F1F8` | `#3E3E3E` |
| nav centre circle — selected | `#4B675E` | `#AE87E7` |
| nav centre glyph — idle / selected | `#B3B3B3` / `white` | `#B3B3B3` / `white` |
| nav tab glyph + label — off / on | `#B3B3B3` / `#4B675E` | `#B3B3B3` / `#AE87E7` |
| nav 26×2 top rule | `#4B675E` | `#AE87E7` |
| language pill fill | `#FCFBF9` | `#232428` |
| language pill border | `#4B675E` | **none** |
| language pill icon + label | `#384F47` | `#FCFBF9` |
| track card fill | `#FCFBF9` | `#232428` |
| track card border | **gradient** `#384F47` → `#95CDBB` | **none** |
| track card radio ring | `#384F47` | `#FCFBF9` |
| level card | `#FCFBF9`, radius 15 | `#232428`, radius 15 |
| level progress fill | `#AE87E7` | `#AE87E7` |
| level progress track | `#ECECEC` | `#2E2D32` |
| stat label ("current level") | `#7070A0` | `#7070A0` |
| stat value ("LEVEL 8") | `#393939` | `#FCFBF9` |
| stat divider | `#AE87E7` | `#AE87E7` |
| bell ring fill / stroke | `#FCFBF9` / `#4B675E` 0.5px | `#232428` / `#4B675E` 0.5px |
| bell glyph | `#4B675E` | `#FCFBF9` |
| bell unread dot | `#E67E22` | `#AE87E7` |

Two patterns worth naming, because they explain most of the bugs:

- **The green/purple accent flip does not hold everywhere.** Home's progress bar, stat divider and
  stat label are the **same purple in both canvases**. The nav bar *does* flip. Do not apply
  `cs.primary` on Home.
- **Borders are light-only.** The language pill and the track card both carry an outline in light
  and **none** in dark. The build adds a border in both, so it is wrong in dark twice.

The existing **dark** palette is already correct on the tokens it names — `progressTrack #2E2D32`,
`cardLabel #7070A0`, `mutedText #B3B3B3` all match the frames. The damage is on the light side,
where tokens carry the comment `(no light Home frame)`.

---

# Assets already committed

Pulled from Figma and in the tree. All are `currentColor` — tint at the call site with
`flutter_svg`'s `colorFilter`, never by editing the file.

| file | source node | viewBox | notes |
|---|---|---|---|
| `assets/icons/nav/home.svg` | `59:1007` icon/footer/home | `0 0 18 18.75` | not square |
| `assets/icons/nav/leaderboard.svg` | `59:1043` material-symbols:social-leaderboard | `0 0 24 24` | rosette, not a bar chart |
| `assets/icons/nav/learn.svg` | `59:1031` icon/footer/course | `0 0 16 20` | |
| `assets/icons/nav/message.svg` | `59:1205` icon/footer/notification | `0 0 20 17.9495` | not square |
| `assets/icons/nav/account.svg` | `59:1254` icon/footer/account | `0 0 24 24` | two paths |
| `assets/icons/language.svg` | `82:1100` meteor-icons:language | `0 0 20.129 20.129` | **stroke**, not fill |
| `assets/icons/chevron.svg` | `90:209` weui:arrow-filled | `0 0 15 30` | points **right** |
| `assets/icons/notification.svg` | `59:1466` mingcute:notification-fill | `0 0 37 37` | glyph only |

`pubspec.yaml` already declares `assets/icons/` and `assets/icons/nav/` (asset directories are not
recursive — that second line is required and easy to lose in a merge).

Plus the two track illustrations, exported by the owner and **now landed**:

| file | source node | size | note |
|---|---|---|---|
| `assets/images/track_school.svg` | `125:862` › Group 37219 | 99×101, 83 KB | ⚠ contains a `<filter>` blur — see C1 |
| `assets/images/track_university.svg` | `125:959` › Group | 98×97, 3.9 KB | clean |

**Still needed from outside the repo:** only the level-badge set (blocked on the designer — D3).

---

# A. Bottom nav bar — `lib/features/shell/main_shell.dart`

Frames: `59:1264` (light) / `348:6686` (dark), variants `Property 1=Home | leaderboard | learn |
message | Account`. Closes **#36, #37, #38**.

The bar is wrong in three independent ways. Fix them together — same widget.

## A1. Swap the Material icons for the exported SVGs (#36)

`main_shell.dart:41-47` uses `Icons.home / leaderboard / menu_book / chat_bubble / person`. None is
the design's shape; the leaderboard one is not even the same idea (the frame has a **rosette**). The
design mixes two icon sets — MingCute filled for four tabs, Material Symbols for leaderboard.

- **One glyph per tab, not two.** The design has no separate on/off artwork; selection only changes
  fill. Tint with `ColorFilter.mode(color, BlendMode.srcIn)`.
- **The viewBoxes are not square and not all 24.** Do not force `24×24` — Home is 18×18.75 and
  Message 20×17.95, and forcing will stretch them. Fit each into the frame's 24×24 slot with
  `BoxFit.contain`.
- Delete the `TODO(design-asset)` at `main_shell.dart:67` and replace `_NavTab`'s `IconData` field
  with an asset path.
- Keep the `Semantics(button:, selected:, label:)` wrapper — SVGs carry no semantics.

## A2. Rebuild the bar shape: notch + radius + shadow (#37)

Today: a rectangular `Container`, a 0.5px top `BorderSide`, and the raised centre faked as a
separate circle floating over a square bar. In the frame the raised centre is **part of the bar's
own outline** — a Union of a 64×64 circle and a 375×96 rounded rectangle.

Path, normalised to a **375×111** box (y=0 is the top of the bump):

```
M187 0 C198.426 0 208.452 5.99 214.113 15
H345 C361.569 15 375 28.4315 375 45
V111 H0 V45 C0 28.4315 13.4315 15 30 15
H159.887 C165.548 5.99 175.574 0 187 0 Z
```

As named constants rather than magic numbers:

| | value |
|---|---|
| bar height below the bump | 96 |
| bump rise | 15 → total 111 |
| top corner radius | 30 |
| notch circle | r = 32, centre (187, 32) |
| notch tangents | x = 159.887 and x = 214.113 |
| fill | `#FCFBF9` light / `#212226` dark |
| shadow | filter bounds imply ≈ blur 20, y+4, black ~8% — **unconfirmed, open question 2** |

Build with a `CustomClipper<Path>` / `CustomPainter`. **Scale the x values by `width / 375` and keep
the y values fixed**, so the notch does not distort on a tablet. Drop the 0.5px top border — the
frame has a shadow, not a rule. `SafeArea(top: false)` stays; the bump must not eat the gesture
inset.

## A3. Selected state is a background fill, not an icon tint (#38)

The centre tab is the one tab whose **background** carries the state:

| | circle (r = 26) | glyph | label |
|---|---|---|---|
| idle | `#F3F1F8` light / `#3E3E3E` dark | `#B3B3B3` | `#B3B3B3` |
| selected | `#4B675E` light / `#AE87E7` dark | `white` | accent |

Today the circle is `ext.cardFill` in **both** states with a 0.5px border the frame does not have,
and the glyph is recoloured instead. Invert it: animate the circle fill, glyph goes white when
selected, delete the border.

The other four tabs are right in principle — glyph + label `#B3B3B3` → accent, plus the 26×2 rounded
top rule. Verify the rule is `26×2` with a radius and picks up the accent, not a full-width bar.

`#F3F1F8` / `#3E3E3E` need a new token pair — suggest `navCentreIdleFill`.

## A4. Commit

`fix(nav): real footer glyphs, notched bar shape, centre-tab fill state` — closes #36, #37, #38.

---

# B. Language pill — `lib/core/widgets/language_pill.dart`

Frame `82:1093` (light) / `337:19693` (dark). Closes **#39**.

**Wording does not change.** The label stays `l10n.switchLanguage` — "English" / "العربية". Do not
touch the ARB files. Only the glyph and the box are wrong.

## B1. The icon

Replace `Icon(Icons.language, size: 18)` — a filled globe — with `assets/icons/language.svg`, the
frame's 文A translate mark (`meteor-icons:language`). It is **stroke-drawn**: `stroke="currentColor"`,
`stroke-width 1.67742`, round caps and joins. Size **20.13**. Do not re-render it as a fill — the
hairline weight is the whole look.

## B2. Metrics and colours

| | light | dark |
|---|---|---|
| size | 78.13 × 36.10, radius **18.05** (full stadium) | same |
| fill | `#FCFBF9` | `#232428` |
| border | **`#4B675E`** — *not* `ext.secondaryButtonBorder` (`#384F47`) | **none** |
| icon + label | `#384F47` | `#FCFBF9` |
| padding | 14.47 start / end, **10.07** icon→label gap | same |
| label | ~14 / line-height 21 | same |
| position (Log in) | end inset ≈ 24, top 64.89 | same |

Two things the build gets wrong beyond the glyph: it uses radius 24 and a 6px gap, and it paints the
border with `secondaryButtonBorder` (`#384F47`) — the frame's outline is the *lighter* `#4B675E`.
`#4B675E` already exists as `quizOptionBorder`; either reuse it or add a dedicated token, but do not
inline the hex.

**In dark there is no border at all.** The pill is `#232428` on a `#232428` page with white content.
Make the border nullable per canvas rather than always drawing one.

## B3. Kill the duplicate

`login_screen.dart:310-342` is a byte-for-byte copy of the shared widget. Fixing one and not the
other is how this drifts again — delete the private `_LanguagePill` and point `login_screen.dart:139`
at `core/widgets/language_pill.dart`.

All six call sites must still compile: `login_screen`, `otp_screen`, `onboarding_screen`,
`signup_identity_screen`, `signup_track_screen`, `registration_chrome`.

## B4. Commit

`fix(i18n): real translate glyph and frame metrics on the language pill` — closes #39.

---

# C. Sign Up_2 / track picker — `lib/features/registration/screens/signup_track_screen.dart`

Frame `82:1785` (light) / `337:15947` (dark). Cards `125:862` / `125:959`, back button `90:208`.
Closes **#40**.

**The screen is implemented and correctly positioned.** Route `/register/track`
(`app_router.dart:107`), entered from `signup_identity_screen.dart:90`, exits to
`/register/school` | `/register/university`. Nothing about the flow moves. The rendering is wrong.

## C1. The illustrations

The cards draw `Icons.menu_book_outlined` / `Icons.school_outlined` at 32px where the frame has a
**98×98 3D illustration**. Both assets are committed:

```
assets/images/track_school.svg        99×101   ← 125:862 › Group 37219
assets/images/track_university.svg    98×97    ← 125:959 › Group
```

Label starts at **x=107** in the frame, i.e. the art occupies the leading ~99px — not a 32px icon
with a 16px gap. These are full-colour illustrations: render them with a plain
`SvgPicture.asset(...)`, **no `colorFilter`**, unlike every icon in this brief.

**⚠ `track_school.svg` contains a Figma blur filter** — a `<g opacity="0.53"
filter="url(#filter0_f_…)">` wrapping a `feGaussianBlur` drop shadow. `flutter_svg` does not
implement SVG filters, so that group will render **unblurred** — a hard dark shape under the books
instead of a soft shadow. Check it on device first. If it looks wrong, delete that one `<g>` from
the asset (the illustration is complete without it) rather than trying to make flutter_svg blur it.
`track_university.svg` has no filter and needs no such treatment.

## C2. Card chrome

| | design | built |
|---|---|---|
| size | 363 × 112 | hug |
| radius | **25** | 20 |
| fill | `#FCFBF9` light / `#232428` dark | `ext.fieldFill` |
| border | **1px gradient `#384F47` → `#95CDBB`** (top-right → bottom-left) in light, **none** in dark | flat `ext.fieldBorder` 1.17px, both canvases |
| radio | circle **r = 9.5**, 1px ring, transparent fill — `#384F47` light / `#FCFBF9` dark | `Icons.radio_button_unchecked` |

Flutter has no gradient `Border`. Either wrap in a gradient-filled container with an inset child, or
stroke an `RRect` with a `Shader` in a `CustomPainter`. `#95CDBB` is a new colour — add a token.

**The selected state is not in the frame** — both cards are drawn unselected, so today's
`cs.primary` @ 8% + 2px border is invented. Leave it exactly as it is and flag it. Do not replace
one guess with another.

## C3. The circular back button

The frame has a **35×35 circle**, fill `#FCFBF9`, **no stroke**, holding `weui:arrow-filled` — a
15×30 chevron in `#4B675E`. The build uses a bare `IconButton(Icons.arrow_back)`.

`assets/icons/chevron.svg` **points right** — mirror it for back, and let RTL flip it naturally. The
soft ring in the render reads as a shadow, not a border (open question 3) — do not add a stroke.

This chip recurs on other registration screens. Build it once as
`core/widgets/circle_back_button.dart` and reuse it.

## C4. Layout

Side inset is **20** in the frame, 24 in code. The back-button row sits at y=64.89 — the same row
that carries the language pill from section B. Header block (title + subtitle) at y=146.

## C5. Commit

`fix(registration): track cards to frame — illustrations, gradient border, back chip` — closes #40.

---

# D. Home — palette, bell, medallion

Frame `59:1439` (light) / `337:5303` (dark). Closes **#41, #42, #43**.

## D1. Re-derive the light Home palette — **do this first** (#42)

`app_colors.dart:212-214` carries tokens commented `(no light Home frame)`. There **is** one —
`59:1439` — and Home does not follow the green-in-light rule.

| token / element | change to | today |
|---|---|---|
| level progress fill | `#AE87E7` (both canvases) | `cs.primary` → green in light |
| `progressTrack` (light) | `#ECECEC` | `#D1D1D1` |
| `cardLabel` (light) | `#7070A0` — same as dark | `#696969` |
| stat value (light) | `#393939` | `ext.textPrimary` |
| stat divider | `#AE87E7` (both) | `cs.primary` |

Do **not** simply swap `cs.primary` for `Brand.purplePrimary` at the call site — that hides the rule
change. Introduce an explicit Home/level accent token so the exemption is visible in the palette.

The **dark** side needs no change: `progressTrack #2E2D32`, `cardLabel #7070A0` and
`mutedText #B3B3B3` already match `337:5303`.

While you are in `app_colors.dart`, re-read **every** remaining `(no light Home frame)` and
`(no light Learn frame)` comment against the light frames now that they are known to exist, and
report what you find. Do not change anything outside Home in this commit — list it.

## D2. The bell becomes a bordered chip with an unread dot (#41)

`home_header.dart:60-67` renders `Icons.notifications` alone. The frame has three parts:

| part | light | dark |
|---|---|---|
| ring — 36.5 circle | fill `#FCFBF9`, stroke `#4B675E` **0.5px** | fill `#232428`, stroke `#4B675E` **0.5px** |
| glyph — `assets/icons/notification.svg` | `#4B675E` | `#FCFBF9` |
| unread dot — **r = 3** at **(23.5, 11.5)** | `#E67E22` | `#AE87E7` |

The asset is the **glyph only**, deliberately: the ring is decoration and the dot is *state*. Draw
both in Flutter; keep the SVG's 37 viewBox and the dot coordinates land without arithmetic. Note the
dot changes hue between canvases — it is not a fixed "notification orange".

**The dot must be conditional.** There is still no notifications endpoint in the contract (see the
comment at `home_header.dart:10`). Gate it behind an unread flag that currently resolves `false` and
mark it `TODO(contract)`. Do not render it always-on to match the frame.

## D3. The level medallion needs an asset set, not an icon (#43)

`level_card.dart:78` draws `Icons.emoji_events` at 56px in `cs.primary`. The frame has a **91×91
gold 3D medallion**, and the node is an instance of a `Level badges` component whose variant
property reads **`Level= 8`** — different artwork per level — filled with **raster PNGs**. It cannot
be exported as SVG and cannot be tinted.

**It does not come from the server.** The contract has no badge or medallion image anywhere:
`/reference/avatars` exists for avatars, but `badges` on the profile is an `integer` described as
*"Post-level-12 badges (every 5,000 points; first at 11,000)"*, with `newBadge: boolean` on quiz
finish. So the contract's `badges` is a **milestone counter that starts after level 12** — a
different concept from the Figma `Level badges` keyed `Level= 1…12`, which is driven by `level`.
Flag that name collision to Seif (open question 5).

**Action this day: none.** Keep the Material trophy and its `TODO(design-asset)`. `kMaxLevel = 12`,
so when the set arrives it is up to 12 images at @3x in `assets/images/badges/`, selected by level,
drawn at 91×91 (56 today). Shipping one badge for all levels is worse than the placeholder — it
looks correct and is wrong.

## D4. Commit

`fix(home): light palette from 59:1439, bell chip with gated unread dot` — closes #41, #42, #43.

---

# E. Golden tests

New this day, using Flutter's built-in `matchesGoldenFile`. **No new package.** Load the bundled
fonts in the test harness (`assets/fonts/`) or the goldens will render with the fallback face and be
useless for spacing.

Cover, in **both** canvases:

| golden | what it guards |
|---|---|
| nav bar × 5 selected states | the notch path, the centre-fill inversion, the right glyphs |
| track card — unselected | gradient border, radius 25, illustration slot |
| level card | the purple-in-light palette change |
| language pill | border present in light, absent in dark |
| Home header bell | ring + glyph, **and that the dot is absent** |

Also add plain widget tests for the two behavioural assertions, because a golden will not explain a
failure:

1. the unread dot does not render while the unread flag is false;
2. selecting the centre tab changes the circle's fill, not the glyph's colour.

Keep `flutter analyze` clean and the existing 45 tests green.

## E1. Commit

`test(golden): baseline goldens for nav, track card, level card, pill, bell`

---

# Verification before you hand back

- `flutter analyze` clean; `flutter test` green including the new goldens.
- Walk on a real device, both locales: onboarding → login → OTP → register → track → home, then all
  five tabs.
- RTL: the chevron mirrors, the nav notch stays centred, the illustrations do **not** mirror.
- Confirm the bump does not clip the home indicator.
- `DESIGN_ISSUES.md` #36–#43 all read RESOLVED except #43 (blocked) and the parts explicitly left
  open below.

---

# Open questions — for the designer / Seif

1. Is mixing **MingCute filled** (Home/Learn/Message/Account) with **Material Symbols**
   (Leaderboard) in one nav bar intentional? (#36)
2. Exact shadow token under the nav bar — colour, opacity, blur, offset. (#37)
3. Is the ring around the circular back button a shadow or a stroke? (#40)
4. The **selected** state of the track card — the frame only draws both cards unselected. (#40)
5. **To Seif:** the design's `Level badges` (per level 1–12) and the contract's `badges` integer
   (post-level-12 milestones) are different concepts sharing a name. Which drives the Home
   medallion, and is any badge imagery ever coming from the server? (#43)
6. **To the designer:** the level-badge set at @3x — how many distinct badges, and what is the
   fallback for a level with no artwork? (#43)
7. The unread dot on the bell has no contract behind it — is a notifications endpoint coming? (#41)
8. Confirm Home is **deliberately** exempt from the green/purple accent flip, since the light frame
   uses purple. (#42)

---

# Paste this into Claude Code

> The full phased version lives in **`docs/day7b_claude_code_prompt.md`** — use that one. The block
> below is the short form, kept here so the brief stays self-contained.

```
# ROLE

You are implementing Day 7b of the Level Up Flutter app: a design-fidelity pass over
screens already built in Days 00–7. No new features, no new endpoints, no new packages.

# SOURCE OF TRUTH — in precedence order

1. docs/day7b_design_fixes_brief.md — this day's spec. Its "Assumptions" section is
   already settled with the owner; do not relitigate it.
2. contract/openapi.yaml (pinned 23f0535) — where design and contract disagree, the
   contract wins.
3. The Figma frames — the brief gives measured values and node ids. Pull a frame
   yourself only if the brief does not already give you the number.
4. Existing repo patterns — match the surrounding code.

If two of these contradict each other in a way the brief has not settled, STOP and ask.

# EXECUTION ORDER

A. Bottom nav bar        (main_shell.dart)              → commit, closes #36 #37 #38
B. Language pill         (language_pill.dart)           → commit, closes #39
C. Track picker          (signup_track_screen.dart)     → commit, closes #40
D. Home — D1 palette FIRST, then bell, then medallion   → commit, closes #41 #42 #43
E. Golden tests                                         → commit

One commit per section. Each commit updates its DESIGN_ISSUES.md entries to RESOLVED.

# SKILLS — invoke from .claude/skills/

level-up-domain     glossary + operating rules       (always, first)
build-screen        the gather → plan → build loop
figma-frame         pulling and reading a frame
screen-states       state coverage per screen
river               Riverpod patterns
flutter-add-widget-test   for section E
flutter-fix-layout-issues for A2's custom clipper

# STOP AND ASK IF

- assets/images/track_school.svg or track_university.svg is missing (section C1)
- a frame shows a state the brief has not specced — do NOT invent one
- section D1 turns up a "(no light frame)" token outside Home; list it, don't change it
- the golden harness needs a package to load fonts
```
