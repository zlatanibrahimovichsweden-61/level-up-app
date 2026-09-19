# Edit 5 — Account & auth screens: Profile, Edit Profile, Settings, OTP, sign-up track card

> Self-contained implementation guide. Token names refer to entries that **edit1.md** adds to
> `AppColors` / `AppElevation`. If edit1 shipped a name slightly differently, use the shipped
> equivalent; never add a parallel primitive.
>
> Figma file `P6044i0giD9TmdQ7C2AmLq`, page `design`. Written 2026-09-17.

---

## 0. Pre-flight

1. Read `CLAUDE.md`, `docs/WAVE_STATUS.md`, `docs/AGENT_WORKFLOW.md` § "Theme discipline",
   `.claude/skills/river/SKILL.md` (Settings/Profile are Riverpod screens; state logic stays as is),
   and **edit1.md §4 (rules R1–R10)**.
2. **edit1 must be in the tree:** `app_elevation.dart`, `elevated_surface.dart`, `segmented_track.dart`,
   and the guard test `raw elevation effects do not increase`. If missing, implement edit1 first.
3. `git status --short`. `lib/features/profile/screens/profile_screen.dart` carried an unrelated
   uncommitted doc change on 2026-09-17 (Subscription row). Several sessions edit this repo
   concurrently: never discard or reformat foreign hunks, and ask the owner if unsure.
4. Run `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` and record the passing count.
5. Do not commit unless asked.

## 1. Scope

