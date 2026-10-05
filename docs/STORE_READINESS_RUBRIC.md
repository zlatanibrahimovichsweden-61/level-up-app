# Store Readiness Rubric — fixed scale for the Environment & Architecture chapter

**Created:** 2026-10-04 (chapter Wave 0) · **Rule:** the categories, weights and items below are
**frozen for the chapter**. A wave may flip an item from ❌ to ✅ (or back) only with repo or
build evidence; it may not add, remove or re-weight items. Chapter completion does not move a
score; evidence does.

The percentage is **overall store readiness of the product**, not chapter progress and not a
probability of review acceptance. Submission *blockers* are binary and tracked in
`docs/STORE_READINESS.md` and `.ai/audits/current/store_readiness_audit.md` §19; a high score with an
open blocker is still NOT READY.

**Scoring.** Each category has N evidence items worth equal shares of the category weight. Score =
Σ (weight × ✅items / N). Weights sum to 100. An item is ✅ only at the verification level named in its
row (SOURCE / BUILD / ARTEFACT / DEVICE / CI); reading is not running.

**Not-yet-applicable rule.** Category 8 (notifications) stays in the denominator at weight 4 because
the contract already declares the FCM endpoint as stable. It can be closed either by implementing
per-environment Firebase or by a recorded decision that v1 ships without push; both count. No other
category is conditional.

---

## Categories, items and the current score (after Wave 1, 2026-10-06)

Items that moved since Wave 0 are marked **▲**. Evidence for the moves is in
`.ai/audits/current/env_wave1_report.md`.

