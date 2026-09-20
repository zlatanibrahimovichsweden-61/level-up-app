# Prompt for the Edit 4 session

> Copy everything inside the fence below into a **fresh** Claude Code session opened at
> `F:\level\level_up\level_up_app`. Written 2026-09-20, after edit1, edit2 and edit3 landed and
> were pushed.
>
> Nothing outside the fence is part of the prompt.

---

```text
Implement `edit4.md` — the Quiz flow & Leaderboard wave of the elevation work.

## Where the project is

Branch `merged`, working directory F:\level\level_up\level_up_app.

**The tree is CLEAN and pushed.** HEAD is `4215e1c`, level with `origin/merged`. This is a change
from the previous waves: you are not inheriting a dirty tree, and `edit4.md` §0.3 and §13 both tell
you that the quiz-review and leaderboard files are "uncommitted/untracked — coordinate first".
**That is no longer true** — they landed in `f987f20`. Verify with `git status --short` (expect
empty) rather than taking either of us on trust.

**edit1, edit2 and edit3 are all implemented and committed.**

- **edit1** — the foundation: `AppElevation` tokens, `GlassStyle` / `Backlight` / `FigmaShadow` /
  `ScrimStyle`, and the primitives in `lib/core/widgets/elevation/`: `ElevatedSurface`,
  `PrimaryCta`, `SegmentedTrack`, `paintFigmaShadows`, `paintGlassRim`, `app_modal.dart`. Consume
  those. Never add a second glass, shadow or scrim implementation.
- **edit2** — shared chrome. This resolves one of your own conditionals: `showAppDialog` **exists**
  (`lib/core/widgets/elevation/app_modal.dart:46`), so `edit4.md` §7.10's "Leave quiz?" dialog step
  is **mandatory, not optional**, and §14's "migrated if edit2 landed, otherwise noted" has only
  one branch left.
- **edit3** — Home / Learn / Mistakes. It matters to you for one reason, below.

## `edit4.md` was written 2026-09-17 and is stale in eight specific places

The guide is otherwise sound and self-contained — every factual claim its §6 makes about the quiz
and leaderboard code still verifies. Do not re-derive it. But these eight have moved underneath it,
and one of them is load-bearing:

1. **§3 "Independent of: edit3" is WRONG, and it is the important one.** Your item #19 migrates the
   Leaderboard scope toggle onto `SegmentedTrack` — and edit3 rewrote that primitive on 2026-09-19.
   See "The scope-toggle migration" below before you touch §7.8.
2. **§0.3 and §13** — "uncommitted / untracked / coordinate first" is answered. Tree is clean.
3. **§0.2** — "if edit1 is missing, implement it first". It is not missing.
4. **§7.10 / §14** — the `showAppDialog` conditional is resolved (see above).
5. **§7.12 ratchet** — "−3 expected" is still the right DELTA, but the absolute moved: the baseline
   was 9 when that line was written and is now **7** (`test/guards/project_rules_test.dart:229`).
   **You land on 4, not 6.** Your three sites are `ai_explanation_panel.dart:134` (`BoxShadow`) and
   `quiz_review_screen.dart:249` + `:250` (`elevation:` / `shadowColor:`). Lower it in the SAME
   change that removes them, and **rewrite the comment block above it** — edit3 left a dated entry
   enumerating the survivors, and a bare decrement would leave that list lying.
6. **§7.7's `elevationShadow` deletion can never fire.** It says to delete the token "if it has no
   remaining references afterwards". Four remain after you, all edit5's: `otp_screen.dart:390`,
   `edit_profile_screen.dart:563`, `profile_header_card.dart:45`, `profile_stat_card.dart:36`.
   Expect it to survive; do not delete it or flip its dark value on its own.
7. **§11.3 "none of the existing golden files cover these widgets"** — half wrong now.
   `test/goldens/quiz_type_tabs_dark.png` is a live baseline **for the `SegmentedTrack` primitive**
   (driven by `edit3_surfaces_golden_test.dart`, 402×80 surface). You cannot touch that primitive
   without moving an edit3 golden.
8. **§11.2 "the dark-theme row assertions from #53 still pass"** — this contradicts D-010. #53 was
   RESOLVED 2026-09-17 and those assertions
   (`test/features/quiz/quiz_review_screen_test.dart:200-231`) encode the SUPERSEDED ruling. D-010
   and DESIGN_ISSUES #53 win over §11 here: **rewrite them, do not delete them quietly.**

## Documents that will actively mislead you

Read them — they are in the required order — but know where they lie:

- **`CLAUDE.md`** says the contract pin is `184d6ec` / 3.0.0-m1 and cites 849 tests. Both stale.
  `contract/SOURCE.md` is the truth: **`2dca3c5`, `info.version` 3.13.0-m1, 29 stable / 13 draft /
  42 operations.** Verify it yourself.
- **`docs/WAVE_STATUS.md`** is billed by `CLAUDE.md` as the single source of project truth that
  "wins over every other document". It says **Last updated: 2026-09-12** with a validate count of
  **943**, and contains **zero** mentions of elevation, Glass, `ElevatedSurface` or edit1–5. Three
  waves and ~234 tests have landed since. Do not conclude something regressed. Do not update it
  either — it is not in your scope; say so in your summary.
- **`test/goldens/golden_harness.dart`**'s own doc comment shows
  `flutter test --update-goldens test/goldens` — the directory-wide form, which **rewrites every
  golden in the repo**. Do not copy it. Always name one file:
  `flutter test --tags golden --update-goldens test/goldens/<one>_test.dart`.
- **`lib/core/router/app_router.dart:152-158`** says the leaderboard is gated because the endpoint
  is "draft AT OUR PIN … until contract/ is re-vendored and the board is audited". The re-vendor
  happened; the audit did not. The gate stands. Do not read that comment as a condition you may
  now act on.
- **Item numbers collide.** `edit4.md`'s item numbers come from the 55-item elevation register, NOT
  from `docs/DESIGN_ISSUES.md`, and they overlap almost everywhere — elevation #47 is the question
  card, DESIGN_ISSUES #47 is the withdrawn cream-shadow derivation; elevation #19 is the scope
  toggle, DESIGN_ISSUES #19 is Arabic digits. Always write "DESIGN_ISSUES #n" when you mean that
  register.

## Read before you change anything

1. `CLAUDE.md` (repo root) — the five rules, minus the stale lines above.
2. `docs/RISKS.md`, `docs/AGENT_WORKFLOW.md` § "Theme discipline" and § "Never invent".
3. `edit1.md` §4 — design rules R1–R10. They apply to your work verbatim.
4. `.claude/skills/bloc/SKILL.md` — the quiz is the Bloc feature. You restyle it; you do not touch
   its state logic.
5. `edit4.md` — **in full**, with the eight corrections above applied as you read.
6. `docs/DECISIONS.md` — D-006, D-008, D-009, D-010, D-011, D-012 (see the fence below).
7. `docs/DESIGN_ISSUES.md` — #29, #52, #53, #54, #55, #56, #57, #58, #72, #74, #76, #77, #81.
8. `contract/SOURCE.md`, and `docs/seif_fight.md` S15 and S17.

Then, before your first edit:

- `git status --short` — expect empty.
- `powershell -ExecutionPolicy Bypass -File tool\validate.ps1`. The last recorded run is
  **OVERALL: PASS, 1177 passed / 0 failed / 1 skipped**, guards 8/8, ratchet 7 — but that record
  was taken at `f987f20` with a dirty tree, two commits ago. **Re-run it and use the number you
  actually get as your floor.** One test is skipped on purpose (the leaderboard route test, D-008);
  it should stay skipped.

## Your scope — `edit4.md` §1, and nothing else

Items 11, 14, 15, 16, 17, 19, 20, 46, 47, 48; #45 and #49 are **record only**; plus the two
consumer steps §7.10a (wrap five CTAs in `PrimaryCta`) and §7.10 (the dialog, now mandatory).

**Not yours:** the `PrimaryCta` primitive itself (edit1); the limit sheet and back chips (edit2);
the Lectures quiz-type tabs (edit3, landed); profile and settings (edit5). And per §10: quiz Bloc
state/events, the repository, grading and points behaviour, semantic correct/wrong HUES, the
insides of the wrapped `FilledButton`s, and `LeaderboardScreen` routing/gating.

### The scope-toggle migration (#19) — read this before §7.8

edit3 rewrote `SegmentedTrack` under owner ruling **D-012** (`DESIGN_ISSUES` #81). Four things you
must know, and none of them are in `edit4.md`:

- **There is no `FittedBox` and no `overflow: ellipsis`.** Labels render at full size and the groove
  SCROLLS when they do not fit. Today's hand-rolled `ScopeToggle` ends its label with
  `overflow: TextOverflow.ellipsis` (`scope_toggle.dart:101`) — migrating silently swaps truncation
  for scrolling. **Re-adding a `FittedBox`, an `ellipsis`, or a fixed-width wrapper to get back to
  the frame's 362 dp is exactly the defect D-012 removed**, and three tests in
  `test/core/widgets/elevation/segmented_track_test.dart` will fail.
- **`SegmentedTrackStyle.segmentPadding` is new and defaults to 10** — a Figma reading off the
  QUIZ TAB's frames (`180:5338` / `180:5340`), not a neutral default. §7.8's style list does not set
  it, so the leaderboard would silently inherit another screen's frame. Read the scope toggle's own
  padding off `158:839` / `158:840`, or set it explicitly and record that you borrowed it.
- **§7.8 asks for `idleLabelColor: ext.textSecondary`.** That is precisely the mistake DESIGN_ISSUES
  #77 caught on the sibling control five days ago — the chips drew grey `textSecondary` where Figma
  reads `#384F47`, a dark green. §5's #19 table has no idle-label node at all. **Read it or record
  it as unread.** (Contrast is fine either way; fidelity is the risk.)
