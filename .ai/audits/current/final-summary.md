# INITIAL PROJECT IMPROVEMENT COMPLETE

**Baseline:** `dev` @ `e3651e6` · 2026-08-11 · working tree clean at start and finish
**Method:** ten specialised Opus agents, report-only, plus orchestrator consolidation
**Status:** ready for independent Fable review. **Not approved.**
**Validation:** ✅ **OVERALL PASS** — 792 tests / 0 failures, analyzer 0 issues,
formatter clean. Run 2026-08-12. See `test-results.md`.

> **Dated note (2026-09-05) — this package is a 2026-08-11 snapshot.** Several of its findings
> were later **superseded by contract 3.0.0-m1** (pin `184d6ec`, adopted 2026-09-04), not fixed
> in place: the `/subscription` dead-end (H-1 / F-3-01 / K-3) and the Paymob return deep link
> (F-6-08) were **removed outright** with the whole purchase surface — the app is purchase-silent
> (adr-049 §3, `docs/DECISIONS.md` D-007, `5c4b855`); `TBD.example` (F-7-10) is now prod-only —
> staging is a real host (`67bdcc1`); `POST /checkout/sessions` (F-7-12) no longer exists in the
> contract. The 792 count is the count at `e3651e6`; `docs/WAVE_STATUS.md` carries the current
> state and `docs/seif_fight.md` Part A the contract history. Nothing below was rewritten.

---

## Project Health

**Strong.** This is a well-engineered codebase and the audit should be read that
way. Measured, not asserted:

- **0** hardcoded colours outside the theme layer, across 36k lines, enforced by an existing guard test
- **0** contract↔model nullability or enum mismatches across all 21 consumed endpoints
- **0** unguarded `BuildContext` uses after `await`
- **0** leaked controllers, timers or subscriptions
- **0** secrets in the tree or in 43 commits of history (677 blobs scanned)
- **43/43** commits follow Conventional Commits
- **0** keyboard-overflow screens; safe areas consistent across 25 sites
- 401→refresh→retry is correct **including under concurrent 401s**
- ~730 test cases; 6 repositories with uniform typed-exception boundaries

The defects cluster in three places: **release-only** behaviour (never built),
**real-API** behaviour (never connected), and **rules written down but not
mechanically enforced**.

---

## Major Gaps Found

**2 CRITICAL** · **9 HIGH** · **24 MEDIUM** · ~40 LOW, de-duplicated from 116 raw findings.

- **C-1** The release APK appears to have no `INTERNET` permission — declared only in the debug and profile manifests. Every network call would fail in release, invisibly during development.
- **C-2** Logout clears tokens but invalidates no providers, and `meProvider` is non-`autoDispose` — the next student on a shared handset sees the previous student's name, level, points, school and entitlements. Disclosure of a minor's PII.
- `/subscription` is a live dead-end on the revenue path, in unthemed hardcoded English
- A `fromJson` `TypeError` escapes every catch clause — the first real-API schema drift hangs the screen silently
- Onboarding's primary CTA dead-ends on `RegistrationExpiredView`
- No `TextTheme` exists — 153 inline `TextStyle(` with hardcoded sizes
- Dark hint text is pixel-identical to typed text; light nav labels sit at 2.03:1 contrast
- No text-scale policy — three defects trigger between 1.2× and 1.3×, one on every quiz question
- `select()` used 0 of 70 times, against a rule written in three separate spec files
- Three structural test blind spots, all in BUG-001's family

**The structural finding:** eight documented rules are violated by current code.
The one rule that was mechanised — the palette guard test — holds with zero
exceptions. Prose rules decay; tests hold. That gap is the most actionable thing
in this audit.

---

## Gaps Fixed

**In code: none, deliberately.** No Dart toolchain was available, so no change to
application code could be validated. Report-only was agreed before work started.

**In infrastructure:** CI, git hooks, and the validation runner — all inert until
invoked, none capable of changing app behaviour.

**In documentation:** the central guide, the responsive strategy, the agent
workflow and the audit protocol.

---

## Gaps Deferred

Everything in `known-issues.md` — 37 items across four tiers, each with
`file:line`, an estimated size, and a "done when" condition. Tier 0 is the two
CRITICALs; Tier 3 is the enforcement work that stops these classes recurring.

Three items are held as **PRODUCT DECISIONS** and were deliberately not decided:
the `textScaler` clamp, the two contrast token values, and the Arabic w600 face.

---

## Architecture Changes

