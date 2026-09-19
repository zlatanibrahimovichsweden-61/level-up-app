# Store Readiness Audit — 2026-09-05

**Type:** dated release/artifact audit. Not a living register.
**Companion:** `docs/STORE_READINESS.md` is the living policy & compliance register
(Google Play / Apple rules, data map, pre-submission checklist). This file is the
**evidence** — what was actually built, inspected and run on 2026-09-05. Where the two
disagree about a fact, this file wins for 2026-09-05 and the register should be corrected.

**Scope:** Android release configuration, entrypoints/flavors, the built artefacts,
secrets, store metadata, and release validation. **Out of scope and untouched:**
`contract/`, backend behaviour, product features, `zna.md`, unrelated Phase 3 findings.

**Verification levels** (per `docs/WAVE_STATUS.md`): SOURCE → BUILD → ARTEFACT → DEVICE → CI.
Every claim below carries its level. Nothing is rounded up.

**Method:** six parallel audit agents (Android config, entrypoints/flavors, secrets,
store metadata, release validation, artefact) reporting evidence with `path:line`;
findings consolidated, then verified independently by the lead before being written here.

---

## 1. Executive summary

# NOT READY

The app **builds, launches and behaves correctly in release mode** — that part is
genuinely good, and more of it is now proven than at any previous point in this project.
(It does not *install* as built: the artefact is unsigned, so a re-signed copy was used
for the run — see §5.) Three things stop it from being submittable, and none of them is a
code defect:

1. **There is no production backend to point at.** The prod flavor's base URL is the
   deliberate placeholder `https://TBD.example/api/v1`, and it is *confirmed present in
   the shipped binary*. A production build cannot reach any server. Blocked on Seif.
2. **There is no release signing key.** `android/key.properties` does not exist, so the
   release artefact is **unsigned** — verified, not assumed. This is correct fail-closed
   behaviour, not a bug, but no store will accept the output until a keystore is
   provisioned in the release environment.
3. **Store-facing identity does not exist yet.** Stock Flutter launcher icon on both
   platforms, `android:label="level_up_app"` (confirmed in the artefact), placeholder
   `.example` legal URLs, no account-deletion path, and no way for a store reviewer to
   get past phone-OTP login.

iOS is a separate and larger gap: it has never been built, has no `Podfile`, and has no
privacy manifest.

**One real defect was found and fixed** during this audit: the release command written in
`docs/RELEASE_SIGNING.md` omitted `-t lib/main_prod.dart`, so following the project's own
documentation produced a signed release APK **pointed at the live staging backend**. This
was proven at ARTEFACT level (§4.3), fixed, and mechanised as a guard test.

---

## 2. Release configuration — the actual release path

There are **no Gradle product flavors and no iOS schemes** (`android/app/build.gradle.kts`
has no `productFlavors` block; `ios/` has a single `Runner` scheme). The "flavor" is
entirely the `-t` argument to the Flutter CLI. That single argument decides which backend
the shipped artefact talks to, with nothing in the build system to enforce it.

### 2.1 Entrypoint matrix

| Entrypoint | Intended use | API base URL | Mock reachable? | Production-safe? |
| --- | --- | --- | --- | --- |
| `lib/main.dart` | bare `flutter run` convenience | staging (forwards to dev) | no | **NO** — forwards to `main_dev.dart` (`lib/main.dart:4-6`) |
| `lib/main_dev.dart` | dev flavor | `https://level-up-backend-staging.up.railway.app/api/v1` | no | no (by design) |
| `lib/main_staging.dart` | staging flavor | same staging host | no | no (by design) |
| `lib/main_prod.dart` | **the release entrypoint** | `https://TBD.example/api/v1` — placeholder | no | fails closed; cannot function until the real host lands |
| `lib/main_mock.dart` | throwaway on-device preview | `dioProvider` is overridden with `buildMockDio()`, so ordinary calls never leave the device — but it still runs `AppConfig.init(Flavor.dev)` (`lib/main_mock.dart:46`), and `refreshDioProvider` is **not** overridden (`:44-45`), so the token-refresh path targets live staging | yes, by design | **NO** — documented as "NOT a shipping flavor" |

Source: `lib/core/config/app_config.dart:43-55`, `lib/main_*.dart`.

`AppConfig.isDev` (`app_config.dart:13,33`) is assigned and never read. Staging and prod
builds are therefore visually indistinguishable at runtime — there is no banner or tag
that would let QA catch a wrong-flavor build by looking at it.

### 2.2 The intended release command

```bash
flutter build apk --release -t lib/main_prod.dart
```

Used by `.github/workflows/ci.yml:377` and `tool/verify_release_manifest.ps1:60`.
`docs/RELEASE_SIGNING.md:49` omitted the `-t` until this audit — see §4.3 and §8.

### 2.3 Signing