| # | Item | File |
|---|---|---|
| 21 | Profile header card: dark black shadow + Glass G15 + back-light | `lib/features/profile/widgets/profile_header_card.dart` |
| 22 | Profile edit pencil chip (40×40) | same file |
| 23 | Profile stat card: blur 2, black, dark solid fill | `lib/features/profile/widgets/profile_stat_card.dart` |
| 24 | Profile menu rows (+ icon discs) | `lib/features/profile/widgets/profile_menu_row.dart` |
| 25 | Edit Profile avatar badge (34×34) | `lib/features/profile/screens/edit_profile_screen.dart` (`_AvatarEditor`) |
| 28 | Settings section cards (+ back-light on Notification Preferences) | `lib/features/settings/widgets/settings_section.dart`, `settings_screen.dart` |
| 50 | Settings → Languages rebuilt as a segmented track (**owner decision 2026-09-17**) | `lib/features/settings/screens/settings_screen.dart` (`_LanguagesSection`) |
| 51 | Settings → Mode swatches | **BLOCKED** (DESIGN_ISSUES #45): record only |
| 30 | OTP resend timer pill: inner shadow, h42, padding 15 | `lib/features/auth/screens/otp_screen.dart` (`_ResendTimerPill`) |
| 31 | OTP code card (light shadow, dark lavender glow) | `otp_screen.dart` (`_InputView`) |
| 52 | OTP digit boxes: dark Glass G19 + 0.5 hairline | `otp_screen.dart` (Pinput) |
| 53 | OTP success badge drop shadow | **BLOCKED** (DESIGN_ISSUES #28): record only |
| 32 | Sign-up track card (light shadow, dark Glass, no opaque fill) | `lib/features/registration/screens/signup_track_screen.dart` (`_TrackCard`) |
| 54 | Track card illustration blur layer | verify, then implement (same file) |

Plus a **CTA consumer step** for #12 (primary owner edit2; primitive from edit1). Wrap OTP "Verify",
OTP success "Continue" and Edit Profile "Save" in `PrimaryCta` (§7.11a). This does not depend on
edit2.

Plus one **consumer step** from edit2 (#27): Edit Profile "Discard changes?" → `showAppDialog`, only
if edit2 has landed.

**Owned elsewhere:**

| What | Owner |
|---|---|
| Back chips (`CircleBackButton`, `TitledChrome`), language pill, form fields (`FieldShell`), Logout / Go-to-University dialog scrims, panels and confirm CTA, avatar sheet scrims | edit2 |
| The `PrimaryCta` primitive | edit1. This edit only wraps OTP and Edit Profile CTAs (§7.11a). |
| The `CircleBackButton(variant:)` call in `signup_track_screen.dart` | edit2 (this edit changes only `_TrackCard`) |
| Leaderboard | edit4 |

## 2. Objective

Profile, Edit Profile, Settings, OTP and the sign-up track picker match Figma in both themes.

- **Light:** exact shadows and hairlines, and the OTP timer's real inner bevel.
- **Dark:** measured black shadows on the solid and translucent cards that keep them; Glass on header,
  chips, rows, badge, sections, digit boxes and track cards; lavender back-lights behind the profile
  header and Notification Preferences; the OTP card's lavender glow; the Settings language segmented
  track with inner bevels.
- The four remaining raw `BoxShadow`s disappear (guard ratchet −4) and the frozen
  `AppColors.elevationShadow` test group for `ProfileStatCard` is replaced.

## 3. Dependencies

- **Depends on:** edit1.
- **Optional:** edit2, only for the Discard-changes dialog step (§7.11). Skip it if `showAppDialog`
  does not exist. Settings → Languages reuses `pillTrackLabel` / `pillTrackSelectedLabel` only if
  edit3 added them.
- **Independent of:** edit3, edit4.
- `signup_track_screen.dart` is also touched by edit2 (one call). Keep changes to `_TrackCard`.

## 4. Design rules (plus R1–R10)

- Translucent cards that keep a shadow in dark (profile header, edit chip, avatar badge) paint it
  **outside** the shape only (R4). Their Glass rim sits on top.
- The stat card is **solid** `#27282C` in dark, not 20%.
- The OTP timer's bevel is an **inner** shadow in both themes (R7). The old outer shadow was borrowed,
  not read.
- The OTP code card's dark "shadow" is a lavender glow: a drop shadow in `rgba(174,135,231,0.25)`.
  It is a shadow token, not a back-light.

## 5. Figma evidence

Frames:

| Screen | Light | Dark |
|---|---|---|
| Profile | `166:4416` | school `337:7433`, uni `349:12919` |
| Edit Profile | `180:4012` | `337:7795`, uni `349:12688` |
| Settings | `176:1840` | school `337:8141`, uni `349:12113` |
| OTP | `82:1328` | `337:15739`, `337:15807`; success-state variant `337:19471` |
| Sign Up_2 (track picker) | `82:1785` | `337:15947` |

### #21 — Profile header (`Frame 5`, 363×104, r15)

| Theme | Node | Fill | Shadow | Glass | Back-light |
|---|---|---|---|---|---|
| Light | `169:4609` | `#FCFBF9` | (0.5, 0.5) blur 4 black 25% | — | — |
| Dark | `337:7455` (uni `349:12941`) | `#27282C` @20% | **same black** (0.5, 0.5) blur 4 25% | **G15** frost 57 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0 | B7 `348:8973` (uni B16 `349:12920`): 100×14 at (4, 11) |

On canvas (dark, 100%): a lavender haze behind the avatar, and rims top-left and bottom-right.

### #22 — Edit pencil chip (`fluent:edit-16-filled`, 40×40, r48.17)

| Theme | Node | Fill | Shadow | Glass | Glyph |
|---|---|---|---|---|---|
| Light | pencil chip in `166:4416` | `#FCFBF9` | (0.02833, 0.02833) blur 1.3 black 25% | — | not read |
| Dark | `337:7466` | `#232428` @20% | same black shadow | **G5** (frost 4 · refraction 0.80 · depth 20 · angle −45 · intensity 0.80 · dispersion 0.50 · splay 0) | vector 20×20, `#FCFBF9` (read 2026-09-17) |

### #23 — Stat card (`Container`, 363×82 and 176.5×82, r16)

| Theme | Node | Fill | Shadow |
|---|---|---|---|
| Light | `661:8571` | `#FCFBF9` | (0.02, 0.02) blur **2** black 25% (code says 1: wrong) |
| Dark | `661:8579` | **`#27282C` solid** | same black shadow, no Glass |

### #24 — Menu rows (`Button`, 363×63–64, r16, padding 14/16, gap 12) and icon discs (35×35, r48.17)

| Row tone | Theme | Nodes | Row fill | Row stroke | Row Glass | Disc fill | Disc Glass |
|---|---|---|---|---|---|---|---|
| Neutral (8 rows) | Light | `170:4790` + siblings | `#FCFBF9` | 0.5 `#7070A0` | — | `#F4E6FF` | — |
| Neutral | Dark | `337:7479` … | `#27282C` @20% | **none** (stroke hidden) | **G5** | `#27282C` @20% | **G5** (`337:7480`, `337:7487`, `337:7494`, `337:7501`, `337:7515`, `337:7522`) |
| Emphasis (Go to University) | Light | row with trend-up icon | `#FCFBF9` | 0.5 **`#101010`** | — | `#F4E6FF` | — |
| Emphasis | Dark | trend-up row, disc `337:7536` | `#27282C` @20% | none | **G5** | `#27282C` @20% | **G5** |
| Destructive (Logout) | Light | Logout row | `#FCFBF9` | 0.5 `#EF4444` | — | `#F4E6FF` | — |
| Destructive | Dark | `337:7545`, disc `337:7546` (disc has a shadow flag) | `#27282C` @20% | **0.5 `#EF4444`** | **G5** | `#27282C` @20% | **G5** |

- The CSS export of the current light frame shows a `#F4E6FF` 35×35 disc on **every** row.
- The widget's doc says neutral rows have a bare glyph. That came from an older frame (`170:4933`).
  Verify before changing (§7.4).

### #25 — Avatar badge (`fluent:edit-16-filled`, 34×34, r40.94)

| Theme | Node | Fill | Shadow | Glass |
|---|---|---|---|---|
| Light | Edit Profile light (`180:3989`, located by name) | `#FCFBF9` | (0.0240833, 0.0240833) blur **1.105** black 25% (code: 0.5/0.5/2, wrong) | — |
| Dark | `337:7925` | `#FCFBF9` @20% | same black shadow | **G5** |

### #28 — Settings sections (`Container`, r16)

| Section | Theme | Node | Fill | Stroke | Glass | Back-light |
|---|---|---|---|---|---|---|
| "Show Rank" (362×52) | Light | `176:1840` | `#FCFBF9` | 0.5 **`#AE87E7`** | — | — |
| | Dark | `642:8583` | `#27282C` @20% | **none** (hidden) | **G16** frost **63**, other values G5 | — |
| Notification Preferences (362×209) | Light | `176:1840` | `#FCFBF9` | 0.5 `#AE87E7` | — | — |
| | Dark | `337:8195` (uni `349:12171`) | `#27282C` @20% | none | **G16** | school B8 `348:8975`: 100×14 at (**0, 33**); uni B15 `349:12114`: (**0, 27**) |

- Row dividers inside a section were not read. Keep today's.
- Figma draws Languages and Mode **without** a section card (a segmented track and swatches).

### #50 — Settings → Languages (`Frame 1000003007`, 362×44, r32; selected `Frame 1000003004`, 181×44, r51)

| Theme | Node | Track | Selected segment |
|---|---|---|---|
| Light | `176:1840` | `#ECECEC`, flat | `#AE87E7`, flat |
| Dark | `337:8177` (in `337:8141`) | `#232429` + **inset** (0, −3) blur 4 black 25% | `#AE87E7` + **inset** (0, 4) blur 4 black 25% |

- This is the same component as the quiz-type tabs (edit3), so the `pillTrack*` tokens are shared.
- Segment order and label colours were not read; read them (§7.6).

### #51 — Mode swatches: BLOCKED, record only

Three `Ellipse 124` circles (47.51, at x 9.58 / 76.24 / 142.91). On canvas they are diagonal
two-colour splits (green/white, purple/dark, teal/white), with `Ellipse 125` (#AE87E7, rotated) forming
a half.

| Swatch | Light frame | Dark frame |
|---|---|---|
| 1 | `#FCFBF9` + 5 `#384F47` ring (selected) + drop (0, −1) blur 3 black 25% + inset (0, 2) blur 4 black 25% | `#FCFBF9`, same two shadows |
| 2 | `#232428` + drop (0, −1) blur 3 + inset (0, −2) blur 4 `#FFFFFF` | `#232428` + 5 `#AE87E7` ring (selected) + drop (0, −1) blur 3 + inset (0, −2) blur 2 `rgba(255,255,255,0.25)` |
| 3 | `#FFFFFF` + drop (0, −1) blur 3 + inset (0, 2) blur 4 black 25% | same |

Blocked by DESIGN_ISSUES #45 (three swatches, two themes). The app keeps two `SettingsChoiceRow`s.
**No change.**

### #30 — OTP resend timer (`Item / Timer`, 90×42, r100 stadium, in `Frame 1000002977` `332:3390`)

| Theme | Node | Fill | Effect | Size |
|---|---|---|---|---|
| Light | `332:3391` | `#FCFBF9` | **inset** (0, −1) blur 4 black 25% | height **42**, horizontal padding **15** (panel) |
| Dark | `337:19503` | `#232428` (solid) | **inset** (−0.5, 0.5) blur 1.2 `rgba(198,198,198,0.25)` | same |

The code cites "Frame `427319517`" and a 36/14 geometry measured off a screenshot, with the shadow
borrowed from other cards. Both are superseded by these panel readings.

### #31 — OTP code card (`Type= correct`, 354×171.01, r19)

| Theme | Node | Fill | Shadow |
|---|---|---|---|
| Light | `308:5114` | `#FCFBF9` | (0.2, 0.2) blur 4 black 25% |
| Dark | `337:19501` | `#232428` | (0.2, 0.2) blur **7.9** `rgba(174,135,231,0.25)` (lavender glow) |

The card is a component instance containing the digit boxes (`I337:19501;337:19276`–`…19279`). Read
its full child list and auto-layout padding in the layers panel before building (§7.8).

### #52 — OTP digit boxes (`Rectangle 104`–`107`, 66×61.01, r11.73)

| Theme | Nodes | Fill | Stroke | Glass |
|---|---|---|---|---|
| Light | `Rectangle 104–107` (OTP light) | `#FDFDFD` | 1.17333 `#D1D1D1` | — |
| Dark | `I337:19295;337:19276`–`…19279` (OTP `337:15739`), `I337:19501;337:19276`–`…19279` (OTP `337:19471`) | `#232428` @20% | **0.5** `#D1D1D1` | **G19** frost 56 · refraction 0.80 · depth **100** · angle −45 · intensity 0.80 · dispersion **0.65** · splay **0.50** |

Figma draws **4** boxes; the build draws **6** (contract, DESIGN_ISSUES #5). Box geometry stays the
build's (48×56, r16). Only the surface treatment follows Figma.

### #53 — OTP success badge: BLOCKED, record only

`Vector` `#22C55E` + drop (2, 1.5) blur 4 black 25% in both themes (OTP #1 light/dark). The SVG carries
the shadow as a `<filter>` that `flutter_svg` ignores. DESIGN_ISSUES #28 asks the designer whether it
matters and, if so, to re-export without the filter. **No change.**

### #32 — Sign-up track cards (`Component 2` / `Frame 1000002985`, 363×112, r25)

| Theme | Node | Fill | Border | Shadow | Glass |
|---|---|---|---|---|---|
| Light | `125:862` (in `82:1785`) | `#FCFBF9` | 1px gradient `#384F47` → `#95CDBB` (already built) | (0.5, 0.5) blur 4 black 25% | — |
| Dark, first card | `337:15981` (`Component 2`, y 234) | `#232428` @20% | **none** | **none** | **G20**: G5 values with **angle 25** |
| Dark, second card | `I337:15982;125:727` (`Frame 1000002985`) | `#232428` @20% | none | none | **G5** |

Map "first/second" to School/University by reading the card labels in `337:15947`.

### #54 — Track card illustration layer (verify)

Inside `Component 2` (both themes): layer `189984493_3c0d286d-…`, 98×98, **opacity 0.53**, CSS
`filter: blur(3.7px)` (panel layer blur **7.4** → σ 3.7). It is not yet known whether this is the
illustration itself or a blurred duplicate behind it (a glow).

## 6. Current Flutter state (SOURCE, 2026-09-17)

- **#21** `ProfileHeaderCard`: `Container(height 104, padding h18, color: ext.cardFill (L #FDFDFD / D
  #232428@20%), r15, BoxShadow(elevationShadow@0.25, 0.5/0.5, blurRadius 4))`. In dark this is cream,
  under the translucent fill. Guard site.
- **#22** The pencil is a bare `IconButton(key: profile_edit_button, tooltip: editLabel,
  Icon(Icons.edit, 24, homeAccent))`. No chip.
- **#23** `ProfileStatCard`: `Container(padding 12, cardFill, r16, BoxShadow(elevationShadow@0.25,
  0.02, blurRadius 1))`. Guard site. `test/core/theme/palette_discipline_test.dart` group
  `a card on each canvas` pins exactly this `Container`/`BoxShadow` (blur 1, cream dark).
- **#24** `ProfileMenuRow`: `Container(padding 16.5/14.5, color cardFill, Border.all(border 0.5), r16)`.
  Border by tone: neutral `profileRowBorder #7070A0` in both themes; emphasis `textPrimary`;
  destructive `destructive`. Glyph disc only on emphasis/destructive rows (`profileIconChip`: L
  `#F4E6FF`, D `#3E3E3E` derived). Disabled = `IgnorePointer` + `Opacity 0.45`.
- **#25** `_AvatarEditor` badge: `Container(34 circle, cardFill, BoxShadow(elevationShadow@0.25,
  0.5/0.5, blurRadius 2))` + `Icon(edit 18, homeAccent)`. Guard site.
- **#28** `SettingsSection`: `Container(clip, cardFill, Border.all(profileRowBorder 0.5), r16)` +
  `Divider(profileRowBorder 0.5)` between children. The same in both themes.
- **#50** `_LanguagesSection`: `SettingsSection` + two `SettingsChoiceRow` (keys
  `settings_language_ar` / `settings_language_en`) → `localeProvider.select`. Tests tap these keys.
  `_ModeSection` rows use keys `settings_mode_light` / `settings_mode_dark`, and tests read them as
  `SettingsChoiceRow`. **Keep Mode unchanged.**
- **#30** `_ResendTimerPill`: `Container(height 36, padding h14, cardFill, stadium, outer
  BoxShadow(elevationShadow@0.25, 0.5/0.5, blurRadius 4))`. The doc says the values were measured from
  a screenshot and the shadow borrowed (DESIGN_ISSUES #49). Guard site.
- **#31 / #52** `_InputView`:
  - no card; `Pinput` (6 boxes) with `PinTheme(48×56, BoxDecoration(fieldFill, Border.all(fieldBorder,
    1.17), r16))`;
  - focused 1.5 `cs.primary`, error 1.5 `cs.error` + 6% error fill;
  - forced LTR `Directionality`.
  - `pinput 6.0.2` offers `Pinput.builder(builder: (context, PinItemState state))`, with `state.type`
    and `state.value`.
- **#32** `_TrackCard`:
  - outer `Container(height 112, r25, gradient (light, unselected) / 2px primary border
    (selected))`;
  - inner `Container(color: selected ? cs.primary@0.08 : ext.background, r25 − borderWidth)`;
  - `InkWell`; no shadow;
  - dark fill is opaque `background`;
  - selected state is invented (documented).
  - Goldens: `track_screen_{light,dark}.png`.
- **#54** The illustration is `SvgPicture.asset(art)` with no opacity or blur.
- `edit_profile_screen.dart` "Discard changes?" = `showDialog` + `AlertDialog`.

## 7. Required changes

### 7.1 #21 Profile header

`ProfileHeaderCard` → `ElevatedSurface(shape: RoundedRectangleBorder(r15), height 104, padding h18,
color: ext.profileHeaderFill, shadows: elevation.profileHeaderShadows, glass:
elevation.profileHeaderGlass, backlights:` `[elevation.profileHeaderBacklight]` when non-null`)`.

- The back-light mirrors in RTL, so it stays behind the avatar.
- Remove the raw `BoxShadow` and lower the ratchet by 1.
- Content, avatar and level chip are unchanged.

### 7.2 #22 Edit chip

1. Replace the bare `IconButton` with a 40×40 chip: `ElevatedSurface(shape: CircleBorder(), width 40,
   height 40, color: ext.profileEditChipFill, shadows: elevation.profileEditChipShadows, glass:
   elevation.profileEditChipGlass, onTap: onEdit)`, with the edit glyph centred.
2. Keep `Key('profile_edit_button')` on the tappable, the tooltip/semantics label (`editLabel`), and a
   ≥ 48 dp hit area (pad the gesture region, not the drawn chip).
3. Glyph:
   - size 20, per the Figma vector;
   - colour: dark reads `#FCFBF9`, light was not read. Read the light glyph fill in `166:4416`. If
     readable, add `profileEditChipGlyph` (edit1 style, both themes, citations). If not, keep
     `homeAccent` and record it.
   - The Iconify asset itself stays a `TODO(design-asset)` (ASSET_MANIFEST).

### 7.3 #23 Stat card

1. `ProfileStatCard` → `ElevatedSurface(shape: RoundedRectangleBorder(r16), padding 12, color:
   ext.profileStatFill, shadows: elevation.profileStatShadows)`. Remove the `BoxShadow`; lower the
   ratchet by 1.
2. In `test/core/theme/palette_discipline_test.dart`, delete the `a card on each canvas` group
   (frozen by edit1 for this edit). Replace it with `test/features/profile/profile_stat_card_test.dart`,
   asserting in both themes:
   - the surface resolves `profileStatShadows` (black 25%, blur 2, offset 0.02);
   - light fill `#FCFBF9`, dark opaque `#27282C`;
   - no Glass.
3. Keep the "no arithmetic in this widget" doc.

### 7.4 #24 Menu rows

1. Row → `ElevatedSurface(shape: RoundedRectangleBorder(r16), padding 16.5/14.5, color:
   ext.profileMenuRowFill, side: border == null ? null : BorderSide(border, 0.5), glass:
   elevation.profileMenuRowGlass)`, with border by tone:
   - neutral → `ext.profileMenuRowBorder` (light `#7070A0`, dark none);
   - destructive → `ext.destructive` (both themes);
   - emphasis → a new `profileMenuEmphasisRowBorder` token (light `#101010`, the Figma light emphasis
     stroke; dark `null`, since `337:7433` rows have no stroke), added in the edit1 style with
     citations.

   Keep `InkWell`, disabled `IgnorePointer` + `Opacity 0.45`, semantics and keys.
2. **Icon discs, verify first.** In `166:4416`, check on the Properties panel that each of the rows has
   a 35×35 `#F4E6FF` disc behind its glyph.
   - **If confirmed:** draw the disc on **all** rows with `ElevatedSurface(shape: CircleBorder(),
     35×35, color: ext.profileMenuIconDiscFill, glass: elevation.profileMenuIconDiscGlass)` (glyph
     size 22). Delete `profileIconChip` if it has no remaining references, and update the `_Glyph` /
     `ProfileRowTone` docs (they cite the older `170:4933`).
   - **If not confirmed:** keep discs only on emphasis/destructive rows, switch them to the new
     fill/Glass tokens, and record the discrepancy.
3. Glyph and label colours are unchanged.

### 7.5 #28 Settings sections

1. `SettingsSection` gets an optional `List<Backlight> backlights = const []`. Its card →
   `ElevatedSurface(shape: RoundedRectangleBorder(r16), clipBehavior: Clip.antiAlias, color:
   ext.settingsSectionFill, side:` light `BorderSide(ext.settingsSectionBorder,
   elevation.settingsSectionBorderWidth)` / dark `null`, `glass: elevation.settingsSectionGlass,
   backlights: backlights)`.
2. Dividers are unchanged (not read; recorded).
3. `settings_screen.dart`: the Notification Preferences section passes the track's back-light
   (`notificationPreferencesBacklightSchool` / `…University`) once `meProvider` has data. Before that,
   pass none.
4. The Mode section keeps its card (blocked #51) and gets the new surface. Record that Figma draws no
   card there.

### 7.6 #50 Settings → Languages

1. Replace `_LanguagesSection`'s card and rows with:
   - the section title, styled like `SettingsSection`'s (`AppType.h3`, same padding);
   - then `SegmentedTrack<Locale>(segments: [the two locales in Figma order], selected: current,
     onChanged: (l) => ref.read(localeProvider.notifier).select(l), labelOf: (l) => l.languageCode ==
     'ar' ? l10n.languageArabicName : l10n.languageEnglishName, keyOf: (l) =>
     Key('settings_language_${l.languageCode}'), height 44, style: <pillTrack style>)`.
   - Style values: `trackColor ext.pillTrackFill`, `trackRadius 32`,
     `trackInsetShadows elevation.pillTrackInsetShadows`, `idleSegmentColor transparent`,
     `selectedColor ext.pillTrackSelectedFill`, `selectedRadius 22`,
     `selectedInsetShadows elevation.pillTrackSelectedInsetShadows`.
2. **Read** the segment order and label text colours (selected / idle) in `176:1840` and `337:8177`.
   - Use `pillTrackLabel` / `pillTrackSelectedLabel` if edit3 already added them.
   - Otherwise add them now (edit1 style, citations) if readable.
   - If unreadable, keep `textPrimary` (idle) / `cs.onPrimary` (selected), check ≥ 4.5:1 in both
     themes, and record it.
3. Keep behaviour: tapping the current language does nothing (`select`, not `toggle`); endonyms in
   their own language; keys preserved so `settings_screen_test.dart` still passes.

### 7.7 #30 OTP timer

1. `_ResendTimerPill` → `ElevatedSurface(shape: StadiumBorder(), height **42**, padding h**15**, color:
   ext.otpTimerFill, shadows: elevation.otpTimerInsetShadows)` (both are **inset**). Keep the row
   content: stopwatch 15×19, gap 8, digits, semantics sentence, `gapBelow 20`.
2. Remove the outer `BoxShadow` and lower the ratchet by 1.
3. Rewrite the doc comment: nodes `332:3390` / `332:3391` (light), `337:19503` (dark); height, padding
   and inner shadows read from the panel on 2026-09-16; the previous measured/borrowed values are
   superseded. Update DESIGN_ISSUES #49's table rows for height, inset and shadow.

### 7.8 #31 OTP code card

1. In the layers panel, read `308:5114` (`Type= correct`): its children (digit boxes only, or also
   error text) and its auto-layout padding.
2. Wrap exactly those children in `ElevatedSurface(shape: RoundedRectangleBorder(r19), padding:
   <read>, color: ext.otpCardFill, shadows: elevation.otpCardShadows)`. Light: black 0.2/0.2/4. Dark:
   lavender 0.2/0.2/7.9 glow.
   - The card is opaque, so knockout is not visible, but keep it.
   - If the padding cannot be read, use the card's 354×171 bounds around the build's Pinput row, and
     record it.
3. Keep title/subtitle, error messages, Verify button and resend row placement relative to the card as
   in Figma.

### 7.9 #52 OTP digit boxes

1. Switch to `Pinput.builder(length: 6, controller, focusNode, autofocus, keyboardType, forceErrorState,
   mainAxisAlignment: spaceBetween, onChanged, onCompleted, builder: (context, state) => …)`. Each
   cell is `ElevatedSurface(shape: RoundedRectangleBorder(r16), width 48, height 56, color:
   ext.otpDigitFill, side: BorderSide(color: <state colour>, width: <state width>), glass:
   elevation.otpDigitGlass)` with the digit text (`AppType.h2`, `textPrimary`).
   - Default side: `ext.otpDigitBorder`, `elevation.otpDigitBorderWidth` (light 1.17333, dark 0.5).
   - Focused: `cs.primary` 1.5 (unchanged).
   - Error: `cs.error` 1.5, and fill `cs.error` @6% (unchanged).
2. Keep the forced LTR `Directionality`, 6 boxes, 48×56/r16 geometry (DESIGN_ISSUES #5), and every
   callback.
3. Tests that relied on `PinTheme` decorations must be updated to the new cell surface.

### 7.10 #32 / #54 Track cards

1. `_TrackCard`:
   - wrap the existing structure (gradient border and inner surface) in `ElevatedSurface(shape:
     RoundedRectangleBorder(r25), height 112, shadows: elevation.trackCardShadows, glass: index == 0
     ? elevation.trackCardGlassFirst : elevation.trackCardGlassSecond, onTap: onTap)`;
   - inner fill → `selected ? cs.primary@0.08 : ext.trackCardFill` (dark now 20%, not opaque
     `background`).

   Map index to track by reading `337:15947`'s card labels (§5 #32). Keep the invented selected border,
   the radio, the art slot and semantics.
2. **#54:** open `125:862` / `337:15981` and inspect `189984493_…`.
   - **If it is a blurred copy behind the art** (a glow), add `lib/core/widgets/elevation/layer_blur.dart`
     (a small `LayerBlur(sigma, opacity, child)` using `ImageFiltered(ImageFilter.blur)`, allowed in
     that folder), and render a copy of the SVG at 53% opacity, σ 3.7, behind the art.
   - **If it is the art itself** (the visible illustration is blurred at 53%), apply the same to the
     art.
   - **If unclear**, change nothing and record it.

### 7.11a CTA consumer step (#12): wrap the account/auth CTAs

The design item is #12 (edit2), and the primitive is edit1's `PrimaryCta`.

Wrap these `FilledButton`s as `PrimaryCta(tone: CtaTone.primary, enabled: <onPressed != null>,
child: …)`:

- `otp_screen.dart` "Verify" and success "Continue";
- `edit_profile_screen.dart` "Save".

Figma: light (0.5, 0.5) blur 4 black 25%; dark the same plus the `#AE87E7` glow layer (layer blur 8).
Nodes: OTP dark `Frame 427319502` / `427319511`; Edit Profile Save `348:8911` / glow `348:8909`.
Retry buttons (`edit_profile_screen.dart` error state, `profile_screen.dart`) stay unwrapped. Test:
Verify is disabled (dimmed treatment) until 6 digits are entered.

### 7.11 Consumer step (edit2 #27): "Discard changes?"

If `showAppDialog` exists: in `edit_profile_screen.dart`, replace that `showDialog` with
`showAppDialog(context: context, scrim: elevation.logoutDialogScrim, builder: …)`. Keep the
`AlertDialog`. There is no Figma frame; it takes the app dialog scrim (edit2 §13). If `showAppDialog`
does not exist, skip this step and record it.

### 7.12 #25 Avatar badge

`_AvatarEditor` badge → `ElevatedSurface(shape: CircleBorder(), 34×34, color: ext.avatarBadgeFill,
shadows: elevation.avatarBadgeShadows, glass: elevation.avatarBadgeGlass)` with the same icon. Remove
the `BoxShadow` and lower the ratchet by 1.

### 7.13 Records, guard and cleanup

- **DESIGN_ISSUES:**
  - #45: append the swatch spec (#51);
  - #28: append the badge shadow facts (#53), no change;
  - #49: update (§7.7);
  - #72: profile/settings back-light outcome, discs verification, track art layer (#54) outcome, any
    unread glyph/label colours.
- **Guard:** lower the ratchet to the real count (−4 expected: header, stat, timer, badge).
- **`elevationShadow`:** if it has no remaining references in `lib/`, delete it (field, both values,
  `copyWith`, `lerp`) and its `palette_discipline_test.dart` group. If the ratchet reaches **0**,
  convert the test to zero-enforcement that lists offending `file:line` (edit1 §7.6).

## 8. Architecture / tokens used

- **AppColors:**
  - Profile: `profileHeaderFill`, `profileEditChipFill`, `profileStatFill`, `profileMenuRowFill`,
    `profileMenuRowBorder`, `destructive`, `profileMenuIconDiscFill`, `avatarBadgeFill`.
  - Settings: `settingsSectionFill`, `settingsSectionBorder`, `pillTrackFill`,
    `pillTrackSelectedFill`.
  - OTP and track cards: `otpTimerFill`, `otpCardFill`, `otpDigitFill`, `otpDigitBorder`,
    `trackCardFill`, `textPrimary`.
  - Added with citations: `profileMenuEmphasisRowBorder`; conditionally `profileEditChipGlyph`,
    `pillTrackLabel`, `pillTrackSelectedLabel`.
- **AppElevation:**
  - Profile: `profileHeaderShadows`, `profileHeaderGlass`, `profileHeaderBacklight`,
    `profileEditChipShadows`, `profileEditChipGlass`, `profileStatShadows`, `profileMenuRowGlass`,
    `profileMenuIconDiscGlass`, `avatarBadgeShadows`, `avatarBadgeGlass`.
  - Settings: `settingsSectionBorderWidth`, `settingsSectionGlass`,
    `notificationPreferencesBacklightSchool`, `notificationPreferencesBacklightUniversity`,
    `pillTrackInsetShadows`, `pillTrackSelectedInsetShadows`.
  - OTP and track cards: `otpTimerInsetShadows`, `otpCardShadows`, `otpDigitGlass`,
    `otpDigitBorderWidth`, `trackCardShadows`, `trackCardGlassFirst`, `trackCardGlassSecond`.
  - Dialog: `logoutDialogScrim` (conditional).
- **Primitives:** `ElevatedSurface`, `SegmentedTrack`, `PrimaryCta` / `CtaTone` (edit1), optional
  new `layer_blur.dart`, `showAppDialog` (edit2, conditional).
- **Deletions:** conditional `profileIconChip`; conditional `elevationShadow`.

## 9. Files expected to change

- `lib/features/profile/widgets/profile_header_card.dart`, `profile_stat_card.dart`,
  `profile_menu_row.dart`
- `lib/features/profile/screens/edit_profile_screen.dart` (badge + optional dialog)
- `lib/features/settings/widgets/settings_section.dart`, `lib/features/settings/screens/settings_screen.dart`
- `lib/features/auth/screens/otp_screen.dart`
- `lib/features/registration/screens/signup_track_screen.dart` (`_TrackCard` only)
- `lib/core/theme/app_colors.dart` / `app_elevation.dart` (cited additions / conditional deletions)
- `lib/core/widgets/elevation/layer_blur.dart` (conditional, #54)
- `test/core/theme/palette_discipline_test.dart`, `test/guards/project_rules_test.dart`
- Tests:
  - new `test/features/profile/profile_stat_card_test.dart`;
  - `test/features/profile/profile_screen_test.dart`, `test/features/settings/settings_screen_test.dart`,
    `test/features/settings/shell_screens_test.dart`, `test/features/auth/otp_screen_test.dart`;
  - registration tests; goldens `track_screen_{light,dark}.png`
- `docs/DESIGN_ISSUES.md`

## 10. Do not change

- Riverpod notifiers/providers, `PATCH /me` behaviour, the Settings toggles' server-authoritative logic
  (DESIGN_ISSUES #46/#48), locale/theme providers.
- Mode rows (#51 blocked), Save-button absence (#48), Settings routing outside the shell.
- The OTP 6-box count and forced LTR, OTP state logic, the success badge (#53 blocked).
- `CircleBackButton`, `LanguagePill`, `FieldShell`, dialogs/sheets and their scrims (edit2); the
  back-chip call in `signup_track_screen.dart` (edit2).
- Foreign uncommitted hunks (`profile_screen.dart`).

## 11. Verification plan

1. `dart format --output=none --set-exit-if-changed lib test` and `flutter analyze`, both clean.
2. Tests:
   - `profile_stat_card_test.dart` (new, §7.3).
   - `profile_screen_test.dart`:
     - the edit chip still routes via `Key('profile_edit_button')`, tooltip present, 48 dp hit area;
     - disabled rows still inert with stable keys;
     - discs per §7.4 outcome;
     - header back-light only in dark.
   - `settings_screen_test.dart`:
     - `settings_language_ar/en` keys exist and tapping switches the locale;
     - tapping the current language does nothing;
     - `settings_mode_*` rows unchanged;
     - segmented semantics (`selected`, mutually exclusive);
     - RTL order;
     - no overflow at text scale 1.3.
   - `otp_screen_test.dart`:
     - 6 cells, LTR even in AR;
     - error state red 1.5 border + tint;
     - focused border;
     - the timer pill is 42 tall with inset shadows (token);
     - the card surface is present;
     - the resend flow unchanged.
   - Edit Profile: badge surface; Discard dialog still returns the right value (if migrated).
   - Registration: track selection still works; dark cards have no border and have Glass.
3. Goldens (Windows): regenerate `track_screen_{light,dark}.png` after review. Coordinate with edit2,
   which also changes that golden; whichever lands last regenerates. Consider new goldens for the
   profile header (dark), settings language track (dark), and the OTP card (dark).
4. `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` → OVERALL: PASS, count ≥ baseline.
   `tool\verify_guards.ps1` still green (update the ratchet probe expectations if the test was converted
   to zero-enforcement).
5. Device: mock backend. OTP (enter wrong code, wait for the timer), sign-up track picker, Profile →
   Edit Profile → Settings. Light and dark, EN and AR.

## 12. Visual QA checklist (compare with Figma nodes at 100%)

- [ ] Profile header light: 0.5/0.5/4 shadow (`169:4609`). Dark: 20% Glass card, black edge shadow
      outside only, lavender haze behind the avatar (`337:7455`); in AR the haze is behind the avatar
      on the right.
- [ ] Edit chip: 40 dp disc, light cream with a hairline-soft shadow; dark 20% Glass disc with a
      shadow (`337:7466`).
- [ ] Stat cards light: blur-2 edge. Dark: **opaque** `#27282C` with a black edge (`661:8579`).
- [ ] Menu rows light: 0.5 purple-grey hairline, emphasis `#101010`, Logout red. Dark: no hairline
      (except Logout red), Glass rims; discs per verification (`337:7479`, `337:7480`).
- [ ] Avatar badge: tiny 1.105 shadow (much tighter than before), dark 20% cream Glass disc
      (`337:7925`).
- [ ] Settings sections light: lavender `#AE87E7` hairline (not grey). Dark: borderless Glass;
      Notification Preferences shows a lavender haze at its top-start edge (`337:8195`).
- [ ] Settings → Languages: segmented track. Light flat grey/lavender; dark recessed track with the
      pressed lavender segment (`337:8177`).
- [ ] OTP timer: 42 tall stadium with an inner top bevel; dark faint grey inner edge (`332:3391`,
      `337:19503`). No outer shadow.
- [ ] OTP card: light soft shadow (`308:5114`); dark lavender glow around the card (`337:19501`).
- [ ] OTP digits dark: 20% cells with a 0.5 grey hairline and Glass rim (`I337:19295;337:19276`);
      light unchanged fill with a 1.17 grey border.
- [ ] Track cards light: gradient border + soft shadow (`125:862`). Dark: borderless 20% Glass; the
      first card's rim angle differs (25°) (`337:15981`).
- [ ] OTP Verify / success Continue and Edit Profile Save: light tight black shadow; dark black
      shadow + lavender glow (`348:8911` / `348:8909`); Verify dimmed until 6 digits are entered.
- [ ] RTL and text scale 1.3: no overflow in the language track, menu rows or the OTP row.
- [ ] Regression: Profile loading/error/offline, Settings toggles still `PATCH /me`, OTP resend and
      success, registration flow.

## 13. Known risks / assumptions

- **BLOCKED:** #51 Mode swatches (#45) and #53 success badge shadow (#28).
- **Verify-first items:** menu icon discs on all rows (#24); track art blur layer (#54); OTP card
  children and padding (#31); track card index → track mapping (#32).
- **Unread colours:** light edit-chip glyph, language segment labels. Read or keep-and-record, never
  guess.
- **Back-light RTL mirroring** is an assumption (edit1 R9).
- **`Pinput.builder`** changes how cells are built. Keep every input behaviour (paste, autofill,
  error) covered by the existing tests.
- **Concurrent work** in `profile_screen.dart`; edit2 also touches `signup_track_screen.dart` and the
  track golden.

## 14. Completion criteria

- [ ] #21, #22, #23, #24, #25, #28, #50, #30, #31, #52, #32 implemented per §7 in both themes with
      edit1 primitives. #54 implemented or recorded. #51, #53 recorded.
- [ ] Owner decision honoured: Settings → Languages is a `SegmentedTrack` with the preserved keys.
- [ ] No raw shadow left in these files. Ratchet lowered by 4 (converted to zero-enforcement if it
      reaches 0). `palette_discipline_test` group for `ProfileStatCard` replaced. `elevationShadow`
      deleted if unused.
- [ ] Tests and goldens updated after visual review. `validate.ps1` OVERALL: PASS. Count not lower.
- [ ] DESIGN_ISSUES updated (#28, #45, #49, #72 notes).
