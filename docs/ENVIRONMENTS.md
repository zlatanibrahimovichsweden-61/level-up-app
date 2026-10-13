# Environments & Platform Identity — the architecture record

**Chapter:** Environment & Architecture — Identity / Flavors · **Opened:** 2026-10-04 · **Status:** Wave 0
done (2026-10-04); **D-021 ratified 2026-10-06**; **Wave 1 (Android) done 2026-10-06**; **Wave 2 partly built
2026-10-12** (boot assertion, `main_mock` release refusal, environment ribbon — BUILD only: unit / widget / guard tests, see the per-feature levels in §4.4; the
`.example`-in-prod build failure is still OPEN, an owner decision); Waves 3–4 not started.
**Input audit:** `.ai/audits/current/app_identity_environment_audit_2026-10-04.md` (read-only, 2026-10-04).
**Chapter state:** `.ai/audits/current/env_chapter_state.md` · **Readiness rubric:**
`docs/STORE_READINESS_RUBRIC.md` · **Decision:** `docs/DECISIONS.md` D-021 (**ratified 2026-10-06**).

This file is the authoritative description of how the app's environments are identified, configured,
built and guarded. Where it describes a *target*, the target is not yet true of the code and says so.
`docs/WAVE_STATUS.md` wins on wave state; this file wins on environment architecture.

Evidence tags follow `docs/STORE_READINESS.md`: `[REPO]` path:line · `[GOOGLE]`/`[APPLE]` official policy
fetched 2026-10-04 · `[SDK]` read from the pinned Flutter SDK (`C:/flutter`, 3.44.7) · `[CACHE]` read from the
pub cache for the versions in `pubspec.lock` · `[UNKNOWN]` not establishable from the repo.
Verification levels per `WAVE_STATUS.md`: SOURCE → BUILD → ARTEFACT → DEVICE → CI.

---

## 0. Wave 0 verification of the audit (did the audit tell the truth?)

Every claim the chapter rests on was re-checked against files and `git log` on 2026-10-04 before
anything was written. All held; two were sharpened. (State *before* Wave 1 — kept as the record.)

| Audit claim | Re-verified | Evidence |
| --- | --- | --- |
| One Android `applicationId`, `com.levelup.level_up_app`, template TODO still present | ✅ | `android/app/build.gradle.kts:42-43` at `9d5a2ec` `[REPO]` |
| One iOS bundle id, `com.levelup.levelUpApp`, identical in Debug/Profile/Release | ✅ | `ios/Runner.xcodeproj/project.pbxproj:371,550,572` `[REPO]` |
| No `productFlavors` ever existed in Android | ✅ | `git log -S"productFlavors" -- android` → no commits before 2026-10-06 `[REPO]` |
| One Xcode scheme, two xcconfigs that only include `Generated.xcconfig`, no entitlements, no Podfile | ✅ | `ios/Runner.xcodeproj/xcshareddata/xcschemes/` (Runner only); `ios/Flutter/{Debug,Release}.xcconfig`; `ls ios/Runner/*.entitlements` → none `[REPO]` |
| Dart flavor model exists: `enum Flavor { dev, staging, prod }`, three entry points, `-t` is the only selector | ✅ | `lib/core/config/app_config.dart:7,29-35,51-55`; `lib/main_{dev,staging,prod}.dart`; `lib/main.dart:4-6` forwards to dev `[REPO]` |
| Prod host is the reserved placeholder `https://TBD.example/api/v1` | ✅ | `app_config.dart:54` `[REPO]` |
| `isDev` is computed and never read | ✅ | `grep -rn isDev lib` → only `app_config.dart` `[REPO]` |
| Flavors were planned before the first commit with per-flavor bundle-id suffix, base URL and app-name suffix, Android `productFlavors`, iOS schemes | ✅ | `F:\level\laqta\prom.md:280-301` (Prompt 9); `F:\level\level_up\level_up\01_Flutter_Specs\Platform_Specifics.md:21-22` |
| Only the Dart half landed, on Day 0 | ✅ | `5e4a512` 2026-07-22 touches `app_config.dart`, the three mains and `build.gradle.kts` (the latter without flavors) `[REPO]` |
| Identity files never changed since, except signing/backup/INTERNET/host commits | ✅ | `git log -- <identity files>`: `b133bd2`, `3cdab85`, `fffa563`, `67bdcc1`, `b7d0dfb`; none touches an id `[REPO]` |
| Earlier audits flagged the gap and it was never queued or decided | ✅ | `.ai/audits/current/security-performance.md:324-337` (F-9-08); `store_readiness_parts/20_blindspots_play.md:338-352` (BS-D-09); `19_blindspots_apple.md:434-446` (BS-C-13); `docs/DECISIONS.md` D-001…D-020 contain no identity decision `[REPO]` |
| **Sharpened:** the Android id is *unclaimed* on Play | ✅ (2026-09; re-checked 2026-10-06, see §11) | BS-D-09 fetched the Play URL → HTTP 404 |
| **Sharpened:** platform versions were an open question from Day 0 and never answered | ✅ | `00_Project/Open_Questions.md:53` "Android `minSdk`/`targetSdk`, iOS deployment target" — unchecked; `Platform_Specifics.md:27-28` lists it under "Open platform decisions" |

One claim the audit did **not** make and Wave 0 added: the release-entrypoint guard
(`test/guards/workflow_test.dart`, 2026-09-05 form) encoded **"every release build is a production
build"**. A staging release build for QA is legitimate once flavors exist, so Wave 1 evolved the guard
into a *coherence* rule (§6) in the same commit that introduced the flavors.

---

## 1. Environments

