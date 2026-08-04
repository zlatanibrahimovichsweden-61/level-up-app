# Day 7b — execution prompt for Claude Code

> Paste the fenced block below into Claude Code, in the `level_up_app` repo, on branch `dev`.
> Kept as a file on purpose: durable truth lives in files, not chat memory.
>
> **State at handoff (2026-08-03):** Day 7 is built and committed. Day 7b is fully specified in
> `docs/day7b_design_fixes_brief.md` and not started. Nine assets are already committed
> (`assets/icons/nav/*`, `language.svg`, `chevron.svg`, `notification.svg`,
> `assets/images/track_school.svg`, `track_university.svg`) and `pubspec.yaml` already declares
> `assets/icons/nav/`. Findings are `DESIGN_ISSUES.md` #36–#43.
>
> **Why this prompt is phased differently from Day 7:** Day 7b builds nothing new — it corrects four
> already-shipping surfaces. The risk is not "wrong architecture", it is **silent scope creep**:
> touching a screen, noticing something else, and inventing a state the design never drew. So the
> phases are one-per-surface with a hard commit boundary between them, and the palette work lands
> before anything that a golden would capture.
>
> **The measured values are already in the brief.** Do not re-pull a frame to find a number the
> brief gives you — the owner is on a Figma Education plan with a hard MCP call limit that was hit
> during the spec pass.

---

