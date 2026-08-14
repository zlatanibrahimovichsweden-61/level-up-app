# Risks

Two kinds, kept separate: risks **in the project**, and risks **in this audit**.
The second list is the one a reviewer should read first, because it bounds how
much the first list can be trusted.

---

## Part A — Risks in this audit

### A-1 · Findings were derived from reading, not execution. [MEDIUM — reduced from HIGH]

**Partially closed 2026-08-12.** The developer ran `tool/validate.ps1`: analyzer
clean, formatter clean, **792 tests passed / 0 failed**. So the baseline is no
longer an assumption.

**What remains open:** no agent had a toolchain *while forming its findings*. The
suite confirms the code does what its tests assert; it does not confirm the
audit's reasoning about paths the tests never reach — which is precisely where
most findings live (release-only behaviour, real-API behaviour, untested
branches). A finding could still be wrong in a way only a compiler or a device
would catch. Agents were told to mark such claims "Validation Required" and did,
but that is a discipline, not a guarantee.

### A-2 · The "~730 tests pass" claim — CLOSED. [resolved]

Verified 2026-08-12: **792 passed, 0 failed**, goldens included, on Flutter
3.44.7 / Dart 3.12.2. The inherited figure was not only true but conservative.
Goldens passing on Windows additionally confirms no visual regression in the tree.

### A-2b · The tree has changed since the audit baseline. [LOW]

141 files were reformatted after the findings were written (Dart 3.12 tall
style). Every `file:line` reference in this package therefore points at
`e3651e6`, and **line numbers will have shifted** in those 141 files.

The change is proven behaviour-preserving — token stream byte-identical after
normalising whitespace and optional trailing commas, and the suite re-ran green —
so no *finding* is invalidated. But a reviewer chasing `app_colors.dart:504`
should expect the line to have moved. Use `git show e3651e6:<file>` to read the
exact state the findings describe.

### A-3 · C-1 depends on manifest-merger behaviour that was not observed. [MEDIUM]

The missing `INTERNET` permission was verified in *source* — `src/main/` has no
`uses-permission` node, only `debug/` and `profile/` do. But Flutter plugin
manifests can contribute permissions during merge. Agent 9 reports none does;
the orchestrator could not check plugin manifests because the pub cache was not
available.

**If a plugin does supply it, C-1 collapses from CRITICAL to a hygiene note.**
The one-command check is in `known-issues.md` K-1. **This is the single most
important thing for Fable to challenge.**

### A-4 · Agent findings were not cross-verified against each other by default. [MEDIUM]

Ten agents worked in parallel without seeing each other's reports. The
orchestrator de-duplicated afterwards and found three genuine tensions (recorded
in `project-audit.md` §3), all resolvable. But an agent could have asserted
something a neighbouring agent's evidence contradicts, and the orchestrator only
spot-checked the two CRITICALs.

### A-5 · Agent 10 crashed mid-task. [LOW]

Terminated by an API error after writing `ci.yml` and both hooks, before
`validate.ps1` and its report. The orchestrator completed both and re-derived
every figure from the repository rather than inheriting them. Disclosed at the
top of `devops.md`. Residual risk: `ci.yml` was written by an agent whose
reasoning trace is partly lost — though every factual claim in its header
comments was independently re-verified and held.

### A-6 · Severity calibration is a judgement, not a measurement. [LOW]

Ten agents each calibrated independently against a shared instruction to be
conservative. The orchestrator normalised at the top end only. A finding filed
MEDIUM by one agent might have been HIGH under another's calibration.

### A-7 · Figma was not consulted this pass. [LOW]

Agent 3 audited the *residue* of prior device-vs-Figma passes rather than
re-pulling frames. Any fidelity defect that has never been noticed by a human
device pass is invisible to this audit.

### A-8 · iOS was not audited. [LOW]

Every platform finding — manifest, permissions, R8, screenshot protection,
backup rules — is Android-only. The `ios/` directory was not inspected.

---

## Part B — Risks in the project

### B-1 · The app has never been built in release mode. [CRITICAL]