| # | Category | W | Item (level required) | Google Play | Apple App Store | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | **Application identity** | 10 | a. production id ratified in `DECISIONS.md` (SOURCE) | ✅ ▲ | ✅ ▲ | D-021 ratified 2026-10-06: `com.levelupworld.app` both platforms |
| | | | b. staging identity distinct and installable beside prod (ARTEFACT) | ✅ ▲ | ❌ | `aapt2 dump badging`: `app-prod-release.apk` = `com.levelupworld.app`, `app-staging-release.apk` = `com.levelupworld.app.stg`; iOS single template id until Wave 3 |
| | | | c. development identity behaviour defined and implemented (ARTEFACT) | ✅ ▲ | ❌ | defined: no DEV identity, dev/mock run under staging (D-021 Q2); implemented: `app-staging-debug.apk` built from `main_mock.dart` carries `com.levelupworld.app.stg`; iOS Wave 3 |
| | | | d. display name final per environment, not template (SOURCE) | ✅ ▲ | ❌ | per-flavor `resValue app_name` "Level Up" / "Level Up STG", manifest `@string/app_name`, ARTEFACT `application-label` confirms; iOS `Info.plist` still "Level Up App" |
| | | | e. launcher icon is brand artwork (SOURCE) | ✅ | ✅ | `6fe1125` 2026-09-30, both platforms |
| | | | **category score** | **10.0** | **4.0** | 5/5 · 2/5 |
| 2 | **Environment / build configuration** | 10 | a. Dart flavor model with per-flavor base URL (SOURCE) | ✅ | ✅ | `app_config.dart` |
| | | | b. platform flavors / schemes exist (BUILD) | ✅ ▲ | ❌ | Gradle `productFlavors` `prod`/`staging`; both release variants built 2026-10-06; no Xcode schemes yet |
| | | | c. entrypoint ⇄ flavor coherence enforced by the build (BUILD) | ✅ ▲ | ❌ | Gradle check on `compileFlutterBuild<Variant>`; four invalid combinations refused at BUILD level (no flavor · prod+main_staging · prod+no `-t` · staging+main_mock release), two valid ones built |
| | | | d. production host fails closed when unset (SOURCE) | ✅ | ✅ | `.example` reserved TLD; prod APK carries `TBD.example`, zero staging-host strings |
| | | | e. visible environment indicator in non-prod builds (DEVICE) | ❌ | ❌ | `isDev` dead — Wave 2 |
| | | | **category score** | **8.0** | **4.0** | 4/5 · 2/5 |
| 3 | **Signing** | 10 | a. release signing fails closed in the build (ARTEFACT) / iOS: `DEVELOPMENT_TEAM` set (SOURCE) | ✅ | ❌ | `build.gradle.kts` `findByName("release")`; no team in `pbxproj` |
| | | | b. upload key generated and stored off-repo / distribution certificate + profile (owner attestation) | ❌ | ❌ | none |
| | | | c. Play App Signing enrolled / `ExportOptions.plist` + export method (SOURCE) | ❌ | ❌ | none |
| | | | d. CI signing by injected secret, no secret in repo (CI) | ❌ | ❌ | none |
| | | | **category score** | **2.5** | **0.0** | 1/4 · 0/4 |
| 4 | **Release artefact** | 10 | a. release artefact builds for the platform (ARTEFACT) | ✅ | ❌ | `app-prod-release.apk` 60.9 MB 2026-10-06 (AAB 2026-09-05); iOS never built |
| | | | b. artefact inspected: no staging/mock strings in prod (ARTEFACT) | ✅ | ❌ | 2026-10-06 `libapp.so` of the prod APK: 0 × staging host, 0 × mock |
| | | | c. store-format artefact (AAB / IPA) produced by CI (CI) | ❌ | ❌ | CI builds APK; never ran |
| | | | d. release artefact run on a physical device (DEVICE) | ❌ | ❌ | R-4; unsigned by design |
| | | | **category score** | **5.0** | **0.0** | 2/4 · 0/4 |
| 5 | **Store listing / metadata** | 8 | a. developer account decided and available (owner) | ❌ | ❌ | BS-D-03; "to be coordinated" (Seif 2026-10-06) |
| | | | b. app record created; id / name reserved (owner) | ❌ | ❌ | Play URL 404 for the ratified ids 2026-10-06 — nothing registered |
| | | | c. listing assets produced (SOURCE) | ❌ | ❌ | none |
| | | | d. listing copy, category, age rating answered (owner) | ❌ | ❌ | none |
| | | | **category score** | **0.0** | **0.0** | |
| 6 | **Privacy / compliance** | 12 | a. minimal permission posture (ARTEFACT) | ✅ | ✅ | prod APK 2026-10-06: INTERNET + ACCESS_NETWORK_STATE (+ the AGP-generated DYNAMIC_RECEIVER_NOT_EXPORTED self-permission) |
| | | | b. zero third-party data egress (SOURCE) | ✅ | ✅ | no SDKs |
| | | | c. privacy policy reachable in-app (DEVICE) | ❌ | ❌ | placeholder URLs |
| | | | d. account deletion + cancel flow built (DEVICE) | ❌ | ❌ | contract stable, UI absent |
| | | | e. Data safety form / App Privacy label drafted (owner) | ❌ | ❌ | inventory only |
| | | | f. platform declaration artefact: Play target-audience & content answers / iOS `PrivacyInfo.xcprivacy` (SOURCE) | ❌ | ❌ | none |
| | | | **category score** | **4.0** | **4.0** | 2/6 each |
| 7 | **Backend production readiness** | 12 | a. production host declared in the contract `servers:` block (SOURCE) | ❌ | ❌ | still staging only; planned host named by Seif but explicitly "not ready, not in servers:" |
| | | | b. production reviewer-login path exists (contract) | ❌ | ❌ | OTP bypass is staging-only |
| | | | c. a prod build reaches the prod backend (DEVICE) | ❌ | ❌ | impossible today |
| | | | **category score** | **0.0** | **0.0** | |
| 8 | **Notifications / Firebase** | 4 | a. decision recorded: push in v1 or deferred (SOURCE) | ❌ | ❌ | Seif: "treat push as not ready" — a status, not a v1 decision |
| | | | b. if in v1: per-environment Firebase apps against ratified ids (SOURCE) — N/A if deferred | ❌ | ❌ | none; slot and guard prepared |
| | | | **category score** | **0.0** | **0.0** | |
| 9 | **CI/CD** | 8 | a. CI runs the shared quality gate (SOURCE) | ✅ | ✅ | `ci.yml` analyze-and-test |
| | | | b. CI observed green at least once (CI) | ❌ | ❌ | R-3 |
| | | | c. CI builds the platform's store artefact (CI) | ❌ | ❌ | APK only (`--flavor prod` since Wave 1); no iOS job; never ran |
| | | | d. release pipeline to a store track (CI) | ❌ | ❌ | none |
| | | | **category score** | **2.0** | **2.0** | 1/4 each |
| 10 | **Testing & verification** | 8 | a. suite green (BUILD) | ✅ | ✅ | 2046 passed / 0 failed / 0 skipped, 2026-10-06 |
| | | | b. guards cover release invariants (BUILD) | ✅ | ✅ | + identity, SDK pins, flavor/entry coherence (11 probes proven by `verify_guards.ps1`) |
| | | | c. debug build device-verified on the platform (DEVICE) | ✅ | ❌ | device walks 2026-09 (pre-flavor); no iOS device ever |
| | | | d. release build device-verified (DEVICE) | ❌ | ❌ | R-4 |
| | | | **category score** | **6.0** | **4.0** | 3/4 · 2/4 |
| 11 | **Platform-specific store requirements** | 8 | a. target/deployment version meets the store rule (ARTEFACT / SOURCE) | ✅ | ✅ | prod APK `targetSdkVersion 36` ≥ 36 `[GOOGLE]`; iOS 13.0 in code ≥ 13 `[APPLE]` (15.0 ratified, Wave 3) |
| | | | b. store-format artefact producible: AAB / Podfile + Xcode 26 build (ARTEFACT) | ✅ | ❌ | AAB 2026-09-05; no Podfile |
| | | | c. 16 KB page alignment / `ITSAppUsesNonExemptEncryption` + privacy manifest (ARTEFACT / SOURCE) | ✅ | ❌ | audit 2026-09-05; keys absent |
| | | | d. Play web deletion URL / iPad screenshots-or-iPhone-only decision (owner) | ❌ | ❌ | none |
| | | | **category score** | **6.0** | **2.0** | 3/4 · 1/4 |
| | **Total** | **100** | | **43.5 → 44%** | **20.0 → 20%** | |

```text
Google Play Readiness:      44%
Apple App Store Readiness:  20%
```

**Blockers still open regardless of score:** the 17 A-items in `store_readiness_audit.md` §19, of which
this chapter can close only the identity/environment ones. Wave 1 closed the Android half of the identity
blocker (ratified, distinct, artefact-verified ids); the iOS half (B-15-class items) waits for Wave 3.

---

## Score log

| Date | Wave | Google Play | Apple App Store | What moved | Evidence |
| --- | --- | --- | --- | --- | --- |
| 2026-10-04 | 0 — architecture & identity decision | 32% | 18% | baseline; nothing moved (Wave 0 is documentation and a decision request) | this file |
| 2026-10-06 | 1 — D-021 ratified; Android environment architecture | **44%** (+12) | **20%** (+2) | Play: 1a–1d (ratified id, distinct staging id, dev behaviour, per-flavor names) and 2b–2c (flavors exist, coherence enforced by the build) — 6 items. App Store: 1a only (the ratified id is platform-neutral; everything else waits for the Mac). Nothing moved on signing, listing, backend, notifications, CI | `env_wave1_report.md` (aapt2 badging of three APKs, four refused builds, 2046-test suite, 11/11 guard probes) |
