# Fable Review Brief

**You are the adversary, not the confirmer.** This package was produced by ten
Opus agents plus an orchestrator. It has not been independently checked. Your job
is to find where it is wrong.

**Baseline:** `dev` @ `e3651e6`, Flutter app at `F:\level\level_up\level_up_app`.

---

## Read in this order

1. `project-audit.md` — the consolidated register. §3 (agent disagreements) and
   §4 (the structural finding) are where the reasoning is thickest and therefore
   most attackable.
2. `risks.md` **Part A** — the audit's own weaknesses, self-declared.
3. `known-issues.md` — the fix queue.
4. `decisions.md` — nine judgement calls, each with "what would change it".
5. `changed-files.md` — confirms no app code moved.
6. `test-results.md` — **currently UNVERIFIED**; read why.
7. The ten agent reports, as needed.

---

## Validation status — read before anything else

**The baseline IS verified.** `tool/validate.ps1` was run by the developer on
2026-08-12: **792 tests passed / 0 failed** (goldens included), analyzer **0
issues**, formatter clean. Flutter 3.44.7 / Dart 3.12.2. Record in
`test-results.md`.

**But the findings are still statically derived.** No agent had a toolchain
while forming its conclusions. Do not let the green suite launder the reasoning:
a passing test suite confirms the code does what its tests assert, and almost
every finding in this package concerns paths the tests never reach — release
builds, the real API, untested branches. **Those are different claims.** If you
catch the package conflating them anywhere, that is a finding.

**Two things happened after the findings were written**, and both are fair game:

1. **141 files were reformatted** (Dart 3.12 tall style). Claimed
   behaviour-preserving on the basis that the token stream is byte-identical
   after normalising whitespace and optional trailing commas, plus a green
   re-run. **Check that reasoning** — the normalisation stripped *all*
   whitespace, which could in principle mask a change inside a string literal.
   `git diff --ignore-all-space` on a sample is the counter-check.
2. **All `file:line` references point at `e3651e6`**, before the reformat. Line
   numbers have shifted in those 141 files. Use `git show e3651e6:<file>`.

The audit also recorded three falsifiable predictions before running the suite
and **got one wrong** (it predicted the formatter would pass; 141 files failed).
The scorecard is in `final-summary.md`. Judge whether the miss was owned
honestly or spun.

---

## Attack these first — ranked by likelihood of being wrong × cost of being wrong

### 1. C-1, the missing `INTERNET` permission. **Most likely to be wrong.**

Claim: `android/app/src/main/AndroidManifest.xml` has no `uses-permission` node;
`INTERNET` exists only in `src/debug/` and `src/profile/`; therefore release
builds have no network access.

The source facts were re-verified by the orchestrator and are correct. **The
inference may not be.** Flutter's manifest merger lets *plugin* manifests
contribute permissions, and the pub cache was not available to check them. If any
of `dio`, `connectivity_plus`, `cached_network_image`, `url_launcher`,
`device_info_plus`, `flutter_secure_storage` or `screen_protector` declares
`INTERNET`, **C-1 collapses from CRITICAL to a hygiene note** and the package's
headline finding is wrong.

```sh
flutter build apk --release -t lib/main_prod.dart
grep -i uses-permission build/app/intermediates/merged_manifests/release/AndroidManifest.xml
```

### 2. C-2, the logout data leak. **Check the fix, not the finding.**

The finding is solid — re-verified: `auth_controller.dart:56-71` invalidates
nothing, `me_notifier.dart:39,73` are non-`autoDispose`, and the path is live at
`profile_screen.dart:348` plus four interceptor call sites.

**What may be wrong is the proposed fix.** `known-issues.md` K-2 suggests
invalidating `meProvider` and `entitlementsProvider` — and warns not to assume
those two are exhaustive. **Enumerate every provider holding student-scoped
data.** If the list is longer, the one-line fix is a false comfort and the right
answer is probably a scoped `ProviderContainer` or a keyed refresh, not
hand-listed invalidations. This is the most likely place for an incomplete fix
to ship and look done.

### 3. Severity inflation on the two CRITICALs

Both were filed HIGH by the agents and **raised by the orchestrator**
(`decisions.md` D-3). Challenge that. Is "no network in release" CRITICAL when
no release has ever been built and no distribution channel exists? Is a stale-
cache bug CRITICAL because the cached data is a minor's PII? Reasonable people
could file both HIGH. If you think the orchestrator inflated to look decisive,
say so.