Fail-closed and correct. `android/app/build.gradle.kts:52-71` creates a `release` signing
config **only** if `android/key.properties` exists, and uses `findByName("release")` so
its absence yields `null` — an unsigned build — rather than the old debug-keystore
fallback whose password and alias are public. `key.properties`, `*.jks` and `*.keystore`
are gitignored (`android/.gitignore:12-14`) and **none has ever been committed** (verified
across all history).

`android/key.properties` does not exist in this checkout, so **the release artefact
produced today is unsigned**. This is a release-environment provisioning task
(`docs/RELEASE_SIGNING.md`, "One-time setup"), not a repository defect.

One gap worth naming: the gitignore rules that protect keystores are **`android`-scoped**
(`android/.gitignore:12-14`). The root `.gitignore:53-54` deliberately declines to ignore
keystores elsewhere, so a `.jks` copied to the repository root, `docs/`, `tool/` or `ios/`
is committable. Nothing of the sort exists today (verified across all history), but the
protection is narrower than "keystores are gitignored" suggests.

---

## 3. Validation

`tool/validate.ps1` runs: environment/pin check → toolchain → `flutter pub get` →
`dart format --set-exit-if-changed` → `flutter analyze` → `flutter test` (full suite,
including every guard and the goldens). It does **not** build a release artefact; that is
`tool/verify_release_manifest.ps1` and the `build-release-apk` CI job.

