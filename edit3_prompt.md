# Prompt for the Edit 3 session

> Copy everything inside the fence below into a **fresh** Claude Code session opened at
> `F:\level\level_up\level_up_app`. Written 2026-09-19, after edit1 and edit2 landed.
>
> Nothing outside the fence is part of the prompt.

---

```text
Implement `edit3.md` — the Home / Learn / Mistakes wave of the elevation work.

## Where the project is

Branch `merged`, working directory F:\level\level_up\level_up_app. The tree is
INTENTIONALLY DIRTY: several sessions edit this repo concurrently and a large amount of
finished work is uncommitted. Never discard, stash, revert or reformat a hunk you did not
write. If a change in a file you need looks foreign, leave it and ask me.

**edit1 is implemented.** It added the elevation foundation: `AppElevation` tokens,
`GlassStyle` / `Backlight` / `FigmaShadow` / `ScrimStyle`, and the primitives in
`lib/core/widgets/elevation/` — `ElevatedSurface`, `PrimaryCta`, `SegmentedTrack`,
`paintFigmaShadows`, `paintGlassRim`, `app_modal.dart`. Consume those. Never add a second
glass, shadow or scrim implementation, and never hardcode a design colour in a widget.

**edit2 is implemented** — shared chrome: the nav bar, back chips (`BackChipVariant`),
primary and outline CTAs via `PrimaryCta`, the limit-sheet scrim, form fields, the
dialog/sheet scrims and opaque panels via `showAppDialog` / `showAppModalSheet`, the
onboarding sheet and the language pill. `showAppDialog` and `showAppModalSheet` exist for
you if a dialog appears in your scope — but per edit3.md §1 no dialog is in your scope.

**The Glass model was recalibrated on 2026-09-19 and is settled.** Read
`docs/DECISIONS.md` **D-011** and `docs/DESIGN_ISSUES.md` **#72** before you touch anything
Glass. The short version: the rim is a two-lobe directional highlight with a measured back
lobe, a threshold below which it is not drawn, and a width and falloff all pinned to Figma;
its **strength** ships at 70% of Figma's measured alpha by an owner ruling, because tier 1
renders none of the depth/refraction shading that balances it in Figma. That ruling lives in
ONE constant, `kGlassRimMaxAlpha`. **Do not change it, do not "restore fidelity", and do not
compensate for it by bending a per-node Glass value** — those are measured.
`test/core/widgets/elevation/glass_rim_calibration_test.dart` will catch you.

## Read before you change anything

In this order, and do not skip:

1. `CLAUDE.md` (repo root) — the five rules.
2. `docs/WAVE_STATUS.md` — the single source of project truth.
3. `docs/AGENT_WORKFLOW.md` § "Theme discipline" and § "Never invent".
4. `edit1.md` §4 — design rules R1–R10. They apply to your work verbatim.
5. `edit3.md` — **in full**, including §0 pre-flight, §1 scope, §5 Figma evidence, §7 required
   changes, §11 verification, §13 risks and §14 completion criteria.
6. `docs/DECISIONS.md` — at minimum D-009 (elevation model), D-011 (rim strength).
7. `docs/DESIGN_ISSUES.md` — #72 (Glass), plus every entry `edit3.md` cites for your items.
8. `contract/SOURCE.md` — which contract commit is pinned. As of 2026-09-19 that is `2dca3c5`,
   `info.version` **3.13.0-m1**, 29 stable / 13 draft / 42 operations. Verify it yourself; do
   not trust this line if the file disagrees.
9. `flutter_code_tree.md` (repo root) — the module map and the contract/live status of every
   operation, generated 2026-09-19. Useful orientation; the code wins if they disagree.

Then, before your first edit:

- `git status --short` and note what is already dirty in the files you will touch. In
  particular `lib/features/home/widgets/level_card.dart` carries an unrelated doc-comment
  change (contract S3 wording) — keep it.
- `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` and record the numbers. The
  2026-09-19 baseline is **OVERALL: PASS, 1130 passed / 0 failed / 1 skipped**, guards 8/8,
  elevation ratchet **9**. If you see less, find out why before doing anything else.

## Your scope — `edit3.md` §1, and nothing else

Items 1, 3, 4 (record only), 5, 6, 7, 9, 10, 41, 42, 43 (record only), 44 (record only).
Files: `lib/features/home/**`, `lib/features/catalog/**`, `lib/features/mistakes/**` — as
`edit3.md` §1 names them.

**Explicitly NOT yours**, per `edit3.md` §1 "Owned elsewhere": the `CatalogHeader` back chip
and the bottom nav bar (edit2, already done); the Home/catalog error-state Retry buttons,
which have no Figma frame and stay unwrapped; the quiz setup / quiz / result / review screens
and the leaderboard (edit4); profile and settings (edit5).

`edit3.md` lowers the elevation ratchet by **2** — in the same change that removes the two
sites, not before and not after.

## Rules that will fail the build if you break them

- **No colour literal outside `lib/core/theme/`.** The palette guard scans every line under
  `lib/`, comments included, for `0xFF`, `Color(0x`, `Colors.black`, `Colors.white`. A new
  colour means a new `AppColors` token with BOTH canvas values and a Figma node citation.
- **No shadow / blur / backdrop primitive outside `lib/core/theme/` and
  `lib/core/widgets/elevation/`.** The elevation ratchet is 9 — do not raise it.
- **No new inline `fontSize:` or `fontWeight:`** (ratchet 0). Use a named `AppType` style.
- **All user-facing copy through `AppLocalizations`**, in both ARB files.
- Bloc only in `lib/features/quiz/`; everything else Riverpod.
- Never log personal data or tokens. Do not edit anything under `contract/`.
- `flutter test --tags golden --update-goldens` **with no file argument rewrites every golden
  in the repo.** Always pass the specific test file.

## How to work

Small, verifiable increments. After each one: `dart format`, `flutter analyze`, the targeted
tests. At the end of the wave: `tool\validate.ps1` → OVERALL: PASS with a count no lower than
the baseline, and `tool\verify_guards.ps1` → 8/8.

Label every claim and never round one up:
**FIGMA READ** (a value off the Properties panel / Dev Mode / CSS export / plugin) ·
**FIGMA CALIBRATED** (an actual side-by-side against a Figma render) ·
**BUILD VERIFIED** (compiles, suite green) · **GOLDEN VERIFIED** (regenerated AND inspected
by you, PNG by PNG) · **DEVICE VERIFIED** (actually installed and driven on hardware).

Where Figma and the code disagree, the design wins and the divergence is logged in
`docs/DESIGN_ISSUES.md`. Where Figma is **missing** something, stop and ask — never invent a
value, a token, a type scale or a behaviour.

## Stop and ask me — do not decide these yourself

- Product intent, or a visual interpretation that is not in Figma.
- A Figma value you cannot actually read (say you could not read it; do not approximate it
  from a screenshot — this project has already shipped a whole token block that was eyeballed
  and wrong in every value).
- Anything that would change a calibrated Glass constant or a per-node Glass value.
- A destructive migration, or a security/privacy trade-off.

## Scope discipline — this is the important one

If you discover work that is **outside** `edit3.md` §1 — a bug, a stale doc, a missing test,
a tempting refactor, an item that looks like it belongs to edit4 or edit5 — **do not do it.**

Instead: stop, tell me plainly what you found, where it is, why it is out of scope, and what
you would propose. Then **wait for me to reply `continue`.** Do not expand the change set on
your own initiative, and do not bundle "while I was in there" fixes.

The same applies if an item in your own scope turns out to be blocked: record it per
`edit3.md`, say so, and move on to the next item rather than inventing a way round it.

## Finally

Do not commit unless I explicitly ask.

When the wave is done — or when you hit the first thing that needs me — give me a short
summary in Egyptian Arabic: what landed, what is blocked, the verbatim validate and guard
numbers, which goldens moved, and what you need from me.
```

---

## Notes for me (not part of the prompt)

- **Why the Glass paragraph is in there.** D-011 is exactly the kind of ruling a fresh session
  would "helpfully" undo — the constant sits 30% below a measured value with the measurement
  recorded right next to it. The prompt names it, names the test that guards it, and forbids
  both the direct revert and the sideways one.
- **Why the baseline numbers are spelled out.** `edit3.md` §0 tells the session to record the
  validate count but not what it should be; a regression that predates the session would
  otherwise be invisible.
- **What this prompt deliberately does not do:** it does not summarise `edit3.md`'s Figma
  evidence or required changes. That guide is self-contained by design, and paraphrasing it
  here would create a second source that can drift.
- **Before sending it**, re-check that `contract/SOURCE.md` still pins `2dca3c5` / 3.13.0-m1
  and that the validate baseline is still 1130/0/1 — both are quoted as facts in the prompt.