### 4. The three agent disagreements (`project-audit.md` §3)

Each was resolved by the orchestrator. Check the resolutions:

- **Mock backend fidelity** — Agent 7 says the mock is good, Agent 8 says the app
  never runs against it. Resolved as "both, composing". Is that right, or is one
  agent's evidence actually contradicted by the other's?
- **Arabic text expansion** — Agent 5 refuted the brief's premise by reading the
  ARB pairs, and pivoted to a *vertical* risk via font line-height tables
  (Cairo 1.874em). **The font-metrics claim is unverified by anyone else and is
  load-bearing for `docs/RESPONSIVE.md` Rule 6.** Check it.
- **The quiz timer** — resolved as "code right, spec stale". Confirm
  `quiz_state.dart:93-96` and `seif_fight.md S7` actually say what Agent 6 says.

### 5. Findings that no second agent corroborated

Single-source claims, highest risk of error:

- Agent 4's **38 contrast failures**, including `mutedText` at 2.03:1. Computed
  by script. **Recompute two or three by hand.** If the relative-luminance
  arithmetic is wrong, an entire HIGH finding and two design decisions collapse.
- Agent 5's **font line-height table** (see above).
- Agent 7's claim that **all 21 stable endpoints have zero nullability
  mismatches**. This is a strong negative claim across 21 endpoints. Spot-check
  three against `contract/openapi.yaml`.
- Agent 9's claim that **git history is clean** across 677 blobs. Spot-check.
- Agent 2's claim of **zero unguarded post-`await` `context` uses** (8 sites).

### 6. The infrastructure nobody has run

`ci.yml`, both hooks, and `tool/validate.*` have **never executed**. `ci.yml` was
written by an agent that crashed before reporting (`decisions.md` D-8) — its
factual claims were re-verified, its reasoning trace is partly lost.

Read them as code. Specifically: does the format-check file-list construction
work on Windows? Does `pre-push`'s ref-range parsing handle a new branch
correctly? Does `validate.ps1`'s 60-file chunking actually avoid the command-line
limit? Is `FLUTTER_VERSION: "3.44.0"` defensible given
`pubspec.yaml` says `sdk: ^3.10.4` and `.metadata` says something else again?

### 7. What ten agents did **not** look at

- **iOS.** Entirely un-inspected. Every platform finding is Android-only.
- **Release behaviour.** Never built.
- **Figma.** Not consulted this pass — Agent 3 audited the residue of prior
  device passes instead. **Any fidelity defect a human never noticed is invisible
  to this audit.**
- **Runtime performance.** All performance findings are static reasoning.
- **The 12 `docs/day*_brief.md`** were read for context but not audited for
  whether the code actually implements what they specify.

---

## Questions worth asking that this package may have dodged

1. **Is the "structural finding" (§4) real, or is it a narrative imposed on eight
   unrelated defects?** It is the intellectual centrepiece. If the eight rows are
   just normal drift in a fast-moving project, the framing is overreach.
2. **Is `docs/RESPONSIVE.md` premature?** It codifies rules from one agent's
   single pass, and the `textScaler` clamp it proposes overrides a real
   accessibility setting on a product used by children. `decisions.md` D-6 leaves
   it as a product decision — but the document already reads as though 1.3 is
   settled.
3. **Was creating four documents instead of eight the right call?** `decisions.md`
   D-4 argues the other four would duplicate existing homes. Push on it.
4. **Is report-only the right posture, or is it risk aversion?** Two CRITICALs
   sit unfixed. C-1 is one line. Was "no toolchain" a sufficient reason not to
   apply it?
5. **Did severity get calibrated, or averaged?** Ten agents self-calibrated; the
   orchestrator normalised only at the top. Check the MEDIUM tier for HIGHs.

---

## What good looks like

`APPROVED WITH WARNINGS` is the expected outcome — the package is honest about
its gaps but rests on unverified execution.

`REJECTED` is warranted if: C-1's inference is wrong, the contrast arithmetic is
wrong, or you find a CRITICAL the ten agents missed.

Per issue: **Issue · Severity · Evidence · Required Fix · Suggested Location ·
Validation Required.**

Do not approve because it is thorough. Thoroughness is not correctness.