| Step | Result | Level |
| --- | --- | --- |
| `tool/validate.ps1` | **OVERALL: PASS — 864 passed / 0 failed**, format PASS, analyze PASS (0 issues). Baseline was 862; the two new guard tests account for the difference. | BUILD |
| The new guards actually ran | Verified by a **targeted run**, not by the `862 → 864` delta: `flutter test test/guards/workflow_test.dart` → 14/14 pass, both new tests named in the output. (The delta alone would not be proof — see W-15.) | BUILD |
| Honest note on getting there | The first post-change validate run **FAILED**: `format: FAIL` on the new guard, because the code as written was not `dart format`-clean (tests passed 864/0 even then). Fixed with `dart format` and re-run. Recorded because a clean-looking final number should not hide a red run. | BUILD |
| `tool/verify_release_manifest.ps1` | **RESULT: VERIFIED** — release APK declares `INTERNET`, proven with `aapt2 dump permissions` | ARTEFACT |
| `tool/verify_guards.ps1` | **RESULT: VERIFIED — 7/7 guards proved**, including the new probe `[7] release build names the prod entrypoint`. It reintroduces the defect as a bare `flutter build apk` (no `--release`, no `-t` — release is Flutter's default mode, so this is the subtler form of the bug), confirms the guard fires *in isolation*, restores `docs/RELEASE_SIGNING.md` under SHA-256 verification, and re-runs the whole suite to prove nothing was left broken. | BUILD |
| Guard probe — can it pass vacuously? | Pointed the scan at a tree with no build commands → the positive companion went **red** with `Only 0 release-build command(s) found`. Restored, SHA-256 match. (Manual; the harness above covers the negative test.) | BUILD |
| Release APK build | `flutter build apk --release -t lib/main_prod.dart` → 60.2 MB, exit 0 | BUILD |
| Release AAB build | `flutter build appbundle --release -t lib/main_prod.dart` → 58.6 MB, exit 0 | BUILD |

**CI has still never been observed executing** (risk R-3). Every claim about CI in this
document is read from the YAML, which is SOURCE level, not CI level.

---

## 4. Artefact verification

This section reports **only what was found inside the built files**, not what the source
says. Built 2026-09-05 on Flutter 3.44.7 / Dart 3.12.2, JDK 21, Android SDK 36.1.0.

### 4.1 Release APK — `build/app/outputs/flutter-apk/app-release.apk`

Built with `-t lib/main_prod.dart`; 63,160,865 bytes. Inspected with `aapt2`, `apksigner`
and by unzipping.

| Property | Value in the artefact |
| --- | --- |
| package | `com.levelup.level_up_app` |
| versionCode / versionName | `1` / `1.0.0` |
| minSdk / targetSdk / compileSdk | `24` / `36` / `36` |
| Permissions | `INTERNET`, `ACCESS_NETWORK_STATE`, and its own `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (AndroidX-generated). Nothing else. |
| `application-label` | **`level_up_app`** — the raw project name, in every locale variant |
| Launcher icon | 5 legacy density PNGs; **no adaptive icon** |
| Components (complete) | `MainActivity` exported=**true** (it is the launcher); `io.flutter.plugins.urllauncher.WebViewActivity` exported=false; `androidx.startup.InitializationProvider` exported=false; `androidx.profileinstaller.ProfileInstallReceiver` exported=true (standard AndroidX, `DUMP`-protected). Every one carries an explicit `android:exported`. |
| Native code | `arm64-v8a`, `armeabi-v7a`, `x86_64`; libraries are `libapp.so`, `libflutter.so`, `libdartjni.so`, `libdatastore_shared_counter.so` |
| **16 KB page-size alignment** | **PASS** — `zipalign -c -P 16 -v 4` → `Verification successful`. This is a Google Play hard requirement for `targetSdk ≥ 35` since 2025-11-01, and this app targets 36. |
| Backup / minors'-PII flags | `allowBackup=false`, `fullBackupContent=false`, `dataExtractionRules` all **survive the manifest merge** into the artefact (checked in the binary manifest, because losing a manifest attribute at merge time is exactly what defect C-1 was) |
| debuggable | **absent** — not a debug build |
| cleartext traffic | **absent** — platform default (blocked) applies |
| Signing | **UNSIGNED.** `apksigner verify` → `DOES NOT VERIFY / ERROR: Missing META-INF/MANIFEST.MF`. No signature block of any scheme. |

### 4.2 Release AAB — `build/app/outputs/bundle/release/app-release.aab`

58.6 MB. Single `base` module (no dynamic features), same three ABIs. Protobuf manifest
contains `android.permission.INTERNET` and `ACCESS_NETWORK_STATE`; contains **no**
`debuggable` and **no** `usesCleartextTraffic`; carries the same `allowBackup=false` /
`dataExtractionRules` protections as the APK.

**The AAB is also unsigned** — it has no signing block. This matters more than the APK's
signing state, because the AAB is the file that actually gets uploaded to Play.

This is the first AAB this project has ever produced. The Play-required format is
therefore **proven buildable** — only the CI wiring and the signing key are missing.

### 4.3 Contamination scan — the decisive test

Every `libapp.so` (all three ABIs) in each artefact was scanned for embedded
configuration:

| String | prod build (`-t lib/main_prod.dart`) | **default build (`flutter build apk --release`, no `-t`)** | AAB |
| --- | --- | --- | --- |
| `TBD.example` (prod placeholder) | **PRESENT** | ABSENT | **PRESENT** |
| `level-up-backend-staging.up.railway.app` | **ABSENT** | **PRESENT** | **ABSENT** |
| `mock_backend` | ABSENT | ABSENT | ABSENT |
| `buildMockDio` | ABSENT | ABSENT | ABSENT |

Read the middle column carefully. **The command that `docs/RELEASE_SIGNING.md:49` told
you to run produced a release artefact containing the live staging hostname.** Not a
placeholder — a real, reachable server holding real students' data. Both builds were made
and unzipped to establish this; it is not inference.

The right-hand columns are the good news: the prod-targeted APK and the AAB contain the
prod URL and **no** staging or mock configuration. Dart's whole-program compilation from
the entrypoint tree-shakes `lib/dev/` out entirely, so **mock contamination is
artefact-disproven**, not merely argued.

---

## 5. Device verification

**Emulator only. No physical device was attached to this machine, so no claim here is a
physical-device claim.** Pixel 8 AVD, Android 16 (API 36), 1080×2400 @ 420dpi.

The release APK is unsigned and cannot install. To test it at all, a **copy** of it was
signed in the session scratchpad with a throwaway, clearly-labelled audit key
(`CN=AUDIT ONLY DO NOT SHIP`, 30-day validity). That key never entered the repository, no
`android/key.properties` was created, and the artefact's code is byte-for-byte the one
built above. **This is not the shipping signature and proves nothing about signing.**

| Check | Result |
| --- | --- |
| Install | **PASS** (audit-signed copy) |
| Cold start | **PASS** — 1990 ms first launch, 2945 ms after force-stop |
| Reach initial screen | **PASS** — onboarding renders fully |
| Dependency / router / theme / l10n init | **PASS** — no init errors in logcat |
| INTERNET permission at runtime | **NOT VERIFIED.** See the correction below — do not read this row as proof. |
| Navigation (onboarding → login) | **PASS** |
| Arabic / RTL | **PASS** — default locale, correct RTL layout |
| English / LTR | **PASS** — toggle works, layout flips |
| Locale persistence across restart | **PASS** — force-stop then relaunch came back in English |
| **Backend unavailable** | **PASS** — requesting an OTP against the unresolvable `TBD.example` host shows an inline localized error and **does not crash** |
| Crash-free | **PASS** — zero `FATAL`/`AndroidRuntime` entries for the package across the whole session |
| Login / OTP | **BLOCKED — backend dependency** (prod URL is a placeholder) |
| Session logout / restart | **BLOCKED — backend dependency** (requires a signed-in session) |
| Dark mode | **BLOCKED** — the theme control lives in Settings, behind login |
| Quiz / catalogue / leaderboard | **BLOCKED — backend dependency** |
| Orientation change | **NOT TESTED** |
| **Physical device** | **NOT VERIFIED — no device attached** |

### 5.1 Correction — what the logcat evidence does NOT prove

An earlier draft of this report cited
`ConnectivityService: requestNetwork … RequestorPkg: com.levelup.level_up_app … Capabilities: INTERNET`
as runtime proof of the `INTERNET` permission. **That is wrong and has been removed.**
That line is `connectivity_plus` registering a `NetworkCallback`, which requires
`ACCESS_NETWORK_STATE`; the `INTERNET` capability in it is a *requested network
capability*, not a granted permission. `android.permission.INTERNET` is enforced by the
kernel at socket creation, so only an actual socket attempt can prove it.

The OTP request would have been that proof, but the exception it raised was not captured,
and against an unresolvable host a DNS failure (`errno 7`) and a permission denial
(`errno 13`) are not distinguishable from the UI — both surface as the same offline
message. So:

- **`INTERNET` is present in the shipped artefact — ARTEFACT VERIFIED** (`aapt2 dump
  permissions` on the APK, plus the AAB's protobuf manifest). That is solid.
- **`INTERNET` working at runtime — NOT VERIFIED.** It needs one successful socket, which
  needs a reachable host, which needs blocker B-1 resolved.

### 5.2 What this does and does not do for R-4

This is the **first release-mode execution of this app that the project has any record
of** — `docs/RISKS.md` R-4 states plainly that nobody had installed the release artefact,
and every screenshot in `docs/device_pass/` is a debug build against the mock backend.

R-4 is **narrowed, not closed.** Its stated action is "install the release APK, complete a
login end to end." What happened here was an *emulator*, running a *re-signed copy*, which
could not attempt a login because there is no backend. `docs/RISKS.md` has deliberately
not been edited: R-4 stays open, and this section is the evidence of how far it has moved.

---

## 6. Store Readiness Matrix

| Area | Status | Evidence | Severity | Action |
| --- | --- | --- | --- | --- |
| Production entrypoint | **PASS** | `-t lib/main_prod.dart`; prod URL in artefact, staging absent (§4.3) | — | none |
| Release build | **PASS** | APK 60.2 MB + AAB 58.6 MB, both exit 0 (§3) | — | wire AAB into CI |
| Signing | **BLOCKED** | `apksigner`: unsigned; `key.properties` absent by design (§2.3) | HIGH | provision keystore in the release environment |
| INTERNET permission | **PASS (artefact)** | `aapt2 dump permissions` on the APK + AAB protobuf manifest. Runtime behaviour is **NOT VERIFIED** — see §5.1 | — | prove with one successful socket once B-1 lands |
| Package ID | **PASS** | `com.levelup.level_up_app` in the artefact | — | confirm it is the business-final value before keystore generation |
| Versioning | **PASS WITH WARNINGS** | `1.0.0+1` → versionCode 1 / versionName 1.0.0, consistent pubspec → artefact | LOW | make `1.0.0+1` an explicit decision, not a template default |
| Staging contamination | **PASS** | staging host **absent** from prod APK and AAB (§4.3) | — | the flagless-build hazard is now fixed + guarded (§8) |
| Mock contamination | **PASS** | `mock_backend`/`buildMockDio` absent from every artefact (§4.3) | — | none |
| Debug contamination | **PASS** | not debuggable; no cleartext; zero `print`/`debugPrint` in `lib/`; no logging interceptor | — | none |
| Secrets | **PASS** | no key/token/keystore in tree or in any commit; tokens in Keychain/Keystore; no TLS bypass; no analytics/ads/crash SDK | — | none |
| Icons | **FAIL** | stock Flutter logo, both platforms; no adaptive icon | HIGH | brand assets required |
| Splash | **FAIL** | default white layer-list; blank iOS `LaunchImage` | MEDIUM | brand assets required |
| Localization | **PASS** | AR + EN, ARB parity guard-enforced, both rendered correctly in a release build **on an emulator** | — | set App Store Connect languages separately |
| RTL | **PASS** | release build **on an emulator**, Arabic RTL layout correct | — | golden-level RTL coverage is still 0% |
| Dark mode | **NOT VERIFIED** | control is behind login, which is backend-blocked | MEDIUM | retest once a backend exists |
| Crash/startup | **PASS (emulator)** | cold-starts, initialises, survives an unreachable backend (§5) | — | **emulator only, re-signed copy** — not a physical-device pass |
| Physical-device release test | **NOT VERIFIED** | no device attached | HIGH | required before submission |
| Store metadata | **FAIL** | `android:label="level_up_app"` in the artefact; `pubspec` description still "A new Flutter project."; no listing assets anywhere in the repo | HIGH | product + design |
| Privacy/Data Safety | **FAIL** | `.example` legal URLs (`login_screen.dart:41-44`); in-app legal screens render "not published"; **no account deletion anywhere** (filed as `seif_fight.md` S38) | HIGH | legal asset + contract |
| Signing/Play Console | **NOT VERIFIED** | console state is not visible from the repository | — | see §9 |

---

## 7. Confirmed blockers

**CRITICAL**

- **B-1 — No production backend.** `app_config.dart:54` resolves prod to
  `https://TBD.example/api/v1`, ARTEFACT-confirmed inside both the APK and the AAB. A
  production build cannot reach any server. *Blocked on Seif* — the contract's `servers:`
  block still lists staging only. Nothing in this repository can fix it.

**HIGH**

- **B-2 — No release signing key.** Both the APK **and the AAB** verified unsigned.
  Fail-closed by design and correct; a keystore must be generated and
  `android/key.properties` created in the release environment
  (`docs/RELEASE_SIGNING.md`, "One-time setup") before any store upload. Classify as
  *requires release-environment provisioning*, not a repository defect. HIGH rather than
  CRITICAL precisely because unsigned is the safe alternative to debug-signed.
- **B-3 — No account deletion.** No UI row, no repository method, no route, and the only
  `delete:` operation in the entire contract is `removeFavorite`
  (`contract/openapi.yaml:1145`). Required by Google Play (in-app path **and** a public
  web URL) and Apple 5.1.1(v). Filed as `docs/seif_fight.md` S38 (2026-09-04); the local
  wipe choreography can be built now, the endpoint cannot.
- **B-4 — Privacy policy and terms are placeholders.** `.example` URLs in
  `login_screen.dart:41-44`; the in-app legal screens render "not published"
  (`legal_document_screen.dart:28-56`). Both stores require a live policy URL. Blocked on
  a legal asset, not on engineering.
- **B-5 — No reviewer access.** Phone-OTP is the only authentication path and no
  bypass/demo account exists, so a store reviewer cannot get past the login screen. Needs
  a permanent review account with a static OTP **and** seeded catalogue content for its
  cohort. Blocked on the backend.
- **B-6 — Store identity is the Flutter template.** Stock launcher icon on both platforms
  (artefact-confirmed), `android:label="level_up_app"` (artefact-confirmed), `pubspec`
  description "A new Flutter project.", and zero listing assets in the repository.
- **B-7 — iOS has never been built.** No `Podfile`, no `Pods/`, no
  `ios/Runner/PrivacyInfo.xcprivacy`. Apple has required privacy manifests since
  2024-05-01 and an Xcode 26 / iOS 26 SDK build since 2026-04-28. Whether the iOS target
  compiles at all is **UNKNOWN** — it needs a Mac.
- **B-8 — No physical-device release test.** Everything in §5 is an emulator. The two
  worst defects in this project's history (the missing `INTERNET` permission; a
  mis-decoded PowerShell script) were both invisible to source review and to green tests.

