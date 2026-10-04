# Environment & Architecture chapter — Wave 0 report

**Date:** 2026-10-04 · **Branch:** `merged` · **Pre-wave HEAD:** `03fd7cf` · **Wave commit:** see `git log -1 -- docs/ENVIRONMENTS.md`

## Wave

- **Number:** 0
- **Name:** Architecture & identity decision
- **Objective:** verify the identity audit against the repository, establish the environment
  architecture, the supported platform versions and the fixed store-readiness rubric, and surface the
  owner decisions that gate any implementation. No code changes by design.

## Changes

**What changed (documentation only):**
- `docs/ENVIRONMENTS.md` — new; the architecture record: audit verification table, environments,
  identity state and the pending decision (D-021), supported versions with evidence, build-command
  contract (today vs target), safety invariants, integration with existing guards/CI/hooks, the
  Firebase slot, the wave plan, history, deferred work, uncertainties.
- `docs/STORE_READINESS_RUBRIC.md` — new; 11 categories, 100 weight points, 46 evidence items, frozen
  for the chapter; Wave 0 score.
- `docs/DECISIONS.md` — appended D-021 (**PROPOSED — awaiting owner ratification**).
- `docs/RISKS.md` — added R-9 (single platform identity; id never ratified).
- `docs/WAVE_STATUS.md` — added a pointer section for the chapter.
- `docs/PROJECT_GUIDE.md` — one index row.
- `.ai/audits/current/env_chapter_state.md` — new; chapter state.
- `.ai/audits/current/app_identity_environment_audit_2026-10-04.md` — the read-only input audit, now
  committed with the chapter.

**What did not change:** `lib/`, `test/`, `android/`, `ios/`, `pubspec.*`, `.github/`, `.githooks/`,
`tool/`, `contract/`. No identifiers, no Firebase files, no signing files, no secrets. The 20 modified
and 4 untracked files belonging to other sessions were not touched or staged.

## Validation

| Check | Result | Level |
| --- | --- | --- |
| Format (`dart format --set-exit-if-changed`, via `tool/validate.ps1`) | PASS — 320 files, 0 changed | BUILD |
| Analyze (`flutter analyze`) | PASS — 0 issues | BUILD |
| Tests (full suite) | PASS — **2036 passed / 0 failed / 0 skipped** | BUILD |
| Guards | all guards are in the suite; `test/guards/workflow_test.dart` also run alone: 14/14, including "every runnable release-build command targets lib/main_prod.dart" and its positive companion over the new docs | BUILD |
| Build checks | none run — no build input changed | — |
| CI / hook checks | hooks are not enabled on this clone (`core.hooksPath` unset); CI has never run (R-3). Both SOURCE-level only | SOURCE |
| Baseline before the wave | `validate.sh` under Git Bash: analyze PASS, 2036 tests PASS, format step aborted on the Git Bash 8191-char command-line limit (environment, not code). `validate.ps1` after the wave: OVERALL PASS | BUILD |

`.ai/audits/current/test-results.md` (dirty from another session) was deliberately not overwritten;
both validation reports were redirected to the scratchpad with `LEVELUP_VALIDATE_OUT`.

## Identity State

| Platform / environment | Identifier | State |
| --- | --- | --- |
| Android Development | `com.levelup.level_up_app` | shared template id — **not separated** |
| Android Staging | `com.levelup.level_up_app` | shared template id — **not separated** |
| Android Production | `com.levelup.level_up_app` | template default — **not ratified** (D-021 Q1) |
| iOS Development | `com.levelup.levelUpApp` | shared template id — **not separated** |
| iOS Staging | `com.levelup.levelUpApp` | shared template id — **not separated** |
| iOS Production | `com.levelup.levelUpApp` | template default — **not ratified** (D-021 Q1) |

## Supported Versions

```text
Android:
Minimum SDK/API: 24  (inherited from Flutter 3.44.7 via flutter.minSdkVersion; plugin floor also 24)
Target SDK:      36  (inherited; Play requires ≥ 36 since 2026-08-31 — PASS)
Compile SDK:     36  (inherited)

iOS:
Minimum iOS:       13.0  (AppFrameworkInfo.plist; Flutter floor 13.0; plugin floor 13.0)
Deployment Target: 13.0  (project.pbxproj ×3; Apple requires ≥ 13 since 2026-09-09 — PASS)
```

Supported versions: unchanged from the pre-wave state (Wave 0 changed nothing). Wave 0 *documented*
them for the first time; the Day-0 open question (`Open_Questions.md:53`) now has a proposed answer
awaiting D-021 Q4. Wave 1 will pin the three Android numbers explicitly instead of inheriting them.

## Store Readiness

```text
Google Play Readiness:      32%
Apple App Store Readiness:  18%
```

First measurement; no previous wave to compare against. Score is the rubric's evidence tally, not
chapter progress: Android earns its points from fail-closed signing, the ARTEFACT-inspected APK/AAB,
target 36, 16 KB alignment, device-walked debug builds and the guard suite; iOS has never been built,
has no team, no Podfile, no privacy manifest. Both share the zeros for identity, listing, backend
production readiness and notifications. The 17 submission blockers in
`store_readiness_audit.md` §19 remain open regardless of the percentage.

## Risks / Remaining Work

- **Owner decision (blocking Wave 1):** D-021 Q1 production ids (keep template / one shared token /
  other prefix), Q2 two or three installable identities, Q3 display names, Q4 confirm the versions
  above. Recommendation recorded in D-021; the token for option B must come from the owner.
- **Environment block (Wave 3):** iOS schemes/xcconfigs can be authored here but need a Mac with
  Xcode 26 for BUILD-level proof.
- **Guard conflict to resolve in Wave 1:** the current release-entrypoint guard assumes release ≡ prod
  and would reject a staging QA release command; it must become a flavor ⇄ entrypoint coherence rule
  in the same commit as the flavors.
- **Hook gap (Wave 1):** `pre-push` skips validation for `android/`, `ios/`, `.github/`, `tool/` changes.
- **Re-check before implementing Q1:** whether `com.levelup.level_up_app` is still unclaimed on Play
  (last seen 404 in September).
- **Dependencies outside the chapter:** production host from Seif (contract `servers:`); developer
  accounts, keystore, Play App Signing, App Store Connect record — owner; Firebase — after Waves 1 and 3.

## Git

- **Branch:** `merged`
- **Commit:** one focused docs commit containing only the nine chapter files listed above
  (recorded in `env_chapter_state.md` after the commit)
- **Working tree status:** other sessions' 20 modified + 4 untracked files remain uncommitted and
  untouched; nothing pushed (R-3, owner's call)

Backend status: Wave 0 of the environment/identity chapter is complete and documentation-only; the app still points dev and staging at the existing staging host, production remains blocked on a production base URL in the contract's `servers:` block, and no backend action is required right now.