- **`_Segment` declares `onTap` on the `Semantics` node AND on the inner `GestureDetector`.** That
  duplication is deliberate — excluding the subtree took the tap ACTION with it. Do not "simplify"
  it. It also adds `inMutuallyExclusiveGroup`, which the hand-rolled toggle lacks, so your
  leaderboard semantics assertions need re-checking rather than assuming.

Two measurements handed to you, both to be re-verified rather than trusted:

- **The selected scope label fails contrast worse than the one the owner accepted.**
  `podiumOnAccent` `#FCFBF9` on `scopeSelectedFill` measures **1.75:1 light** (`#D8B0FF`) and
  **2.02:1 dark** (`#C4A8E3`). #77's ruling accepted **2.74:1** and was explicitly scoped to
  "`#FCFBF9` on `#AE87E7` … the same pair is on every filled CTA". **This is a different pair, so
  #77 does not pre-cover it.** Measure it yourself, record it in #77 as a new finding, and **do not
  pick a colour.**
- **`AppType.h3` (18 px) is 50% larger than the label the primitive was tuned on.** A build-level
  probe at 375 dp suggests the ENGLISH pair `System | Governorate` overflows and scrolls while the
  Arabic fits — the inverse of #81's finding. The test binding's font is ~1.5× wider than Inter, so
  a device is kinder; treat this as a reason to measure before adding a golden, not as a fact.