---

## 8. Warnings (non-blocking)

- **W-1 — No AAB in CI.** `ci.yml:377` builds an APK only. The AAB is now proven
  buildable (§4.2) but nothing produces one automatically.
- **W-2 — The artefact-level INTERNET check only runs on `push` to `main`**
  (`ci.yml:318-320`), never on PRs or on `dev`/`merged` — the branch actually in use. The
  cheap source-level grep does run everywhere.
- **W-3 — No release-flavor guard.** Nothing prevents
  `flutter build --release -t lib/main_mock.dart`. The new guard (§9) covers the
  *documented commands*; it cannot stop a hand-typed one.
- **W-4 — `AppConfig.isDev` is dead code.** Staging and prod builds look identical on
  screen, so a wrong-flavor build cannot be caught by eye.
- **W-5 — R8/minification and Dart obfuscation are off**, and there is no mapping file or
  crash reporting. First release will fly blind. This is an open decision, not an
  oversight (`STORE_READINESS.md` §14.2).
- **W-6 — Freezed `toString()` interpolates raw tokens and minors' PII**
  (`token_pair.freezed.dart:39-41`, `student_profile.freezed.dart`). Inert today —
  nothing logs. It becomes a live leak the day any crash reporter is added. Override
  `toString` **before** that happens, not after.