| Environment | Purpose | Backend | Dart flavor | Platform identity |
| --- | --- | --- | --- | --- |
| **Development** | daily `flutter run`, the mock harness (`lib/main_mock.dart`), device walks | staging host (`app_config.dart:52`, deliberate since `67bdcc1`) | `Flavor.dev` | **none of its own — runs under the staging identity** (D-021 Q2: two identities, no DEV app) |
| **Staging** | QA against Seif's staging deployment; the only live backend; shared with the web team, test data may be reset | `https://level-up-backend-staging.up.railway.app/api/v1` (contract `servers:`) | `Flavor.staging` | **`com.levelupworld.app.stg` · "Level Up STG"** — Android ✅ (Wave 1), iOS ⏳ (Wave 3) |
| **Production** | store builds | planned `https://api.level-upworld.com/api/v1` — **not live, not in the contract**; the code keeps the fail-closed `https://TBD.example/api/v1` placeholder until the contract's `servers:` block announces it (§10) | `Flavor.prod` | **`com.levelupworld.app` · "Level Up"** — Android ✅ (Wave 1), iOS ⏳ (Wave 3) |

Two real backends are expected (staging, production); the contract currently declares one
(`contract/openapi.yaml:107-109`, 3.28.0-m1). There is **no development backend** (Seif, 2026-10-06, Q6).
Development is a *client-side* distinction (mock overrides, and the Flavor-driven environment ribbon built in
Wave 2 — §4.4) living inside the staging identity. Mapping: non-production app → staging backend; production app → production backend.

---

## 2. Platform identity — RATIFIED (D-021, 2026-10-06)

### 2.0 The decision

Ratified by the owner on 2026-10-06 by forwarding Seif's written answers (Q1–Q3, Q5–Q7) and closing Q4
with the frontend decision `Flutter 3.44.7 · Android 24/36/36 · iOS 15.0`. Recorded verbatim in
`docs/DECISIONS.md` D-021.

| | Production | Non-production (the single staging/QA app) |
| --- | --- | --- |
| Android `applicationId` | `com.levelupworld.app` | `com.levelupworld.app.stg` |
| iOS bundle id | `com.levelupworld.app` | `com.levelupworld.app.stg` |
| Display name | `Level Up` | `Level Up STG` |
| Gradle flavor / Xcode scheme name (engineering, not an identifier) | `prod` | `staging` |
| Dart entrypoints allowed | `lib/main_prod.dart` only | `lib/main_staging.dart`, `lib/main_dev.dart`, `lib/main.dart` (→ dev); `lib/main_mock.dart` in debug/profile only |
| Backend | production (when it exists; §10) | staging |

- The ids derive from the product name and the owned domain `level-upworld.com` (hyphen dropped — illegal
  in a package name), deliberately independent of any person's name and of the company's still-unknown
  legal name. The suffix is **`.stg`**, not `.staging`/`.dev`. The template ids `com.levelup.level_up_app`
  / `com.levelup.levelUpApp` are dropped.
- **No DEV identity and no DEV display name.** `Flavor.dev` is a runtime mode of the staging identity. A
  developer's local build therefore overwrites QA's staging install on a shared device — accepted in Q2.
- **Flavor names are an engineering choice, not part of the decision:** `prod` and `staging` mirror the
  Dart enum and the entrypoint file names, which is what keeps the flavor ⇄ entrypoint rule readable
  (`--flavor staging -t lib/main_staging.dart`). They appear only in build commands and artefact names
  (`app-staging-release.apk`), never in a store or a console, and can be renamed at any time. Flutter
  requires the Android flavor name and the iOS scheme name to equal the `--flavor` value.
- Store registrations and account ownership are **not** decided by D-021 and remain to be coordinated
  (Seif, 2026-10-06, Q1 note).

### 2.1 What is in the code now (SOURCE + ARTEFACT, 2026-10-06)

| Platform | Environment | Identifier | State |
| --- | --- | --- | --- |
| Android | prod | `com.levelupworld.app` | ✅ `android/app/build.gradle.kts` `defaultConfig.applicationId`; ARTEFACT-confirmed by `aapt2 dump badging` on `app-prod-release.apk` (Wave 1 report) |
| Android | staging | `com.levelupworld.app.stg` | ✅ flavor `staging`, `applicationIdSuffix = ".stg"`; ARTEFACT-confirmed on `app-staging-release.apk` |
| Android `namespace` / Kotlin package | — | `com.levelup.level_up_app` | unchanged on purpose — never shipped, never visible |
| iOS | all | `com.levelup.levelUpApp` | ❌ **still the template id** — Wave 3 (needs a Mac with Xcode 26) |
| iOS test target | — | `com.levelup.levelUpApp.RunnerTests` | ❌ Wave 3 |

Display names: Android generated per flavor (`resValue "app_name"`; manifest reads `@string/app_name`) —
✅; iOS `CFBundleDisplayName` "Level Up App" / `CFBundleName` `level_up_app` — ❌ Wave 3.

### 2.2 Why the production identity was an owner decision, not an engineering default (record)

- It is **irreversible at first upload** to any Play track and at App ID registration on Apple
  (BS-D-09, BS-C-13). Firebase app registration is keyed by it (§7).
- The template spellings differed (`level_up_app` vs `levelUpApp`) only because of a template rule, not a
  choice. Nobody had ever confirmed either string was wanted (`RELEASE_SIGNING.md` said "confirm the value
  is the one the business wants **before** generating the production keystore").
- The stores are **the client's developer accounts** (`00_Project/Team_and_Interfaces.md:48`,
  `Platform_Specifics.md:25`).
- The project rule is explicit: "Never invent … A reasonable-looking guess is still a guess"
  (`CLAUDE.md` §1.3 rule 4). Picking a permanent public identifier is that guess.

### 2.3 The questions as asked, and the answers (2026-10-06)

