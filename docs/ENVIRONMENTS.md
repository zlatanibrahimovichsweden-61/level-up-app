# Environments & Platform Identity — the architecture record

**Chapter:** Environment & Architecture — Identity / Flavors · **Opened:** 2026-10-04 · **Status:** Wave 0
complete (decision pending); Waves 1–4 not started.
**Input audit:** `.ai/audits/current/app_identity_environment_audit_2026-10-04.md` (read-only, 2026-10-04).
**Chapter state:** `.ai/audits/current/env_chapter_state.md` · **Readiness rubric:**
`docs/STORE_READINESS_RUBRIC.md` · **Decision:** `docs/DECISIONS.md` D-021 (proposed, not ratified).

This file is the authoritative description of how the app's three environments are identified,
configured, built and guarded. Where it says **DECISION PENDING**, nothing has been chosen and nothing
has been implemented. Where it describes a *target*, the target is not yet true of the code and says
so. `docs/WAVE_STATUS.md` wins on wave state; this file wins on environment architecture.

Evidence tags follow `docs/STORE_READINESS.md`: `[REPO]` path:line · `[GOOGLE]`/`[APPLE]` official policy
fetched 2026-10-04 · `[SDK]` read from the pinned Flutter SDK (`C:/flutter`, 3.44.7) · `[CACHE]` read from the
pub cache for the versions in `pubspec.lock` · `[UNKNOWN]` not establishable from the repo.
Verification levels per `WAVE_STATUS.md`: SOURCE → BUILD → ARTEFACT → DEVICE → CI.

---

## 0. Wave 0 verification of the audit (did the audit tell the truth?)

Every claim the chapter rests on was re-checked against files and `git log` on 2026-10-04 before
anything was written. All held; two were sharpened.

| Audit claim | Re-verified | Evidence |
| --- | --- | --- |
| One Android `applicationId`, `com.levelup.level_up_app`, template TODO still present | ✅ | `android/app/build.gradle.kts:42-43` `[REPO]` |
| One iOS bundle id, `com.levelup.levelUpApp`, identical in Debug/Profile/Release | ✅ | `ios/Runner.xcodeproj/project.pbxproj:371,550,572` `[REPO]` |
| No `productFlavors` ever existed in Android | ✅ | `git log -S"productFlavors" -- android` → no commits `[REPO]` |
| One Xcode scheme, two xcconfigs that only include `Generated.xcconfig`, no entitlements, no Podfile | ✅ | `ios/Runner.xcodeproj/xcshareddata/xcschemes/` (Runner only); `ios/Flutter/{Debug,Release}.xcconfig`; `ls ios/Runner/*.entitlements` → none `[REPO]` |
| Dart flavor model exists: `enum Flavor { dev, staging, prod }`, three entry points, `-t` is the only selector | ✅ | `lib/core/config/app_config.dart:7,29-35,51-55`; `lib/main_{dev,staging,prod}.dart`; `lib/main.dart:4-6` forwards to dev `[REPO]` |
| Prod host is the reserved placeholder `https://TBD.example/api/v1` | ✅ | `app_config.dart:54` `[REPO]` |
| `isDev` is computed and never read | ✅ | `grep -rn isDev lib` → only `app_config.dart` `[REPO]` |
| Flavors were planned before the first commit with per-flavor bundle-id suffix, base URL and app-name suffix, Android `productFlavors`, iOS schemes | ✅ | `F:\level\laqta\prom.md:280-301` (Prompt 9); `F:\level\level_up\level_up\01_Flutter_Specs\Platform_Specifics.md:21-22` |
| Only the Dart half landed, on Day 0 | ✅ | `5e4a512` 2026-07-22 touches `app_config.dart`, the three mains and `build.gradle.kts` (the latter without flavors) `[REPO]` |
| Identity files never changed since, except signing/backup/INTERNET/host commits | ✅ | `git log -- <identity files>`: `b133bd2`, `3cdab85`, `fffa563`, `67bdcc1`, `b7d0dfb`; none touches an id `[REPO]` |
| Earlier audits flagged the gap and it was never queued or decided | ✅ | `.ai/audits/current/security-performance.md:324-337` (F-9-08); `store_readiness_parts/20_blindspots_play.md:338-352` (BS-D-09); `19_blindspots_apple.md:434-446` (BS-C-13); `docs/DECISIONS.md` D-001…D-020 contain no identity decision `[REPO]` |
| **Sharpened:** the Android id is *unclaimed* on Play | ✅ (as of 2026-09) | BS-D-09 fetched the Play URL → HTTP 404 on its date. Not re-fetched in Wave 0; the window is still believed open `[UNKNOWN today]` |
| **Sharpened:** platform versions were an open question from Day 0 and never answered | ✅ | `00_Project/Open_Questions.md:53` "Android `minSdk`/`targetSdk`, iOS deployment target" — unchecked; `Platform_Specifics.md:27-28` lists it under "Open platform decisions" |