- **W-7 (HIGH — fixable now) — `CachedNetworkImage` disk cache survives logout**, so a
  minor's avatar can persist across accounts on shared hardware. Same defect class as C-2,
  which was fixed for providers only. `STORE_READINESS.md:124` already rates this HIGH and
  fixable today; it is listed here as a warning only because it is a session/privacy
  defect rather than a release-configuration one — **not** because it is less urgent.
- **W-8 (MEDIUM) — The login phone hint is a real-looking Egyptian number**
  (`01021871999`, in both ARB files). It **ships**: it was read off the screen of the
  release build. The same number is the canned profile in `lib/dev/mock_backend.dart:196`.
  If it belongs to a real person, a shipped app is displaying their number to every user.
  It is a design string, so the change is the owner's call — but it deserves one.
- **W-9 — Git hooks are not installed on this clone** (`core.hooksPath` empty,
  `.git/hooks` holds only samples), so local commits and pushes are ungated.
- **W-10 — No orientation lock** on either platform, and iOS opts into iPad
  (`TARGETED_DEVICE_FAMILY = "1,2"`) with landscape never tested.
- **W-11 — Stub screens are reachable from the Profile menu** (Customer Support,
  Refer-a-Friend, disabled avatar upload, "not published" legal). Reviewers open these.
