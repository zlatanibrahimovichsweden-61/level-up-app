# App Identity & Staging/Production Readiness Audit — 2026-10-04

**Type:** dated, read-only architectural audit. Nothing under `android/`, `ios/`, `lib/`,
`contract/` or `.github/` was modified. The working tree's 20 modified and 3 untracked files
were left exactly as found (git status fingerprint `d5a619b2…` before and after).
**Verification level:** SOURCE throughout (files and git history read), except where a row
cites the 2026-09-05 audit, whose artefact inspections were ARTEFACT level. Nothing is rounded up.
**Companions:** `docs/STORE_READINESS_AUDIT_2026-09-05.md` (release artefacts),
`docs/RELEASE_SIGNING.md` (signing), `.ai/audits/current/security-performance.md` F-9-08 and
`.ai/audits/current/architecture.md` F-1-12 (the two earlier findings on this exact topic).

---

## 0. The answer

**Are we ready for separate staging and production application identities? No.**
There is exactly one identity per platform, both set by the `flutter create` template on
2026-07-22 and never touched since. Staging and production builds install over each other.

**Overall verdict: NOT READY.**

Not ready for *separate identities* (none exist), not ready for a production build (the
prod host is a placeholder), and not ready for a store listing (no keystore, no Apple team,
iOS never built). The part that *is* ready is the Dart side of the flavor model and a
well-mechanised guard that stops the one mistake the project has already made once.

### The four requested values

| Platform | Environment | Identifier | Status |
| --- | --- | --- | --- |
| iOS | Staging | **none** — shares `com.levelup.levelUpApp` | no scheme, no xcconfig, no separate ID |
| iOS | Production | `com.levelup.levelUpApp` | template default (`project.pbxproj:371,550,572`), identical in Debug / Profile / Release; never ratified |
| Android | Staging | **none** — shares `com.levelup.level_up_app` | no `productFlavors`, no `applicationIdSuffix` |
| Android | Production | `com.levelup.level_up_app` | template default (`build.gradle.kts:43`); the template's `// TODO: Specify your own unique Application ID` comment is still on line 41 |

Test target: `com.levelup.levelUpApp.RunnerTests` (`project.pbxproj:387,404,419`). Android
`namespace` equals the `applicationId`. The Kotlin package is `com.levelup.level_up_app`.

Two things about these values are worth seeing clearly:

1. **They are exactly what `flutter create --org com.levelup level_up_app` emits** — the
   snake-case Android ID and the camel-case iOS ID are the tool's two default spellings of
   the same project name. Nobody chose them. The parent scaffold (`F:\level\laqta\prom.md`
   Prompt 0) literally says `flutter create level_up --org com.levelup`.
2. **The project's own documents disagree about whether they are final.**
   `docs/RELEASE_SIGNING.md` says the `applicationId` "value is already settled in code";
   `.ai/audits/current/store_submission_checklist.md:13` lists "application id / bundle id
   freeze" as an *open* `[Product]` action; `security-performance.md` F-9-08 says "settle the
   final `applicationId` before the production keystore is generated". No `DECISIONS.md`
   entry records a ruling either way. **This is an owner decision that has never been made,
   only inherited.**

`[UNKNOWN]` Whether the client controls a domain under `levelup.*` that would justify the
`com.levelup` reverse-DNS prefix. Stores do not verify this, but Android App Links and iOS
Universal Links would, and every legal URL in the app is still a `levelup.example`
placeholder (`login_screen.dart:46-48`).

---

## 1. Was this planned from the beginning?

**Yes — explicitly, in three places. It was then half-built on Day 0, and the other half
was never scheduled, never recorded as deferred, and flagged twice by audits without entering
the fix queue.**

### 1.1 The plan (all pre-date the first commit)