### Item #48 is the one place the guide gives an outcome and no instructions

§1, §5, §12 and §14 all tell you to build it, and there is **no §7 step and no `AppElevation`
token** — `grep reviewRow lib/core/theme/app_elevation.dart` returns nothing. You will have to
author the row tokens yourself in edit1's style (G5 per DESIGN_ISSUES #72, node `337:6731`, dated
citation) and decide the alpha under D-010's "consistency beats the literal 20%" clause.

**And it breaks DESIGN_ISSUES #54**, which `edit4.md` never mentions: #54's whole table was derived
on the premise that the dark correct row is OPAQUE `#BFFFC3`. The moment option (c) lands that is
false, and two live assertions stop describing reality. Re-measure, keep both rows legible, record
it in #54. If the arithmetic will not work with approved dark values, **that is an escalation, not
an invention.**

## Rules that will fail the build if you break them

- **No colour literal outside `lib/core/theme/`.** The palette guard scans every line under `lib/`,
  comments included, for `0xFF`, `Color(0x`, `Colors.black`, `Colors.white`. A new colour means a
  new `AppColors` token with BOTH canvas values and a Figma node citation.
- **No shadow / blur / backdrop primitive outside `lib/core/theme/` and
  `lib/core/widgets/elevation/`.** Ratchet 7 → 4, in the same change.