- **W-12 — CI has never been observed running** (R-3). Every CI claim here is SOURCE level.
- **W-13 (LOW) — Keystore gitignore is `android`-scoped only.** See §2.3: a `.jks` placed
  anywhere outside `android/` is committable. Nothing of the sort exists today.
- **W-14 (MEDIUM) — The emulator ran API 36 only.** `minSdk` is 24, and Play's pre-launch
  report exercises several API levels. Nothing below 36 has been run at all. Related:
  `targetSdk 36` brings mandatory edge-to-edge and predictive back, and only the
  onboarding and login screens were seen — the rest of the app is untested under both.
- **W-15 (LOW) — `.ai/audits/current/test-results.md` cannot attribute a test to a file.**
  Its per-test file attribution is visibly wrong (many lines credited to a single golden
  test; 23 of 63 test files get no lines at all), so the record proves the *totals* but
  cannot show that any *specific* test ran. That is why §3 cites a targeted run for the
  new guard rather than the `862 → 864` delta. Worth a `KNOWN_BUGS.md` entry — the
  project's canonical evidence file has a defect in exactly the dimension it is used for.

---

## 9. Changes made

**Six files written, plus one rewritten as a side effect.** Nothing under `contract/`,
`android/`, `ios/`, or `lib/` was touched, and no product behaviour changed.

An earlier draft of this section said "three files" and was wrong: it omitted
`docs/STORE_READINESS.md`, which this audit also edited. That file is **untracked**
(`git log --all -- docs/STORE_READINESS.md` is empty — the "living register" has never
been committed since it was written on 2026-08-23), so `git diff` does not show it and it
is easy to miss. Anyone reviewing this work should check untracked files too. That the
register has never been committed is itself worth fixing — a living document outside
version control has no history and can be lost.

| File | Change | Why |
| --- | --- | --- |
| `docs/RELEASE_SIGNING.md` | `:49` — the release command now reads `flutter build apk --release -t lib/main_prod.dart`, with the artefact evidence for why the flag is not optional | Following the doc literally produced a release APK containing the live staging hostname (§4.3). This is the confirmed defect this audit found. |
| `docs/RELEASE_SIGNING.md` | `## CI` section — replaced "There is no CI yet" with what CI actually does (`build-release-apk`, main-only, unsigned compile gate + `aapt2` proof) | Stale: the job has existed for some time. A doc that denies CI exists misleads whoever next touches signing. |
| `docs/RELEASE_SIGNING.md` | `applicationId` bullet — corrected the claim that the ID "still carries the template's TODO" | The **value** is settled (`build.gradle.kts:43`, artefact-confirmed); only the leftover comment at `:42` is stale. The distinction matters because the ID must never change after release. |
| `test/guards/workflow_test.dart` | New guard pair: *every runnable release-build command targets `lib/main_prod.dart`*, plus a positive companion asserting the scan finds at least three such commands | This project's own rule — "prose rules decay; mechanised rules hold." The prose version had already decayed once. The scan walks `docs/`, `tool/`, `.github/`, `.githooks/` by tree rather than a hand-written file list, treats a bare `flutter build apk` as a release (it is Flutter's default mode), accepts every working spelling of the target flag, and matches only lines that *start* a command so prose explaining the hazard cannot trip it. Both tests **proven able to fail** (§3). |
| `docs/STORE_READINESS.md` | Banner pointing at this audit; `[2026-09-05]` corrections to the AAB row, the account-deletion row (now filed as S38), the release-config scorecard row, and §9 (artefact-confirmed fail-closed signing + the entrypoint defect) | The register's facts had drifted; it is named here as the policy authority, so its stale rows had to be corrected rather than silently contradicted. |
| `docs/ENFORCEMENT.md` | Two rows added to "The rules" — the entrypoint rule and its non-vacuity companion | Fable's finding #10: a rule that exists only as a test, and is listed in no inventory, is a rule the next person cannot find. |
| `tool/verify_guards.ps1` | Seventh probe added to `editProbes` | Same finding. "Proven able to fail" must be repeatable, not a one-off manual edit. The probe reintroduces the defect in its *subtler* form (bare `flutter build apk`, no `--release`), so the harness itself would have caught the hole Fable found in our first guard. |
| `.ai/audits/current/test-results.md` | Rewritten **by `tool/validate.ps1`**, not by hand | Every validate run overwrites it. Listed for completeness because it is a tracked file and will show in `git diff`. |