One claim the audit did **not** make and Wave 0 adds: the existing release-entrypoint guard
(`test/guards/workflow_test.dart:234`) encodes **"every release build is a production build"**. A
staging release build for QA (`--flavor staging -t lib/main_staging.dart`) is legitimate once flavors
exist, and the guard as written would reject the documented command. The guard must evolve into a
*coherence* rule (§6.3) in the same wave that introduces flavors, or the two will fight.

---

## 1. Environments

| Environment | Purpose | Backend host today | Dart flavor | Exists as a platform identity? |
| --- | --- | --- | --- | --- |
| **Development** | daily `flutter run`, the mock harness (`lib/main_mock.dart`), device walks | staging host (`app_config.dart:52`, deliberate since `67bdcc1`) | `Flavor.dev` | **No** — shares the single id |
| **Staging** | QA against Seif's staging deployment; the only live backend | `https://level-up-backend-staging.up.railway.app/api/v1` (contract `servers:`) | `Flavor.staging` | **No** — shares the single id |
| **Production** | store builds | `https://TBD.example/api/v1` placeholder — fails closed | `Flavor.prod` | **Yes, by default** — the single id *is* whatever ships |

Two real backends are expected (staging, production); the contract currently declares one
(`contract/openapi.yaml:107-109`, 3.28.0-m1). Development is a *client-side* distinction (mock
overrides, future `isDev` indicator), not a backend. Whether it deserves its own installable identity
is part of D-021 (§2.3).

---

## 2. Platform identity — DECISION PENDING (D-021)

### 2.1 What is in the code today (SOURCE + ARTEFACT)

| Platform | Environment | Identifier today | Origin |
| --- | --- | --- | --- |
| Android | dev / staging / prod | `com.levelup.level_up_app` | `flutter create --org com.levelup` (prom.md Prompt 0); project name `level_up_app` snake-cased |
| iOS | dev / staging / prod | `com.levelup.levelUpApp` | same template run; project name camel-cased because `_` is illegal in a bundle id |
| iOS test target | — | `com.levelup.levelUpApp.RunnerTests` | template |
| Android `namespace` / Kotlin package | — | `com.levelup.level_up_app` | template; **does not need to change** whatever the `applicationId` becomes |

Display names today: Android `android:label="level_up_app"` (`AndroidManifest.xml:27`, no `strings.xml`);
iOS `CFBundleDisplayName` "Level Up App", `CFBundleName` `level_up_app` (`Info.plist`).

### 2.2 Why the production identity is an owner decision, not an engineering default

- It is **irreversible at first upload** to any Play track and at App ID registration on Apple
  (BS-D-09, BS-C-13). Firebase app registration is keyed by it (§7).
- The two spellings differ (`level_up_app` vs `levelUpApp`) only because of a template rule, not a
  choice. Nobody has ever confirmed either string is wanted (`RELEASE_SIGNING.md:80-85` says "confirm
  the value is the one the business wants **before** generating the production keystore").
- The stores are **the client's developer accounts** (`00_Project/Team_and_Interfaces.md:48`,
  `Platform_Specifics.md:25`); the org token `com.levelup` presumes the client controls or accepts
  that reverse-DNS. Whether the client owns a `levelup.*` domain is `[UNKNOWN]` (legal URLs in the app
  are `levelup.example` placeholders).
- The project rule is explicit: "Never invent … A reasonable-looking guess is still a guess"
  (`CLAUDE.md` §1.3 rule 4). Picking a permanent public identifier is that guess.

### 2.3 The decision the owner must make (copy of D-021's question)

**Q1 — Production identifiers.** One of:

| Option | Android prod | iOS prod | Cost / consequence |
| --- | --- | --- | --- |
| **A. Ratify the template ids as-is** | `com.levelup.level_up_app` | `com.levelup.levelUpApp` | Zero code change for prod; the ARTEFACT evidence of 2026-09-05 stays valid; two differently-spelled identities for the life of the product (every console, CI secret, Firebase app, crash report). Underscore is legal on Play, illegal on Apple, so they can never match. |
| **B. One shared spelling on both platforms** | `com.levelup.<token>` | `com.levelup.<token>` | `<token>` must be lowercase, letters/digits only (no `_`, no `-`, so it is legal on both stores and in Firebase). **The token is the owner's to supply** — nothing in the repo or briefs names one. Android `namespace`/Kotlin package stay `com.levelup.level_up_app`; only `applicationId` and `PRODUCT_BUNDLE_IDENTIFIER` change. One sentence of rework per console forever avoided. |
| **C. A different organisation prefix** | `<rdns>.<token>` | `<rdns>.<token>` | Only if the client does not accept `com.levelup`. Same mechanics as B. |

Engineering recommendation: **B if the owner can name the token; otherwise A.** Both are cheap today;
neither is cheap after the first upload. Do not let this default to A by inaction.

**Q2 — How many installable identities per platform: two or three?**