```
# ROLE

You are implementing Day 7b of the Level Up Flutter app: a design-fidelity pass over
four surfaces already built in Days 00–7 — the bottom nav bar, the language pill, the
Sign Up_2 track picker, and Home. No new features, no new endpoints, no new packages,
no logic changes.

# SOURCE OF TRUTH — in precedence order

1. docs/day7b_design_fixes_brief.md — this day's spec. Its "Assumptions this brief is
   built on" section (8 items) is ALREADY settled with the owner. Follow it; do not
   relitigate it.
2. contract/openapi.yaml (pinned 23f0535) — where design and contract disagree, the
   contract wins.
3. The Figma frames — the brief carries a measured light+dark colour matrix and the
   node ids. Pull a frame ONLY if the brief does not already give you the number.
   The Figma MCP has a hard call limit on this plan; budget it.
4. Existing repo patterns — match the surrounding code.

If two of these contradict in a way the brief has not settled, STOP and ask.

# EXECUTION ORDER

Work the phases in sequence. Do not start a phase until the previous one's exit
criteria are met. Invoke each skill at the phase where it is listed, not all upfront.
One commit per phase, 1 through 5. Do not push.

## Phase 0 — Ground yourself
  Skill: `level-up-domain`
  - Read docs/day7b_design_fixes_brief.md end to end, including the colour matrix.
  - Read DESIGN_ISSUES.md #36–#43 — they are the same findings with the "why".
  - Read what you are about to change, before changing it:
      lib/features/shell/main_shell.dart
      lib/core/widgets/language_pill.dart  + login_screen.dart:139,310-342
      lib/features/registration/screens/signup_track_screen.dart
      lib/features/home/widgets/home_header.dart, level_card.dart
      lib/core/theme/app_colors.dart
  Exit: you can state, without looking, (a) which two surfaces have a border in light
  and none in dark, and (b) why Home does not use cs.primary.

## Phase 1 — Bottom nav bar   → commit, closes #36 #37 #38
  Skills: `build-screen`, `flutter-fix-layout-issues`
  Brief section A. Three changes in one widget:
    A1  five exported SVGs replace Icons.*; ONE glyph per tab, tinted by state.
        Do NOT force 24x24 — Home is 18x18.75 and Message 20x17.95.
    A2  the bar becomes the Union path: notch r=32 at (187,32), 15px rise, radius 30,
        96 high, drop shadow, NO top border. CustomClipper/CustomPainter. Scale x by
        width/375; keep y fixed.
    A3  the centre tab's CIRCLE FILL carries selection, not the glyph colour.
        idle #F3F1F8 light / #3E3E3E dark, glyph #B3B3B3
        selected #4B675E light / #AE87E7 dark, glyph white
        Delete the 0.5px border the frame does not have.
  New token pair: navCentreIdleFill.
  Exit: all 5 states render in light + dark; flutter analyze clean.

## Phase 2 — Language pill   → commit, closes #39
  Skill: `build-screen`
  Brief section B. THE WORDING DOES NOT CHANGE — "English" / "العربية" stay, no ARB
  edit, no semantic change. Only:
    B1  assets/icons/language.svg (STROKE, not fill) replaces Icons.language, size 20.13
    B2  radius 18.05 (full stadium), padding 14.47, icon→label gap 10.07,
        border #4B675E in light and NONE in dark, content #384F47 / #FCFBF9
    B3  delete the duplicate _LanguagePill in login_screen.dart:310-342 and point
        line 139 at the shared widget
  Exit: all six call sites compile — login, otp, onboarding, signup_identity,
  signup_track, registration_chrome.

## Phase 3 — Track picker   → commit, closes #40
  Skills: `build-screen`, `screen-states`
  Brief section C. The screen is implemented and CORRECTLY ROUTED — do not move it.
    C1  the two committed illustrations replace the 32px Material icons; label at
        x=107. Render with plain SvgPicture.asset, NO colorFilter — these are
        full-colour art. Check track_school.svg's blur filter on device first
        (flutter_svg cannot render SVG filters); if the shadow renders hard, delete
        that one <g> from the asset.
    C2  radius 25, fill #FCFBF9 / #232428, 1px GRADIENT border #384F47 → #95CDBB in
        light and NONE in dark, radio = r9.5 ring
    C3  circular back chip 35x35 + chevron.svg (points right — mirror it), built once
        as core/widgets/circle_back_button.dart
    C4  side inset 20, not 24
  Exit: the whole registration flow still walks OTP → identity → track →
  school/university on device.

## Phase 4 — Home   → commit, closes #41 #42 #43
  Skills: `build-screen`, `river`
  Brief section D. D1 FIRST — the palette change is what Phase 5 photographs.
    D1  light Home goes purple: progress fill #AE87E7, track #ECECEC, cardLabel
        #7070A0, value #393939, divider #AE87E7. Add an explicit Home/level accent
        token — do NOT just swap cs.primary for Brand.purplePrimary at the call site.
        The dark palette is already correct; change nothing there.
        Then re-read every remaining "(no light … frame)" comment in app_colors.dart
        and REPORT what you find. Change nothing outside Home in this commit.
    D2  bell becomes a chip: 36.5 ring (fill #FCFBF9/#232428, stroke #4B675E 0.5px),
        notification.svg glyph (#4B675E / #FCFBF9), unread dot r=3 at (23.5,11.5),
        #E67E22 in light and #AE87E7 in dark. THE DOT IS GATED — see NON-NEGOTIABLES.
    D3  the level medallion: NO CODE THIS DAY. Keep Icons.emoji_events and its
        TODO(design-asset). Read D3 in the brief for why.
  Exit: light and dark Home both purple-accented; the dot does not render.

## Phase 5 — Tests   → commit
  Skills: `flutter-add-widget-test`, `dart-run-static-analysis`
  Goldens with Flutter's built-in matchesGoldenFile. NO new package. Load the bundled
  fonts from assets/fonts/ in the harness or the goldens are worthless for spacing.
  Goldens, in BOTH canvases:
    - nav bar x 5 selected states
    - track card, unselected
    - level card
    - language pill
    - Home header bell
  Widget tests for the two behavioural claims a golden cannot explain:
    1. the unread dot does not render while the unread flag is false
    2. selecting the centre nav tab changes the CIRCLE FILL, not the glyph colour
  Exit: flutter analyze clean; the existing 45 tests still green; new tests green.

## Phase 6 — Docs, then report
  - DESIGN_ISSUES.md #36–#43 → RESOLVED, except #43 (blocked) and the parts the brief
    explicitly leaves open.
  - PROGRESS.md: add a Day 7b section. Do NOT touch its stale Day-2/Day-3 headers —
    that re-grounding is its own task.
  - Report in the format at the bottom of this prompt.

# NON-NEGOTIABLES

1. DO NOT INVENT A STATE THE DESIGN DOES NOT DRAW. Two are missing: the track card's
   selected state and the nav's pressed state. Code already invented the first
   (cs.primary @ 8% + 2px). LEAVE IT AS IT IS and flag it. Replacing one guess with a
   different guess is worse than leaving it.
2. The bell's unread dot is GATED behind a flag that currently resolves false, marked
   TODO(contract). There is no notifications endpoint in the contract. Do not render it
   always-on to match the frame.
3. Home does NOT use cs.primary. Its accent is #AE87E7 in BOTH canvases. The
   green/purple flip does not apply there. The nav bar DOES flip.
4. Borders are light-only on the language pill and the track card. Make the border
   nullable per canvas; do not draw one in dark.
5. Every icon SVG is currentColor and tinted with colorFilter. The two track
   illustrations are the ONLY assets rendered without one.
6. Do not force icon SVGs to a square box. Three of the eight are not square.
7. No hex at a call site. Every new colour becomes an AppColors token in BOTH palettes.
8. No logic changes. Routing, quiz, catalog and registration behaviour stay identical.
   The orphan /track-select route at app_router.dart:121 STAYS — out of scope.
9. No new packages. flutter_svg is already a dependency.
10. One commit per phase. Do not push.

# DO NOT BUILD

  - the level medallion (no asset set, no server source — D3)
  - any change to switchLanguage or the .arb files (assumption 3)
  - a dark value that is not in the brief's matrix — if one is genuinely missing, add
    the token with a TODO(design) and the current fallback, and say so
  - golden infrastructure that needs a package

# SELF-VERIFICATION — run these before reporting

  grep -rnE "0xFF|Color\(0x" lib/features/shell/ lib/features/home/ \
      lib/features/registration/screens/signup_track_screen.dart \
      lib/core/widgets/language_pill.dart          → empty (tokens only)
  grep -rn "Icons\." lib/features/shell/main_shell.dart      → empty
  grep -rn "_LanguagePill" lib/                              → empty
  grep -rn "TODO(design-asset)" lib/    → only level_card.dart and home_banner.dart
                                           and catalog_scaffold.dart remain
  grep -rn "cs.primary" lib/features/home/                   → empty
  grep -rn "left:\|right:" lib/features/shell/ lib/features/home/  → empty
                                                     (EdgeInsetsDirectional only)
  grep -rn "colorFilter" lib/  → present on every icon SVG, absent on the two
                                  track illustrations
Confirm assets/icons/nav/ is still listed in pubspec.yaml (asset dirs are not
recursive — this line is easy to lose in a merge).

# FINAL REPORT FORMAT

  - one line: analyze status, test count (and delta), goldens generated, commit count
  - a table: each of #36–#43, ✅ resolved / ⏸ blocked / ❌, with one line of evidence
  - "What D1 turned up" — every remaining "(no light … frame)" comment in
    app_colors.dart, and whether the frame now contradicts it. Do not fix them; list
    them.
  - "Deviations you should know about" — anything done differently from the brief and
    WHY. A deviation with a good reason is fine; a silent one is not.
  - "Also worth flagging" — out of scope but matters.

# STOP CONDITIONS

Stop and ask, rather than guessing, if:
  - a frame shows a state the brief has not specced
  - track_school.svg's blur filter cannot be resolved by deleting the filtered group
  - the golden harness cannot load the bundled fonts without a package
  - D1 turns up a "(no light frame)" token OUTSIDE Home that the frames contradict
  - any measured value in the brief disagrees with what you see in the file
  - a fix would require changing routing, state management, or an .arb file
```