Deliberately **not** changed, though found: the stale `// TODO` comment at
`android/app/build.gradle.kts:42` (cosmetic; keeping the diff out of the release build
configuration is worth more than tidying it), the mock backend's phone number and OTP
codes (dev-only, artefact-disproven from release), R8/obfuscation posture (open owner
decision), and everything in §7 that is blocked on the contract, a legal asset, design, or
the release environment.

---

## 10. Manual store-console checklist

Nothing below can be established from this repository. Each is classified:
**VERIFIED IN REPOSITORY** / **REQUIRES MANUAL VERIFICATION** / **NOT APPLICABLE** / **UNKNOWN**.

### Google Play Console

| Item | Classification |
| --- | --- |
| Play App Signing enrollment | REQUIRES MANUAL VERIFICATION |
| Upload key generated and backed up | REQUIRES MANUAL VERIFICATION |
| AAB uploaded to a release track | REQUIRES MANUAL VERIFICATION |
| Data Safety form (draft it from `STORE_READINESS.md` §5) | REQUIRES MANUAL VERIFICATION |
| Account-deletion declaration + public web deletion URL | REQUIRES MANUAL VERIFICATION (and blocked by B-3) |
| Privacy policy URL (live, non-PDF) | REQUIRES MANUAL VERIFICATION (blocked by B-4) |
| Content rating questionnaire | REQUIRES MANUAL VERIFICATION |
| Target audience & age groups; under-13 stance | UNKNOWN — owner decision, `STORE_READINESS.md` §14.1 |
| Ads / Advertising ID declaration ("no ad ID") | VERIFIED IN REPOSITORY that no ad SDK exists; the declaration itself REQUIRES MANUAL VERIFICATION |
| App access instructions (reviewer credentials) | REQUIRES MANUAL VERIFICATION (blocked by B-5) |
| Store listing: icon 512, feature graphic 1024×500, ≥2 screenshots, EN+AR descriptions | REQUIRES MANUAL VERIFICATION (blocked by B-6) |
| Developer account verification; 12-tester/14-day gate for newer personal accounts | UNKNOWN — depends on which account publishes |
| Target API level at upload time | VERIFIED IN REPOSITORY — targetSdk 36, artefact-confirmed 2026-09-05 |
| Contact / support information | REQUIRES MANUAL VERIFICATION |

### Apple App Store Connect

| Item | Classification |
| --- | --- |
| Build with Xcode 26 / iOS 26 SDK | UNKNOWN — iOS has never been built (B-7) |
| `PrivacyInfo.xcprivacy` + plugin privacy manifests | VERIFIED IN REPOSITORY as **absent** |
| App Privacy nutrition label | REQUIRES MANUAL VERIFICATION |
| Account deletion (5.1.1(v)) | REQUIRES MANUAL VERIFICATION (blocked by B-3) |
| `ITSAppUsesNonExemptEncryption` | VERIFIED IN REPOSITORY as **absent** — trivial to add, HTTPS-only qualifies as exempt |
| Age rating questionnaire | REQUIRES MANUAL VERIFICATION |
| Demo account for App Review | REQUIRES MANUAL VERIFICATION (blocked by B-5) |
| Support URL, Privacy Policy URL, marketing copy EN+AR, screenshots | REQUIRES MANUAL VERIFICATION (blocked by B-4/B-6) |
| `PRODUCT_BUNDLE_IDENTIFIER` actual value at archive time | REQUIRES MANUAL VERIFICATION — `Info.plist:11` only holds the build-setting reference |
| Supported languages in App Store Connect | REQUIRES MANUAL VERIFICATION — the Xcode project knows only `en`/`Base` |
| Sign in with Apple | NOT APPLICABLE — no third-party login exists |
| App Tracking Transparency | NOT APPLICABLE — zero tracking SDKs |
| Distribution territories (affects US state age-verification laws) | UNKNOWN — owner decision |

---

## 11. Fable review

Fable reviewed this audit and its changes **read-only** — it was instructed not to modify
any file, and it did not. Its job was to find our mistakes, not to fix them.

**Verdict: APPROVE WITH FINDINGS.** It independently confirmed the central defect
(`lib/main.dart:4-6` → `main_dev.dart:5` → `app_config.dart:52` → the staging host),
re-scanned both artefacts and reproduced the contamination results, and confirmed that no
other runnable release command in the repository was missing the flag. It then found real
problems in our work.

### 11.1 Findings accepted and fixed

