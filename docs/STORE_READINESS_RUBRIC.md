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

## Categories, items and the Wave 0 score (2026-10-04)

| # | Category | W | Item (level required) | Google Play | Apple App Store | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | **Application identity** | 10 | a. production id ratified in `DECISIONS.md` (SOURCE) | ❌ | ❌ | D-021 proposed only |
| | | | b. staging identity distinct and installable beside prod (ARTEFACT) | ❌ | ❌ | single id per platform |
| | | | c. development identity behaviour defined and implemented (ARTEFACT) | ❌ | ❌ | D-021 Q2 open |
| | | | d. display name final per environment, not template (SOURCE) | ❌ | ❌ | `level_up_app` / "Level Up App" |
| | | | e. launcher icon is brand artwork (SOURCE) | ✅ | ✅ | `6fe1125` 2026-09-30, both platforms |
| | | | **category score** | **2.0** | **2.0** | 1/5 each |
| 2 | **Environment / build configuration** | 10 | a. Dart flavor model with per-flavor base URL (SOURCE) | ✅ | ✅ | `app_config.dart` |
| | | | b. platform flavors / schemes exist (BUILD) | ❌ | ❌ | none |
| | | | c. entrypoint ⇄ flavor coherence enforced by the build (BUILD) | ❌ | ❌ | text guard only |
| | | | d. production host fails closed when unset (SOURCE) | ✅ | ✅ | `.example` reserved TLD |
| | | | e. visible environment indicator in non-prod builds (DEVICE) | ❌ | ❌ | `isDev` dead |
| | | | **category score** | **4.0** | **4.0** | 2/5 each |
| 3 | **Signing** | 10 | a. release signing fails closed in the build (ARTEFACT) / iOS: `DEVELOPMENT_TEAM` set (SOURCE) | ✅ | ❌ | `build.gradle.kts:52-71`; no team in `pbxproj` |
| | | | b. upload key generated and stored off-repo / distribution certificate + profile (owner attestation) | ❌ | ❌ | none |
| | | | c. Play App Signing enrolled / `ExportOptions.plist` + export method (SOURCE) | ❌ | ❌ | none |
| | | | d. CI signing by injected secret, no secret in repo (CI) | ❌ | ❌ | none |
| | | | **category score** | **2.5** | **0.0** | 1/4 · 0/4 |
| 4 | **Release artefact** | 10 | a. release artefact builds for the platform (ARTEFACT) | ✅ | ❌ | APK+AAB 2026-09-05; iOS never built |
| | | | b. artefact inspected: no staging/mock strings in prod (ARTEFACT) | ✅ | ❌ | audit 2026-09-05 |
| | | | c. store-format artefact (AAB / IPA) produced by CI (CI) | ❌ | ❌ | CI builds APK; never ran |
| | | | d. release artefact run on a physical device (DEVICE) | ❌ | ❌ | R-4 |
| | | | **category score** | **5.0** | **0.0** | 2/4 · 0/4 |
| 5 | **Store listing / metadata** | 8 | a. developer account decided and available (owner) | ❌ | ❌ | BS-D-03 |
| | | | b. app record created; id / name reserved (owner) | ❌ | ❌ | unclaimed |
| | | | c. listing assets produced (SOURCE) | ❌ | ❌ | none |
| | | | d. listing copy, category, age rating answered (owner) | ❌ | ❌ | none |
| | | | **category score** | **0.0** | **0.0** | |
| 6 | **Privacy / compliance** | 12 | a. minimal permission posture (ARTEFACT) | ✅ | ✅ | INTERNET + network state only |
| | | | b. zero third-party data egress (SOURCE) | ✅ | ✅ | no SDKs |
| | | | c. privacy policy reachable in-app (DEVICE) | ❌ | ❌ | placeholder URLs |
| | | | d. account deletion + cancel flow built (DEVICE) | ❌ | ❌ | contract stable, UI absent |
| | | | e. Data safety form / App Privacy label drafted (owner) | ❌ | ❌ | inventory only |
| | | | f. platform declaration artefact: Play target-audience & content answers / iOS `PrivacyInfo.xcprivacy` (SOURCE) | ❌ | ❌ | none |
| | | | **category score** | **4.0** | **4.0** | 2/6 each |
| 7 | **Backend production readiness** | 12 | a. production host declared in the contract `servers:` block (SOURCE) | ❌ | ❌ | staging only |
| | | | b. production reviewer-login path exists (contract) | ❌ | ❌ | OTP bypass is staging-only |
| | | | c. a prod build reaches the prod backend (DEVICE) | ❌ | ❌ | impossible today |
| | | | **category score** | **0.0** | **0.0** | |
| 8 | **Notifications / Firebase** | 4 | a. decision recorded: push in v1 or deferred (SOURCE) | ❌ | ❌ | none |
| | | | b. if in v1: per-environment Firebase apps against ratified ids (SOURCE) — N/A if deferred | ❌ | ❌ | none |
| | | | **category score** | **0.0** | **0.0** | |
| 9 | **CI/CD** | 8 | a. CI runs the shared quality gate (SOURCE) | ✅ | ✅ | `ci.yml` analyze-and-test |
| | | | b. CI observed green at least once (CI) | ❌ | ❌ | R-3 |
| | | | c. CI builds the platform's store artefact (CI) | ❌ | ❌ | APK only; no iOS job |
| | | | d. release pipeline to a store track (CI) | ❌ | ❌ | none |
| | | | **category score** | **2.0** | **2.0** | 1/4 each |
| 10 | **Testing & verification** | 8 | a. suite green (BUILD) | ✅ | ✅ | 2036 passed / 0 failed, 2026-10-04 baseline |
| | | | b. guards cover release invariants (BUILD) | ✅ | ✅ | entrypoint, INTERNET, palette, fontSize, Bloc scope… |
| | | | c. debug build device-verified on the platform (DEVICE) | ✅ | ❌ | device walks 2026-09; no iOS device ever |
| | | | d. release build device-verified (DEVICE) | ❌ | ❌ | R-4 |
| | | | **category score** | **6.0** | **4.0** | 3/4 · 2/4 |
| 11 | **Platform-specific store requirements** | 8 | a. target/deployment version meets the store rule (ARTEFACT / SOURCE) | ✅ | ✅ | target 36 ≥ 36 `[GOOGLE]`; 13.0 ≥ 13 `[APPLE]` |
| | | | b. store-format artefact producible: AAB / Podfile + Xcode 26 build (ARTEFACT) | ✅ | ❌ | AAB 2026-09-05; no Podfile |
| | | | c. 16 KB page alignment / `ITSAppUsesNonExemptEncryption` + privacy manifest (ARTEFACT / SOURCE) | ✅ | ❌ | audit 2026-09-05; keys absent |
| | | | d. Play web deletion URL / iPad screenshots-or-iPhone-only decision (owner) | ❌ | ❌ | none |
| | | | **category score** | **6.0** | **2.0** | 3/4 · 1/4 |
| | **Total** | **100** | | **31.5 → 32%** | **18.0 → 18%** | |

```text
Google Play Readiness:      32%
Apple App Store Readiness:  18%
```

**Blockers still open regardless of score:** the 17 A-items in `store_readiness_audit.md` §19, of which
this chapter can close only the identity/environment ones (A-5 partially, B-1, B-15).

---

## Score log

| Date | Wave | Google Play | Apple App Store | What moved | Evidence |
| --- | --- | --- | --- | --- | --- |
| 2026-10-04 | 0 — architecture & identity decision | 32% | 18% | baseline; nothing moved (Wave 0 is documentation and a decision request) | this file |
