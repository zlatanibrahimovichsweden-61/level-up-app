# Level Up — Independent Store Readiness Re-check (2026-10-04)

**Type:** investigation only. No application, configuration, manifest, plist, Gradle, CI, contract or dependency file was modified; nothing was committed. The only writes are this file, `store_readiness_recheck_ledger.md`, and scratchpad logs outside the repository.
**Question answered:** if the 2026-09-22 audit were ignored and the repository re-investigated today, what is the actual store-readiness status?
**Method:** every previous blocker was re-derived from the current tree, today's production build, the current contract pin and today's fetch of the official policy pages; the previous report was read only to enumerate what to re-check. Verification levels: SOURCE → BUILD → ARTEFACT → CONTRACT → WEB → UNVERIFIED (macOS / signed build / device / console).
**Companion:** `store_readiness_recheck_ledger.md` (full evidence tables A–D).

---

## 1. Executive summary

**Verdict: NOT READY** for both stores.

- **8 engineering/content blockers** remain, independently re-derived and disjoint: 5 need a change in this repository or supplied content (production host line, privacy policy + legal copy, account-deletion flow, iOS privacy manifest, the "Message" placeholder tab) and 4 need the backend (production host announcement, production reviewer login, retention/erasure/sub-processor facts, web deletion URL). The production host is counted once.
- **7 release prerequisites** (keystore + Play App Signing, macOS build/archive, identifier ratification D-021, console forms, listing assets, developer accounts, closed-test cohort) are human/console steps with no code defect behind them. The previous audit counted most of these as blockers; this re-check lists them separately so the blocker count reflects defects, not paperwork.
- **Of the previous 17 blockers:** 8 still confirmed · 1 partially fixed and re-graded below blocker (store identity: icons fixed, label/splash remain) · 7 re-classified as prerequisites (signing, iOS build, forms, iPad screenshots, Content Rights, production access, developer account) · 1 stale as a blocker (adr-171 link: nothing links out at HEAD) · 0 fixed outright.
- **Changed since 2026-09-22 (12 commits):** launcher icons replaced on both platforms (`6fe1125`); Leaderboard tab un-gated (`09dca36`) — which also made the user-generated-content exposure live (new high-risk item H-1); Waves 01–22 shipped; contract re-vendored twice to 3.28.0-m1 (inbox endpoints now stable, no production host, no reviewer mechanism); Environment chapter opened with D-021 proposed. Nothing landed for deletion, legal copy, privacy manifest, production host or reviewer access.
- **Corrections to the previous audit:** "SwiftPM default-on / hybrid build" is not supported by the project's tool state (`swift_package_manager_enabled: ios:false`); "ScreenPreventerKit second pod" is unverified (derived from upstream `master`, the pinned pod is `ScreenProtectorKit 1.5.1`); the Play developer-verification "deadline 2026-09-30" applied only to Brazil, Indonesia, Singapore and Thailand (global rollout 2027); the retention questions were never filed with the backend.
- **Verified today at BUILD/ARTEFACT:** `flutter test` 2036 passed / 0 failed; production AAB builds (59.3 MB), unsigned by design, clean of staging and mock strings, but ships the placeholder host and the three `levelup.example` URLs.

---

## 2. Baseline snapshot