| # | Finding | What we did |
| --- | --- | --- |
| 1 | **The guard missed a bare `flutter build apk`.** Release is Flutter's *default* build mode, so a command with no `--release` is still a release build — and our guard keyed on the literal `--release`. The subtler form of the exact defect would have passed. | Rewrote the matcher: any `flutter build apk\|appbundle\|ipa\|ios` counts unless it says `--debug`/`--profile`. Proven with a probe. |
| 2 | **The guard could pass vacuously.** It skipped missing files and had no positive assertion, so renaming the doc or rewording the fence would leave it green — the very trap this file's own xargs guard documents at `:301-304`. | Added the positive companion: the scan must find ≥ 3 release commands. Proven by pointing the scan at an empty tree and watching it go red. |
| 3 | **Hand-enumerated file list** — the anti-pattern this same file warns about ("we fixed the instance we noticed is precisely how this recurred"). | Now walks `docs/`, `tool/`, `.github/`, `.githooks/` by tree. |
| 4 | Matcher holes: `flutter  build` (double space), `--target`, `-t=`, quoted and `./`-prefixed and backslash paths. | Whitespace normalized; the target regex accepts every working spelling. Remaining limits (wrapped or line-continued commands) are documented in the test rather than papered over. |
| 5 | **Our scope claim was wrong.** We wrote "three files"; we had also edited `docs/STORE_READINESS.md`, which is untracked and therefore invisible to `git diff`. | §9 corrected and the omission explained, since the same trap will catch the next reviewer. |
| 6 | **Emulator results were phrased as DEVICE-level** in several matrix rows and in the register banner, and we said R-4 was "satisfied". | Every such row now says emulator; the banner says emulator and re-signed; R-4 is **narrowed, not closed** (§5.2). `docs/RISKS.md` deliberately left unedited. |
| 7 | **We cited the wrong evidence for runtime `INTERNET`.** The `ConnectivityService … Capabilities: INTERNET` line is `connectivity_plus` registering a callback (which needs `ACCESS_NETWORK_STATE`); `INTERNET` is enforced at socket creation. | Claim withdrawn. §5.1 states plainly what the evidence does and does not prove. This was our worst error — rounding a level up is the one thing this project's rules single out. |
| 8 | Line-number errors, including one we introduced (`namespace` is at `:28`, not `:27`; `openapi.yaml` `removeFavorite` is at `:1145`). | Corrected here and in the register. |
| 9 | `main_mock.dart` "API base URL: none" was false — it runs `AppConfig.init(Flavor.dev)` and does not override `refreshDioProvider`. | Matrix cell corrected. |
| 10 | **The new rule was registered nowhere** — no `docs/ENFORCEMENT.md` row, and no `tool/verify_guards.ps1` probe, so "proven able to fail" was an unrepeatable manual edit. | Added both. The probe reintroduces the defect in its *subtler* form (bare `flutter build apk`), so the harness would have caught finding #1 by itself. |
| 13 | The AAB's signing status was never stated — and the AAB is the file that gets uploaded. W-7/W-8 carried no severity. | AAB stated unsigned (§4.2); W-7 marked HIGH, W-8 MEDIUM. |
| 14 | **16 KB page-size compliance not assessed** — a Play hard requirement for `targetSdk ≥ 35` since 2025-11-01. | Verified independently (`zipalign -c -P 16` → `Verification successful`) and added to §4.1, along with the complete native-library list. |
| 15 | `allowBackup=false` / `dataExtractionRules` survival into the artefact not checked — and manifest-merge loss is precisely what C-1 was. | Verified in the binary manifest and the AAB protobuf manifest; added to §4.1/§4.2. |
| 16 | Keystore gitignore is `android`-scoped only. | Added to §2.3 and as W-13. |
| 17 | Component inventory incomplete ("the only activity"); emulator was API 36 only; `targetSdk 36` edge-to-edge and predictive back untested. | Full component inventory added to §4.1 (all four components carry explicit `android:exported`); W-14 added. |
| 11 | "+1 is the new guard" was inferred from the test count, and `test-results.md` cannot attribute a test to a file. | §3 now cites a targeted run of the guard file; the record's attribution defect is logged as W-15. |

### 11.2 Findings noted, not acted on

- **Fable questioned whether B-1 strictly meets the brief's CRITICAL definition** (the build
  succeeds, the app starts, nothing is mocked). We keep CRITICAL on impact: a release that
  can reach no backend is not a release. Fable called this defensible.
- **B-2 severity.** Fable agreed HIGH, not CRITICAL — unsigned is the safe alternative to
  debug-signed. Unchanged.
- **`.ai/audits/current/` is not scanned by the new guard.** It holds dated audit records
  that quote broken commands as history; scanning them would eventually punish an accurate
  record. The one live command there already carries the flag.
- **Which APK is on disk.** Fable noted the artefact was rebuilt after the device run. The
  rebuild was re-inspected (§18 of the brief): identical identity, same contamination
  result. Byte-identity with the copy that was installed is not claimed.

### 11.3 Fable could not verify

The emulator no longer has the app installed, so §5 is not reproducible from device state;
the flagless build was overwritten, so its contents rest on our record and the two
independent scans we ran at the time; the "no secrets in history" check was by filename,
not by content scan; and the store-policy dates come from the register's 2026-08-23
research, not from a fresh reading of Google's and Apple's pages. Re-verify those dates
before submission — they moved twice in 2026.