| Source | What it specified |
| --- | --- |
| `F:\level\laqta\prom.md` **Prompt 9** "Flutter Flavors (dev / staging / prod)" | "Each has its own: **bundle ID suffix**, base URL, **app name suffix** · `AppConfig` exposes `baseUrl`, flavor name, `isDev` · `main_dev/staging/prod.dart` · **Android: `productFlavors` in build.gradle** · **iOS: Xcode schemes**". Acceptance step: `flutter run --flavor dev -t lib/main_dev.dart` launches. |
| `prom.md` **Prompt 52** | "Per-flavor icon naming suffix: dev icon has a DEV banner overlay". |
| `prom.md` **Prompt 61** "iOS Release Config" | "Bundle ID per flavor (dev/staging/prod)"; capabilities Keychain Sharing, Push Notifications, Associated Domains. |
| `prom.md` **Prompt 62** "Full CI/CD Pipeline" | `deploy_android.yml` / `deploy_ios.yml` building "with prod flavor", Fastlane supply/pilot. |
| `prom.md` **Prompt 51** | Crashlytics "initialize in main_dev/staging/prod with crashlyticsEnabled = false for dev". |
| `F:\level\level_up\01_Flutter_Specs\Platform_Specifics.md:21-22` §Flavors | "Bundle-ID suffix + base URL + app-name suffix per flavor … Android `productFlavors`; iOS schemes. Run: `flutter run --flavor dev -t lib/main_dev.dart`." |
| `F:\level\04_interfaces_and_handoff_contract.md:122-123` | The Flutter partner tests against "a staging API once available"; Seif "keeps … a staging environment current". |
| `F:\level\00_project_brief_and_team_model.md:33` | Push notifications: **Firebase Cloud Messaging**. |

So the original architecture had: three flavors, per-flavor identity, per-flavor name and
icon, Gradle flavors, Xcode schemes, Firebase (Crashlytics + FCM), and flavor-aware deploy
pipelines. That is a complete, conventional environment-separation design.

### 1.2 What was implemented (git history)

| Date | Commit | What landed | What did not |
| --- | --- | --- | --- |
| 2026-07-22 | `5e4a512` "scaffold — feature-first structure, core infra, **flavors**" (first commit) | `enum Flavor { dev, staging, prod }`, `AppConfig`, `main_dev/staging/prod.dart`, template `build.gradle.kts` and `project.pbxproj` with the default IDs | **No `productFlavors`. No schemes. No suffixes.** Commit body is empty. |
| 2026-07-22 | `9e094d7`, `57cc8f0` "Day 0 foundation — … flavors" | same files, analyze clean | same gap; bodies empty |
| 2026-07-30 | `b133bd2` "chore(android): release signing" | `key.properties` plumbing | identity untouched |
| 2026-08-14 | `424aa1f` ten-agent audit | **F-9-08** and **F-1-12** both name the missing flavors; F-9-08: "do it now, not later … becomes blocking the week staging goes live" | not added to `known-issues.md`; never actioned |
| 2026-08-22 | `67bdcc1` "point the dev and staging flavors at the real staging host" | staging went live; `dev` deliberately set to the **same host** ("there has only ever been one server") | the week F-9-08 said it would become blocking |
| 2026-09-05 | store-readiness audit | confirms "no Gradle product flavors and no iOS schemes"; finds the documented release command shipped the **staging host in a release APK**; fixes it with a **guard test** on the `-t` flag | chooses to guard the convention rather than add the build-system flavors |
| 2026-10-04 | HEAD `03fd7cf` | `git log -S"productFlavors" -- android` returns nothing outside the audit package: **a flavor block has never existed in this repository** | — |

`git log -S'com.levelup.level_up_app' -- android` and `-S'com.levelup.levelUpApp' -- ios`
each return only `5e4a512`. The identifiers have never been edited.

### 1.3 Decisions that now bear on the requirement

- **`67bdcc1` (2026-08-22): `dev` and `staging` resolve to one host.** Not a conflict, but
  it means the Dart model has three flavors for **two real environments**. `isDev` was the
  only thing distinguishing them, and `isDev` is assigned and **never read** (confirmed by
  grep; also 2026-09-05 audit §2.1).