| Option | Android | iOS | Notes |
| --- | --- | --- | --- |
| **3 (recommended, matches the Dart model and the Day-0 spec)** | `<prod>` · `<prod>.staging` · `<prod>.dev` | `<prod>` · `<prod>.staging` · `<prod>.dev` | Dev, staging and prod can sit on one phone. Dev gets a visibly different package so a mock/dev install can never be mistaken for QA's staging build. Cost: one extra Apple App ID registration (free, admin only); one extra Firebase app per platform *when* Firebase lands. |
| **2 (dev shares staging's identity)** | `<prod>` · `<prod>.staging` | `<prod>` · `<prod>.staging` | Fewer registrations; a developer's local build overwrites QA's staging install on a shared device; `Flavor.dev` and `Flavor.staging` become distinguishable only on screen. |

The suffix spelling `.staging` / `.dev` comes from the Day-0 spec ("bundle ID suffix") and the
2026-08-14 audit (F-9-08); it is Android's `applicationIdSuffix` idiom and legal on Apple. The *flavor
names* are fixed by the existing Dart enum: `dev`, `staging`, `prod` — Flutter requires the Android
flavor names and the iOS scheme names to equal the string passed to `--flavor`, so they are not open.

**Q3 — Display names per environment.** The brand is "Level Up" everywhere in the briefs and Figma;
the store name is still an open product item (`store_submission_checklist.md:13` "app name … freeze").
Proposed default, to be confirmed with Q1:

| Environment | Android label / iOS `CFBundleDisplayName` | Note |
| --- | --- | --- |
| prod | `Level Up` | iOS truncates home-screen names beyond ~12–14 characters; "Level Up" fits |
| staging | `Level Up STG` | short enough not to truncate; visibly not production |
| dev | `Level Up DEV` | ditto |

**Q4 (confirm only) — supported OS versions.** §3 proposes the authoritative answer from evidence; it
needs an owner "yes" because `minSdk 24` excludes Android 5.x–6.x devices and that is an audience
question for Egyptian students, not an engineering one.

Until Q1–Q4 are answered, **no identifier changes and no flavors are implemented** (brief §3, §16).

---

## 3. Supported platform versions — the authoritative answer (proposed; Q4 confirms)

```text
Android:
Minimum:   API 24  (Android 7.0 Nougat)
Target:    API 36  (Android 16)
Compile:   API 36  (Android 16)

iOS:
Minimum:           iOS 13.0
Deployment Target: iOS 13.0
```

### 3.1 Where each number comes from

| Value | Code today | Source of the number | Evidence |
| --- | --- | --- | --- |
| Android `compileSdk` 36 | `compileSdk = flutter.compileSdkVersion` (`build.gradle.kts:29`) — **inherited, not pinned** | Flutter 3.44.7 default | `C:/flutter/packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt:23` `[SDK]` |
| Android `minSdk` 24 | `minSdk = flutter.minSdkVersion` (`:46`) — inherited | Flutter 3.44.7 default | `FlutterExtension.kt:26` `[SDK]` |
| Android `targetSdk` 36 | `targetSdk = flutter.targetSdkVersion` (`:47`) — inherited | Flutter 3.44.7 default | `FlutterExtension.kt:34` `[SDK]` |
| NDK `28.2.13676358` | `ndkVersion = flutter.ndkVersion` (`:30`) | Flutter default | `FlutterExtension.kt:42` `[SDK]` |
| iOS deployment target 13.0 | `IPHONEOS_DEPLOYMENT_TARGET = 13.0` ×3 (`project.pbxproj:349,475,526`); `MinimumOSVersion` 13.0 (`ios/Flutter/AppFrameworkInfo.plist:23-24`) | Flutter 3.44.7 floor | SDK template `project.pbxproj.tmpl` = 13.0; `ios_deployment_target_migration.dart:97-101` raises anything lower to 13.0 `[SDK]` |
| Toolchain | AGP 8.11.1, Kotlin 2.2.20 (`settings.gradle.kts`), Gradle 8.14 (wrapper), Java 17 target, Dart 3.12.2 | pinned in repo | `[REPO]` |

ARTEFACT confirmation: the 2026-09-05 release APK/AAB carried min 24 / target 36 / compile 36
(`.ai/audits/current/store_readiness_audit.md:252`).

### 3.2 Dependency floors (can we go lower? are we forced higher?)

Read from the pub cache for the exact versions in `pubspec.lock` `[CACHE]`:

| Package (locked) | Android `minSdk` | iOS floor |
| --- | --- | --- |
| `shared_preferences_android` 2.4.27 | **24** | — |
| `url_launcher_android` 6.3.32 | **24** | — |
| `flutter_secure_storage` 10.3.1 | 23 | — |
| `connectivity_plus` 7.3.0 | 21 | 12.0 |
| `device_info_plus` 13.2.0 | 21 | 12.0 |
| `screen_protector` 1.5.3 | 21 | 12.0 |
| `jni` / `jni_flutter` (transitive) | 21 | — |
| `sqflite_android` 2.4.3 (transitive) | 19 | 12.0 (`sqflite_darwin`) |
| `flutter_secure_storage_darwin` 0.3.2 | — | 12.0 |
| `shared_preferences_foundation` 2.5.6 | — | **13.0** |
| `url_launcher_ios` 6.4.1 | — | **13.0** |

**Android minimum cannot be lower than 24** without downgrading `shared_preferences_android` and
`url_launcher_android`; 24 is also Flutter's own floor. **iOS minimum cannot be lower than 13.0**
(Flutter floor and two plugins). Nothing forces either higher.

### 3.3 Store requirements (fetched 2026-10-04)

- **Google Play** `[GOOGLE]` (support.google.com/googleplay/android-developer/answer/11926878): since
  2026-08-31 new apps and updates must target **API 36** or higher; an extension to 2026-11-01 can be
  requested; apps targeting ≤ API 34 stop being discoverable on newer devices. **Target 36 passes.**
  The requirement rises roughly yearly; the value must be revisited each August.
- **Apple** `[APPLE]` (developer.apple.com/news/upcoming-requirements): since 2026-04-28 uploads must be
  built with **Xcode 26 / iOS 26 SDK** (a build-machine requirement, not a deployment-target one);
  since 2026-09-09 apps must target **iOS 13 or later**. **Deployment target 13.0 passes, exactly at
  the floor.** Privacy-manifest reasons required since 2024-05-01 (tracked in `STORE_READINESS.md`,
  out of this chapter's scope).

### 3.4 Why these values, and what Wave 1 should do with them

- They are the only values the dependency set permits at the bottom and the stores require at the
  top; there is no free choice except *raising* the minimums, which would be a product decision.
- `minSdk 24` excludes Android 5.0–6.0 (2014–2015 devices). Global share of ≤ API 23 is low single
  digits in 2026; the Egyptian student share is `[UNKNOWN]`. This is Q4.
- **Engineering decision for Wave 1 (not an owner item):** write the three Android numbers *explicitly*
  in `build.gradle.kts` instead of inheriting `flutter.*`. Inheriting means a routine Flutter upgrade
  silently changes the supported range and the Play compliance posture; explicit values make the
  documented answer and the built answer the same thing, and a guard can check that this file and
  `build.gradle.kts` agree (prose rules decay; mechanised rules hold — `ENFORCEMENT.md`). iOS already
  holds its value explicitly in `project.pbxproj`.
- No `Podfile` exists yet; the first Mac build will generate one and Flutter will write
  `platform :ios, '13.0'` into it. That value must match this section when it appears.

---

## 4. Build command contract

### 4.1 Today (what actually works at HEAD)

| Intent | Command | What selects the environment |
| --- | --- | --- |
| Run dev | `flutter run -t lib/main_dev.dart` (a bare `flutter run` is the same thing via `lib/main.dart`) | the `-t` file only |
| Run staging | `flutter run -t lib/main_staging.dart` | the `-t` file only |
| Run the mock harness | `flutter run -t lib/main_mock.dart` | the `-t` file only |
| Release APK (prod) | `flutter build apk --release -t lib/main_prod.dart` | the `-t` file only — **omit it and the artefact talks to staging** (ARTEFACT-proven 2026-09-05) |
| Release AAB (prod) | `flutter build appbundle --release -t lib/main_prod.dart` | same |
| iOS | never built; `flutter build ipa --release -t lib/main_prod.dart` is the expected form on a Mac | same |
| CI (`build-release-apk`, `main` only) | `flutter build apk --release --no-pub -t lib/main_prod.dart` (`ci.yml:377`) | same; APK only, unsigned, no upload |

Protection today: `test/guards/workflow_test.dart:234` fails the suite if any runnable store-artefact
command in `docs/ tool/ .github/ .githooks/` lacks `-t lib/main_prod.dart`. It does **not** see a
developer's terminal, and it has no concept of flavors.

### 4.2 Target contract (after Waves 1–3; shown in tables on purpose — see §0, the current guard
would reject fenced staging release commands)

| Intent | Target command | Platform identity produced |
| --- | --- | --- |
| Run dev | `flutter run --flavor dev -t lib/main_dev.dart` | `<prod>.dev` |
| Run staging | `flutter run --flavor staging -t lib/main_staging.dart` | `<prod>.staging` |
| Run mock | `flutter run --flavor dev -t lib/main_mock.dart` | `<prod>.dev` (mock is a dev-flavor overlay) |
| QA build, staging | `flutter build apk --release --flavor staging -t lib/main_staging.dart` → `app-staging-release.apk` | `<prod>.staging` |
| Store build, Android | `flutter build appbundle --release --flavor prod -t lib/main_prod.dart` → `app-prod-release.aab` | `<prod>` |
| Store build, iOS (Mac) | `flutter build ipa --release --flavor prod -t lib/main_prod.dart` | `<prod>` (scheme `prod`, configuration `Release-prod`) |
| CI | the same two store commands, selected by workflow input / branch; staging QA build on `merged`, prod on `main` | — |

Rules the target contract must make true (Wave 2 guards, §6):

1. `--flavor X` and `-t lib/main_X.dart` must agree; a mismatch fails the **build**, not just a text scan.
2. A release build without `--flavor` fails (no implicit flavor, no default `applicationId` for release).
3. `Flavor.prod` with a `.example` host fails at build time, not at first request.
4. `main.dart` keeps forwarding to dev for `flutter run` convenience **only if** rule 2 makes it
   harmless; otherwise it is removed.

---

## 5. Environment safety invariants (what must be impossible to ship)

| Forbidden combination | Today | Target enforcement |
| --- | --- | --- |
| staging flavor + production configuration | not expressible (no flavors) | Gradle: the flavor sets a `FLAVOR` build-config/`resValue`; Dart reads it at boot and asserts it equals `Flavor` (Wave 2) |
| production flavor + development/staging API | possible: `--flavor` absent, `-t` wrong | Dart boot assertion + `main_prod.dart` is the only entry that may run under the `prod` flavor |
| production build + `.example` host | possible today (build succeeds; app fails closed at runtime) | release build of `prod` fails if `_baseUrlFor(prod)` matches `.example` (guard test + build-time check, Wave 2) |
| staging identity + production Firebase | not applicable (no Firebase) | per-flavor `google-services.json` / `GoogleService-Info.plist` directories (§7); a guard that the file's `package_name` / `BUNDLE_ID` equals the flavor's id |
| release build from the mock entrypoint | possible | `main_mock.dart` refuses to run when `kReleaseMode` (Wave 2) |

---

## 6. Integration with existing safeguards (reuse, do not duplicate)

| Mechanism | Today | Chapter change |
| --- | --- | --- |
| `tool/validate.{ps1,sh}` — format, analyze, full suite | the one command; CI and `pre-push` route through it | unchanged; new guards live in `test/guards/` so they ride along |
| `test/guards/workflow_test.dart` release-entrypoint rule | `-t lib/main_prod.dart` on every store-artefact command in repo text | **evolves** into: every store-artefact command carries `--flavor X` *and* `-t lib/main_X.dart` with equal X; release without `--flavor` is an offender (Wave 1, same commit as the flavors) |
| `tool/verify_guards.ps1` probe 7 | mutates `RELEASE_SIGNING.md`'s command to prove the guard fails | probe updated to the new command and a second probe for a flavor/entry mismatch |
| `tool/verify_release_manifest.ps1` | builds `app-release.apk` and checks INTERNET via aapt2 | path becomes `app-prod-release.apk`; adds a `package:` check against the ratified id |
| `.github/workflows/ci.yml` `build-release-apk` | APK, unsigned, `main` only, path `app-release.apk` | `--flavor prod`, artefact path update, `aapt2 dump badging` asserts `package='<prod id>'`; AAB in Wave 4 |
| `.githooks/pre-push` | runs `validate.sh` only when `lib/ test/ pubspec* l10n analysis dart_test .flutter-version` change | **gap:** `android/`, `ios/`, `.github/`, `tool/` edits skip validation; Wave 1 adds `android/` and `ios/` to the trigger list |
| `.githooks/pre-commit` | format + analyze staged Dart | unchanged |
| `docs/ENFORCEMENT.md` | lists every mechanised rule | gains the new guards (Wave 1/2) |
| `docs/RELEASE_SIGNING.md` | Android-only, cites the current id as "settled" | corrected to point at D-021 (Wave 1) |

Hooks are **not enabled on this clone** (`git config core.hooksPath` is unset — `branch-topology`
memory, re-checked 2026-10-04). CI has never been observed running (R-3). Both facts cap every CI/hook
claim in this chapter at SOURCE level until proven otherwise.

---

## 7. The Firebase / FCM slot (not implemented in this chapter)

The contract already declares `PUT /me/fcm-token` as `x-stability: stable` (`openapi.yaml:896-900`),
the briefs plan FCM push (`00_project_brief_and_team_model.md:33`, prom.md Prompt 51), and Firebase
registration is keyed by `applicationId` / bundle id. Therefore:

- Firebase must **not** be created until D-021 is ratified and Waves 1 and 3 have landed the ids.
- Reserved locations, so nothing is invented later: `android/app/src/<flavor>/google-services.json`
  (one per flavor; Gradle picks the source set automatically) and
  `ios/Runner/Firebase/<flavor>/GoogleService-Info.plist` copied by a scheme-specific build phase.
  These files are **not secrets** in Google's model but are environment-specific and must never be
  shared across flavors; the guard in §5 checks the embedded id.
- `pubspec.yaml` has no Firebase packages today (`grep firebase pubspec.yaml` → none). Adding them is a
  separate chapter.

---

## 8. Wave plan (decided after the Wave 0 audit)

| Wave | Name | Scope | Blocked by | Where it runs |
| --- | --- | --- | --- | --- |
| **0** | Architecture & identity decision | this document, rubric, D-021 proposal, risk R-9 | — | done 2026-10-04 (Windows) |
| **1** | Android environment architecture | `flavorDimensions("env")`, three `productFlavors` with suffixes + `resValue app_name`, label → `@string/app_name`, explicit SDK numbers (§3.4), guard evolution (§6), `ci.yml` + `tool/` command updates, `pre-push` trigger list, `RELEASE_SIGNING.md` correction | **D-021 Q1–Q3** | Windows; BUILD + ARTEFACT verifiable here (`aapt2 dump badging`) |
| **2** | Flutter environment contract | flavor ⇄ entrypoint boot assertion, `.example`-in-prod build-time failure, `isDev` ribbon/banner, `main_mock` release refusal, `main.dart` decision, guard tests for each | Wave 1 (needs the Gradle `FLAVOR` value) | Windows; DEVICE verifiable on the Android test device |
| **3** | iOS environment architecture | three schemes, `Debug/Release/Profile-<flavor>` configurations, per-flavor `xcconfig` with `PRODUCT_BUNDLE_IDENTIFIER` and `APP_DISPLAY_NAME`, `Info.plist` reads them, Podfile generated and committed, `knownRegions` + `ar` | D-021; **a Mac with Xcode 26** | **Blocked on this machine.** The `pbxproj`/`xcconfig` edits can be authored here at SOURCE level but cannot reach BUILD; the wave is marked "explicitly blocked by environment" until a Mac runs it |
| **4** | Cross-platform validation & release safety | AAB in CI, `aapt2` package assertion, signing-secret injection design (no secrets committed), first observed CI run (R-3), rubric re-score, final chapter report | Waves 1–2 (Android), 3 (iOS) | Windows for Android; Mac for iOS |

Phase 5 of the audit (Seif's production host) and Phase 6 (Firebase per flavor, deploy workflows) are
**deferred out of this chapter** and recorded in §10.

---

## 9. Historical record (why it was not done before)

| Date | Event | Evidence |
| --- | --- | --- |
| before 2026-07-22 | Flavors specified: 3 flavors, bundle-id suffix, base URL, app-name suffix, `productFlavors`, iOS schemes; platform versions listed as an open decision | prom.md Prompt 9; `Platform_Specifics.md:21-28`; `Open_Questions.md:53` |
| 2026-07-22 | Day 0 scaffold lands the Dart half only; commit body empty; no record of deferring the Gradle/Xcode half | `5e4a512`, `9e094d7`, `57cc8f0` |
| 2026-07-30 | Release signing made fail-closed; the id is referred to but not decided | `b133bd2`; `RELEASE_SIGNING.md` |
| 2026-08-14 | Audit F-9-08: "Android product flavors are not wired … settle the final applicationId before the production keystore … do it now, not later"; F-1-12 same | `security-performance.md:324-337`; `architecture.md` |
| 2026-08-22 | Dev and staging pointed at the real staging host; prod left at `.example` on purpose | `67bdcc1` body |
| 2026-09-05 | Flagless release build ARTEFACT-proven to ship the staging host; `-t` guard added; audit §2 records "no Gradle product flavors and no iOS schemes" | `STORE_READINESS_AUDIT_2026-09-05.md`; `workflow_test.dart:148-160` |
| 2026-09 | Store audit BS-D-09 / BS-C-13 / IOS-17 ask for the id decision; Play URL 404 (unclaimed) | `store_readiness_parts/19,20` |
| 2026-10-04 | Identity audit; this chapter opened | this file |

No commit, decision entry or brief records a reason for omitting the platform half. The evidence
supports "not reached" rather than "rejected"; this record does not claim more than that.

---

## 10. Deferred work (belongs to later chapters)

- Production backend host in the contract `servers:` block — Seif (`seif_fight.md`).
- Firebase project + per-flavor registrations; FCM client; APNs key — after Waves 1 and 3.
- Keystore generation, Play App Signing enrolment, App Store Connect record, developer-account
  decision — owner; `RELEASE_SIGNING.md`, `STORE_READINESS.md`.
- Deploy workflows (`deploy_android.yml`, `deploy_ios.yml`, Fastlane) — after Wave 4.
- Store metadata, icons per flavor beyond the name suffix, privacy policy, account deletion — other
  chapters (`STORE_READINESS.md` scorecard).
- `screen_protector` iOS 26 crash report (store audit IOS-19) — not an environment item.

---

## 11. Uncertainties carried forward

- Whether `com.levelup.level_up_app` is still unclaimed on Play was last checked in September
  (BS-D-09). Re-check before the owner's decision is implemented.
- iOS is SOURCE-only from this machine; Wave 3's BUILD/ARTEFACT levels require a Mac with Xcode 26.
- CI has never run (R-3); every CI statement here is SOURCE.
- The Egyptian student device distribution below API 24 is `[UNKNOWN]` (Q4).
- Whether the client accepts `com.levelup` as the organisation prefix is `[UNKNOWN]` (Q1 option C).
