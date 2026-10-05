# Environment & Architecture chapter — Wave 1 report

**Date:** 2026-10-06 · **Branch:** `merged` · **Pre-wave HEAD:** `9d5a2ec` · **Commits:** `965c185`
(D-021 ratified) and the commit that contains this file (Android implementation).

## Wave

- **Number:** 1
- **Name:** Android environment architecture (preceded by the DECIDE step: D-021 ratified)
- **Objective:** turn the ratified identities into the Android build — two product flavors with their own
  `applicationId` and display name, explicit supported-version literals, a build-time flavor ⇄
  entrypoint rule — and evolve the existing guards, CI job, tool scripts and hook so the invalid
  combinations are refused by the build and by the documents that teach commands.

## Changes

**Decision (own commit `965c185`):** `docs/DECISIONS.md` D-021 moved from PROPOSED to RATIFIED with the
owner's answers recorded verbatim (Q1–Q4) and Seif's Q5–Q7 as inputs.

**Android build (`android/`):**
- `app/build.gradle.kts` — `applicationId = "com.levelupworld.app"`; `flavorDimensions("env")`; flavors
  `prod` (`app_name` "Level Up") and `staging` (`applicationIdSuffix ".stg"`, `app_name` "Level Up STG");
  `compileSdk 36 / minSdk 24 / targetSdk 36` as literals (were inherited from `flutter.*`); the Kotlin
  `namespace` unchanged on purpose; a flavor ⇄ entrypoint check that reads Flutter's `-Ptarget` and
  throws in the variant's `compileFlutterBuild<Variant>` task — `prod` accepts `main_prod.dart` only;
  `staging` accepts `main_staging`/`main_dev`/`main.dart`, plus `main_mock` in debug/profile only.
- `app/src/main/AndroidManifest.xml` — `android:label="@string/app_name"` (was the literal `level_up_app`,
  DEVICE-confirmed gap G-9).

**Guards (`test/guards/`):**
- `workflow_test.dart` — the 2026-09-05 rule "every release command targets `lib/main_prod.dart`" became
  "every release command pairs `--flavor` with a matching entrypoint" (no flavor, no `-t`, unknown flavor,
  or `prod`+non-prod / `staging`+mock are offenders). Dated records (`*_YYYY-MM-DD.md`) are skipped as
  history. A third test proves the detector itself on literal good and bad commands.
- `android_identity_test.dart` — new, 9 tests: the ratified id, exactly the two flavors, the `.stg`
  suffix, per-flavor names + manifest reads them, the Gradle check is present, SDK literals, the literals
  equal `docs/ENVIRONMENTS.md` §3, and the Firebase slot (per-flavor `google-services.json` must name its
  own id; none in `src/main`) — vacuous until Firebase exists, by design.

**Scripts, CI, hook:**
- `tool/verify_guards.ps1` — 8 → 11 probes: the release-command probe now reintroduces the post-flavor
  regression (right entrypoint, no `--flavor`); new probes for a `prod`/`main_staging` mismatch and for
  reverting `applicationId` to the template value.
- `tool/verify_release_manifest.ps1` — builds `--flavor prod`, reads `app-prod-release.apk`, asserts
  `package: name='com.levelupworld.app'` via `aapt2 dump badging` before the INTERNET check.
- `.github/workflows/ci.yml` `build-release-apk` — `--flavor prod`; new artefact path; package assertion
  before the INTERNET assertion.
- `.githooks/pre-push` — validation also triggers on `android/ ios/ tool/ .github/ .githooks/`.

**Docs:** `ENVIRONMENTS.md` rewritten for the ratified state (identity table, Q4 iOS 15.0 verification,
the in-force Android command contract with fenced commands, refused combinations, invariants, Seif's
inputs, uncertainties); `RISKS.md` R-9 → mitigating; `WAVE_STATUS.md` chapter paragraph;
`ENFORCEMENT.md` evolved row + 3 new rows; `RELEASE_SIGNING.md` command and id paragraph; `STORE_READINESS_RUBRIC.md`
re-score; `flutter_frontend_workflow.md` one stale sentence; `.ai/audits/current/env_chapter_state.md`.

**What did not change:** `lib/` (no Dart app code), `ios/`, `pubspec.*`, `contract/`, any Firebase or
signing file. No secrets, no credentials, no `key.properties`, no `google-services.json`. The other
sessions' 20 modified + 7 untracked files were not touched or staged (`docs/STORE_READINESS.md` among them).

## Validation