- **adr-049 purchase-silent (`5c4b855`, 2026-09-04)** removed the Paymob deep-link return
  route. That deleted the only planned deep link, so Associated Domains / App Links are
  **no longer required** for release 1 — one fewer per-environment configuration. Positive.
- **"The contract wins" + server-authoritative.** The production host must come from the
  contract's `servers:` block, which still lists staging only (`openapi.yaml:107-109`). The
  app cannot invent it. Identity, by contrast, is **not** a contract matter — it is the app
  owner's call, and nothing external blocks it.
- **The 2026-09-05 choice to mechanise the `-t` rule instead of wiring flavors.** Defensible
  at the time (it closed a proven defect in an afternoon), but it hardened a convention that
  the original design intended the build system to enforce.

**Classification: planned → partially implemented (Dart half only) → silently postponed
→ flagged by audit (2026-08-14) → flagged again (2026-09-05) → still open.** The postponement
was never a decision; it was an omission that two audits noticed and no wave picked up.

---

## 2. Actual readiness today — what is implemented vs what merely appears configured

### 2.1 Android

| Item | State | Evidence | Real or apparent? |
| --- | --- | --- | --- |
| `applicationId` | one value for all build types | `build.gradle.kts:43` | real, but template default |
| Product flavors | **none**; `flutter build --flavor X` fails ("no such flavor") | no `flavorDimensions`/`productFlavors` block | — |
| App label | hardcoded `android:label="level_up_app"`; no `strings.xml` | `AndroidManifest.xml` | ARTEFACT-confirmed 2026-09-05 |
| Signing | fail-closed: no `key.properties` → unsigned release, never debug-signed | `build.gradle.kts:19-25, 52-71` | **real and good** |
| Keystore | none exists; `key.properties.example` documents the shape | `docs/RELEASE_SIGNING.md` | provisioning not done |
| Play App Signing | not enrolled (no listing) | STORE_READINESS §1 | — |
| `INTERNET` permission in release | in `src/main`; guarded twice in CI | `ci.yml` "Release manifest declares INTERNET" + aapt2 step | **real, mechanised** |
| Backup | `allowBackup=false`, `dataExtractionRules` | manifest | real |
| Deep links | none beyond MAIN/LAUNCHER | manifest | correct for release 1 |

### 2.2 iOS

| Item | State | Evidence |
| --- | --- | --- |
| Bundle ID | one value, all three configurations | `project.pbxproj:371,550,572` |
| Schemes | single `Runner.xcscheme` (Debug launch / Profile / Release archive) | `xcshareddata/xcschemes/` |
| xcconfig | `Debug.xcconfig` and `Release.xcconfig` each contain only `#include "Generated.xcconfig"` | `ios/Flutter/` |
| Signing | `CODE_SIGN_STYLE = Automatic`; **no `DEVELOPMENT_TEAM`** anywhere | pbxproj grep |
| Entitlements | **none** (no `.entitlements` file) — no Push, no Keychain Sharing, no Associated Domains | `find ios -name "*.entitlements"` empty |
| Podfile | **absent** | `ls ios/Podfile` fails |
| Ever built? | **No.** "iOS … has never been built" | 2026-09-05 audit §1 |
| `knownRegions` | `en`, `Base` only — no `ar` | `project.pbxproj:188-191` |
| Display name / `CFBundleName` | "Level Up App" / `level_up_app` | `Info.plist:8,16` |
| Privacy manifest | absent | 2026-09-05 audit; `store_readiness_parts/04_ios_src.md` IOS-03 |

Everything iOS is SOURCE-level only and **unverifiable from this Windows machine**.

### 2.3 Flutter entry points and environment selection