None applied. Proposed: move `Track` out of `profile/models/` into `core/models/`
(it is used in 26 files across 6 features, making `profile` an accidental shared
kernel); break the `core/` → `features/auth/` provider cycle the source
acknowledges at `core_providers.dart:36-38`; consolidate four parallel
`AsyncValue`→4-state implementations back into `StateWidget`.

## Theme Changes

None applied. Proposed: a `TextTheme` (currently absent entirely); two contrast
token fixes pending design input; collapse the `#7070A0` duplicate token family.
Recorded as correct and left alone: `Brand.*` sealing, all 15 `Colors.*` uses,
all 5 `BoxShadow` sites.

## Responsive Changes

None applied. **`docs/RESPONSIVE.md` created** — this rule had no home anywhere
before. Eight rules, an 11-item ranked fix queue, and a guard-test spec. The
audit corrected a widely-held premise here: Arabic does **not** run longer in
this app; the real RTL risk is vertical line-height, not horizontal overflow.

## Testing Changes

None applied. Proposed: `test/core/discipline_test.dart` (~120 lines, five
properties that hold today and are enforced by nobody, including the literal
BUG-001 guard); extend the registration router flow through both detail screens;
OTP resend/countdown coverage (currently zero); Arabic goldens (currently zero);
three integration tests, each crossing a platform channel no widget test reaches.

## CI Changes

`.github/workflows/ci.yml` created — 268 lines, every decision derived from a
measured fact about this repo and documented inline. Analyze + test gate on PR
and push to `dev`/`main`; goldens in a separate **advisory Windows** job because
the baselines are Windows-captured and would fail on Linux for platform reasons;
codegen-drift and release-compile on `main` only, because generated code is
committed and an APK build finds little on a PR-sized change.

⚠ **`FLUTTER_VERSION` must be set from your local `flutter --version` before the
first run** — `.metadata`, `pubspec.yaml` and `pubspec.lock` currently disagree.

## Git Hook Changes

`.githooks/pre-commit` and `pre-push` created, **not installed** —
`git config core.hooksPath .githooks` is your call. `pre-commit` touches only
staged Dart files; `pre-push` skips the suite entirely when a push carries no
Dart or config change. No `commit-msg` hook: commit hygiene is already 43/43, so
one would be automation for its own sake.

## Documentation / Skill Changes

Four documents created — `PROJECT_GUIDE.md`, `RESPONSIVE.md`, `AGENT_WORKFLOW.md`,
`AUDIT_PROTOCOL.md`. **Not the eight the brief listed**, because four of those
eight describe rules that already have homes, and duplicating them is the exact
mechanism by which this project's docs have already drifted. Reasoning in
`decisions.md` D-4.

Recommended (not applied): declare `.claude/skills/` canonical over the vault
mirrors; fix `Architecture_and_Folders.md`, which is wrong in 5 of ~10 assertions.

---

## 10-Agent Audit

| # | Agent | Findings | Notable |
| --- | --- | --- | --- |
| 1 | Architecture | 12 | Cleared the mock backend, the DI root and the repository layer with evidence |
| 2 | Flutter/Dart Quality | 10 | Found zero crashes, leaks or async-gap bugs; one HIGH (`select`) |
| 3 | UI / Figma Fidelity | 12 | 2 HIGH, both user-facing dead ends |
| 4 | Design System / Theme | 12 | Computed 38 contrast failures by script |
| 5 | Responsive & Accessibility | 13 | **Refuted the brief's Arabic-expansion premise** and pivoted to font metrics |
| 6 | State & Navigation | 10 | **Independently re-verified BUG-001's scope claim — it still holds** |
| 7 | API & Data | 12 | **Corrected the brief's assumption about the mock backend** |
| 8 | Testing & QA | 10 | Mapped the structural blind spots; corrected 3 orchestrator errors |
| 9 | Security & Performance | 13 | Scanned all 43 commits for secrets — clean |
| 10 | DevOps & Workflow | 12 | Crashed mid-task; orchestrator completed and re-verified every figure |

That three agents contradicted their own brief and were right is the strongest
evidence the process worked.

---

## Tests

**PASS — 792 passed, 0 failed**, goldens included. Run by the developer on
2026-08-12 via `tool/validate.ps1` (Flutter 3.44.7, Dart 3.12.2, Windows).
Full record in `test-results.md`.

The "~730 green tests" figure this audit had to inherit is now **verified, and
is actually 792**. Goldens passing on Windows also confirms no visual regression
is sitting in the tree.

## Analyzer

**PASS — 0 issues.**

## Formatter

