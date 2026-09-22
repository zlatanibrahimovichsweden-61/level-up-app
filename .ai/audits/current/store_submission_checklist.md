# Level Up — Pre-Submission Checklist (derived from the 2026-09-22 audit, HEAD bf967d6)

Companion to `store_readiness_audit.md` (findings, evidence) and `store_readiness_matrix.md`. Every line cites the finding it derives from. Nothing here has been implemented; this audit changed no application code.

## 0. Dependency-ordered critical path (what unblocks what)

```
[Backend/Seif]  prod host + TLS ──┐
[Backend/Seif]  ≥3 reviewer numbers + fixed OTP (prod), entitled, seeded, eviction/throttle-exempt, + 1 sacrificial deletion-test number ──┤
[Backend/Seif]  Q4–Q7 retention/erasure/subprocessors + security.md ──► [Legal] privacy policy + terms + support page + web deletion page ──┐
[Frontend]      account deletion (confirm + cancel + 403 redirect + SecureStorage.clear()) ──────────────────────────────────────────────┤
[Frontend]      un-gate /legal/*, static Profile rows, real URLs ─────────────────────────────────────────────────────────────────────────┤
[Product]       app name + application id / bundle id freeze; icon/splash/feature graphic; hide-or-finish stubs; iPhone-only decision ───┤
[Owner+Seif]    adr-171 decision (no link in release 1 recommended) + §4 correction; D-007 amendment ────────────────────────────────────┤
                                                                                                                                          ▼
[Frontend]      drop device_info_plus on iOS + Runner PrivacyInfo; drop iOS screen_protector leg; entrypoint runtime guard; image-cache wipe
                                                                                                                                          ▼
[Owner/Mac]     upload keystore + Play App Signing ─► first iOS build on Xcode 26 (Podfile, UIScene migration, team) ─► archive Privacy Report
                                                                                                                                          ▼
[Console]       Play: Data safety (true answers) ─► closed test (12×14 if personal account) ─► production-access application
[Console]       ASC: App ID + name, Sign-in fields + Notes, Content Rights, label, age rating, territories, Mac/Vision opt-out, iPad screenshots or iPhone-only
                                                                                                                                          ▼
[QA]            device walks (Android 15/16, iOS 26, Arabic locale, large text) ─► listing-assets build for screenshots ─► submit
```
Parallelisable from day one: Seif asks; legal copy; icon/brand work; deletion flow; guard tests. Longest external lead times: legal copy (blocked on Q4–Q7), Play closed-test window, D-U-N-S if an org account is created now.

## 🔴 Must fix before submission (code / config)