| Entrypoint | Flavor | Host | Notes |
| --- | --- | --- | --- |
| `lib/main.dart` | → `dev` | staging | the bare `flutter run`/`flutter build` default |
| `lib/main_dev.dart` | `dev` | `https://level-up-backend-staging.up.railway.app/api/v1` | identical host to staging by decision (`67bdcc1`) |
| `lib/main_staging.dart` | `staging` | same | — |
| `lib/main_prod.dart` | `prod` | `https://TBD.example/api/v1` | **placeholder**; fails closed (`.example` is reserved) |
| `lib/main_mock.dart` | `dev` + Dio override | on-device mock | not a shipping flavor; its `refreshDioProvider` still targets live staging (2026-09-05 §2.1) |

- **The only selector is the `-t` argument.** Nothing in Gradle or Xcode knows which flavor
  is being built. This is the root cause of the 2026-09-05 defect (release APK shipped with
  the staging host because the documented command omitted `-t`). ARTEFACT-proven then.
- **Mitigation in place:** `test/guards/workflow_test.dart` "every runnable release-build
  command targets lib/main_prod.dart" + a non-vacuity companion; scans `docs/`, `tool/`,
  `.github/`, `.githooks/`. Proven able to fail (`tool/verify_guards.ps1` probe 7).
  **Limit:** it guards *text in the repo*, not *what a human types in a terminal*. A local
  `flutter build appbundle` still produces a staging-pointed release.
- **No visible environment indicator.** `isDev` is dead code. A staging build and a prod
  build are pixel-identical. QA cannot catch a wrong build by looking at it.
- **No `--dart-define` usage anywhere** (`grep fromEnvironment lib/` → none). Environment is
  compile-time by entrypoint only; there is no runtime override and no secrets injection
  path. (Fine for now — there are no client secrets.)

### 2.4 Firebase

**None.** No `firebase_*` dependency in `pubspec.yaml`/`pubspec.lock`, no `firebase.json`,
no `firebase_options.dart`, no `google-services.json`, no `GoogleService-Info.plist`, no
Google Services Gradle plugin. Therefore **no Firebase ↔ applicationId conflict exists today**.

But it is coming: the contract has `PUT /me/fcm-token` **stable** (`openapi.yaml:896-900`,
`registerFcmToken`), the parent briefs name FCM as the push channel, and the 3.28.0-m1
notification inbox just went stable. Firebase registers apps **by applicationId / bundle
ID**. If Firebase is set up against the current shared IDs and the IDs are later split or
renamed, every Firebase app registration, `google-services.json` and APNs key mapping is
redone. **The identity decision must precede the first Firebase project touch.** Today the
order is still free to choose; after FCM lands it is not.

### 2.5 Backend API separation

One host, from the contract (`servers:` → staging only). Production host: **not announced**
(`app_config.dart:47-51` TODO; `seif_fight.md` S1 resolved for staging only; `RISKS.md` R-8).
Whether Seif runs separate staging and production databases, OTP providers, and FCM
server keys is `[UNKNOWN]` from this repo.

### 2.6 Push / APNs / FCM

Not implemented on either platform: no `POST_NOTIFICATIONS`, no APNs entitlement, no FCM
SDK. `CONTRACT-DELTA.md:74` (parent folder) records the same. Not a gap for *today's* release
scope, but see §2.4 ordering.

### 2.7 Deep links / Universal Links / App Links

None configured, and none required after adr-049. The 2026-09-05 audit records "no hijack
surface" as a positive. When the real legal URLs replace `levelup.example`, a web domain will
exist; App Links can be a later decision.

### 2.8 OAuth / third-party sign-in

None. Phone OTP only. Not applicable.

### 2.9 CI/CD

| Job (`.github/workflows/ci.yml`) | What it does | Environment awareness |
| --- | --- | --- |
| `analyze-and-test` | format, analyze, full suite minus goldens, INTERNET grep, lockfile/l10n drift | none needed |
| `goldens` (Windows, advisory) | golden tests | — |
| `codegen-drift` (main only) | build_runner diff | — |
| `build-release-apk` (main only) | `flutter build apk --release --no-pub -t lib/main_prod.dart`, aapt2 INTERNET check; **no artefact uploaded, unsigned, APK not AAB** | prod by `-t` only |