**FAIL on first run — 141 of 207 files. Now PASS after remediation.**

This was the audit's one wrong prediction and it turned out to be the most
informative result of the run. The cause was not sloppy code: Dart 3.12's
formatter uses **tall style**, and the tree had been written in the older short
style (8-space continuation indents), so 68% of files differed on indentation
and optional trailing commas alone. Nothing had ever enforced formatting —
no CI, no hook — which is precisely the thesis in §4 of `project-audit.md`
landing on the audit itself.

**Remediated 2026-08-12.** `dart format` applied to the 141 files that needed it
(generated output excluded). Verified behaviour-preserving before re-running:
with whitespace and optional trailing commas normalised away, the token stream
is byte-identical to `e3651e6` in **all 141 files**. The full suite then
re-ran green — 792/0 — confirming the compiler and widget tree agree with the
static check.

### Prediction scorecard

Three falsifiable predictions were recorded before the suite ran, so that the
audit's own reliability could be measured.

| # | Predicted | Actual | |
| --- | --- | --- | --- |
| 1 | `flutter analyze`: 0 issues | 0 issues | ✅ |
| 2 | `dart format`: PASS | **FAIL — 141 files** | ❌ |
| 3 | `flutter test`: ~730 passed, 0 failed | 792 passed, 0 failed | ✅ (count undercounted ~8%) |

**2 of 3.** Prediction 2 failed because it reasoned from "commit discipline is
excellent" — which is true, 43/43 conventional commits — without checking that
commit discipline and *formatter* discipline are independent properties. The
undercount in prediction 3 came from grepping `test(`/`testWidgets(` literals,
which misses loop-generated cases.

Both errors are recorded rather than quietly corrected, because a package that
hides its own misses is not evidence of anything.

---

## Remaining Risks

**In the audit:** the two largest risks are now **closed** — the suite has been
run (792/0) and the analyzer is clean, so findings no longer rest on an
unverified baseline. What remains: C-1 rests on an inference about Android
manifest merging that was not observed; agents did not cross-verify each other
by default; iOS, Figma, release builds and runtime profiling were not covered.

**In the project:** the app has never been built in release — and CI's release
job will pass *even with C-1 present*, because the APK compiles fine. Only a
device catches that class. The real API has never been connected. Rules live in
four locations with no sync mechanism, and two of them are already stale.
RTL golden coverage is 0% for an app whose baseline locale is Arabic.

Full detail in `risks.md`, split into Part A (this audit) and Part B (the project).

---

## Fable Audit Package

```
F:\level\level_up\level_up_app\.ai\audits\current\
```

19 files, ~400 KB. Entry point: `FABLE_REVIEW_BRIEF.md`.

## Recommended Fable Review Scope

**Adversarial, and pointed at this package's weakest joints — which it names itself.**

1. **Verify or demolish C-1.** One `flutter build apk --release` plus a grep of
   the merged manifest settles whether the headline finding is real. If a plugin
   supplies `INTERNET`, the package's top finding is wrong.
2. **Attack C-2's proposed fix**, not the finding. Enumerate every
   student-scoped provider; a hand-listed invalidation that misses one is a false
   comfort that will look fixed.
3. **Recompute two or three of Agent 4's contrast ratios by hand.** An entire
   HIGH finding and two design decisions rest on one script.
4. **Check Agent 5's font line-height table** — uncorroborated and load-bearing
   for `docs/RESPONSIVE.md` Rule 6.
5. **Challenge the severity raises.** Both CRITICALs were filed HIGH by agents
   and promoted by the orchestrator.
6. **Read the unrun infrastructure as code** — `ci.yml`, both hooks,
   `validate.ps1`. None has ever executed; `ci.yml`'s author crashed before
   reporting.
7. **Test the "structural finding" (§4).** It is the package's intellectual
   centrepiece and may be a narrative imposed on eight unrelated defects.
8. **Ask whether report-only was rigour or risk aversion.** Two CRITICALs sit
   unfixed and one of them is a one-line change.

---

**The project is not approved. It is ready for review.**

The baseline is now verified: 792 tests green, analyzer clean, formatter clean,
on a tree whose only change since `e3651e6` is a proven-equivalent reformat.

The highest-value next actions, in order:

1. **Commit the formatting as one isolated commit** and add its SHA to
   `.git-blame-ignore-revs` — see `known-issues.md` K-0.
2. **Settle C-1** — one release build plus a grep of the merged manifest.
3. **Fix C-2** — but enumerate every student-scoped provider first; the
   two-line version is a false comfort.