| Check | Result | Level |
| --- | --- | --- |
| `tool/validate.ps1` (format → analyze → full suite), report redirected via `LEVELUP_VALIDATE_OUT` | **OVERALL PASS** — format 0 changed, analyze 0 issues, **2046 passed / 0 failed / 0 skipped** (Wave 0 baseline 2036; +10 = the new guards) | BUILD |
| `flutter test test/guards` alone, after the last doc edit | 115/115 | BUILD |
| `tool/verify_guards.ps1` | **11/11 guards proved**, each fired in isolation; all probed files restored (SHA-256 verified); no probe file left | BUILD |
| `flutter build apk --release --flavor prod -t lib/main_prod.dart` | built `app-prod-release.apk` 60.9 MB, sha1 `7d7f9b29…` | BUILD |
| `flutter build apk --release --flavor staging -t lib/main_staging.dart` | built `app-staging-release.apk` 60.9 MB, sha1 `b7144fe6…` | BUILD |
| `flutter build apk --debug --flavor staging -t lib/main_mock.dart` (the allowed mock form) | built `app-staging-debug.apk` | BUILD |
| `aapt2 dump badging` prod APK | `package: name='com.levelupworld.app'` · `application-label:'Level Up'` · `targetSdkVersion:'36'` · `compileSdkVersion='36'` · permissions INTERNET + ACCESS_NETWORK_STATE (+ AGP's own not-exported self-permission) | ARTEFACT |
| `aapt2 dump badging` staging release APK | `package: name='com.levelupworld.app.stg'` · `application-label:'Level Up STG'` · target 36 | ARTEFACT |
| `aapt2 dump badging` staging debug (mock) APK | `package: name='com.levelupworld.app.stg'` · `application-label:'Level Up STG'` — dev/mock run under the staging identity as decided | ARTEFACT |
| `libapp.so` of the prod APK | 0 × `level-up-backend-staging`, 0 × mock strings, 1 × `TBD.example` (fail-closed placeholder, as intended) | ARTEFACT |
| `flutter build apk --release -t lib/main_prod.dart` (no flavor) | **refused** — Gradle assembles every flavor; `compileFlutterBuildStagingRelease` fails: "the 'staging' flavor (release) cannot be built from 'lib/main_prod.dart'" | BUILD (negative) |
| `--flavor prod -t lib/main_staging.dart` | **refused** — "the 'prod' flavor (release) cannot be built from 'lib/main_staging.dart'. Allowed: main_prod.dart" | BUILD (negative) |
| `--flavor prod` (no `-t` → `lib\main.dart`) | **refused** — same rule, for `lib\main.dart` (Windows path spelling handled) | BUILD (negative) |
| `--flavor staging -t lib/main_mock.dart` (release) | **refused** — mock is debug/profile only | BUILD (negative) |
| `gradlew :app:assembleProdRelease --dry-run` | graph contains `compileFlutterBuildProdRelease` and no staging compile task; it *does* contain `preStagingReleaseBuild` via the shared `buildCMakeRelease` — which is why the check is not anchored on preBuild | BUILD |
| Play listing URLs for `com.levelupworld.app`, `.stg`, old id | HTTP 404 each — no published app; says nothing about unpublished console records | external, informational |
| CI / hooks | hooks not enabled on this clone; CI never run (R-3) — all CI/hook claims remain SOURCE | SOURCE |
| DEVICE | **not reached** — `adb devices` empty throughout the wave | — |

Observation worth keeping: the Flutter tool did **not** stop a flavorless release build on its own;
Gradle's `assembleRelease` assembled both flavors and the coherence check refused the one that could not
take the single entrypoint. The outcome ("a flavorless build fails") holds, but for that reason, and the
docs say so.

## Identity State

| Platform / environment | Identifier | Display name | State |
| --- | --- | --- | --- |
| Android Development | `com.levelupworld.app.stg` (shares staging by decision) | Level Up STG | ✅ implemented, ARTEFACT (`app-staging-debug.apk` from `main_mock`) |
| Android Staging | `com.levelupworld.app.stg` | Level Up STG | ✅ implemented, ARTEFACT (`app-staging-release.apk`) |
| Android Production | `com.levelupworld.app` | Level Up | ✅ implemented, ARTEFACT (`app-prod-release.apk`); **not registered anywhere yet** |
| iOS Development | `com.levelup.levelUpApp` (template) | Level Up App | ❌ ratified `com.levelupworld.app.stg`; Wave 3 |
| iOS Staging | `com.levelup.levelUpApp` (template) | Level Up App | ❌ ratified `com.levelupworld.app.stg`; Wave 3 |
| iOS Production | `com.levelup.levelUpApp` (template) | Level Up App | ❌ ratified `com.levelupworld.app`; Wave 3 |

Flavor / scheme names: `prod`, `staging` (engineering choice, recorded in D-021). Android `namespace`:
`com.levelup.level_up_app`, unchanged, never shipped.

## Supported Versions

```text
Android (ratified and in code — literals, ARTEFACT-confirmed on three APKs):
Minimum SDK/API: 24
Target SDK:      36
Compile SDK:     36

iOS (ratified; NOT yet in code):
Minimum iOS:       15.0  ratified (D-021 Q4)  — repo still 13.0 (project.pbxproj ×3, AppFrameworkInfo.plist)
Deployment Target: 15.0  ratified             — applied in Wave 3 together with the Podfile
```

Supported versions: **changed by decision, not by code, for iOS** — 13.0 → 15.0 ratified; the repo value
is unchanged until Wave 3. Android numbers unchanged in value; now written explicitly instead of
inherited. Q4 compatibility verification done: every iOS native dependency declares a floor of 12.0 or
13.0 (`ENVIRONMENTS.md` §3.2), so 15.0 is compatible; Android 24/36/36 equals Flutter 3.44.7's defaults.

## Store Readiness

```text
Google Play Readiness:      44%   (was 32%)
Apple App Store Readiness:  20%   (was 18%)
```

Rubric unchanged (frozen); six Play items and one App Store item flipped on evidence: 1a ratified id
(both), 1b distinct staging id (ARTEFACT, Android), 1c dev behaviour defined + implemented (ARTEFACT,
Android), 1d per-environment names (Android), 2b flavors exist (BUILD, Android), 2c coherence enforced by
the build (BUILD, Android — four refused combinations). Nothing moved on signing, listing, backend
production readiness, notifications, CI or DEVICE-level items. The 17 submission blockers in
`store_readiness_audit.md` §19 remain open except the Android half of the identity blocker.

## Risks / Remaining Work

- **Wave 2 (next, unblocked):** Dart boot assertion compiled `Flavor` ⇄ platform flavor (needs a value
  from Gradle, e.g. a `resValue`/`buildConfigField` per flavor); `.example`-in-prod → build-time failure;
  `main_mock` release refusal in Dart (cross-platform); an on-screen `isDev` indicator, now needed because
  dev and staging share one identity; per-flavor website/`/redeem` URL slot (Seif Q7), without hard-coding
  and without putting the planned production URL in code before the contract carries it.
- **Wave 3 (blocked on a Mac with Xcode 26):** two schemes, per-configuration bundle ids, display names,
  13.0 → 15.0, Podfile. Until then iOS ships the template id in one scheme; R-9 stays open-mitigating.
- **DEVICE check pending:** install `app-staging-debug.apk` and a `--flavor prod` debug build side by side
  on the Pixel 8 to confirm two launcher entries with distinct labels (Wave 4, or any session with the
  device). The old `com.levelup.level_up_app` install is now an orphan and can be uninstalled.
- **Registrations (owner + Seif, outside this chapter):** developer accounts and ownership, Play Console
  app record for `com.levelupworld.app`, App Store Connect record, the four Firebase registrations and the
  Firebase project-sharing question, APNs key — nothing may be created in this repo for these before they
  exist; the file slots and guards are ready.
- **Backend dependency unchanged:** the production host is planned, not live, not in `servers:`.
- **Known limits of the new guards:** the text scan does not see a developer's terminal or a command
  split across lines; the dated-record exclusion means a wrong command in a *new* dated file is not seen;
  the Gradle check covers Android only until Wave 2's Dart assertion.
- **CI still never observed** (R-3); the `ci.yml` changes are SOURCE-level and will be proven at the first
  run on `main`.

## Git

- **Branch:** `merged`
- **Commits:** `965c185` `docs(decisions): ratify D-021 …` (DECISIONS.md only) · this wave's
  implementation commit `build(android): …` (14 modified + 3 new files: `android/`, `test/guards/`,
  `tool/`, `.github/`, `.githooks/`, the chapter docs, this report).
- **Working tree status:** the other sessions' 20 modified + 7 untracked files remain uncommitted and
  untouched; `build/` outputs are gitignored; nothing pushed (R-3, owner's call).

Backend status: D-021 is ratified and the Android app now ships as `com.levelupworld.app` (prod) and `com.levelupworld.app.stg` (staging) with the staging flavor still pointed at your staging host; the production base URL stays a fail-closed placeholder until `https://api.level-upworld.com/api/v1` appears in the contract's `servers:` block, and the only backend-side items queued are the four Firebase registrations and the production host announcement, both at your pace.