- **No new inline `fontSize:` AND no inline `fontWeight:`** — the ratchet is 0 and
  `.copyWith(fontWeight: …)` is not an escape hatch. This bites §7.8 directly: `AppType.h3` carries
  w600 against Figma's 500, recorded as a divergence. Use a differently-named `AppType` style or
  leave the divergence; do not `copyWith`.
- **All user-facing copy through `AppLocalizations`**, both ARB files.
- Bloc only in `lib/features/quiz/`; everything else Riverpod. No provider mutation in `initState`.
- Never log personal data or tokens. Do not edit anything under `contract/`.
- `flutter test --tags golden --update-goldens` with **no file argument rewrites every golden in
  the repo.** Always pass the specific test file, and diff what moved.

## Settled rulings — do not "helpfully" undo these

Each is a place where the obvious-looking correction is wrong:

- **D-011 — the Glass rim ships at 0.55 against a measured 0.79** (70%), deliberate visual
  compensation for the depth/refraction shading tier 1 does not render. You are adding four new dark
  Glass surfaces and the rim will look dimmer than #72's table says Figma's is. Do not "fix"
  `kGlassRimMaxAlpha`, and do not dim a surface by bending the geometry instead.
  `glass_rim_calibration_test.dart` asserts the 70% ratio and the scaled profile, so both routes
  fail.
- **D-012 — `SegmentedTrack` never shrinks a label.** See above.
- **D-010 / DESIGN_ISSUES #53 — the dark review rows take option (c).** Do not re-open the three
  options, do not re-colour the quiz page's graded tiles "for consistency" (that is a NEW designer
  question if they visibly disagree), and do not delete the assertions that stop being true.
- **D-009 — dark drop shadows are the MEASURED BLACK.** DESIGN_ISSUES #47's cream derivation is
  withdrawn, but the AI panel's own doc comment still encodes the withdrawn premise. Blur converts
  as **σ = B/2**, never tunable.
- **D-006 / DESIGN_ISSUES #50 — the result screen renders no level, no points total, no meter** —
  even though frame `159:2252` draws a Level Progress meter inside the very card item #16 rebuilds.
  "The frame has it" is the whole failure mode here.
- **DESIGN_ISSUES #77 — the 2.74:1 selected label ships as measured**, routed to the designer. Do
  not choose a colour in the scope toggle.