C-1 (missing `INTERNET`) is the proof: a defect that makes the app entirely
non-functional survived 43 commits because release was never exercised. It is
unlikely to be the only one. R8 is off, obfuscation is undocumented, and
`build-release-apk` in the new CI will be the first release compile this project
has ever done.

**The corollary matters more than the finding:** CI's release job will pass
even with C-1 present, because the APK *compiles* fine. **Only a device can
catch this class.** Automation does not remove the need for the device pass.

### B-2 · Written rules decay because nothing enforces them. [HIGH]

Eight documented rules are violated by current code (`project-audit.md` §4),
found by five independent agents. Meanwhile the one rule that *was* mechanised —
the palette guard test — holds perfectly across 36k lines with zero exceptions.

**The risk is that this audit becomes another unenforced document.** The
mitigation is K-20 and K-21: convert the highest-value prose rules into a guard
test and a lint config. Everything else in this package is a snapshot; those two
are the only durable outputs.

### B-3 · The real API has never been connected. [HIGH]

Base URLs are `TBD.example`. Every one of ~730 tests has only ever talked to
mocktail stubs or `mock_backend.dart`, which cannot produce 401s, 5xx, timeouts
or malformed bodies, and short-circuits at `onRequest` so nothing is JSON
round-tripped. H-2 (a `fromJson` `TypeError` escaping every catch and hanging
the screen) is the specific defect this will surface.

**Expect connection day to be eventful.** `api-data.md` contains a 10-step
ordered migration checklist naming what breaks first at each step. Read it
*before* the base URL arrives, not after.

### B-4 · Single-developer bus factor, with rules split across four locations. [MEDIUM]

Rules live in `.claude/skills/` (22), the vault's `skills/` (7) and
`.agents/skills/` (15) — byte-identical today with no mechanism keeping them so —
plus 21 prose files in `01_Flutter_Specs/` **outside the app repo**, plus 12
`docs/day*_brief.md` inside it. `docs/PROGRESS.md` already self-declares its
headers stale, and `Architecture_and_Folders.md` is wrong in 5 of ~10 assertions.

Much of the reasoning that makes this codebase good lives in comments and in one
person's head. The comments are unusually good — the risk is that the maps are
already drifting from the territory.

### B-5 · Two product surfaces have no backend at all. [MEDIUM · PRODUCT]

Leaderboard is `draft`; Message has **no endpoint at all**. Neither is fixable
from the app side. `docs/PROGRESS.md` states this plainly and this audit
confirms it: all 15 unconsumed paths are genuinely `x-stability: draft`, so the
claim that no further endpoint work is possible is **true**.

### B-6 · Accessibility has not been treated as a requirement. [MEDIUM]

Zero text-scale handling; three defects trigger between 1.2× and 1.3×, one on
every question of every quiz. Eight interactive controls have no accessible
name. For an education product used by minors, in a market where system font
scaling is commonly raised, this is a product risk, not just a code smell.

### B-7 · Golden coverage is English-only, for an app whose baseline locale is Arabic. [MEDIUM]

18 baselines, **zero** in `ar`. RTL golden coverage is 0% against a rule the
project itself calls a baseline requirement rather than an edge case. 43 of ~760
test cases (5.7%) touch Arabic at all. The 8-cell states × languages rule in
`screen-states/SKILL.md` is therefore **unverifiable** on its language half.

### B-8 · Adding CI creates a new failure mode. [LOW]

`FLUTTER_VERSION` is currently a guess (`3.44.0`, the lockfile floor) because
three sources in the repo disagree about the SDK. Until the developer sets the
real local version, CI's first run may fail on dependency resolution and look
like a code problem. The `goldens` job is advisory precisely because it may be
permanently red for platform reasons — decide after the first run whether it is
signal or noise. A red CI that everyone learns to ignore is worse than no CI.

### B-9 · `dev` is not a superset of `main`. [LOW]

`main` carries 3 commits `dev` does not. The next `dev` → `main` merge will be a
real merge with conflict potential, at exactly the moment a fast-forward is
expected. Cheap to fix now at 3 commits.