Missing versus the plan: `deploy_android.yml`, `deploy_ios.yml`, Fastlane, signing secrets,
an AAB job, any iOS/macOS job. **And `RISKS.md` R-3: CI has never been observed running** —
nothing has been pushed (`branch-topology-merged` memory). Every CI claim above is SOURCE.

### 2.10 Signing and store readiness

Covered exhaustively by the 2026-09-05 audit (NOT READY: no prod URL, no key, no store
identity). Nothing in this audit changes that verdict. The one additional observation: the
keystore gitignore rules are `android/`-scoped only (2026-09-05 §2.3) — a `.jks` under
`ios/` or `docs/` is committable.

---

## 3. Gap analysis

Severity = impact × likelihood of going unnoticed, per `RISKS.md`.

| # | Gap | Severity | Impact | Reversible later? |
| --- | --- | --- | --- | --- |
| G-1 | **One identity per platform; staging ≡ production** | **CRITICAL** | A tester cannot hold staging and prod on one phone; installing one over the other either overwrites data or fails on signature mismatch; a staging build *is* a prod build to the OS, Play, Firebase and App Store Connect | **No** after the first Play upload / App Store record — the ID is permanent |
| G-2 | Production IDs never ratified; template `TODO` still present; docs disagree (RELEASE_SIGNING "settled" vs checklist "freeze pending") | **HIGH** | The keystore, Play listing, App ID and Firebase app will all be minted against a value nobody chose | No, same reason |
| G-3 | Environment chosen by `-t` only; no Gradle/Xcode enforcement | **HIGH** | Already produced one staging-pointed release artefact (2026-09-05). Guard covers repo text, not terminals | Yes |
| G-4 | No visual environment indicator (`isDev` dead) | **HIGH** | Combined with G-1, a wrong-environment build is undetectable by QA by eye or by package name | Yes, ~20 lines |
| G-5 | Production host is a placeholder | **CRITICAL (external)** | No prod build can function. Owned by Seif via the contract `servers:` block | Yes |
| G-6 | iOS never built; no team; no Podfile; no entitlements; single scheme | **HIGH** | Half the product's platforms have zero release readiness and cannot be verified from this machine | Yes, needs a Mac |
| G-7 | Firebase/FCM planned but identity not fixed first | **MEDIUM (rising)** | Registering Firebase against unratified or shared IDs forces rework of every registration later | Yes until Firebase is created |
| G-8 | CI builds unsigned APK, no AAB, no upload, no iOS lane, never executed | **MEDIUM** | No path from `main` to a store track; Play requires AAB | Yes |
| G-9 | App name hardcoded `level_up_app` on Android, `level_up_app`/"Level Up App" on iOS; no per-flavor name | **MEDIUM** | Store listing shows a snake_case name; staging and prod icons/names identical on a home screen | Yes |
| G-10 | Three Dart flavors, two real environments; `dev` ≡ `staging` | **LOW** | Conceptual noise; `dev` has no distinct purpose until a local backend or the mock is bound to it | Yes |
| G-11 | `main_mock.dart` refresh path reaches live staging | **LOW** | Documented; not a shipping flavor | Yes |
| G-12 | Android/iOS ID spelling differs (`level_up_app` vs `levelUpApp`) | **LOW** | Cosmetic, but a visible fingerprint that the IDs are defaults | Only before G-2 is closed |
| G-13 | Keystore ignore rules are `android/`-scoped | **LOW** | A stray `.jks` elsewhere is committable | Yes |

**Configurations that could cross-connect environments today:**
- Any release build without `-t lib/main_prod.dart` → staging host in a release binary (G-3).
  Guarded in repo text only.
- `main_mock.dart`'s un-overridden `refreshDioProvider` → staging (G-11).
- Conversely, nothing can accidentally reach *production*, because no production host exists.
  That protection is an accident of G-5, not a design.

---

## 4. Did we miss an architectural opportunity? — honest assessment

**Yes, and the window is still open, but it closes at the first store upload or the first
Firebase registration — whichever comes first.**