- **DESIGN_ISSUES #76 — eight buttons stay unwrapped by `PrimaryCta` on purpose**, including the
  leaderboard's Retry. §7.10a wraps exactly five. `grep -rn 'PrimaryCta(' lib/` is the invariant.
- **DESIGN_ISSUES #55 / #52 / #57 / #58 / #74** — the skipped row is neutral with no third semantic
  colour; the review frame's wrong-row hexes are drift and stay unadopted; the four text styles are
  deliberate nearest-token mappings; the RTL rows are mirrored although the frame is not;
  `limitSheetScrim` dark is null meaning "not measured", pinned by a test.
- **D-008 — the leaderboard is still gated behind its placeholder**, and #19/#20 are therefore not
  reachable at runtime. Build them behind the gate and verify by mounting the widgets directly.
  §11.5 permits a LOCAL-ONLY ungating for the device pass; §10 forbids committing one. Do not touch
  `app_router.dart`, do not un-skip the skipped test, do not delete the placeholder.

## How to work

Small, verifiable increments. After each: `dart format`, `flutter analyze`, the targeted tests. At
the end: `tool\validate.ps1` → OVERALL: PASS with a count no lower than your measured floor, and
`tool\verify_guards.ps1` → 8/8.

Label every claim and never round one up:
**FIGMA READ** (a value off the Properties panel / Dev Mode / CSS export / plugin) ·
**FIGMA CALIBRATED** (an actual side-by-side against a Figma render) ·
**BUILD VERIFIED** (compiles, suite green) · **GOLDEN VERIFIED** (regenerated AND inspected by you,
PNG by PNG) · **DEVICE VERIFIED** (actually installed and driven on hardware).

Three values `edit4.md` §13 flags as UNREAD and that you must read or record as unread — never
guess: the previous-button chevron glyph colour; the light selected scope hex (`#D8B0FF` read
2026-09-08 vs `#DBB0FF` in the 2026-09-16 CSS export, node `158:840`); the dark A/B/C/D badge ring
colour.

**The Figma route that works**, proven twice on 2026-09-19: the Claude-in-Chrome extension against
the OWNER's signed-in Figma account, reading the Properties panel. The MCP connector is
unauthenticated in agent sessions and authenticates as a view-only seat regardless. Try the browser
route before invoking any "could not read" fallback — taking the documented fallback twice in edit3
would have shipped a token at 1.00:1 contrast and a grey where Figma specifies green.

## Stop and ask me — do not decide these yourself

- Product intent, or a visual interpretation that is not in Figma.
- A Figma value you cannot actually read. Say you could not read it; do not approximate it from a
  screenshot. This project has already shipped a whole token block that was eyeballed and wrong in
  every value.
- Anything that would change a calibrated Glass constant or a per-node Glass value.
- The #54 contrast arithmetic if it will not close with approved values.
- A destructive migration, or a security/privacy trade-off.

## Scope discipline — this is the important one

If you discover work that is **outside** `edit4.md` §1 — a bug, a stale doc, a missing test, a
tempting refactor, an item that looks like edit5's — **do not do it.**

Instead: stop, tell me plainly what you found, where it is, why it is out of scope, and what you
would propose. Then **wait for me to reply `continue`.** Do not expand the change set on your own
initiative, and do not bundle "while I was in there" fixes.

The same applies if an item in your own scope turns out to be blocked: record it per `edit4.md`,
say so, and move on to the next item rather than inventing a way round it.

## Finally

Do not commit unless I explicitly ask.

When the wave is done — or when you hit the first thing that needs me — give me a short summary in
Egyptian Arabic: what landed, what is blocked, the verbatim validate and guard numbers, which
goldens moved, and what you need from me.
```

---

## Notes for me (not part of the prompt)

- **Why the eight-point staleness list is the core of this prompt.** `edit4.md` is three days old
  and two waves behind. Every one of the eight was verified against the code on 2026-09-20, not
  inferred. The first — "Independent of: edit3" — is the one that would have cost real time: a
  session would migrate the scope toggle onto a primitive whose contract changed, re-add an
  `ellipsis` to make it look like the frame, and fail three tests without understanding why.
- **What this prompt deliberately does not do:** it does not summarise `edit4.md`'s Figma evidence
  or its §7 required changes. That guide is self-contained by design, and paraphrasing it here
  would create a second source that can drift — which is exactly the failure the staleness list
  above is cleaning up after.
- **The two handed-over measurements** (the 1.75:1 / 2.02:1 scope-toggle contrast, and the h3
  overflow probe) are labelled as "re-verify, don't trust" on purpose. The contrast one was
  computed with the method that reproduces #77's published 2.74:1 exactly, so I believe it; the
  overflow one is BUILD-level against the test binding's font and the device will be kinder.
- **#77 carried a factual error I wrote on 2026-09-19** — it claimed the Figma reading "matches
  `AppType.labelMedium`". It does not: `labelMedium` is 12/16 w500, the frame is 14 px at 100%.
  Only the weight matches. Corrected in `docs/DESIGN_ISSUES.md` on 2026-09-20 with the reasoning,
  because that entry is on edit4's required-reading list and would otherwise be cited as precedent.
- **Before sending it**, re-check that `contract/SOURCE.md` still pins `2dca3c5` / 3.13.0-m1, that
  the ratchet is still 7, and that HEAD is still `4215e1c` with a clean tree — all three are quoted
  as facts in the prompt.