**Q1 — Production identifiers.** Options were (A) ratify the template ids; (B) one shared token under
`com.levelup`; (C) a different organisation prefix. **Answer: C** — `com.levelupworld.app`, same string on
both platforms; non-production `com.levelupworld.app.stg`. (The repo had recommended B-if-a-token-can-be-named,
else A; the owner's prefix is based on the owned domain, which the repo could not know.)

**Q2 — Installable identities per platform.** Options were three (`<prod>`, `.staging`, `.dev`) or two
(dev shares staging). **Answer: two.** Consequence accepted: dev and staging builds overwrite each other on
one device; `Flavor.dev` and `Flavor.staging` are distinguishable only on screen (the Wave 2 ribbon, §4.4).

**Q3 — Display names.** Proposed `Level Up` / `Level Up STG` / `Level Up DEV`. **Answer: the first two;
no DEV name** because there is no DEV identity. iOS truncates home-screen names beyond ~12–14 characters;
both fit.

**Q4 — Supported versions.** Android: **24 / 36 / 36 accepted** as proposed. iOS: Seif's rule was "the
lowest version supported by the pinned Flutter version" (= 13.0 for 3.44.7) and asked the frontend to
state the pin and the resulting number; the **frontend decision chose iOS 15.0** instead of the 13.0
floor as a more appropriate production baseline that still covers the older iPhone generations iOS 15
supports, and asked that the dependency set be verified against 15.0 before implementation. That
verification is §3.2. Final: `Flutter 3.44.7 · Android 24/36/36 · iOS 15.0`.

Seif's reply also answered three questions this chapter had not asked (Q5–Q7); they are inputs, not
decisions of this chapter, and are recorded in §10.

---

## 3. Supported platform versions — ratified (D-021 Q4, 2026-10-06)

```text
Android (in code — literals in android/app/build.gradle.kts since Wave 1):
Minimum:   API 24  (Android 7.0 Nougat)
Target:    API 36  (Android 16)
Compile:   API 36  (Android 16)

iOS (ratified; NOT yet in code — the repo still carries 13.0 until Wave 3):
Minimum:           iOS 15.0
Deployment Target: iOS 15.0
```

`test/guards/android_identity_test.dart` fails the suite if the three Android literals and the three
`API n` lines above disagree, or if any of them goes back to being inherited from `flutter.*`.

### 3.1 Where each number comes from

| Value | Code | Source of the number | Evidence |
| --- | --- | --- | --- |
| Android `compileSdk` 36 | `compileSdk = 36` (literal since Wave 1; was `flutter.compileSdkVersion`) | ratified D-021; equals the Flutter 3.44.7 default | `FlutterExtension.kt:23` `[SDK]` |
| Android `minSdk` 24 | `minSdk = 24` (literal) | ratified; equals the Flutter default and the plugin floor | `FlutterExtension.kt:26` `[SDK]`; §3.2 |
| Android `targetSdk` 36 | `targetSdk = 36` (literal) | ratified; equals the Flutter default; Play requires ≥ 36 | `FlutterExtension.kt:34` `[SDK]`; §3.3 |
| NDK `28.2.13676358` | `ndkVersion = flutter.ndkVersion` (still inherited — a toolchain detail, not a support range) | Flutter default | `FlutterExtension.kt:42` `[SDK]` |
| iOS deployment target | **code: 13.0** — `IPHONEOS_DEPLOYMENT_TARGET = 13.0` ×3 (`project.pbxproj:349,475,526`), `MinimumOSVersion` 13.0 (`ios/Flutter/AppFrameworkInfo.plist:23-24`). **Ratified: 15.0**, applied in Wave 3 together with the Podfile's `platform :ios, '15.0'` | owner decision above the 13.0 floor | SDK template = 13.0; `ios_deployment_target_migration.dart:97-101` raises anything *lower* to 13.0 and leaves higher values alone `[SDK]` |
| Toolchain | AGP 8.11.1, Kotlin 2.2.20 (`settings.gradle.kts`), Gradle 8.14 (wrapper), Java 17 target, Dart 3.12.2 | pinned in repo | `[REPO]` |

ARTEFACT confirmation: the 2026-09-05 release APK/AAB carried min 24 / target 36 / compile 36
(`.ai/audits/current/store_readiness_audit.md:252`); the Wave 1 `app-prod-release.apk` and
`app-staging-release.apk` carry `sdkVersion:'24'` / `targetSdkVersion:'36'` (Wave 1 report).

### 3.2 Dependency floors — and the iOS 15.0 verification the owner asked for

Read from the pub cache for the exact versions in `pubspec.lock` `[CACHE]`; iOS floors re-read on
2026-10-06 from each package's `.podspec` (`platform :ios, 'x'`):

| Package (locked) | Android `minSdk` | iOS floor | ≤ 15.0? |
| --- | --- | --- | --- |
| `shared_preferences_android` 2.4.27 | **24** | — | — |
| `url_launcher_android` 6.3.32 | **24** | — | — |
| `flutter_secure_storage` 10.3.1 | 23 | — | — |
| `connectivity_plus` 7.3.0 | 21 | 12.0 | ✅ |
| `device_info_plus` 13.2.0 | 21 | 12.0 | ✅ |
| `screen_protector` 1.5.3 | 21 | 12.0 | ✅ |
| `jni` / `jni_flutter` (transitive) | 21 | — | — |
| `sqflite_android` 2.4.3 / `sqflite_darwin` 2.4.3+1 (transitive) | 19 | 12.0 | ✅ |
| `flutter_secure_storage_darwin` 0.3.2 | — | 12.0 | ✅ |
| `shared_preferences_foundation` 2.5.6 | — | **13.0** | ✅ |
| `url_launcher_ios` 6.4.1 | — | **13.0** | ✅ |
| Flutter 3.44.7 engine / template | 24 | **13.0** | ✅ |

**Q4 verification result (SOURCE, 2026-10-06):** every native dependency and Flutter itself declare a
floor of 13.0 or lower; a deployment target may be any version ≥ every floor, so **iOS 15.0 is compatible
with the whole current dependency set**. No plugin requires more than 13.0. Android **24 / 36 / 36 is
exactly Flutter 3.44.7's own default triple**, so it is compatible by construction. Caveat on level: this is
a SOURCE check of declared floors; a Mac build (Wave 3) is what turns it into BUILD evidence, and
CocoaPods will warn if any pod's floor is above the target — none is today.

**Android minimum cannot be lower than 24** without downgrading `shared_preferences_android` and
`url_launcher_android`; 24 is also Flutter's own floor. Nothing forces either platform higher; iOS 15.0
is a product choice above the 13.0 floor (it drops iPhone 6/6 Plus/5s-class devices, which stop at iOS 12,
and keeps iPhone 6s and later).

### 3.3 Store requirements (fetched 2026-10-04)

- **Google Play** `[GOOGLE]` (support.google.com/googleplay/android-developer/answer/11926878): since
  2026-08-31 new apps and updates must target **API 36** or higher; an extension to 2026-11-01 can be
  requested; apps targeting ≤ API 34 stop being discoverable on newer devices. **Target 36 passes.**
  The requirement rises roughly yearly; the value must be revisited each August.
- **Apple** `[APPLE]` (developer.apple.com/news/upcoming-requirements): since 2026-04-28 uploads must be
  built with **Xcode 26 / iOS 26 SDK** (a build-machine requirement, not a deployment-target one);
  since 2026-09-09 apps must target **iOS 13 or later**. **15.0 passes with margin** (13.0 passed exactly
  at the floor). Privacy-manifest reasons required since 2024-05-01 (tracked in `STORE_READINESS.md`,
  out of this chapter's scope).

### 3.4 Why the numbers are written explicitly

- Inheriting `flutter.*` meant a routine Flutter upgrade silently changed the supported range and the
  Play compliance posture. Literals make the documented answer and the built answer the same thing, and
  the guard checks that this file and `build.gradle.kts` agree (prose rules decay; mechanised rules hold —
  `ENFORCEMENT.md`). Done in Wave 1.
- iOS holds its value explicitly in `project.pbxproj`; Wave 3 changes 13.0 → 15.0 in the three
  configurations, in `AppFrameworkInfo.plist`, and writes `platform :ios, '15.0'` into the Podfile it
  generates. Flutter's migration only ever *raises* to 13.0, so it will not fight 15.0.

---

## 4. Build command contract

### 4.1 Android — in force since 2026-10-06 (Wave 1)

Every build or run names **both** the flavor and the entrypoint, and they must agree. Gradle enforces the
pairing in the variant's `preBuild` task (`android/app/build.gradle.kts`, "Flavor ⇄ entrypoint
coherence"); a build without `--flavor` makes Gradle assemble *every* flavor (`assembleRelease` =
prod + staging) and the check then refuses whichever flavor cannot take the single entrypoint, so a
flavorless build always fails; and `test/guards/workflow_test.dart` refuses a documented release command that is not a coherent pair.

Daily work (debug):

```bash
flutter run --flavor staging -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor staging -t lib/main_mock.dart
```

A bare `flutter run --flavor staging` compiles `lib/main.dart`, which forwards to dev — allowed and
harmless (staging identity, staging backend). A bare `flutter run` (no flavor) fails: Gradle assembles
both flavors and `prod` refuses `lib/main.dart`.

QA build (the non-production app, installable beside production):

```bash
flutter build apk --release --flavor staging -t lib/main_staging.dart
```

→ `build/app/outputs/flutter-apk/app-staging-release.apk`, package `com.levelupworld.app.stg`, label
"Level Up STG".

Store build (production):

```bash
flutter build appbundle --release --flavor prod -t lib/main_prod.dart
```

→ `build/app/outputs/bundle/prodRelease/app-prod-release.aab`, package `com.levelupworld.app`, label
"Level Up". The APK form (`flutter build apk --release --flavor prod -t lib/main_prod.dart` →
`app-prod-release.apk`) is what CI and `tool/verify_release_manifest.ps1` build as the compile gate.
Both are **unsigned** until `android/key.properties` exists (`RELEASE_SIGNING.md`).

What Gradle refuses (each proven at BUILD level in the Wave 1 report):

| Command | Result |
| --- | --- |
| `flutter build apk --release -t lib/main_prod.dart` (no flavor) | Gradle assembles every flavor (`assembleRelease`); `staging` refuses `lib/main_prod.dart` → build fails. (Observed: the Flutter tool does **not** stop a flavorless build by itself.) |
| `flutter build apk --release --flavor prod -t lib/main_staging.dart` | Gradle: "the 'prod' flavor (release) cannot be built from 'lib/main_staging.dart'" |
| `flutter build apk --release --flavor prod` (no `-t` → `lib/main.dart`) | Gradle: same message, for `lib/main.dart` |
| `flutter build apk --release --flavor staging -t lib/main_mock.dart` | Gradle: the mock entrypoint is debug/profile only |

### 4.2 iOS — target (Wave 3, needs a Mac with Xcode 26)

| Intent | Target command | Identity |
| --- | --- | --- |
| Run staging on a device/simulator | `flutter run --flavor staging -t lib/main_staging.dart` | `com.levelupworld.app.stg`, scheme `staging`, configuration `Debug-staging` |
| Store build | `flutter build ipa --release --flavor prod -t lib/main_prod.dart` | `com.levelupworld.app`, scheme `prod`, configuration `Release-prod` |

Until Wave 3 lands, iOS has one scheme and the template id; **no iOS command is documented as runnable**.

### 4.3 Rules the contract makes true (and which wave makes each one true)

1. `--flavor X` and `-t lib/main_X.dart` must agree — **Android: build-time (Wave 1)**; iOS: Wave 3; a
   Dart boot assertion that the compiled `Flavor` agrees with the platform flavor adds a second,
   cross-platform layer — **built 2026-10-12 (Wave 2, BUILD: tests only, never run in a built app; §4.4)**.
2. A release build without `--flavor` fails — **Android: true (Wave 1)**: a flavorless build assembles every
   flavor and the coherence check refuses one of them, because no entrypoint is accepted by both `prod` and
   `staging`.
3. `Flavor.prod` with a `.example` host fails at build time, not at first request — Wave 2.
4. `main.dart` keeps forwarding to dev for `flutter run` convenience: rule 2 makes it harmless (it can
   only run under `--flavor staging`), so it stays. Wave 2's boot assertion does not need it changed:
   `Flavor.dev` accepts the `staging` platform flavor (§4.4).

### 4.4 Wave 2 as built (2026-10-12) — BUILD (unit / widget / guard tests); the level differs per feature, below

Levels use the ladder of `IMPL_RUN_2026-10-12.md` §0 (unit / widget / guard tests are BUILD; an APK is ARTEFACT; an
emulator walk is EMULATOR; nothing here reached DEVICE or CI):

| Feature | Level reached | What was not done |
| --- | --- | --- |
| Boot assertion (`bootstrap` → `AppConfig.verifyPlatformFlavor`) | **BUILD only**: the pure mapping is unit-tested, its call and ORDER are pinned by a guard; the `verify_guards.ps1` probe added for it (which would prove the guard can fail) was only parse-checked; no run of it is recorded | Never run in a built app. The one APK built in this run starts from `main_mock.dart`, which calls `AppConfig.init(Flavor.dev)` itself and does not go through `bootstrap`, so it never exercised the assertion; the real `appFlavor` under `--flavor` was never observed |
| `main_mock` release refusal | **BUILD only**: source plus a guard and a (parse-checked; no run recorded) `verify_guards.ps1` probe; `kReleaseMode` is false under `flutter test` and in a debug APK | No release build of any entrypoint was made, so the refusal itself never fired |
| Environment ribbon | **BUILD** (widget and pixel tests), **plus one EMULATOR sighting** before the corner pin: the E3 walk of the mock debug APK (ARTEFACT) saw the `DEV` ribbon at the earlier end corner. After the R2c pin to the physical top right it is **BUILD only** | The `STAGING` ribbon and the production absence were never seen on an emulator (the mock entrypoint hard-codes `Flavor.dev`); no DEVICE |

- **Boot assertion** — `bootstrap()` (`lib/bootstrap.dart`) calls `AppConfig.verifyPlatformFlavor(flavor,
  platformFlavor)` as its first statement, before the binding, `AppConfig.init` and `runApp`; the platform
  flavor defaults to `appFlavor` (`package:flutter/services.dart`, the value of `--flavor`). A mismatch throws
  a `StateError` and boot stops with no UI and no copy. The comparison is a **mapping, not an equality**:
  `Flavor.dev` and `Flavor.staging` accept the platform flavor `staging`, `Flavor.prod` accepts `prod`, because
  Android has only the `prod` and `staging` identities and `Flavor.dev` is a runtime mode of the staging one
  (D-021 Q2). An **absent** platform flavor (null: iOS until Wave 3, `flutter run` without `--flavor`,
  `flutter test`) is tolerated. Pure function, unit-tested in `test/core/config/w1_platform_flavor_test.dart`;
  the wiring and its ORDER are pinned by `test/guards/workflow_test.dart` ("the Dart layer of the flavor
  contract"), and `tool/verify_guards.ps1` carries a probe meant to delete the call and show the guard fails (parse-checked only: the script edits files, and no run of it is recorded in the ledger).
- **Mock refusal** — `lib/main_mock.dart` throws when `kReleaseMode`, as the first statement of `main()`:
  before the binding, before `AppConfig.init`, before the token wipe. Gradle already refuses the build on
  Android; this is the cross-platform layer. Pinned by the same guard group and a second
  `verify_guards.ps1` probe (also with no run recorded). (`kReleaseMode` is false under `flutter test`, so the refusal itself is
  checked at source level only; no release build was run and it has never fired.)
- **Environment ribbon** — `EnvironmentRibbon` (`lib/app.dart`, wired into the `MaterialApp.router` builder): a
  stock Flutter `Banner` reading **`AppConfig.maybeInstance?.flavor`** (not `isDev`, which is true for dev and
  staging alike). It shows `DEV` / `STAGING` (the flavor's name upper-cased — no `Text`, no string literal, no
  ARB key) on `Flavor.dev` and `Flavor.staging` only; production, and any harness that never initialised
  `AppConfig`, get the child untouched. Colour: the existing `AppColors.destructive` (one value on both
  canvases; no new token). Corner (**superseded 2026-10-12: now pinned to the physical top right, see the next bullet**): **top end** (top-left in Arabic) — Flutter's banner paints a 45-degree band
  over roughly 40 ≤ x + y ≤ 57 dp from that corner (read from `banner.dart`), i.e. over the OS status icons and
  the margin around them; the app's own controls keep **at least 20dp** clear of the edge and start below the
  status bar, and the closest one (the stadium-shaped language pill) has its nearest painted point about 39dp
  plus the status-bar height from the corner, past the band's outer edge on any status bar of about 18dp or
  more. That is layout reasoning, **not a device check**. The bottom corners were rejected because the first and
  last navigation tabs sit there. It paints only (its painter reports no hit), so it never intercepts a tap —
  tested. Tests: `test/core/config/w1_env_indicator_test.dart`.
- **Ribbon corner, pinned (2026-10-12, R2c) — BUILD; not seen on an emulator or device after the pin.** The emulator walk (E3, EMULATOR level, the mock build with the earlier end corner) saw the ribbon at the top LEFT over the OS clock in Arabic. `layoutDirection` and `textDirection` are now pinned to `ltr`, so the corner is physically the **top right in both app languages** (`test/core/config/w1_env_indicator_test.dart`, 14 tests, pixels included). **Caveat:** that assumes a left-to-right SYSTEM language; on an Arabic-system phone the OS may mirror its clock to the top right and the ribbon would then cover it in both app languages. Not checked on any device; pinned by a "KNOWN LIMIT" test; owner decision `COMPLETION_STATE.md` O-20, `docs/DECISIONS.md` D-028.
- **What a boot-assertion mismatch looks like** — `main_dev.dart`, `main_staging.dart` and `main_prod.dart` are
  `void main() => bootstrap(...)`, so the `StateError` surfaces as an unhandled async error, not a visible
  crash: nothing after it runs (no binding, no `AppConfig.init`, no `runApp`), so it fails closed, but to a
  tester it is most likely a blank launch with no on-screen signal. This is a SOURCE-level expectation; when a
  `--flavor` build is first run on a device (BUILD/DEVICE level), check what the tester actually sees and
  whether the platform log is enough.
- **Still OPEN (owner decision, not built):** the `.example`-in-prod build failure (rule 3 above) — the
  placement of that check was never settled, and `Flavor.prod`'s host is still the fail-closed placeholder.

---

## 5. Environment safety invariants (what must be impossible to ship)

| Forbidden combination | Android today | iOS today | Remaining enforcement |
| --- | --- | --- | --- |
| staging flavor + production configuration | **impossible at build** — Gradle refuses `--flavor staging -t lib/main_prod.dart` | not expressible (no schemes) | Dart boot assertion flavor ⇄ `Flavor` **built 2026-10-12** (BUILD: tests only, never run in a built app, §4.4); Wave 3: iOS schemes |
| production flavor + development/staging API | **impossible at build** — `prod` compiles `main_prod.dart` only; no flavor → refused | possible (template; `-t` is the only selector) | boot assertion **built 2026-10-12** — but with no iOS platform flavor it TOLERATES an absent one, so on iOS it cannot yet catch this; Wave 3 schemes close it |
| production build + `.example` host | possible (build succeeds; app fails closed at runtime) | same | Wave 2: release build of `prod` fails if `_baseUrlFor(prod)` matches `.example` |
| staging identity + production Firebase | **guarded (vacuous until Firebase exists):** `android_identity_test.dart` checks a per-flavor `google-services.json` names its own id and none sits in `src/main` | none | Wave 3: the iOS equivalent for `GoogleService-Info.plist` |
| release build from the mock entrypoint | **impossible at build** — `main_mock.dart` is allowed in debug/profile only | possible at build | `main_mock.dart` refuses to run when `kReleaseMode` (cross-platform) — **built 2026-10-12** (BUILD: source + guard, never run in a release build; §4.4) |

---

## 6. Integration with existing safeguards (reuse, do not duplicate)

| Mechanism | Before Wave 1 | Now |
| --- | --- | --- |
| `tool/validate.{ps1,sh}` — format, analyze, full suite | the one command | unchanged; the new guards live in `test/guards/` and ride along |
| `test/guards/workflow_test.dart` release-entrypoint rule | `-t lib/main_prod.dart` on every store-artefact command in repo text | **evolved:** every runnable store-artefact command carries `--flavor X` and a `-t` that matches X (`prod`→`main_prod`; `staging`→`main_staging`/`main_dev`); no flavor, no `-t`, unknown flavor or a mismatch is an offender; dated records (`*_YYYY-MM-DD.md`) are history and skipped; the detector itself is unit-tested against literal good/bad commands |
| `test/guards/android_identity_test.dart` | — | **new:** ratified `applicationId`, exactly the two flavors, `.stg` suffix, per-flavor names, manifest reads `@string/app_name`, Gradle coherence check present, SDK literals = this file's §3, Firebase-slot rules |
| `tool/verify_guards.ps1` | 8 probes | **11 probes:** the release-command probe now reintroduces the *post-flavor* regression (right entrypoint, no `--flavor`); new probes for a `prod`/`main_staging` mismatch and for reverting `applicationId` to the template value |
| `tool/verify_release_manifest.ps1` | built `app-release.apk`, checked INTERNET | builds `app-prod-release.apk` with `--flavor prod`; checks INTERNET **and** `package: name='com.levelupworld.app'` via `aapt2 dump badging` |
| `.github/workflows/ci.yml` `build-release-apk` | APK, unsigned, `main` only | `--flavor prod -t lib/main_prod.dart`; asserts the package is `com.levelupworld.app` before the INTERNET check; AAB in Wave 4 |
| `.githooks/pre-push` | validated only for `lib/ test/ pubspec* l10n analysis dart_test .flutter-version` | **also** `android/ ios/ tool/ .github/ .githooks/` — the trees the guards read |
| `.githooks/pre-commit` | format + analyze staged Dart | unchanged |
| `docs/ENFORCEMENT.md` | listed every mechanised rule | gained the evolved rule and three identity rows |
| `docs/RELEASE_SIGNING.md` | cited the template id as "settled" | cites D-021; command carries `--flavor prod` |

Hooks are **not enabled on this clone** (`git config core.hooksPath` unset — re-checked 2026-10-06). CI
has never been observed running (R-3). Both facts cap every CI/hook claim in this chapter at SOURCE level
until proven otherwise.

---

## 7. The Firebase / FCM slot (not implemented in this chapter)

The contract declares `PUT /me/fcm-token` as `x-stability: stable` (`openapi.yaml:896-900`), the briefs
plan FCM push, and Firebase registration is keyed by `applicationId` / bundle id. Seif's position on
2026-10-06 (Q7): the backend holds **no Firebase credential in any environment**, sends **no push today**
(the sender is not built), Firebase project ownership and app registration are **not yet coordinated**,
whether the two flavors share one Firebase project is **not finalised**, and iOS push will additionally
need an APNs key from the Apple developer account. *Treat push as not ready until told otherwise.*

- The four registrations that will be needed: Android `com.levelupworld.app` and `com.levelupworld.app.stg`;
  iOS `com.levelupworld.app` and `com.levelupworld.app.stg`.
- Reserved locations, so nothing is invented later: `android/app/src/prod/google-services.json` and
  `android/app/src/staging/google-services.json` (Gradle picks the flavor source set automatically);
  `ios/Runner/Firebase/prod/GoogleService-Info.plist` and `ios/Runner/Firebase/staging/GoogleService-Info.plist`
  copied by a scheme-specific build phase (Wave 3). These files are **not secrets** in Google's model but
  are environment-specific and must never be shared across flavors; `android_identity_test.dart` already
  checks the Android half and refuses a file in `src/main`.
- `pubspec.yaml` has no Firebase packages. Adding them is a separate chapter.

---

## 8. Wave plan

| Wave | Name | Scope | Blocked by | Status |
| --- | --- | --- | --- | --- |
| **0** | Architecture & identity decision | this document, rubric, D-021 proposal, risk R-9 | — | **done 2026-10-04** |
| **1** | Android environment architecture | `flavorDimensions("env")`, flavors `prod`/`staging`, `.stg` suffix, `resValue app_name`, label → `@string/app_name`, SDK literals, Gradle flavor ⇄ entrypoint check, guard evolution + identity guard, `ci.yml` + `tool/` updates, `pre-push` trigger list, `RELEASE_SIGNING.md` correction | D-021 (ratified 2026-10-06) | **done 2026-10-06** — BUILD + ARTEFACT on Windows; DEVICE not reached (no device attached during the wave) |
| **2** | Flutter environment contract | boot assertion compiled `Flavor` ⇄ platform flavor, `.example`-in-prod build-time failure, `isDev` indicator (dev vs staging are now distinguishable only on screen), `main_mock` release refusal (cross-platform), guard tests for each. **No website/redeem URL slot** — see §10 and `RISKS.md` R-10 | Wave 1 | **partly built 2026-10-12** (§4.4): boot assertion, `main_mock` release refusal, environment ribbon (Flavor-driven, not `isDev`) and their guard tests — per feature (§4.4): the assertion and the `main_mock` refusal at BUILD only (unit / guard tests, never run in a built app); the ribbon at BUILD plus one EMULATOR sighting in the mock build before the corner pin; no release build, no DEVICE, no CI. **OPEN, owner decision:** the `.example`-in-prod build failure |
| **3** | iOS environment architecture | two schemes `prod`/`staging`, `Debug/Release/Profile-<flavor>` configurations, per-flavor `xcconfig` with `PRODUCT_BUNDLE_IDENTIFIER` and display name, `Info.plist` reads them, deployment target 13.0 → **15.0** (×3 + `AppFrameworkInfo.plist`), Podfile generated with `platform :ios, '15.0'` and committed, `knownRegions` + `ar`, iOS half of the Firebase-slot guard; **input R-11:** the Xcode archive's Privacy Report is the only proof that no undeclared required-reason API remains after the `device_info_plus` replacement (`RISKS.md` R-11, reconciliation O-3) | **a Mac with Xcode 26** | **blocked on this machine** — SOURCE-level authoring possible here, BUILD is not |
| **4** | Cross-platform validation & release safety | AAB in CI, signing-secret injection design (no secrets committed), first observed CI run (R-3), DEVICE check of both Android identities side by side, rubric re-score, final chapter report | Waves 1–2 (Android), 3 (iOS) | not started |

---

## 9. Historical record

| Date | Event | Evidence |
| --- | --- | --- |
| before 2026-07-22 | Flavors specified: 3 flavors, bundle-id suffix, base URL, app-name suffix, `productFlavors`, iOS schemes; platform versions listed as an open decision | prom.md Prompt 9; `Platform_Specifics.md:21-28`; `Open_Questions.md:53` |
| 2026-07-22 | Day 0 scaffold lands the Dart half only; commit body empty; no record of deferring the Gradle/Xcode half | `5e4a512`, `9e094d7`, `57cc8f0` |
| 2026-07-30 | Release signing made fail-closed; the id is referred to but not decided | `b133bd2`; `RELEASE_SIGNING.md` |
| 2026-08-14 | Audit F-9-08: "Android product flavors are not wired … settle the final applicationId before the production keystore … do it now, not later"; F-1-12 same | `security-performance.md:324-337`; `architecture.md` |
| 2026-08-22 | Dev and staging pointed at the real staging host; prod left at `.example` on purpose | `67bdcc1` body |
| 2026-09-05 | Flagless release build ARTEFACT-proven to ship the staging host; `-t` guard added; audit §2 records "no Gradle product flavors and no iOS schemes" | `STORE_READINESS_AUDIT_2026-09-05.md` |
| 2026-09 | Store audit BS-D-09 / BS-C-13 / IOS-17 ask for the id decision; Play URL 404 (unclaimed) | `store_readiness_parts/19,20` |
| 2026-10-04 | Identity audit; chapter opened; D-021 proposed; Wave 0 | `f4cd5a9`, `9d5a2ec` |
| 2026-10-06 | **D-021 ratified** — Seif's written answers (Q1 C with exact ids, Q2 two, Q3 names, Q5–Q7 backend positions) forwarded by the owner, who closed Q4 (`Flutter 3.44.7 · Android 24/36/36 · iOS 15.0`) | `DECISIONS.md` D-021 |
| 2026-10-06 | **Wave 1** — Android flavors, ids, names, SDK literals, Gradle coherence check, guards, CI/tool/hook updates | Wave 1 commits; `env_wave1_report.md` |

No commit, decision entry or brief records a reason for omitting the platform half in July. The evidence
supports "not reached" rather than "rejected"; this record does not claim more than that.

---

## 10. Deferred work and inputs received (belong to later waves or other chapters)

**From Seif, 2026-10-06 (answers Q5–Q7 — inputs, not decided here; extended and in part superseded by his reply of 2026-10-09 — Firebase, production host, APNs, test data — see `docs/BACKEND_HANDOFF.md` §A, §G, §H):**

- **Production API base URL — planned, not live:** host `api.level-upworld.com`, so the planned base URL is
  `https://api.level-upworld.com/api/v1` (the path is carried over from today's contract, not separately
  confirmed). Nothing is deployed there, DNS is unverified, it is **not** in the contract's `servers:` list,
  and there is no date. **The contract remains the announcement channel:** when production is up, the URL
  is added to `servers:` and announced in `contract-changelog.md`. Until then the production base URL stays
  per-flavor configuration that **cannot ship by accident** — today the build-failing-at-runtime
  `.example` placeholder; Wave 2 makes a `.example` prod release fail at *build* time. **Do not put the
  planned URL into `app_config.dart` on the strength of this note.**
- **Public website host and the `/redeem` hand-off — DO NOT BUILD (R-10).** Seif's Q7 note says the app
  "opens the website's `/redeem` page in the browser" and re-reads `GET /api/v1/me/entitlements` on return,
  with the host `level-upworld.com` (decided, not live) in per-flavor configuration. **This contradicts the
  contract:** `contract/contract-changelog.md:360` (adr-049 §3) — the app "never carries a purchase link, and
  never tells the student where to buy", deletes the "refetch on return from a hand-off" moment, and makes
  `POST /subscription-codes/redemptions` the only commerce operation (redemption is an API call, not a web
  page). The contract wins. An earlier revision of this bullet listed the slot as Wave 2 work; that was
  wrong and is withdrawn. Recorded as **`RISKS.md` R-10 (OPEN — DECISION, owner + Seif)** and in
  `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md` O-4 / Q-B10: nothing is built until
  Seif revises the rule in a changelog entry *and* the owner accepts the Apple 3.1.1 exposure. No
  per-flavor URL slot for it exists or is planned in this chapter.
- **No deep links / app links in release 1** — no `assetlinks.json`, no `apple-app-site-association`, no
  custom scheme. Nothing for the flavors to declare.
- **No CORS, no OAuth redirect URIs** (phone + OTP only), **no id checks on API requests**, **one device per
  account enforced server-side.**
- **Firebase / push:** see §7 — not ready; registrations and ownership to be coordinated.

**Deferred to other chapters / owners:**

- Production host in the contract `servers:` block — Seif (`seif_fight.md`).
- Firebase project + the four registrations; FCM client; APNs key — after Waves 1 and 3, and after Seif
  says push is ready.
- Keystore generation, Play App Signing enrolment, App Store Connect record, developer-account decision,
  store/account ownership arrangements — owner + Seif; `RELEASE_SIGNING.md`, `STORE_READINESS.md`.
- Deploy workflows (`deploy_android.yml`, `deploy_ios.yml`, Fastlane) — after Wave 4.
- Store metadata, per-flavor icon badge beyond the name suffix, privacy policy, account deletion — other
  chapters (`STORE_READINESS.md` scorecard).
- Android 13+ themed icon (`<monochrome>` layer absent) — launcher-icon work, not an environment item.
- `screen_protector` iOS 26 crash report (store audit IOS-19) — not an environment item.
- `device_info_plus` reads a required-reason API (DiskSpace) on iOS with an empty plugin privacy manifest
  (`RISKS.md` R-11, reconciliation O-3) — a store-readiness/privacy item owned by the device-binding code,
  not by this chapter; Wave 3 only *proves* the outcome via the archive's Privacy Report.
- Uninstalling the old `com.levelup.level_up_app` debug install from the test devices (it is now an
  orphan package; the new identities install beside it).

---

## 11. Uncertainties carried forward

- **Play listing check, 2026-10-06:** `https://play.google.com/store/apps/details?id=` returns HTTP 404 for
  `com.levelupworld.app`, `com.levelupworld.app.stg` and the old `com.levelup.level_up_app`. This proves no
  *published* app uses the ids; it cannot see an unpublished Play Console record held by someone else.
  The id is reserved for real only when the client's Play Console creates the app record.
- iOS is SOURCE-only from this machine; Wave 3's BUILD/ARTEFACT levels require a Mac with Xcode 26. The
  iOS 15.0 compatibility statement in §3.2 is a SOURCE check of declared floors.
- CI has never run (R-3); every CI statement here is SOURCE. Hooks are not enabled on this clone.
- No Android device was attached during Wave 1, so the two identities installing side by side is
  ARTEFACT-level (two APKs with distinct `package:` lines), not DEVICE-level. Wave 4 closes it.
- The Egyptian student device share below API 24 and below iOS 15 is `[UNKNOWN]`; both floors are now
  owner decisions, not engineering constraints.
- The contract pin is 3.28.0-m1 (`contract/SOURCE.md`); Seif's note says nothing in his reply changes the
  published contract.