What proper separation buys, specifically for this project:

| Benefit | Concrete effect here |
| --- | --- |
| Safer QA | Staging and prod coexist on the tester's Pixel 8 and tablet (the devices the walkthrough memories name); no uninstall between builds, no lost local state |
| Fewer release mistakes | The build system refuses `--flavor prod` with `main_staging.dart` (if the tie-in guard in Phase 2 is added); the shipped package name itself says which environment it is |
| Minors' data safety | A staging-pointed "production" install is the exact scenario the 2026-09-05 memory names as the reason the guard exists. Identity separation makes it impossible rather than merely detected |
| Backend integration | Seif can register **two** FCM apps and **two** OTP sender configurations and never confuse their device tokens |
| Store process | Internal/closed testing tracks on Play and TestFlight need the production ID; a separate staging ID keeps the staging artefact out of the store entirely |
| Future environments | Adding `uat` or a `local` flavor later is one Gradle block and one scheme, not a migration |

Cost, honestly: Android flavors are a half-day including CI and guard updates; iOS schemes
and xcconfigs need a Mac session and are the fragile part (this project has already had
`project.pbxproj` broken once by the launcher-icon tool — memory `launcher-icon-regeneration-trap`).
The decision itself (G-2) costs nothing and unblocks everything else.

**Related improvements that belong in the same wave rather than as separate tickets:**
1. A visible environment tag gated on `isDev` (finally using the field) — a corner ribbon or
   a Settings footer line. Zero product risk in prod because prod never shows it.