| Item | Value | Evidence |
|---|---|---|
| Branch / HEAD | `merged` / `f4cd5a9` (2026-10-04) | `git rev-parse HEAD` |
| Remote | `origin` = `zlatanibrahimovichsweden-61/level-up-app`; `merged` is **4 ahead** of `origin/merged`, nothing pushed since `e6e6567` | `git status -sb` |
| Previous audit HEAD | `bf967d6` (2026-09-22); **12 commits** since; 256 files, +38,786 / −3,483 | `git log bf967d6..HEAD` |
| Dirty tree | 20 modified + 5 untracked (settings/elevation Wave 21 work, test goldens, four audit artefacts, one new test); fingerprint `fee80139…` unchanged by this re-check | `git status --porcelain \| sha1sum` |
| Toolchain | Flutter 3.44.7 stable (engine 7076f47b), Dart SDK constraint `^3.10.4` | `flutter --version`; `pubspec.yaml:22` |
| App version | `1.0.0+1` | `pubspec.yaml:19` |
| Android | `applicationId com.levelup.level_up_app`; min/target/compile SDK inherited from Flutter (24 / 36 / 36 per `docs/ENVIRONMENTS.md` §3, ARTEFACT-confirmed 2026-09-05 and today's manifest carries `targetSdk 36`); label `level_up_app` | `android/app/build.gradle.kts:28,43,46-49`; `AndroidManifest.xml:27` |
| iOS | `com.levelup.levelUpApp`; `IPHONEOS_DEPLOYMENT_TARGET 13.0`; `TARGETED_DEVICE_FAMILY "1,2"`; no `DEVELOPMENT_TEAM`; `CODE_SIGN_STYLE Automatic`; no entitlements, no `PrivacyInfo.xcprivacy`, no Podfile; knownRegions `en, Base`; display name "Level Up App", bundle name `level_up_app` | `project.pbxproj:349,353,371,383`; `Info.plist:8,16`; `ls ios/Runner` |
| Contract pin | `0df5cf4` = **3.28.0-m1**, vendored 2026-10-04 (previous audit: 768e67d, 3.22.0-m1); 38 stable / 16 draft / 54 ops; `servers:` staging only | `contract/SOURCE.md`; `openapi.yaml:107-109` |
| Validation scripts | `tool/validate.ps1` / `validate.sh` (format + analyze + tests; **not run here because the format step rewrites source**); `tool/verify_guards.ps1` | `tool/` |
| Tests (today) | **2036 passed / 0 failed / 0 skipped**, exit 0 (BUILD) | scratchpad `recheck/flutter_test.log` |
| Production AAB (today) | `flutter build appbundle --release -t lib/main_prod.dart` → 62,144,628 bytes, 3 ABIs, **unsigned**, R8 mapping + native symbols embedded | scratchpad `recheck/appbundle_build.log`; zip inspection |
| Existing audit artefacts | `store_readiness_audit.md` (FINAL v2), `_matrix.md`, `_state.md`, `store_submission_checklist.md`, `store_readiness_parts/01–20` (2026-09-22); newer: `wave_20_21_state_audit.md` (09-30), `app_identity_environment_audit_2026-10-04.md`, `env_wave0_report.md`, `env_chapter_state.md`, `notification_inbox_3_28_investigation.md` (10-04); `docs/STORE_READINESS.md` living register (uncommitted edits dated 2026-09-29); `docs/STORE_READINESS_RUBRIC.md` (Play 32 % / App Store 18 % at Wave 0) | `ls -lt .ai/audits/current` |

---

## 3. Previous 17 blockers — current verification

Full table with evidence: ledger §A. Summary:

| # | Previous blocker | Status today |
|---|---|---|
| 1 | Production host placeholder | **Confirmed** — `app_config.dart:54`; ships in today's AAB; contract still staging-only at 3.28.0-m1 |
| 2 | Privacy policy unreachable | **Confirmed** — `levelup.example` URLs ship; `/legal/*` say "not published"; S30 open |
| 3 | No deletion / cancel flow | **Confirmed** — only the `403` error mapping exists; both contract ops stable |
| 4 | Required-reason API undeclared, no Runner manifest | **Confirmed at SOURCE** — `device_info_plus` reads disk-space keys, declares none; Runner manifest absent; upload effect needs an archive |
| 5 | Template identity | **Partially fixed** — icons replaced; label, bundle name, splash still template → High, not blocker |
| 6 | Two placeholder tabs | **Partially fixed** — Leaderboard real; "Message" remains → still blocker-grade |
| 7 | Reviewer login mechanism | **Confirmed** — bypass "Absent from production configuration" (`openapi.yaml:96-98`) |
| 8 | Web deletion URL + "paid"/"refund" copy | **Confirmed** — URL nonexistent; copy at `openapi.yaml:1089-1093` |
| 9 | Retention answers absent | **Confirmed** — and never filed in `seif_fight.md`; `security.md` cited but not vendored |
| 10 | Unsigned artefact | **Fact confirmed; re-classified** as release prerequisite (fail-closed design, documented) |
| 11 | iOS never built | **UNVERIFIED — needs macOS**; "no Podfile" is not a defect |
| 12 | False declarations / Data safety gates closed track | **Console action**, dependent on 2/3/9; gating rule re-verified at WEB (§8) |
| 13 | iPad screenshots or iPhone-only | **Decision + console**; family "1,2" unchanged; rule re-verified at WEB (§7) |
| 14 | Content Rights | **Console** |
| 15 | Production-access review | **Console/process**; 12 × 14 rule re-verified at WEB |
| 16 | adr-171 link on iOS | **Not a blocker at HEAD** — no link exists; decision item |
| 17 | Developer account | **Account prerequisite** |

---

## 4. Fixed findings (since 2026-09-22)

| Finding | Fixed by | Evidence |
|---|---|---|
| Launcher icons were the Flutter template on both platforms | `e4d1401` → `634cc34` → `6fe1125` (2026-09-30, mark-only artwork) | Android `mipmap-xxxhdpi/ic_launcher.png` md5 `e70a5834…` vs template `57838d52…`; adaptive icon `ic_launcher.xml` with designer foreground, inset 0; iOS 1024 icon md5 `d98eeda4…` vs template `c785f893…`, 1024×1024 RGB, no alpha (ASC requirement met) |
| Leaderboard primary tab was a "Coming soon" placeholder | `09dca36` (2026-09-22), D-008 closed after `docs/D008_LEADERBOARD_AUDIT.md` | `app_router.dart:188-191` → `LeaderboardScreen`; `tab_placeholder.dart:43-49` |
| Deletion blocked by the contract (older registers) | Contract 3.3.0-m1+ (`requestAccountDeletion` / `cancelAccountDeletion` stable) | `openapi.yaml:1070-1136`; `docs/STORE_READINESS.md:33` working copy |

No previous **blocker** is fixed outright; two are half-fixed (#5, #6).

---

## 5. Stale or incorrect previous findings

| Previous statement | Today's finding | Evidence |
|---|---|---|
| Two placeholder primary tabs | One ("Message") | `tab_placeholder.dart:7` "One is left: Message." |
| Icons md5-identical to the template | Replaced | §4 |
| "SwiftPM is default-on; the iOS build may be hybrid" | Not supported: the Flutter tool records SwiftPM **off** for this project | `.flutter-plugins-dependencies` → `"swift_package_manager_enabled":{"ios":false,"macos":false}` (regenerated 2026-10-04 by today's build) |
| "ScreenPreventerKit — a second closed-source pod — was never inventoried" | Unverified. The pinned plugin's podspec depends on `ScreenProtectorKit 1.5.1` only; the ScreenPreventerKit import was read from upstream `master`, not from 1.5.1 | `screen_protector-1.5.3/ios/screen_protector.podspec:19`; `parts/11` row "Residual technique" cites `master` |
| "No Podfile" listed as an iOS buildability fact | Not a defect — Flutter generates it on the first `flutter build ios`; buildability itself stays UNVERIFIED | `ios/` listing |
| adr-171 link = "A-conditional" blocker | Nothing links out today; the only `launchUrl` call opens the three legal URLs in the external browser | `grep launchUrl lib` → `login_screen.dart:123` only; no `redemption`/`subscription-codes` string in `libapp.so` |
| "Developer verification deadline 2026-09-30" (Play Console item) | That date applied to installs in Brazil, Indonesia, Singapore and Thailand only; global rollout planned for 2027; Egypt not in the initial set | WEB (§8, G7) |
| Retention Q4–Q7 "outstanding with Seif" | Outstanding, but never filed — no retention question exists in `docs/seif_fight.md` | `grep -i retention docs/seif_fight.md` → none |
| `ar-EG` listing language (draft v1) | v2 had already corrected to `ar`; re-verified today: Play lists "Arabic – ar" with no regional variant | WEB (§8, G8) |
| "7 points" of mandated deletion copy (draft v1) | v2 had already corrected; the mandated block is `openapi.yaml:1089-1097` | contract |
| "Data safety gates the closed track" | **Correct** — re-verified at WEB; internal testing only is exempt | §8, G2 |
| "iPad screenshots mandatory with family 1,2" | **Correct** — re-verified: iPad 13-inch set required if the app runs on iPad | §7, A5 |

---

## 6. New findings (not in the previous audit, or newly live)

| ID | Finding | Evidence | Classification |
|---|---|---|---|
| H-1 | The live leaderboard renders peer display names and avatars to other students, with no report/block control, no terms acceptance, and no server-side name moderation (only avatars are moderated) | `leaderboard_row.dart:99`, `podium.dart:154`, `top_student_section.dart:285-291`; `openapi.yaml:870` (avatar moderation only); no acceptance control in auth/registration; Apple 1.2 and Play UGC text re-verified today (§7 A8, §8 G6) | **Likely rejection risk / UGC decision** (Option 0: rank + points + avatar only, or report/block + terms acceptance) |
| E-7′ | The backend retention/erasure/sub-processor question was never filed; `security.md`, which the contract cites for the OTP whitelist, is not part of the vendored contract | `openapi.yaml:98`; `ls contract/` | Needs backend action |
| M-1 | No guard test prevents a future call to the three web-only operations; the contract's replay note still describes an "app session" path | no `x-consumers`/`redeemSubscriptionCode` in `test/`; `openapi.yaml` ≈ `:1996-2000` | Medium |
| M-3 | `/track-select` is a dead placeholder route with no callers | `app_router.dart:488-496`; grep | Informational |
| M-6 | Release hygiene: 4 unpushed commits and a 25-file dirty tree; a build taken now is not a build of any commit | `git status` | Process |
| — | `.flutter-plugins-dependencies` shows SwiftPM off (corrects the previous "hybrid" expectation) | see §5 | Correction |
| — | `screen_protector` iOS plugin ships **no** privacy manifest (0 `PrivacyInfo.xcprivacy`); `device_info_plus` ships one with an empty API list | pub cache listing | Supports E-4 |

---

## 7. Apple App Store readiness

Policy items were re-fetched 2026-10-04 by a delegated researcher (paraphrases with section anchors; only the 3.1.3(b) quote is verbatim). Classification: **hard blocker / likely rejection / conditional / informational / not applicable / satisfied**.

| Item | Rule (official page, fetched 2026-10-04) | Repository fact today | Classification |
|---|---|---|---|
| Account deletion | 5.1.1(v): apps that support account creation must offer in-app deletion; may complete later if the user is told and confirmed (`developer.apple.com/support/offering-account-deletion-in-your-app/`) | No flow (E-3); contract's 30-day grace + daily job fits "complete later" if the app states it | **Hard blocker** |
| Privacy policy | 5.1.1(i): link in metadata and in app | Placeholder URLs; "not published" screens (E-2) | **Hard blocker** |
| Required-reason APIs | `NSPrivacyAccessedAPICategoryDiskSpace` is a required-reason category (includes `systemFreeSize`/`systemSize`, the Swift names of `NSFileSystemFreeSize`/`NSFileSystemSize` — mapping inferred); since 2024-05-01 apps not describing required-reason use "are not accepted" by App Store Connect (Apple documentation-data JSON for `describing-use-of-required-reason-api`); developer-forum posts show ITMS-91053 sometimes arriving as a warning | Plugin reads the keys; no declaration anywhere (E-4) | **Hard blocker at upload per official text**; block-vs-warn in practice UNVERIFIED |
| Completeness | 2.1(a): final versions only; placeholder text and temporary content must be removed; 4.2 minimum functionality | "Message" tab "Coming soon" (E-5); three Home "Coming soon" cards; four inert ON toggles; three disabled shells (H-3) | **Likely rejection** (tab) / conditional (cards, toggles, shells) |
| Demo account | 2.1(a) + App Review Information: demo credentials required when sign-in is required; must not expire; demo mode needs prior approval. No Apple text about SMS/OTP found (inference: a US reviewer cannot receive Egyptian SMS) | OTP bypass staging-only (E-6) | **Hard blocker** (no reviewable login in production) |
| Purchases / external links | 3.1.1(a): link-outs to the developer's purchase site need storefront-specific entitlements; no entitlement needed in the US; "in all other storefronts" buttons/links/CTAs to non-IAP purchasing are prohibited. Egypt is named on no page read (conclusion by absence) | No link, price or purchase surface at HEAD; purchase-silent | **Not applicable today**; adr-171 link would be a violation on the Egypt storefront → decision |
| Access to web-purchased content | 3.1.3(b) multiplatform: allowed "provided those items are also available as in-app purchases within the app"; 3.1.3 intro and 3.1.3(f): no in-app encouragement of other purchase methods | App shows entitlement state the server returns; no IAP offered → does not satisfy 3.1.3(b)'s condition; 3.1.3(f) fits only as a free companion to a paid web tool | **Conditional risk** — explain the model in Review Notes; owner decision on positioning |
| iPad | Screenshot specifications: iPad 13-inch screenshots required if the app runs on iPad; smaller iPad sizes derived | `TARGETED_DEVICE_FAMILY "1,2"`; iPad orientations in `Info.plist` | **Prerequisite** (asset) or decision (iPhone-only = code change) |
| Xcode floor | Upcoming requirements: since 2026-04-28 uploads must be built with Xcode 26 / iOS 26 SDK. A line about "target iOS 13 or later from 2026-09-09" came back from the fetch but was not independently confirmed | Deployment 13.0; never built | **Prerequisite** (macOS with Xcode 26); 13.0 floor UNVERIFIED |
| UGC | 1.2: filter, report with timely response, block, published contact info; developer removes violating content. Whether leaderboard names are UGC is a judgment call | Names shown, nothing else (H-1) | **Likely rejection risk / decision** |
| Content Rights | App Information reference: apps showing third-party content must hold the rights | Question bank is server content | **Console** |
| Localisation accuracy | 2.3 metadata accuracy | Always Arabic, bundle `en` only (H-4) | Conditional |
| Export compliance | `ITSAppUsesNonExemptEncryption` absent → answered at upload | Standard HTTPS/Keychain only | Informational (answer "No") |
| Permissions / purpose strings | None needed | No camera/photos/location/tracking | **Satisfied** |
| Sign in with Apple / ATT | Own account system, no tracking | — | **Not applicable** |

---

## 8. Google Play readiness

| Item | Rule (official answer page, fetched 2026-10-04) | Repository fact today | Classification |
|---|---|---|---|
| Account deletion | 13327111: in-app path **and** a web link resource; web link declared in the Data safety form | No in-app flow (E-3); no web URL (E-8) | **Hard blocker** (both halves) |
| Data safety | 10787469: required for apps on closed, open or production tracks; internal-testing-only exempt; privacy-policy link required even with no collection | Truthful form impossible until E-2/E-3/E-7 | **Gates closed testing** — prerequisite dependent on blockers |
| Privacy policy | 10144311: active, public, non-geofenced, non-PDF URL in console **and** link/text in app | E-2 | **Hard blocker** |
| Production access | 14151465: personal accounts created after 2023-11-13 need a closed test with ≥12 testers opted in for 14 continuous days, then apply | Account type unknown | **Process prerequisite** |
| Target API | 11926878: from 2026-08-31 new apps/updates target API 36 (extension to 2026-11-01 on request) | targetSdk 36 (ARTEFACT) | **Satisfied** |
| 16 KB pages | Required for apps with native code targeting API 35+; dates differ between pages (2027-02-01 for updates) | Flutter ships native code; 16 KB alignment ARTEFACT-verified 2026-09-22 (APK); AAB not re-measured today | **Satisfied (carried)** |
| UGC | 9876937: terms acceptance before creating UGC; moderation; in-app report and block | H-1 | **Likely rejection risk / decision** |
| Developer verification | Sep 30 2026 protections apply to installs from participating stores in Brazil, Indonesia, Singapore, Thailand; global 2027; Play-verified developers with Play App Signing registered automatically | Account not created | **Informational for Egypt**; Play Console verification still required at account creation |
| Listing languages | Translate & localize: "Arabic – ar", no regional variant | ARB `ar` + `en` | **Satisfied** (`ar` + `en` listings) |
| Target audience / Families | 9867159: any under-13 group → Families policy + self-certified ads SDKs; 13–15 only where local law treats them as children; child-appealing marketing can be rejected | No age floor (H-5); no ads SDK | **Decision** (legal memo on audience) |
| Permissions | — | `INTERNET`, `ACCESS_NETWORK_STATE`; no `AD_ID`, no `POST_NOTIFICATIONS` (ARTEFACT) | **Satisfied**; declare AD_ID "No" |
| App access | Reviewer instructions must work | E-6 | **Hard blocker** |
| Application ID permanence | Fixed at first upload | Template id unratified (D-021) | **Prerequisite/decision** |
| Package / label | — | `android:label="level_up_app"` (H-2) | Conditional (reviewer-visible) |

---

## 9. Android release readiness

| Check | Result (today) | Level |
|---|---|---|
| Release build | `flutter build appbundle --release -t lib/main_prod.dart` succeeds (139 s Gradle), 59.3 MB | BUILD |
| Signing | **Unsigned** — no `META-INF` signature; `key.properties` absent; design is fail-closed (`build.gradle.kts:19-25,52-71,76-81`), procedure in `docs/RELEASE_SIGNING.md`, template `android/key.properties.example`. Intentional developer-side signing, **not** an incomplete pipeline; still a prerequisite for upload | ARTEFACT |
| Application ID / version | `com.levelup.level_up_app`, `1.0.0` / `1` (`pubspec.yaml:19` via Flutter) | SOURCE |
| SDKs | min 24 / target 36 / compile 36 (Flutter 3.44.7 defaults) | SOURCE (+ `ENVIRONMENTS.md` §3) |
| R8 / shrinking | **ON** — `proguard.map` embedded; native `.sym` for 3 ABIs; `docs/STORE_READINESS.md:68,195` still say OFF (stale) | ARTEFACT |
| Permissions / manifest | `INTERNET`, `ACCESS_NETWORK_STATE`; `allowBackup=false` + `dataExtractionRules`; no `VIEW` intent filters, no `POST_NOTIFICATIONS`, no `AD_ID`; `queries` PROCESS_TEXT (Flutter) | ARTEFACT |
| Network security | HTTPS only; no `http://` outside the mock backend; no cleartext config needed | SOURCE |
| Production configuration | `TBD.example/api/v1` **ships** (E-1); no `railway.app`, `mock.local`, `picsum.photos` strings — staging/mock leakage **absent** | ARTEFACT |
| Launcher icon / splash | Designer adaptive icon ✓; splash = template white `launch_background.xml` | SOURCE |
| Label | `level_up_app` (template slug) | ARTEFACT |
| CI | `ci.yml:318-377` builds an unsigned APK compile gate on `main`; no AAB job, no upload job; triggers include `merged` (`ci.yml:26-29`) | SOURCE |
| 16 KB | Not re-measured today; ARTEFACT-verified on 2026-09-22 (APK) | carried |
| Device run | Not performed | UNVERIFIED |

**Needs signed Android verification:** install and run the *signed* production AAB (via bundletool or an internal track) on Android 15/16 devices; confirm the Play pre-launch report, 16 KB alignment of the AAB's libraries, and that `TBD.example` has been replaced before any upload.

---

## 10. iOS release readiness

**Repository-confirmed:** bundle id `com.levelup.levelUpApp`; `MARKETING_VERSION`/`CURRENT_PROJECT_VERSION` driven by Flutter build name/number; deployment target 13.0; device family 1,2; portrait + landscape on iPhone, all four on iPad; no `UIRequiresFullScreen`; no URL schemes; no permission purpose strings (none needed); no entitlements file; no `PrivacyInfo.xcprivacy` in Runner; `ITSAppUsesNonExemptEncryption` absent; knownRegions `en, Base`; no `CFBundleLocalizations`; `AppDelegate.swift` is the Flutter template (UIScene not adopted); icon set complete, 1024 RGB; launch image = template; SwiftPM off; plugins with native iOS code: connectivity_plus, device_info_plus, flutter_secure_storage_darwin, path_provider_foundation, screen_protector (→ CocoaPod `ScreenProtectorKit 1.5.1`, no privacy manifest), shared_preferences_foundation, sqflite_darwin, url_launcher_ios.

**Cannot be verified without macOS/Xcode/device/archive:** whether the project builds at all; Podfile generation and pod resolution (including ScreenProtectorKit's transitive dependencies); whether Xcode 26 auto-migrates UIScene; the archive's Privacy Report and any ITMS-91053/91061 e-mail; signing team and provisioning; the reported ScreenProtectorKit iOS 26 launch crash (upstream issue #8, read 2026-09-22, not re-fetched); runtime behaviour of the secure-text-field protection layer; Keychain persistence across reinstall; iPad layout.

---

## 11. Security / privacy readiness

| Check | Today |
|---|---|
| Secrets / credentials | None in `lib/` (grep for api-key/secret/password literals → none); no `.env` in the project (only Flutter's generated `ios/Flutter/ephemeral/*.env`) |
| Logging | No `print`/`debugPrint`/`log(` sinks in `lib/` |
| Endpoints | Staging host only in `app_config.dart:43-44`; prod placeholder; no cleartext |
| OTP bypass | Staging-only by contract; not in app code |
| WebViews / external launch | No WebView widget; one `launchUrl` with `LaunchMode.externalApplication`; the `url_launcher_android` 6.3.32 WebView fallback (`UrlLauncher.java:118-125`) exists but is unreachable with this mode |
| Screenshot protection | `screen_protection.dart:34-37` enables/disables around quiz surfaces; Android FLAG_SECURE; iOS via ScreenProtectorKit (no privacy manifest; iOS 26 risk UNVERIFIED) |
| Privacy manifests | Runner: none. Plugins: url_launcher_ios, flutter_secure_storage_darwin, shared_preferences_foundation, sqflite_darwin, connectivity_plus ship one; device_info_plus ships one with an **empty** accessed-API list despite reading disk space; screen_protector, path_provider_foundation, pinput, flutter_svg ship none |
| Closed-source SDKs | ScreenProtectorKit pod (source on GitHub; "closed-source" was the previous audit's framing of the binary pod) — transitive set UNVERIFIED |
| Analytics / crash | None (zero third-party egress; first release flies blind — decision) |
| Data retention | Unknown to the app team (E-7) |
| Account deletion | Absent (E-3) |
| Locale | Always Arabic on first launch (`locale_provider.dart:24`); user toggle exists |
| Backups | `allowBackup=false`, extraction rules (ARTEFACT) |
| Token storage | flutter_secure_storage 10.3.1 (Keychain/Keystore); not re-read today beyond the dependency |

---

## 12. Backend / contract readiness

| Item | 3.28.0-m1 (pin 0df5cf4) | Impact |
|---|---|---|
| Production server | Not declared (`servers:` staging only, `:107-109`); no changelog entry | E-1 |
| Reviewer access | Whitelisted numbers + fixed OTP "in staging config only … Absent from production configuration" (`:96-98`) | E-6 |
| Deletion | `requestAccountDeletion` (`:1070-1120`) 202 `{requestedAt, effectiveAt}`, 30-day grace, daily erasure job; `cancelAccountDeletion` (`:1122-1136`) 204/404; `GET /me.pendingDeletion` (`:2750-2757`); allowlist of four endpoints for pending accounts (`:65-83`); mandated confirm copy (`:1089-1097`) contains "paid" ×2, "refund" ×1 | E-3 buildable now; vocabulary vs adr-171 ban is a Seif + owner decision |
| Entitlements | `GET /me/entitlements` stable; no `pending` state; app never watches the provider (H-6) | Risk when web redemption launches |
| Redemption | Three `x-consumers: [web]` ops (`:246,297,1969`) uncalled by the app (source + artefact); replay note still names an "app session" (M-1) | Pass / medium |
| Inbox | `listMyNotifications`, `getUnreadNotificationCount`, `markNotificationRead` **stable** since 3.28.0-m1 — the Message tab is now buildable | E-5 option |
| Retention / sub-processors | Nothing beyond deletion timing; `security.md` cited at `:98` not vendored; question not filed | E-7 |
| Name moderation | Only `PUT /me/avatar` is moderated (`:870`); display names are not | H-1 |
| Backend work landed since 09-22 | 3.22.0-m1 → 3.28.0-m1: inbox stabilised, no production host, no reviewer mechanism, no deletion-web-URL, no retention statement (`contract-changelog.md`) | — |

**Decision questions for the backend owner (record, do not invent):** (1) production host and TLS/HSTS posture; (2) production reviewer numbers with fixed OTP, exempt from eviction; (3) retention periods for account data, logs, OTP provider and hosting sub-processors; (4) ownership and anti-enumeration design of the web deletion page; (5) whether the mandated deletion copy may drop "paid"/"refund" for the app; (6) display-name moderation or endorsement of Option 0.

---

## 13. Console / account requirements (cannot be verified from the repository)

**App Store Connect:** Apple Developer Program enrolment and team; App ID = ratified bundle id (D-021); Content Rights answer; App Privacy label (after E-2/E-3/E-7); Sign-in required + demo account (after E-6); Review Notes explaining the purchase-silent model (3.1.3 positioning); iPad 13-inch + iPhone 6.9-inch screenshots (or iPhone-only decision); age rating questionnaire; export compliance "No"; Mac/Vision availability toggles; `ar` + `en` metadata.

**Play Console:** developer account type and verification; application id = ratified (D-021); Play App Signing enrolment + upload key (P-1); Data safety form (gates closed testing; needs E-2/E-3/E-7/E-8); privacy policy URL; App access instructions (after E-6); content rating; target audience (legal memo); Families if under-13 is included; Advertising ID "No"; store listing (`ar`, `en`; 512 icon; 1024×500 feature graphic; screenshots); category (Apps → Education per earlier analysis); closed test 12 × 14 if personal account; production-access application.

---

## 14. Independent blocker ledger (summary — full tables in `store_readiness_recheck_ledger.md` §B)

| ID | Area | Finding | Severity | Apple | Play | Both | Owner |
|---|---|---|---|---|---|---|---|
| E-1 | Config/backend | Production host placeholder ships; no production server declared | Blocker | ✔ | ✔ | ✔ | Seif → app |
| E-2 | Privacy/legal | No reachable privacy policy or terms; placeholder URLs; no copy | Blocker | ✔ | ✔ | ✔ | Product/legal → app |
| E-3 | Account | No deletion request/cancel flow | Blocker | ✔ | ✔ | ✔ | App (+design) |
| E-4 | iOS manifest | Disk-space required-reason API undeclared; no Runner `PrivacyInfo.xcprivacy` | Blocker (upload) | ✔ | — | — | App |
| E-5 | Completeness | "Message" primary tab is a placeholder | Blocker (likely 2.1 rejection) | ✔ | likely | ✔ | Product / app |
| E-6 | Backend | No production reviewer login | Blocker | ✔ | ✔ | ✔ | Seif |
| E-7 | Backend | Retention/erasure/sub-processor facts absent, never filed | Blocker (prerequisite to E-2 and forms) | ✔ | ✔ | ✔ | Seif / legal |
| E-8 | Play deletion | No web deletion-request URL | Blocker | — | ✔ | — | Seif / web |

**Blocker count: 8.** Release prerequisites P-1…P-7, high-risk H-1…H-7 and medium M-1…M-7 are listed in the ledger and are **not** counted as blockers.

---

## 15. Final verdict

### NOT READY

- **Confirmed blockers (8):** E-1 production host; E-2 privacy policy/legal copy; E-3 account deletion; E-4 iOS required-reason declaration; E-5 placeholder primary tab; E-6 production reviewer login; E-7 backend privacy facts; E-8 web deletion URL.
- **Fixed since the previous audit:** launcher icons (both platforms); Leaderboard tab. No previous blocker is fully closed.
- **Stale/incorrect previous findings:** two tabs → one; template icons → fixed; SwiftPM hybrid → off; ScreenPreventerKit → unverified; "no Podfile" → not a defect; adr-171 link → decision, not blocker; developer-verification deadline → four countries only; retention questions → never filed.
- **Unresolved backend decisions:** production host; reviewer mechanism; retention/sub-processor facts; web deletion page; deletion-copy vocabulary; display-name moderation.
- **Unresolved console/account requirements:** §13 in full; identifier ratification (D-021) precedes all of them.
- **Required macOS/Xcode verification:** build + archive with Xcode 26; Privacy Report; pod resolution; UIScene migration; iOS 26 run with screen protection active; Keychain-after-reinstall behaviour.
- **Required signed Android verification:** install the signed production AAB on Android 15/16; pre-launch report; AAB 16 KB alignment.
- **Changed since the previous audit:** 12 commits (icons, leaderboard un-gate, Waves 01–22, contract 3.22→3.28, environment chapter); the leaderboard un-gate created the live UGC exposure (H-1); nothing landed on any of the eight blockers.

---

## 16. Exact next actions (dependency order)

1. **Owner:** ratify D-021 (ids, display names, 2 vs 3 identities, supported versions) — everything permanent downstream depends on it.
2. **Seif:** publish the production `servers:` entry and TLS posture → app replaces `app_config.dart:54` (E-1).
3. **Seif:** production reviewer numbers with fixed OTP, exempt from eviction, entitled and seeded; document in the contract (E-6).
4. **App team:** file the retention/erasure/sub-processor question in `docs/seif_fight.md` and obtain written answers (E-7); request the vendored `security.md`.
5. **Product/legal:** approve AR + EN privacy policy and terms using those answers; host them; app replaces the `levelup.example` URLs and renders or links the documents at `/legal/*` (E-2).
6. **Design + app:** account-deletion request/confirm (mandated copy `openapi.yaml:1089-1097`, vocabulary ruling from Seif + owner), cancel screen from `GET /me.pendingDeletion`, global `403 account_pending_deletion` route, local wipe (E-3). **Seif/web:** deletion-request web page without phone-number enumeration (E-8).
7. **App:** add `ios/Runner/PrivacyInfo.xcprivacy` declaring `NSPrivacyAccessedAPICategoryDiskSpace` with an approved reason, or drop `iosInfo`; later confirm via the Xcode Privacy Report (E-4).
8. **Product:** hide the Message tab for release 1 or FORMULATE the inbox (endpoints stable) (E-5); decide Option 0 vs report/block + terms acceptance for the leaderboard (H-1); decide iPhone-only vs iPad screenshots (P-5).
9. **Release manager:** generate the upload keystore per `docs/RELEASE_SIGNING.md`, enrol Play App Signing (P-1); add an AAB job to CI.
10. **iOS engineer (Mac, Xcode 26):** first build, archive, Privacy Report, iOS 26 device run with quiz protection active (P-2).
11. **Console owners:** create accounts; fill Data safety / App Privacy / App access / Content Rights / rating / audience only after steps 2–7 make the answers true (P-4, P-6, P-7).
12. **Hygiene before any upload build:** commit or stash the 25-file dirty tree, push `merged`, build from a tagged commit with `-t lib/main_prod.dart`.