- [ ] Replace `Flavor.prod` host `https://TBD.example/api/v1` with the production host from the contract `servers:` block; add a guard test that fails a release while a `.example` host remains (FE-01 / AND-01 / SEC-01 / BS-A-04).
- [ ] Build account deletion: Profile row → confirm screen carrying the contract's mandated points (`openapi.yaml:1011-1018`, wording reconciled with adr-171 §3 — no "paid"/"refund") → `POST /me/deletion-request` → on 202 purge tokens + `SecureStorage.clear()` + image cache → login; cancel screen on `403 account_pending_deletion` with global redirect; `DELETE /me/deletion-request` (FE-03 / FE-04 / API-01 / API-03 / API-24).
- [ ] Make the privacy policy reachable: real URLs replacing `levelup.example/*`, `/legal/privacy` and `/legal/terms` outside the auth gate, Login links pointing at the in-app screens, Profile's static rows (privacy, terms, settings, logout) rendered outside the `GET /me` loaded state (FE-02 / SEC-02 / REV-03).
- [ ] Add terms/privacy acceptance in registration before any UGC (display name) can be created, and a purpose line under DOB and parent phone (BS-D-06 / BS-C-07 / FE-15).
- [ ] Remove `device_info_plus` from the iOS path (stop sending `model`); add `ios/Runner/PrivacyInfo.xcprivacy` with `NSPrivacyTracking=false` and the collected-data types from `parts/14` (IOS-03 / APL-04 / DECL).
- [ ] Drop the iOS leg of `screen_protector` (or device-prove it on iOS 26 against ScreenProtectorKit issue #8 and open issue #11 — residual overlay blacks out `SFSafariViewController`); note it pulls a second closed-source pod, ScreenPreventerKit, with no privacy manifest; keep Android FLAG_SECURE (IOS-19 / APL-13 / POL-08).
- [ ] Leaderboard "Option 0" when the board ships: render rank, points and avatar only — never a peer's display name — which removes Apple 1.2 and Play UGC duties (report/block, terms acceptance) outright; otherwise implement all three (POL-06 / BS-D-06).
- [ ] Replace template identity: adaptive + monochrome Android icons, iOS icon set, localised `android:label` via `strings.xml`/`values-ar`, `CFBundleName`/`CFBundleDisplayName`, branded splash (`launch_background.xml`, `styles.xml`, `LaunchScreen.storyboard`) (FE-09 / AND-03 / AND-04 / IOS-02 / BS-A-03 / BS-B-12).
- [ ] Hide or finish every dead end: Leaderboard and Message placeholder tabs (rename/remove Message), three Home "Coming soon" cards and the inert "See All", Refer a Friend, Customer Support, Favorites, Progress, Go to Uni, Upload photo, disabled notification toggles, the discarded referral field, the inert `+20` chevron (FE-10 / FE-11 / FE-12 / FE-13 / REV-07b / REV-14 / POL-09).
- [ ] Runtime guard: `bootstrap()` throws in `kReleaseMode` when the flavour is not `prod` (explicit `--dart-define` escape for tester builds); keep `lib/main_mock.dart` out of release (FE-05 / SEC-03 / IOS-09).
- [ ] Clear the image cache (`DefaultCacheManager().emptyCache()`) inside `invalidateSessionScope`, or serve question images memory-only (FE-06 / SEC-08).
- [ ] Override `toString` on `TokenPair`, `StudentProfile`, `ProfileUpdate`, `EmailPatch`, `Phone` and add a guard test before any crash reporter is ever added (FE-07 / SEC-04).
- [ ] iOS first-run guard: on a fresh install (flag in `shared_preferences`, which is wiped on uninstall) call `SecureStorage.clear()`; decide whether `device_id` should survive reinstall on iOS (IOS-06 / API-19).
- [ ] Declare `CFBundleLocalizations` = `ar`,`en` (+ `ar` in `knownRegions`); decide device-locale behaviour (REV-02 / IOS-07). Add `android:supportsRtl="true"` and `locales_config.xml` (AND-11).
- [ ] Set `ITSAppUsesNonExemptEncryption` = false; raise `IPHONEOS_DEPLOYMENT_TARGET` to 15.0; decide iPhone-only (`TARGETED_DEVICE_FAMILY = 1`) or build iPad layouts (IOS-04 / IOS-18 / BS-C-01 / BS-C-02).
- [ ] Wire the resume refetch for real before any subscription area exists: one shell-level lifecycle observer, `entitlementsProvider` kept alive/listened, `refresh()` keeping last-known state on failure, defined `active`/`inGrace`/expired display (ENT-01 / ENT-04 / ENT-05).
- [ ] If — and only if — the adr-171 link ships on Android: `supportsLaunchMode` gate with `externalApplication` fallback, `CustomTabsService` `<queries>` entry, bare URL constant, leave-app confirmation with neutral copy, guard test asserting no query parameters (RED-01 / RED-08 / FE-24). Do not ship it on iOS (POL-01).

## 🟠 Must verify before submission

- [ ] First iOS release build on a Mac with Xcode 26: `flutter build ipa --release -t lib/main_prod.dart`; commit `Podfile`/`Podfile.lock`/xcconfig includes and the UIScene migration diff; read the archive Privacy Report for ITMS-91053/91061; confirm SwiftPM/CocoaPods mix (IOS-01 / IOS-05 / IOS-20). **UNVERIFIED — REQUIRES LOCAL RELEASE BUILD.**
- [ ] Rebuild the signed AAB after the fixes; re-run `aapt2 dump permissions` (expect exactly INTERNET + ACCESS_NETWORK_STATE + the AndroidX signature permission), string-scan `libapp.so` for `.example`, `railway`, `mock`, `000000` (expect none) (parts/02 method).
- [ ] Device walks: Android 15/16 (edge-to-edge, predictive back through go_router, gesture + 3-button nav, both themes), iOS 26 (Keychain survival, screenshots), Arabic-locale keyboard on Login and OTP (Arabic-Indic digits), large text 1.3× (BUG-002), tablet/iPad landscape if iPad is kept (AND-09 / AND-10 / FE-16 / FE-32 / FE-33).
- [ ] Confirm `onResume` fires when returning from the system browser (only matters if the link ships) (parts/15 UNVERIFIED).
- [ ] Confirm the staging-only OTP bypass is truly absent from production and that reviewer numbers are exempt from eviction + per-IP throttles (API-02 / API-22 / API-21).
- [ ] Confirm `/me/entitlements` is routed in production and reflects a web redemption on the next read without caching (parts/05 Q11).
- [ ] Confirm what the `.example` legal links and host do on a real device network (NXDOMAIN vs captive portal) — irrelevant once replaced, relevant if any build with placeholders is ever distributed (parts/16 §8).
- [ ] Run `tool/validate.ps1` (expect OVERALL: PASS ≥ 1427 tests) after every fix; push so CI actually executes on the release branch; add `merged` (or `workflow_dispatch`) to the release gate (SEC-05 / SEC-06).

## 🟡 Recommended before submission

- [ ] Guard tests that do not exist yet: no `print`/`debugPrint`/`LogInterceptor` in lib/; exact release-permission allow-list; every `_dio` path resolves to a stable, non-`[web]` operation; no placeholder host in prod config; no query parameters in any `launchUrl`; adr-171 banned vocabulary in both ARBs (BS-A-04 / AND-08 / API-08 / RED-08).
- [ ] Global error handling decision: `FlutterError.onError` + `PlatformDispatcher.onError` at minimum; crash reporting only after the `toString` fix and with both privacy forms updated (FE-14 / SEC-11).
- [ ] Add a GoRouter `errorBuilder` with localised copy (FE-27); persist the registration draft or lengthen the flow to fit the 10-minute token (FE-30 / REV-11); anchor the OTP countdown to wall-clock time (FE-34); fold Arabic-Indic digits consistently on Login and OTP (FE-32 / FE-33).
- [ ] Replace the login phone hint `01021871999` with an obviously fictitious number and scrub `mock_backend.dart:196` (FE-18 / SEC-09).
- [ ] Lock portrait (product decision) or test landscape everywhere (FE-17).
- [ ] Fix the three naive Arabic plural keys; pad the four 35–36 dp tap targets; add `semanticsLabel` to nav SVGs (BS-A-01 / BS-A-02 / BS-D-13).
- [ ] Add an open-source licences entry point (`showLicensePage`) (DEP-11); commit `OFL.txt` per font family (SEC-13).
- [ ] Declare `android:enableOnBackInvokedCallback="true"` (AND-09); decide `--obfuscate --split-debug-info` and archive symbols per release (AND-12 / IOS-13); bump `+N` per upload (AND-17 / IOS-14).
- [ ] Update stale docs: `docs/STORE_READINESS.md` (R8 is ON; deletion endpoint exists; reviewer bypass staging-only), `docs/DECISIONS.md` D-007 amendment for adr-171, `docs/RELEASE_SIGNING.md` iOS section + PKCS12, file the five missing `seif_fight.md` entries (AND-06 / API-11 / API-16 / API-17 / BS-B-17).
- [ ] Supply-chain hygiene: `distributionSha256Sum` + track the Gradle wrapper, SHA-pin GitHub Actions, add an `appbundle` + release workflow, JDK 17 locally and drop the Gradle workarounds (BS-B-01 / BS-B-02 / BS-B-09 / BS-B-11 / AND-14).
- [ ] Dependency batch: `flutter_secure_storage` 11.x, `go_router` 18, `cached_network_image` 4, `xml` 7 — after the release, not before (DEP-08 / BS-B-05).
- [ ] Show flavour + host on Settings for non-prod builds (SEC-10 / FE-22); remove `/track-select` placeholder and `/friends` orphan (FE-19 / FE-20).

## 🔵 App Store Connect actions

- [ ] Register App ID `com.levelup.levelUpApp` (confirm the casing is wanted — irreversible) and reserve the app name (check "Level Up" availability) (IOS-08 / BS-C-12 / BS-C-13).
- [ ] Set the team; export method `app-store-connect`; ensure the Xcode 26 SDK is recorded in the built `Info.plist` (`DTXcode`, `DTSDKName`) (IOS-16).
- [ ] App Review Information: **Sign-in required = Yes**, Username = reviewer phone, Password = fixed OTP, plus the Notes paragraph from `parts/12` POL-03 amended per `parts/19` (device binding, Arabic-first launch, fixed OTP, entitlement state, a separate sacrificial number for deletion testing, screenshot protection, no purchase path) (APL-01 / BS-C-05 / BS-C-06).
- [ ] Support URL with legal address, email and phone; Privacy Policy URL; Marketing URL optional (APL-03 / parts/08 item 24).
- [ ] App Privacy label from `parts/14` deliverable 1 (Contact Info, Identifiers, User Content, Other Data — linked, no tracking); Tracking = No; answer only after deletion + Q4–Q7 are true (POL-11).
- [ ] Age rating questionnaire: expect 13+; Contests = Yes; Unrestricted Web Access = No (flips if a browser link ships); UGC/social-media and age-assurance/parental-control questions answered honestly (BS-C-09 / BS-C-10 / BS-C-16).
- [ ] Content Rights: answer and keep evidence of question-bank/flashcard rights (BS-C-04).
- [ ] Export compliance = No non-exempt encryption; EU DSA trader status ("not a trader" if EU excluded); territories: decide whether to exclude the US (age-assurance laws) and France (encryption declaration) (parts/08 items 16, 21, 26).
- [ ] Untick **Mac (Apple silicon)** and **visionOS** availability (BS-C-03).
- [ ] Screenshots: iPhone set from a listing-assets build (secure layer off); iPad 13" set unless iPhone-only; Arabic and English (BS-C-01 / BS-C-11 / APL-12).
- [ ] TestFlight external testing budget: Beta App Review is its own queue (BS-C-17).
- [ ] Kids Category = No; no "for kids" wording in metadata (5.1.4 / 2.3.8).

## 🟣 Google Play Console actions

- [ ] Decide account type now: organisation (needs D-U-N-S, publishes legal address + phone) vs personal (created after 2023-11-13 → 12 testers × 14 days closed test before production); complete developer verification before 2026-09-30 (BS-D-03 / parts/09 10c–10d).
- [ ] Freeze the application id before any upload (`com.levelup.level_up_app` is a template slug and becomes permanent) (BS-D-09).
- [ ] Enrol Play App Signing; upload the AAB built with `-t lib/main_prod.dart` and signed with the upload key; keep `mapping.txt` per release (AND-02 / AND-06 / AND-07).
- [ ] App access: reusable reviewer credentials (phone + fixed OTP), valid anywhere, in English, never expiring; note device binding, Arabic-first launch and FLAG_SECURE black screenshots (GP-01 / parts/12 POL-03).
- [ ] Data safety form from `parts/14` deliverable 2 — only after the six false answers are true (deletion path + web URL, retention answers, `model` no longer sent, parent phone = Required, iOS Keychain fix); Advertising ID = No; data deletion URL entered here (GP-03 / GP-12 / BS-D-10).
- [ ] Privacy policy URL (live, non-PDF, names the listed entity, covers retention/deletion) (GP-04).
- [ ] Target audience: declare age groups with a legal memo on whether 13–17 counts as children in Egypt; Families compliance is already technically met; keep listing art adult-neutral (GP-08 / BS-D-04).
- [ ] Content rating (IARC) questionnaire; re-run when the leaderboard ships (parts/09 11a; POL-12).
- [ ] Declarations: Financial features = none, Health = none, Government = no, Ads = no, News = no; US export laws acknowledgement at app creation (parts/09 11b; BS-D-18).
- [ ] Store listing: name ≤30 chars, 512×512 icon, 1024×500 feature graphic, ≥2 screenshots per language (listing-assets build), category **Apps → Education** (not Games → Educational — part of the Child Safety Standards N/A condition), default language + `ar` and `en` listings (Play has no `ar-EG` variant), full description without "coming soon" features (GP-06 / GP-11 / BS-D-11 / BS-D-12).
- [ ] Closed testing track → production-access application (7-day review, needs real tester engagement — requires prod host + seeded cohort first) (BS-D-01 / BS-D-02).
- [ ] After launch: Android vitals without a crash signal — decide crash reporting (BS-D-14); Restore Credentials by April 2027 vs one-device-one-session (parts/09 10e).

## ⚪ Backend / infrastructure actions (Seif)

- [ ] Publish the production `servers:` entry (host, TLS, HSTS) (API-23).
- [ ] Production reviewer cohort: ≥3 whitelisted numbers with a fixed OTP, exempt from `session_superseded` eviction and per-IP throttles, pre-registered in School and University cohorts with seeded subjects, active `baseSubscription`, no expiry; plus one sacrificial number that may be deleted and reset; plus 12 tester accounts if a personal Play account is used (API-02 / API-22 / BS-C-06 / BS-D-16).
- [ ] Answer Q4–Q7 (erasure scope at `effectiveAt` incl. "kept forever" quiz attempts, parent phone, projections, audit; log/backup retention and PII/IP in logs; subprocessors: Railway region, Redis, SMS/WhatsApp, SafeSearch, AI-explanation model); publish `security.md` (API-13).
- [ ] Web deletion-request page that names the app as listed and works without the app; confirm it enters the same 30-day flow; it is printed on the public Play listing, so it must not reveal whether a phone number has an account (enumeration) (API-04 / BS-D-18d).
- [ ] Amend the deletion confirm copy (`openapi.yaml:999-1024`) to remove "paid"/"refund" or grant an explicit exception to adr-171 §3; state whether an out-of-band completion confirmation exists for Apple (API-24 / parts/12).
- [ ] Correct adr-171 §4 ("the app already refetches on resume") and confirm `/me/entitlements` is routed and uncached after a web redemption (ENT-01 / Q11).
- [ ] Minors: server-side minimum age on `dateOfBirth`, parent-phone verification or optionality, consent record, masked `parentPhone` on `GET /me` (S34) (API-09).
- [ ] Leaderboard: name moderation/profanity filter, report/block path, stop exposing `studentId` to peers (API-10).
- [ ] Rate-limit magnitudes and an OTP `Retry-After` equivalent; confirm `redeemSubscriptionCode` answers `403 account_pending_deletion` during grace; confirm web session revocation after deletion (API-21 / Q12 / Q14).
- [ ] File the five missing `seif_fight.md` entries (age floor, reviewer account, prod URL, web deletion URL, security.md/name moderation) (API-16).

## 🟢 Final release testing

- [ ] Fresh install → onboarding → login with reviewer number + fixed OTP → registration (both tracks) within 10 minutes → Home → Learn → quiz (FLAG_SECURE) → review → flashcards → mistakes → profile edit → privacy/terms open pre- and post-login → settings → logout → login again (no stale data, no previous avatar/question images) → deletion with the sacrificial number → cancel during grace → re-login after grace.
- [ ] Same flow offline, on slow network, with server 5xx, with an expired refresh token, after 60+ days idle, after backgrounding to the browser and returning (resume refetch), after process kill mid-wizard.
- [ ] Two devices logged in with the same number (eviction message), reviewer behind one NAT (throttles).
- [ ] Arabic and English, RTL, large text, dark and light, Android 15/16 gesture nav, iPad/tablet if supported, iOS 26.
- [ ] Verify the shipped artefacts: signed AAB/IPA built from `-t lib/main_prod.dart`, `aapt2` permissions exact, no placeholder/staging/mock strings, correct version/build numbers, privacy manifest present, icons and labels branded, `apksigner verify` passes.