2. Per-flavor app name (`resValue "string" "app_name"` / `CFBundleDisplayName` per xcconfig)
   and, later, a DEV/STAGING icon overlay (Prompt 52's plan).
3. A **release guard for the `.example` host**: fail the suite if `Flavor.prod` resolves to a
   reserved TLD *and* the build is a release — the submission checklist already asks for it.
4. A **flavor-coherence guard**: extend `workflow_test.dart` so any `--flavor X` and
   `-t lib/main_Y.dart` on one command must have X = Y.
5. AAB instead of APK in the CI release gate (Play requires it; the AAB is already proven
   buildable, 2026-09-05 §4.2).
6. Ratify the display name "Level Up" / "ليفل أب" (already the ARB `appTitle`) for both stores.

Things **not** worth bundling: Firebase (needs FORMULATE and owner rulings on push — the
3.19.0-m1 changelog explicitly says the inbox is not push), deep links (none needed), and
`--dart-define` migration (the entry-point design works; changing it buys little and
touches the guard that currently protects it).

---

## 5. Classification and roadmap

### 5.1 Classification

**Already implemented correctly**
- Dart flavor model: `enum Flavor`, `AppConfig.init`, three entrypoints, single `bootstrap()`.
- Prod host fails closed on a reserved TLD rather than leaking minors' traffic.
- Fail-closed Android signing; keystores never committed in all history.
- `INTERNET` permission guarded at source and at artefact level in CI.
- The `-t lib/main_prod.dart` guard pair (proven able to fail).
- No deep links, no OAuth, no third-party SDKs → nothing to misconfigure per environment yet.

**Implemented but incomplete**
- Flavors exist only in Dart; the Gradle and Xcode halves specified on Day 0 were never built.
- `isDev` exists and is unused — the environment indicator is one `if` away.
- CI has a release compile gate but no AAB, no signing, no upload, no iOS, and has never run.
- `RELEASE_SIGNING.md` documents the keystore flow but asserts the ID is "settled" when no
  ruling exists.

**Missing and necessary (before the first store upload or Firebase project)**
- An owner decision on the production `applicationId` and bundle ID, recorded in `DECISIONS.md`.
- Android `productFlavors` with `applicationIdSuffix` for `dev`/`staging`, `prod` unsuffixed.
- iOS schemes + per-flavor xcconfig setting `PRODUCT_BUNDLE_IDENTIFIER`, created on a Mac.
- A production host in the contract `servers:` block (Seif).
- A visible environment indicator in non-prod builds.

**Optional improvements for later**
- Per-flavor launcher icon overlay; per-flavor Firebase config files when FCM is formulated;
  `deploy_*.yml` + Fastlane; App Links once a real domain exists; unify ID spelling across
  platforms (only possible while G-2 is open).

### 5.2 Prioritised roadmap

| Phase | Work | Depends on | Breaking changes / risks | Owner |
| --- | --- | --- | --- | --- |
| **0 — Decide** (no code) | Ratify production IDs for both platforms (keep the current two, or unify, e.g. one reverse-DNS stem for both). Ratify store display name. Write a `DECISIONS.md` entry. Delete the template `TODO` comment in the same change | nothing | none; but **irreversible once a store record exists**, and the `com.levelup` stem presumes a domain `[UNKNOWN]` | Owner |
| **1 — Android flavors** | `flavorDimensions("env")`; `productFlavors { dev { applicationIdSuffix ".dev"; resValue app_name "Level Up DEV" } staging { ".staging" } prod {} }`; move label to `@string/app_name`. Update `ci.yml`, `tool/verify_release_manifest.ps1`, `verify_guards.ps1`, `RELEASE_SIGNING.md`, the APK output path (`app-prod-release.apk`). Extend `workflow_test.dart` with the flavor-coherence rule | Phase 0 | **Breaking:** every `flutter run`/`build` now needs `--flavor`; existing debug installs on test devices get a new package name (uninstall once); `-t`-only guard becomes `-t`+`--flavor`. Run `validate.ps1` and `verify_guards.ps1` after | Engineering |
| **2 — Make the environment visible + fail-closed** | Read `isDev` to draw a non-prod ribbon/footer; add the `.example`-host release guard the checklist asks for | Phase 1 (so the ribbon can also show the Gradle flavor) | none in prod; one golden may need updating | Engineering |
| **3 — iOS** (Mac session) | Add `Podfile`; schemes `dev`/`staging`/`prod`; `Flutter/Dev.xcconfig`… setting `PRODUCT_BUNDLE_IDENTIFIER` and `CFBundleDisplayName`; set the team; first successful build; `ar` in `knownRegions`. Verify at BUILD level only on the Mac | Phase 0; Apple developer team | `project.pbxproj` edits are fragile here (launcher-icon memory); commit the pbxproj diff separately and re-run the icon tool check | Owner/Mac + Engineering |
| **4 — Release pipeline** | CI release gate builds **AAB** with `--flavor prod -t lib/main_prod.dart`; signing via secrets only when a distribution channel exists; Play App Signing enrolment; first observed CI run (closes R-3) | Phases 1, 0; keystore provisioned per `RELEASE_SIGNING.md` | none to app code; the job's artefact path changes | Engineering + Owner |
| **5 — External** | Production host in the contract `servers:` block; confirm Seif's staging/prod split for OTP sender and FCM server keys | Seif | the app changes one constant (`app_config.dart:50`) | Seif, via `seif_fight.md` |
| **6 — Later** | Firebase per-flavor files (after a FORMULATE for push); per-flavor icon overlay; `deploy_*.yml`; App Links | Phases 0–4; owner rulings | — | — |

Phases 0 → 1 → 2 can be done this week on Windows and are independent of Seif. Phase 3
is the long pole and needs hardware this project does not have at hand. Phase 5 is the only
one that blocks a *functioning* production build, and it is not ours.

---

## 6. Uncertainties, stated

- iOS is entirely SOURCE-level; nothing can be built or verified on this machine.
- CI behaviour is read from YAML; CI has never executed (R-3).
- Whether the client owns a `levelup.*` domain, which Play/Apple accounts will publish, and
  whether Seif's backend has a production environment at all are `[UNKNOWN]`.
- The parent folder's `prom.md` is a prompt scaffold, not a signed-off spec; it is cited as
  evidence of *intent*, with `Platform_Specifics.md` as the spec that carried the same intent.
- This audit did not check Figma and makes no claim about designed environment indicators.
