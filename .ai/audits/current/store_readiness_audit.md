# Level Up — Final Store Readiness Audit (Apple App Store + Google Play)

**Repository:** `F:\level\level_up\level_up_app`, branch `merged`, HEAD `bf967d6` (clean tree; only `.ai/audits/current/` additions from this audit).
**Audit dates:** 2026-09-21 → 2026-09-22. **Contract pin:** `768e67d` (3.22.0-m1). **Toolchain:** Flutter 3.44.7 / Dart 3.12.2, AGP 8.11.1, Gradle 8.14, Kotlin 2.2.20, NDK 28.2.
**Method:** repository map → official policy research (Apple + Google, 2026-09-21) → seven platform audits → Android release artefact build and inspection → Wave 1–3 gap and blind-spot agents (Sonnet + Opus) → Fable reconciliation → Opus adversarial review → Fable final review. Every claim carries a verification level: **SOURCE** (read) · **BUILD** (compiled/tests) · **ARTEFACT** (inspected built output) · **STAGING** (probed staging backend) · **WEB** (official page fetched) · **DEVICE/CI** (not reached in this audit). Nothing was run on a device; iOS was never built (Windows host).
**Detail files:** `.ai/audits/current/store_readiness_parts/01…20_*.md` (evidence, quotes, per-agent tables); `store_readiness_matrix.md`; `store_submission_checklist.md`; working state in `store_readiness_state.md`.
**No application code, configuration, manifest, plist, Gradle, CI or dependency was modified by this audit.**
**Status: FINAL v2** — draft v1 was reviewed adversarially by Opus (2026-09-22) and corrected in the Fable final review: severities reconciled (identity, placeholder tabs, screenshots, screen_protector), counts re-derived as disjoint sets, four policy quotes re-marked to their true verification level, and five missed items added (§18 items 31–35).

Severity scale used everywhere below: **A** Blocker · **B** High risk · **C** Medium · **D** Low · **E** External/console/human · **F** Pass (verified) · **G** Not applicable.

---

## 1. Executive summary

**Verdict: the repository cannot currently be considered technically ready for submission to either store.** The app's engineering fundamentals are unusually clean (zero third-party SDKs, minimal permissions, HTTPS-only, Keychain/Keystore tokens, backups excluded, no logging, 1427 passing tests, 16 KB-aligned, R8 mapping embedded, purchase-silent, no draft or web-only endpoint calls). The blockers are almost all *product-completeness, identity, and store-mechanics* items, plus two iOS platform items, and several of them have long external lead times.

**Seventeen blocker items, in four disjoint groups (each counted once):**

- **Code/config, fixable in this repository (6):** (1) the production API host is a placeholder that ships in the artefact; (2) the privacy policy is unreachable in-app (placeholder URLs, auth-gated stub screens, rows hidden by the `/me` error state); (3) there is no account-deletion or cancel-deletion flow although the contract provides both; (4) a plugin uses an undeclared required-reason API and there is no Runner privacy manifest (upload gate — one-file fix; Apple's rule text is recorded from `parts/08` but could not be re-fetched at source in `parts/12`); (5) the store identity is the Flutter template — icons, label, splash — a Play listing publish gate; (6) two of the five primary navigation tabs are "Coming soon" placeholders (raised to A in the final review: near-certain 2.1 / "designed to do nothing" rejection and a strike-ladder risk post-launch).
- **Backend / contract, owned by Seif (3):** (7) no production reviewer-login mechanism — the OTP bypass is staging-only *by contract*, sessions evict per student, and the contract declares no production server; (8) the Play web deletion-request URL is unowned and the mandated deletion copy uses "paid"/"refund", words adr-171 bans; (9) the retention/erasure/subprocessor answers (Q4–Q7) that the privacy policy and both declaration forms need do not exist.
- **Release build, owner-run (2):** (10) the release artefact is unsigned — no upload keystore, no Play App Signing, no AAB pipeline; (11) iOS has never been built — **UNVERIFIED — REQUIRES LOCAL RELEASE BUILD**.
- **Console / product decisions (6):** (12) six privacy-form answers would be false today, and the Play Data safety form gates even the closed testing track; (13) iPad screenshots are mandatory unless the target becomes iPhone-only; (14) App Store Connect Content Rights is unanswered; (15) Play production access is a Google-reviewed application; (16) the adr-171 redemption link is an Apple 3.1.1(a) violation on the Egypt storefront if shipped (decision required); (17) the developer account itself — type, D-U-N-S, verification — has not been decided.

**Biggest surprises for the team** (§18): iPad screenshots are mandatory because the Xcode target includes iPad; a reviewer who tests account deletion destroys the demo account for 30 days; Play's Data safety form gates the closed track, so the 12-tester/14-day clock cannot start until the deletion flow exists; the redemption warning's assumption that "the app already refetches entitlements on resume" is false at HEAD; url_launcher's in-app browser mode silently falls back to an embedded WebView on Android; R8 is *on* (the project docs say off); the app always launches in Arabic while the iOS bundle declares English only; the screenshot-protection library has a reported iOS 26 launch crash and an Apple DTS objection.

---

## 2. Apple App Store findings

Policy basis: App Store Review Guidelines (footer "Last Updated: June 8, 2026") and App Store Connect help, fetched 2026-09-21 — see `parts/08`, `parts/12`, `parts/19`.

| ID | Sev | Finding | Evidence | Required action |
|---|---|---|---|---|
| APL-01 | A | 2.1(a) demo account: login is phone+OTP only; the only OTP bypass is staging-only by contract ("Absent from production configuration"); prod host is a placeholder → reviewer cannot sign in. ASC "Sign-in required" has structured Username/Password fields the app cannot fill (BS-C-05). | `contract/openapi.yaml:96-98`; `lib/core/config/app_config.dart:54`; `parts/12` POL-03 | Backend: production whitelisted numbers with fixed OTP, pre-registered, entitled, seeded content, no expiry; fill Username/Password fields with phone / fixed code + Notes (paste-able text in `parts/12` POL-03). |
| APL-02 | A | 5.1.1(v) account deletion: no in-app path; contract has `POST/DELETE /me/deletion-request` stable; pending-deletion 403 copy says "cancel" with no cancel screen. A reviewer testing deletion (Notes §6 tells them to) revokes the session instantly and blocks the phone for 30 days (BS-C-06). | `openapi.yaml:993-1064`; `lib/core/network/exceptions.dart:127-134`; `app_en.arb:659-661`; `profile_screen.dart:154-172` | Build confirm screen (the contract's four mandated points, `openapi.yaml:1011-1018`, plus the three policy points in `parts/12` POL-04), cancel screen, global 403 redirect, `SecureStorage.clear()`; provide a sacrificial deletion-test number; rewrite Notes §6. |
| APL-03 | A | 5.1.1(i) privacy policy in-app: Login links are `https://levelup.example/...`; `/legal/*` routes are auth-gated and render "This document hasn't been published yet."; the Profile rows that reach them sit inside the `GET /me` loaded-state, so an error state removes privacy, terms, Settings and Logout (REV-03). | `login_screen.dart:43-46,118`; `app_router.dart:49,74`; `legal_document_screen.dart:47-51`; `profile_screen.dart:75-91,115-152` | Host the policy (must state retention/deletion → backend Q4–Q7 first); un-gate `/legal/*`; render static rows outside the state machine. |
| APL-04 | A | Privacy manifest / ITMS-91053: `device_info_plus` 13.2.0 reads `NSFileSystemFreeSize`/`NSFileSystemSize` (DiskSpace required-reason category) with no `NSPrivacyAccessedAPITypes` in its manifest; latest upstream version identical, no fix tracked. No Runner `PrivacyInfo.xcprivacy`. Apple's rule as recorded in `parts/08` note 5: apps that don't declare "aren't accepted" (since 2024-05-01) — **the source page could not be re-fetched in `parts/12` (JS-rendered), so the exact current wording is UNVERIFIED at source.** Opus rated B because it is caught at upload (pre-publication) by a one-file fix; Fable keeps A because an upload gate still stops a submission and the fix is cheap. Confirm at the Xcode archive Privacy Report. | pub cache `device_info_plus-13.2.0/.../FPPDeviceInfoPlusPlugin.m:42-43`; `parts/04` §4; `parts/11` item 3 | Drop `device_info_plus` on iOS (app only uses `model`, which is itself a declaration ambiguity — stop sending it); add a Runner manifest with collected-data types; confirm via Xcode archive Privacy Report. |
| APL-05 | A | iOS has never been built: no Podfile/Pods/Podfile.lock, no `DEVELOPMENT_TEAM`, no ExportOptions; first Mac build will also rewrite `AppDelegate.swift` + `Info.plist` (UIScene auto-migration) and may run hybrid SwiftPM+CocoaPods. **UNVERIFIED — REQUIRES LOCAL RELEASE BUILD (Xcode 26).** | `ios/Flutter/Debug.xcconfig:1`; `project.pbxproj` (no team); `parts/04` IOS-01/05/08; `parts/11` IOS-20 | Register App ID `com.levelup.levelUpApp`, set team, build `flutter build ipa --release -t lib/main_prod.dart` on Xcode 26, commit Podfile/lock + migration diff. |
| APL-06 | A (console) | iPad screenshots (13", 2064×2752) are mandatory in ASC because `TARGETED_DEVICE_FAMILY = "1,2"`; no iPad layout exists; iPadOS 26 reportedly deprecates `UIRequiresFullScreen` so windows become resizable (BS-C-01/02 — exact wording UNVERIFIED, TN3192 is JS-rendered). | `project.pbxproj:353,479,532`; `parts/19` | Decision: ship iPhone-only for release 1 (removes the requirement) or build/test iPad layouts. |
| APL-07 | A (console) | ASC **Content Rights** question unanswered; question-bank/flashcard provenance not established (BS-C-04). | external | Owner answers; keep evidence of rights. |
| APL-08 | A-conditional | 3.1.1/3.1.3: consumer education subscription sold only on the web, unlocked in-app, no IAP. No exception fits: 3.1.3(a) reader apps are limited to "magazines, newspapers, books, audio, music, and video"; 3.1.3(b) multiplatform requires the items to be "also available as in-app purchases"; 3.1.3(c) enterprise requires sales "to organizations or groups"; 3.1.3(f) free stand-alone companions enumerate infrastructure services (VoIP, cloud storage, email, web hosting). At HEAD (no link, neutral copy) → C residual business risk. adr-171's planned "single neutral link to the redemption page" is a "call to action that direct[s] customers to purchasing mechanisms other than in-app purchase" on non-US storefronts (3.1.1(a)) and Apple also objects to out-linking for sign-in (Guideline 4) → **A if shipped on iOS**. | `parts/12` POL-01; `parts/15` RED-07; `limit_sheet.dart:91-96` | Do not ship the link on iOS in release 1 (Android-only at most, with a certified purchase-free landing page); keep copy neutral; explain in Notes. Needs owner + Seif decision (adr-171 amendment). |
| APL-09 | A (listing) / B (binary) | Template identity: stock Flutter icons (md5-identical to SDK template on both platforms), `CFBundleName level_up_app`, white template launch screen, unreserved generic app name "Level Up". 2.3.8 / 4.1. Listing assets are a publish gate on both stores; in the binary alone it is a high-risk metadata mismatch. | `parts/02` icon hashes; `Info.plist:8,16`; `LaunchScreen.storyboard:22,35`; `parts/19` BS-C-12 | Brand icon set, launch screen, decide and reserve the name in ASC now. |
| APL-10 | B | Minors (5.1.4(a)/(b), 5.1.1(v)/(x), 5.1.2(i)): DOB hard-required but read by zero age logic; parent phone mandatory, write-only, a non-user's PII with no erasure route; no age floor; no consent/terms acceptance in the wizard. | `registration_validation.dart:80,140`; `school_registration.dart:66`; `openapi.yaml:2300,2311,2337`; `parts/19` BS-C-07/08 | Product/legal: define the statutory purpose for DOB + parent phone (or make optional), add terms acceptance, decide age floor; privacy policy must cover it. |
| APL-11 | A (tabs) / B (rest) | Completeness (2.1/4.2): two of five bottom tabs are "Coming soon" (Leaderboard, Message) — **A**: placeholder primary navigation is a near-certain 2.1 / "designed to do nothing" rejection; the remaining stubs are B: three Home cards, Support/Refer/Favorites/Progress/Go-to-Uni/Upload-photo/notification-toggle stubs, referral field discarded, inert "See All" and "+20" chevron. Removing tabs is a design change (`_centreIndex = 2`). | `app_router.dart:168-171,268-271`; `home_screen.dart:92-131`; `main_shell.dart:35`; `parts/16` §2 | Hide or finish before submission; rename/remove "Message". |
| APL-12 | B | 2.3 accuracy: app always launches in Arabic regardless of device locale while the bundle declares `en` only; no `CFBundleLocalizations`; no `ThemeMode.system`. | `locale_provider.dart:23-24`; `pbxproj:186-191`; `theme_provider.dart:35-56` | Declare `ar`,`en`; respect system locale or document; screenshots per language. |
| APL-13 | B (parts/12 POL-08 rated C; raised here for the crash report) | `screen_protector` on iOS uses the `isSecureTextEntry` layer side-effect. An Apple DTS objection ("not its intended purpose", likely 2.5.1) is reported **second-hand** in ScreenProtectorKit issue #7 — the forum thread itself (824922) could not be fetched (SECONDARY). ScreenProtectorKit ships no privacy manifest, delegates blocking to a second closed-source pod **ScreenPreventerKit** (never inventoried, manifest status unknown — independent ITMS-91061 exposure), has a closed issue #8 reporting an **iOS 26.0 launch crash**, and an **open issue #11** where `disablePreventScreenshot()` leaves a residual overlay that blacks out `SFSafariViewController` — which collides with both quiz `dispose()` and the adr-171 in-app-browser plan. A missing plugin throws an unawaited exception. | `screen_protection.dart:30-37`; `parts/11` IOS-19 + §4 table; `parts/12` POL-08 | Drop the iOS leg (keep Android FLAG_SECURE) or device-test on iOS 26 before relying on it. |
| APL-14 | C | Age-rating questionnaire: "Contests" must be ticked (`topStudent`, "REWARDS EARNED", "Study. Compete. Achieve."); "Unrestricted Web Access" is No today and flips if the redemption link ships via SFSafariViewController; September-2026 social-media/age-assurance questions are live. | `parts/19` BS-C-09/10/16 | Answer deliberately; expect 13+. |
| APL-15 | C | Mac (Apple silicon) and Vision Pro availability are **on by default**; screenshot protection, Keychain and RTL never considered there. | `parts/19` BS-C-03 | Opt out in ASC. |
| APL-16 | B (aligned with GP-11: screenshots gate publication) | Marketing screenshots of the quiz cannot be captured from a release build (secure layer) — needs a documented never-shipped listing-assets build. | `quiz_screen.dart:62`; `quiz_review_screen.dart:55` | Runbook item. |
| APL-17 | D | `ITSAppUsesNonExemptEncryption` absent (per-upload prompt); UIScene not migrated (mandatory from Xcode 27); deployment target 13.0 while Flutter docs say 15 (master already 15.0); build number bump convention absent; naming inconsistent ("Level Up App" / `level_up_app` / "Level Up"). | `parts/04` IOS-04/05/10/11/14; `parts/11` IOS-18 | Set key false; raise target to 15; align names. |
| APL-18 | F | 4.8 Sign in with Apple exempt (own account system only); ATT not required (no tracking); no purpose strings needed (no protected resources); ATS default; no URL schemes/associated domains/background modes/entitlements; bundle id not `com.example`; 1024 icon has no alpha; 3.2.2(vi)/(vii) and 5.3 not applicable; export compliance exempt (HTTPS/Keychain only). | `parts/04` §5; `parts/19` BS-C-18 | — |

---

## 3. Google Play findings

Policy basis: Developer Program Policies + Play Console help fetched 2026-09-21 — see `parts/09`, `parts/12`, `parts/20`.

| ID | Sev | Finding | Evidence | Required action |
|---|---|---|---|---|
| GP-01 | A | App access: reusable credentials that bypass OTP, valid anywhere, in English — none exist on production; Robo crawler also needs them. Session eviction is **per student** ("identical to prod" limits for staging numbers), so concurrent reviewers / the Robo device farm evict each other; per-IP OTP throttle has no numeric limit and no `Retry-After`. | `openapi.yaml:56-59,96-98,169,178-181`; `parts/13` API-21/22 | Backend: ≥3 reviewer numbers + 12 tester accounts with relaxed binding/throttle; document under "Any other instructions". |
| GP-02 | A | Account deletion (answer/13327111): in-app path missing; web deletion-request URL is "a separate, still-unowned decision" per the contract changelog — and the URL is entered **in the Data safety form**, so it gates publication. | `contract-changelog.md:250`; `parts/05` API-04 | Build the in-app flow; stand up the web page (must name the app as listed, work without the app). |
| GP-03 | A | Data safety form: six answers would be false today (deletion "Yes" without a path; blanket deletion while quiz attempts are "kept forever"; parent phone as Optional though contract-required; deviceId "regenerated on reinstall" false on iOS; device `model` category ambiguity; a DiskSpace reason the app has no purpose for). The form gates the **closed** testing track, so the 12-tester × 14-day clock cannot start until they are true (BS-D-01). | `parts/14` DECL-*; `parts/12` POL-11; `parts/20` BS-D-01 | Ship deletion; get Seif Q4–Q7; stop sending `model`; fix IOS-06; then file. |
| GP-04 | A | Privacy policy (answer/10144311): live non-PDF URL in Console **and** in-app; must name the listed entity and cover retention/deletion — placeholders in-app, retention unknown. | as APL-03 | as APL-03. |
| GP-05 | A | Release artefact unsigned (no upload keystore); Play App Signing not enrolled; CI builds APK only, never AAB; no release/upload workflow exists. | `build.gradle.kts:52-69`; `apksigner` → DOES NOT VERIFY; `ci.yml:377`; `parts/18` BS-B-11 | Provision upload key (`docs/RELEASE_SIGNING.md`), enrol Play App Signing, add an `appbundle` job. |
| GP-06 | A (listing) | Store identity is the template: label `level_up_app` in every AndroidX resource locale (80+), stock icon at all densities, no adaptive/monochrome icon, stock splash; listing assets (512 icon, 1024×500 feature graphic, ≥2 screenshots) are publish gates. Application ID `com.levelup.level_up_app` becomes permanent at first upload and is still unclaimed (BS-D-09). | `AndroidManifest.xml:27`; `parts/02`; `parts/03` AND-03/04; `parts/20` | Decide name + application id now; brand icon/splash; produce assets. |
| GP-07 | A (schedule) | Production access is a Google-reviewed application ("Review usually takes seven days or less"), refusable for insufficient tester engagement — guaranteed while the prod host is a placeholder and no cohort is seeded (BS-D-02). | `parts/20` | Sequence: prod URL → seeded cohort → closed test → application. |
| GP-08 | B | Target audience / Families: 13–15/16–17 "may be considered to include children in some locales" (legal call for Egypt); marketing art that "suggest[s]" under-13 appeal (bird logo, streaks, podium) can trigger rejection under answer/9867159. Families' phone clause is `TelephonyManager`-scoped, so phone-OTP login is compatible (trap closed). Org account needs D-U-N-S and publishes a legal address + phone. | `parts/20` BS-D-03/04/05 | Legal memo on age groups; adult-neutral listing art; decide account type. |
| GP-09 | B | UGC policy (answer/9876937): leaderboard display names are UGC ("visible to … a subset of the app's users"); requires in-app report/block **and** terms acceptance before users create UGC — no acceptance action exists anywhere; no moderation op in the contract. Not triggered at HEAD (tab is a placeholder) — triggered the day the board ships. | `leaderboard_row.dart:89`; `openapi.yaml:2767-2772`; `parts/20` BS-D-06; `parts/12` POL-06 "Option 0" | Cheapest compliant option ("Option 0", `parts/12` POL-06): never render a peer's display name (rank + points + avatar only) — removes Apple 1.2 and Play UGC duties outright. Otherwise, before shipping the board: terms acceptance, report path, name moderation (Seif). |
| GP-10 | A (tabs) / B (rest) | Broken/dormant functionality + Deceptive Behavior: same stub inventory as APL-11 — the two placeholder primary tabs are rated A ("Apps that are designed to do nothing or have no function"); "Message" tab name implies chat in a 13–17 product (Child Safety Standards question — N/A only if **both** the Message tab is removed **and** the category is Apps → Education, not Games → Educational, `parts/20` BS-D-12). Enforcement ladder is removal → suspension → strikes on a virgin account, not just rejections. | `parts/16` §2; `parts/20` BS-D-08/12 | Hide/finish; rename/remove Message; choose the Education category. |
| GP-11 | B | Marketing screenshots: FLAG_SECURE on quiz + review blocks capture; "Screenshots must demonstrate the actual in-app experience" (answer/9866151); pre-launch report will show black quiz screens. | `quiz_screen.dart:62`; `parts/20` BS-D-07; `parts/16` REV-16 | Listing-assets build; note in App access instructions. |
| GP-12 | C | Advertising ID declaration is separate from "Contains ads"; nothing guards against a plugin merging `AD_ID` (permission proof only checks INTERNET is present). Device `model` transmitted but undeclared. Default listing language decision (Play offers `ar` — there is no `ar-EG` variant — plus `en`). Android vitals with zero crash signal. | `ci.yml:397`; `parts/03` AND-08; `parts/20` BS-D-10/11/14/15 | Exact-permission guard; declare "no AD_ID"; decide crash reporting. |
| GP-13 | C | Android 16 / target 36 behaviours unverified on device: edge-to-edge (no opt-out), predictive back (`enableOnBackInvokedCallback` undeclared; app uses `PopScope` ×3), large-screen orientation ignored (no lock anyway). `supportsRtl`/`localeConfig` absent. | `parts/03` AND-09/10/11 | Device walk on API 35/36; declare the attribute. |
| GP-14 | D | Pre-launch accessibility flags likely: four tap targets 35–36 dp, sparse content labels on SVG nav icons; 3 ARB keys with naive Arabic plurals; template README; gradle wrapper without checksum; CI actions unpinned. | `parts/17` BS-A-01/02; `parts/18` BS-B-01/09 | Polish. |
| GP-15 | F | Target API 36 / compile 36 / min 24 (ARTEFACT); 16 KB page size: zipalign `-P 16` OK and all 12 `.so` LOAD align ≥ 0x4000 (ARTEFACT); AAB builds (59.0 MB, 3 ABIs, base module only); R8 shrink+obfuscate ON with mapping and native symbols embedded in the AAB; permissions exactly INTERNET + ACCESS_NETWORK_STATE (+ AndroidX signature permission); no AD_ID/QUERY_ALL_PACKAGES/FGS/exact-alarm/media; `allowBackup=false` + `dataExtractionRules` exclude everything; no cleartext; not debuggable; no deep links/App Links; no WebView usage (url_launcher's `WebViewActivity` is present but never invoked); no Play Billing / IAP; DEX 1.4 MB (below the 2027 10 MB optimisation rule); Families technical obligations already met (no AAID/IMEI/TelephonyManager). | `parts/02`, `parts/03` §2 | — |

---

## 4. Flutter (Dart) findings

Full tables: `parts/01`, `parts/10`, `parts/16`.

| ID | Sev | Finding | Evidence |
|---|---|---|---|
| FE-01 | A | `Flavor.prod => 'https://TBD.example/api/v1'` ships in the prod artefact (ARTEFACT string scan: the only API host in `libapp.so`). DNS failure → `NetworkException` → `isOffline()` true → **every screen shows "You are offline" on a live network**, banner hidden. | `app_config.dart:54`; `error_interceptor.dart:16-17`; `exceptions.dart:92-93`; `parts/02` |
| FE-02/03/04 | A | Legal placeholders + auth-gated stubs; no deletion path; pending-deletion dead end (see APL-02/03). | `parts/01` |
| FE-05 | B | `lib/main.dart` re-exports `main_dev`; flagless `flutter build … --release` ships the **staging** host (ARTEFACT-proven 2026-09-05); nothing stops `-t lib/main_mock.dart --release`; the only guard lints written commands in docs/tool/CI. | `lib/main.dart:4`; `workflow_test.dart:148-193` |
| FE-06 | B | `CachedNetworkImage` disk cache (avatars **and question images**, 30-day stale period, sqflite index in app-support dir) survives logout and account switch; `invalidateSessionScope` exempts storage. | `session_scope.dart:51-52,58-100`; `mcq_renderer.dart:90`; `parts/07` PRIV-03 |
| FE-07 | B | Generated/hand-written `toString()` interpolate tokens and PII (`TokenPair`, `StudentProfile`, `ProfileUpdate`, `EmailPatch`, `Phone`). No sink today; a future crash reporter or `debugPrint` leaks them. | `token_pair.freezed.dart:40`; `student_profile.freezed.dart:60`; `profile_update.dart:147,198`; `phone.dart:71` |
| FE-08 | B | Entitlement copy names "an active subscription" with no path to obtain one; purchase-silence is otherwise complete (no CTA/price/provider; no banned adr-171 vocabulary in either ARB or Dart — "subscription" as a state noun only). | `app_en.arb:484,495`; `limit_sheet.dart:91-96`; `parts/10` |
| FE-10/11/12/13 | B | Placeholder tabs, Home cards, stub screens, discarded referral field (see APL-11). | `parts/01`, `parts/16` §2 |
| REV-02 | B | Always Arabic on launch; device locale never read (`Platform.localeName` absent). | `locale_provider.dart:23-24` |
| REV-03 | B | Profile hub rows (privacy, terms, settings, logout) render only in the `/me` loaded state. | `profile_screen.dart:75-91,115-152` |
| ENT-01 | B | `entitlementsProvider` has zero watchers; `build()` and its `AppLifecycleListener(onResume: refresh)` never run; the app installs no lifecycle observer at all. adr-171 §4's premise is false. Harmless today only because nothing displays entitlement (gating is 100 % server 403 at call time; cold start is always a live `/me`). | `me_notifier.dart:55-78`; `parts/15` |
| ENT-04/05 | C | `refresh()` discards last-known state on failure (`AsyncValue.guard`); `active`/`inGrace` are independent booleans (2-day grace could render as plain Active). | `me_notifier.dart:67-71`; `entitlement_state.dart:21-37` |
| FE-14 | C | No `FlutterError.onError`/`PlatformDispatcher.onError`/`runZonedGuarded`/`ErrorWidget.builder`; no crash reporting (privacy-positive, review-blind). Unawaited `launchUrl` and `_protection.enable()` throw unhandled if a plugin is missing. | `bootstrap.dart:10-31`; `quiz_screen.dart:70`; `login_screen.dart:118` |
| FE-15 | B | No age floor (DOB picker today → −100 y, initial 15); parent phone required on both tracks with no explanation; no terms/consent in the wizard. | `date_of_birth_field.dart:32-40`; `school_registration.dart:66` |
| FE-16 | C | Text scaling unhandled (no `TextScaler` anywhere; BUG-002 device-verified overflow at 1.3× in Arabic; RESPONSIVE.md 0/11 applied). | `docs/KNOWN_BUGS.md:104-106` |
| FE-17 | C | No orientation lock on either platform; portrait-only frames; iPad/tablet landscape untested. | grep `setPreferredOrientations` → 0 |
| FE-18 | C | Login phone hint `01021871999` is a real-format number that is also the mock fixture; ships in the artefact. | `app_en.arb:32`; `mock_backend.dart:196`; `parts/02` |
| FE-27 | C | No GoRouter `errorBuilder` → un-localised default error page on a bad route. | `app_router.dart:98-102` |
| FE-30/REV-11 | C | Registration draft is in-memory only, no `restorationId`; `registrationToken` TTL 10 min across a 4-screen wizard with 7 reference loads → `RegistrationExpiredView`, draft lost. | `registration_controller.dart:15-36`; `registration_draft.dart:65-67` |
| FE-32/33/34 | C | Login formatter blocks Arabic-Indic digits while OTP field has neither formatter nor folding; OTP resend countdown is a `Timer.periodic`, not wall-clock anchored. | `login_screen.dart:305-323`; `otp_notifier.dart:163-202` |
| REV-07b/14/27 | C | "See All" is a bare `Text` (no handler/semantics); "+20" chevron has no tap handler (non-Egyptian E.164 *is* accepted — corrects POL-03); no `ThemeMode.system`. | `coming_soon_section.dart:76-79`; `login_screen.dart:302`; `phone.dart:34-42` |
| FE-19/20/22/23 | D | `/track-select` dev placeholder title; `/friends` orphan route; `AppConfig.isDev` dead (staging ≡ prod on screen); allowlisted literals. | `parts/01` |
| BS-A-01/02 | D | Naive Arabic plurals in 3 keys (`pointsAwarded`, `rateLimitedIn`, `resendIn`); four tap targets at 35–36 dp. | `app_ar.arb:8,30,189`; `parts/17` |
| FE-PASS | F | Tokens: Keychain `first_unlock_this_device`, non-synchronizable; logout clears tokens + 13 providers (guard-enforced discipline test); single-flight, loop-safe refresh; forced logout on `refresh_token_invalid`/`session_superseded`; offline never logs out; zero `print`/`Logger`/`LogInterceptor`; server `title`/`detail` never rendered; HTTPS-only, no cert overrides, 15 s/20 s timeouts; both ARBs present with parity guard (259/259); `EdgeInsetsDirectional` throughout; `EntitlementType` *decodes* unknown values safely via `unknownEnumValue` (rendering of an unknown type is undefined — `parts/15` ENT-08); no Clipboard/share/intents; no SMS-retriever autofill; FLAG_SECURE covers every answer-bearing screen (quiz + review) and is cleared in `dispose`; `NumberFormat('ar')` renders Western digits; assets match pubspec; no platform names/emoji/TODO in copy. | `parts/01` §2; `parts/06` §2; `parts/10`; `parts/17` |

---

## 5. Android findings

Full tables: `parts/02` (ARTEFACT), `parts/03`, `parts/18`.

| ID | Sev | Finding | Evidence |
|---|---|---|---|
| AND-01 | A | Prod placeholder host (= FE-01). | `app_config.dart:54` |
| AND-02 | A | Unsigned release outputs; fail-closed signing confirmed at ARTEFACT (`apksigner verify` → DOES NOT VERIFY; `output-metadata.json` → `app-release-unsigned.apk`). | `build.gradle.kts:19-25,52-69` |
| AND-03/04 | B | Stock icon at all five densities (md5 = SDK template), no adaptive/monochrome icon; `android:label="level_up_app"` hardcoded, unlocalised; stock splash (pure white/black, stock icon in the Android 12+ system splash). | `AndroidManifest.xml:27`; `parts/17` BS-A-03 |
| AND-06 | C | Docs say R8 is OFF; artefact proves R8 **ON** (Flutter plugin default `shouldShrinkResources() = true` → `isMinifyEnabled = true`); `r8.json` shrink+obfuscate, `proguard.map` 11.7 MB and native `.so.sym` embedded in the AAB. | `FlutterPluginUtils.kt:209-216`; AAB `BUNDLE-METADATA/` |
| AND-07 | C | CI builds APK only, release gate runs only on `main` (work is on `merged`), no artefact upload, no AAB, no release/tag workflow. | `ci.yml:262,320,377`; `parts/18` BS-B-11 |
| AND-08 | C | Permission proof checks INTERNET presence only; no exact-set guard; `allowBackup`/`dataExtractionRules`/`exported` are prose rules. | `ci.yml:397`; `verify_release_manifest.ps1:93` |
| AND-09/10/11 | D | `enableOnBackInvokedCallback` undeclared; edge-to-edge unverified on API 35/36; `supportsRtl`/`localeConfig` absent. | `AndroidManifest.xml:33-54` |
| AND-12/13 | D | No `--obfuscate --split-debug-info` (Dart AOT not obfuscated — R8 covers Java/Kotlin only); FLAG_SECURE scope confirmed complete (quiz + review; result/mistakes render no answers). | `parts/03`, `parts/10` |
| AND-14/15/16/17/18 | D | Gradle workarounds (JVM-target validation relaxed, `-Xmx8G`); template TODO comment; JKS vs PKCS12 doc; versionCode never bumped (1); AGP/Gradle/Kotlin one major behind template. | `gradle.properties:13-20`; `build.gradle.kts:42` |
| BS-B-01/02/03/09 | C | Gradle wrapper has no `distributionSha256Sum` and wrapper files are untracked; no dependency verification; five GitHub Actions unpinned (`@vN`). | `gradle-wrapper.properties:5`; `ci.yml` |
| AND-PASS | F | See GP-15. Also: `taskAffinity=""`, `launchMode=singleTop`, `extractNativeLibs=false`; url_launcher_android 6.3.32 contributes **no** `<queries>` (only Flutter's `PROCESS_TEXT`); `MainActivity` is a bare `FlutterActivity`; no custom Application; `libapp.so` stripped, no `kernel_blob.bin`/`isolate_snapshot_data` in release; dev deps do not leak; codegen-drift job covers generated files; keystore ignore rules + clean git history; estimated Play download ≈ 25.6 MB for arm64. | `parts/02`, `parts/03`, `parts/18` |

---

## 6. iOS findings

Full tables: `parts/04`, `parts/11`, `parts/19`. **All iOS claims are SOURCE-level; nothing was built (Windows host).**

| ID | Sev | Finding | Evidence |
|---|---|---|---|
| IOS-01 | A | Never built; no Podfile/Pods/lock; no team/ExportOptions; first build rewrites AppDelegate/Info.plist (UIScene) and may go hybrid SwiftPM (default-on in 3.44.7). | `parts/04` IOS-01/05/08; `parts/11` IOS-20 |
| IOS-03 | A | device_info_plus DiskSpace required-reason API undeclared (see APL-04). | `FPPDeviceInfoPlusPlugin.m:42-43` |
| IOS-02 | B | Placeholder icon set (all 15 PNGs = template), template launch screen. | `parts/04` |
| IOS-06 | B | Keychain survives uninstall; no first-run guard → reinstall (or a hand-me-down family iPad) silently resumes the previous student's session with stale tokens + `device_id`; makes the contract's "regenerated on reinstall" false on iOS (declaration accuracy). | `secure_storage.dart:31-34,64,66-69`; `parts/13` API-19 |
| IOS-07 | B | Only `en`/`Base` declared; no `CFBundleLocalizations`; Arabic default in Dart → listing/app disagreement; per-app language switcher absent. | `pbxproj:186-191` |
| IOS-19 | B | ScreenProtectorKit: no `PrivacyInfo.xcprivacy`, DTS 2.5.1 objection documented in its issue #7, closed issue #8 reports iOS 26.0 launch crash. | `parts/11` |
| BS-C-01/02 | A/B | iPad in device family → mandatory iPad screenshots; `UIRequiresFullScreen` deprecated on iPadOS 26. | `pbxproj:353` |
| IOS-04/05/10/18 | D | `ITSAppUsesNonExemptEncryption` absent; UIScene not migrated (mandatory Xcode 27); deployment target 13.0 vs documented floor 15 (tool constant already 15.0 on master). | `parts/04`, `parts/11` |
| IOS-09/13/14/17 | D | Flagless `build ipa` ships dev flavour; no `--split-debug-info` (Dart frames unsymbolicated); build number bump; iOS bundle id `com.levelup.levelUpApp` ≠ Android id (legal, two identities). | `Generated.xcconfig:6`; `pbxproj:371` |
| IOS-PASS | F | Bundle id not `com.example`; ATS default; zero `NS*UsageDescription` needed; no entitlements/URL types/background modes; `ENABLE_BITCODE NO`, `EXCLUDED_ARCHS` armv7/i386; generated files git-ignored; Flutter engine PrivacyInfo compliant (FileTimestamp + SystemBootTime, no tracking); shared_preferences_foundation, url_launcher_ios, connectivity_plus, sqflite_darwin, flutter_secure_storage_darwin all ship manifests; `path_provider_foundation` (Dart FFI, no native bundle, no manifest) is treated as exempt only by **inference** from Apple's "binary dependencies" wording (`parts/11` §5 [INFERRED]); `canLaunchUrl` never used → no `LSApplicationQueriesSchemes`. | `parts/04` §4–5; `parts/11` |
| IOS-UNVERIFIED | — | **REQUIRES LOCAL RELEASE BUILD:** `pod install`, Xcode 26 compile of 7 native plugins, archive Privacy Report, signing/provisioning, ITMS validation, Keychain-survival and screenshot behaviour on device, iPad layouts, Impeller rendering of Glass effects. | `parts/04` §6 |

---

## 7. Backend findings (from the vendored contract + staging probes; backend source not available)

| ID | Sev | Finding | Evidence |
|---|---|---|---|
| API-02/22/23 | A | Reviewer bypass staging-only by contract; `servers:` declares staging only (no prod hostname anywhere in `contract/` or `docs/`); eviction per student session; throttles unchanged for whitelisted numbers. | `openapi.yaml:56-59,96-98,107-109,178-181` |
| API-01/03/04 | A | Deletion ops stable and live on staging (`POST /me/deletion-request` → 401 unauthenticated); grace-window rule "do not log out, do not retry — route to the cancel screen" unimplemented; web deletion URL unowned. | `openapi.yaml:82-83,993-1064`; STAGING probe |
| API-24/RED-06 | B | Mandated deletion confirm copy contains "paid" ×2 and "refund" ×1 — collides with adr-171 §3 banned vocabulary; contract never mentions an out-of-band completion confirmation (Apple requires one for slow deletion; session dies at the 202). | `openapi.yaml:999-1024`; `parts/13`, `parts/15` |
| API-09 | B | `dateOfBirth` has no bounds/description; `parentPhone` required on both registration bodies but write-only (S34 open); no consent record; `parentReportStatus` reads `inactive` for everyone. | `openapi.yaml:2300,2311,2337,2389-2396` |
| API-13 | E | Retention: quiz attempts "kept forever" (adr-017); erasure "runs from a daily job"; audit "internal and pseudonymous"; OTP throttle per identifier/device/IP; `security.md` cited at `:98` but absent from the contract repo; logs/backups/subprocessors UNKNOWN. **Blocks the privacy policy and both declaration forms.** | `openapi.yaml:98,169,443,568,1426`; `parts/05` Q4–Q7 |
| API-10 | C | Leaderboard exposes peers' `studentId`, `name`, `avatarUrl`, `points`; no report/block/moderation op ("Reserved … chat block/report outcomes"); names are free text ≤100. | `openapi.yaml:846-886,2767-2772` |
| API-12 | F | Staging TLS valid (Let's Encrypt, `*.up.railway.app`, to 2026-10-27), HTTP/1.1, `x-robots-tag: noindex`, no HSTS seen; 401 body is RFC-7807 with `code` + `traceId`. | STAGING 2026-09-21/22 |
| API-16/17 | D | Only 3 of 8 store topics have `seif_fight.md` entries; `DECISIONS.md` D-007 ("no link at all") not amended for adr-171. | `docs/seif_fight.md`; `docs/DECISIONS.md:245-274` |

**Questions the backend must answer (verbatim list in `parts/05` Q1–Q14, `parts/13`, `parts/15` Q-E1..E3/Q-R1..R4):** production host + TLS/HSTS; reviewer numbers/fixed OTP/eviction + throttle exemptions/entitled + seeded/validity; web deletion URL; erasure scope at `effectiveAt` (attempts kept forever, parent phone, projections, audit); log/backup retention and PII/IP in logs; subprocessors (Railway region, Redis, SMS/WhatsApp, SafeSearch, AI-explanation model); publish `security.md`; server-side age floor / parent-phone verification / consent record; masked parentPhone on `GET /me`; name moderation + report path; confirm `getMyEntitlements` route and no-cache after web redemption; `redeemSubscriptionCode` during grace; rate-limit magnitudes; web session revocation after deletion; completion confirmation for slow deletion.

---

## 8. API / contract findings

- **Hand-written freezed models, no generated client** (`pubspec.lock`: dio only). All 26 operations the app calls exist, are `x-stability: stable`, and none is `x-consumers: [web]`; **zero draft or web-only calls** (census 26 called + 7 stable-uncalled = 33 stable; `parts/05` table). Verification: SOURCE (grep of every `_dio.*` path) + ARTEFACT (no `/subscription-codes` / `/redemption-session` literal in the prod snapshot).
- `DeviceInfo` sent = exactly `deviceId` (32-hex `Random.secure()`, secure storage), `platform`, `model` — no OS version, app version, locale, push token or hardware ID (`device_info.dart:14-19`).
- `registerFcmToken` stable but uncalled; no Firebase dependency (adding push later changes both privacy forms, PrivacyInfo, POST_NOTIFICATIONS/APNs).
- **No mechanised guard** for "no draft / no web-only endpoint", placeholder hosts, `launchUrl` query params, logging, exact permissions, or banned vocabulary (`parts/17` BS-A-04) — all hold by grep only.
- `EntitlementType` extensible enum handled with `unknownEnumValue` (PASS); weekly reset = Monday 00:00 Africa/Cairo is changelog-only (`contract-changelog.md:305`).

---

## 9. Subscription / entitlement findings (`parts/15`)

Lifecycle at HEAD: login embeds `profile.entitlements` (read by no screen) → every gated call returns a server 403 (`subscription_required`, `flashcard_subscription_required`, `weekly_question_limit_reached`) → `limit_sheet.dart` shows neutral copy with **no CTA** → a web redemption is honoured on the next request because nothing is cached. Cold start is a live `/me`, so a redemption while the app was killed is correct; the gap is warm-process only.

| ID | Sev | Finding |
|---|---|---|
| ENT-02 | F | Server-authoritative gating; no client-side computation; no `pending` state anywhere (contract `:1065-1073`). |
| ENT-01 | B | The resume refetch adr-171 relies on never executes (dead provider; no lifecycle observer in the app). Must be fixed (shell-level `ref.listen`/keep-alive + one lifecycle observer covering `/me` and `/me/entitlements`) **before** any subscription area is built; adr-171 §4 needs a correction from Seif. |
| ENT-03/04/05 | C | Two entitlement sources with different refresh regimes; `refresh()` drops last-known state on failure; `active` vs `inGrace` display rule undefined. |
| ENT-09 | C | `403 account_pending_deletion` must not be rendered as "not subscribed". |
| APL-08 | A-cond. | The business model itself (web-only consumer subscription unlocked in-app, no IAP) has no clean Apple clause; residual risk even with no link. Owner decision, explained in Notes. |

## 10. Redemption findings (vs `flutter-partner-web-redemption-warning-v3.md`, adr-171, 2026-09-16)

| Constraint | Status | Evidence |
|---|---|---|
| Never accept/process a code (no entry, paste, QR, OCR, SMS, validation, IAP, price, checkout) | **PASS** | repo-wide grep: no `redeem|redemption|voucher|QR|barcode|OCR|mlkit|camera|in_app_purchase|billing|StoreKit|Paymob|Fawry|InstaPay|Stripe` in lib/, pubspec.lock; `parts/10`, `parts/15` |
| Never call `redeemSubscriptionCode`, `requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp` | **PASS** (SOURCE + ARTEFACT) | `parts/05` table; snapshot scan `parts/02` |
| No embedded WebView / WKWebView | **PASS at HEAD**; **RED-01 (B) for the future link**: `LaunchMode.inAppBrowserView` silently falls back to an embedded WebView on Android when Custom Tabs are unavailable (`url_launcher_android-6.3.32/.../UrlLauncher.java:113-129`), and the manifest lacks the `CustomTabsService` `<queries>` so `supportsLaunchMode()` returns false. On iOS, ScreenProtectorKit's open issue #11 (residual overlay blacks out `SFSafariViewController` after `disablePreventScreenshot()`) collides with an in-app-browser link | no `webview_flutter`/`flutter_inappwebview` in lock; `parts/11` §4 |
| Contract documents an app-session path through `redeemSubscriptionCode` | **RED-03 (C)** — `openapi.yaml:1908-1913` describes the web-only operation in terms a contributor could read as permission to call it from the app; no guard test prevents it (see API-08) | `parts/15` RED-03 |
| No query params/tokens/IDs in outbound URLs | **PASS** — only `launchUrl` site uses three constant query-free URLs (`login_screen.dart:117-118`); no guard test exists (RED-08) | |
| No deep-link return / App Links / push / polling | **PASS** — no VIEW intent-filters, no `CFBundleURLTypes`/associated domains, no FCM | `parts/02`, `parts/04` |
| Banned vocabulary app-wide | **PASS** in app copy; **CONFLICT** in the contract-mandated deletion copy ("paid", "refund") — needs Seif + owner sign-off | `parts/10`, `parts/13` |
| "Exactly one neutral link … system browser … behind a leave-app confirmation … URL to be supplied" | **NOT BUILT** (`lib/features/subscription/` is `.gitkeep` only); `docs/DECISIONS.md` D-007 still says "no link at all"; the only existing `launchUrl` precedent uses `externalApplication` with no confirmation (FE-24) | |
| "Entitlement refetch on resume already runs" | **FALSE at HEAD** (ENT-01) | |
| Policy verdict on the link | Apple: 3.1.1(a) + Guideline 4 → **do not ship on iOS/Egypt**; Play: consumption-only OK only if the landing page "does not eventually lead to an alternate payment method" → Android-only at most, with a certified purchase-free landing page. **Recommendation: no link on either platform in release 1** (`parts/15` RED-07) — requires an adr-171 amendment. | `parts/12` POL-01/02 |

---

## 11. Privacy / data findings (`parts/07`, `parts/14`)

Data map (20 rows, form-ready) is in `parts/07`; declaration drafts (Apple 16 rows, Play 16 rows) in `parts/14`. Summary: **collected** = student phone, parent phone, name, DOB, email (optional), governorate/city/school/stage or university/faculty/year, avatar choice, app-generated deviceId, device model, platform, quiz answers/self-grades/scores/points/level/badges, leaderboard/score visibility toggles; **not collected** = location, contacts, photos (upload disabled), microphone, hardware IDs, AAID/IDFA, push tokens, analytics, crash logs; **third parties** = none (ARTEFACT Maven graph; no plugin makes its own network call; dio sends no identifying headers); **on device** = tokens + deviceId (secure storage; deviceId survives logout by design; both survive uninstall on iOS), theme/locale prefs, image cache; **referral code** is collected but never serialised (never leaves the device).

| ID | Sev | Finding |
|---|---|---|
| POL-11 / DECL | A (at filing) | Six answers would be false today (see GP-03). |
| PRIV-03 / FE-06 | B | Image cache (incl. question images) survives logout; 30-day stale period; not covered by any wipe. |
| PRIV-02 / IOS-06 | B | iOS Keychain survival of tokens + deviceId. |
| PRIV-04 / API-09 | B | Parent phone + DOB required from minors with no age validation and no consent record; parent phone is a non-user's PII (Apple 5.1.2(i)). |
| BS-C-14 | C | Privacy policy must state retention/deletion → blocked on backend Q4–Q7, not a hosting task. |
| DEP-11 | C | No `showLicensePage`/licence surface despite MIT/BSD/Apache deps (not a store rule; attribution hygiene). |
| PRIV-PASS | F | Tracking: No; encrypted in transit; no ads; no Photos row needed (catalogue avatars); fonts embed OFL 1.1 (fontTools read); no third-party sharing (the "not shared" tick is truthful only if the privacy policy states that the leaderboard is peer-visible — `parts/12` POL-11(f)). |
| POL-11(e)/(f) | C | Privacy-policy content duties not yet drafted anywhere: the peer-visible leaderboard (names, avatars, points), and the IP / per-IP rate-limit processing that the contract implies (`openapi.yaml:169,443,568`) — "the largest remaining unknown in the declaration set". |

## 12. Permission findings (`parts/14` deliverable 3)

| Platform | Permission | Declared | Requested at runtime | Necessary | Denied behaviour | Store declaration |
|---|---|---|---|---|---|---|
| Android | `INTERNET` | `AndroidManifest.xml:19` (+ ARTEFACT) | normal, none | yes | n/a | none |
| Android | `ACCESS_NETWORK_STATE` | connectivity_plus manifest (merged) | normal, none | yes (offline banner) | n/a | none |
| Android | `com.levelup.level_up_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | androidx.core (signature) | none | framework | n/a | none |
| Android | `<queries>` `PROCESS_TEXT` | Flutter template `:66-71` | — | vestigial | — | not a declaration item |
| iOS | none — zero `NS*UsageDescription`, correctly | — | — | — | — | — |
| Future | `POST_NOTIFICATIONS`/APNs (push), Photo Picker (avatar upload), camera (blocked by domain rule 9) | not in build | | | | must arrive with declarations in the same change |

Declared-but-unused: none. Used-but-undeclared: none. Dependency-introduced: `ACCESS_NETWORK_STATE`, the AndroidX signature permission, url_launcher's `WebViewActivity` (exported=false), `androidx.browser` (unused Custom Tabs support), `libdartjni.so` (jni package), `libdatastore_shared_counter.so` (shared_preferences). No runtime permission requests exist in Dart.

## 13. Security findings (`parts/06`)

- **PASS:** no secrets/keys/keystores in the tree or git history; `.gitignore` covers signing; zero logging; Dio chain = auth + error interceptors only; error surfaces never render raw exceptions; no `badCertificateCallback`/`HttpClient` overrides/proxy; Authorization header only, no token in URLs; refresh rotation persisted; single-flight; forced logout paths; no token in Riverpod state; `debugShowCheckedModeBanner: false`; no dev menus/hidden gestures/debug routes; no clipboard/share.
- **SEC-03 (B):** release-entrypoint trap (FE-05) with no runtime guard; **SEC-04 (C):** `toString` leaks (FE-07); **SEC-05/06 (C):** hooks unset, CI never run on `merged`, release gate main-only; **SEC-08 (D):** image cache; **SEC-09 (D):** mock harness fixtures (`000000`, `111111`, `+201021871999`) present but **absent from the prod snapshot** (ARTEFACT); **SEC-11 (D):** no diagnostics.
- Storage inventory: `access_token`, `refresh_token` (cleared on logout), `device_id` (kept by design), `pref.theme_mode`, `pref.locale`, image cache (never cleared); `SecureStorage.clear()` has zero callers.

## 14. Dependency / SDK findings (`parts/07` Task 3, `parts/18`)

- All 173 lock entries hosted on pub.dev; no git/path deps; two pre-release versions are dev-only (`freezed 3.2.6-dev.1`).
- Native plugins: connectivity_plus 7.3.0, device_info_plus 13.2.0 (**IOS-03**), flutter_secure_storage 10.3.1 (latest 11.2.0 — **DEP-08**), shared_preferences 2.5.5, url_launcher 6.3.2 (Android `WebViewActivity`, `androidx.browser`), screen_protector 1.5.3 (**IOS-19**; iOS deps ScreenProtectorKit 1.5.x **and its delegate ScreenPreventerKit** — both closed-source, neither ships a privacy manifest, the latter was never inventoried by any part: independent ITMS-91061 exposure), cached_network_image → flutter_cache_manager → sqflite + path_provider (FFI on iOS, no manifest — exemption **inferred** from Apple's "binary dependencies" wording, `parts/11` §5). Pure Dart: go_router (17.3 → 18.0 available), riverpod, bloc, flutter_svg, country_flags (ships ~250 flag assets; only Egypt used), pinput, intl 0.20.2 (exact pin).
- Apple named-SDK list hits: Flutter, connectivity_plus, device_info_plus, url_launcher(_ios), sqflite, path_provider(_ios), shared_preferences_ios — all shipped manifests verified except device_info_plus's missing reason.
- No analytics/ads/crash/tracking SDK anywhere (SOURCE + ARTEFACT). No package reads a hardware identifier the app consumes (device_info_plus exposes `identifierForVendor` but the app never reads it).
- Licences: Flutter `NOTICES.Z` present; no in-app licence page (DEP-11); fonts OFL with embedded text.

## 15. Release-artefact findings (`parts/02`, `parts/18`)

Android prod build from HEAD (`-t lib/main_prod.dart`): APK 60.7 MB, AAB 59.0 MB; `com.levelup.level_up_app` 1 / 1.0.0; min 24 / target 36 / compile 36; unsigned (fail-closed); 3 ABIs; 16 KB aligned; R8 on with mapping + native symbols embedded; DEX 1.4 MB; `libapp.so` stripped; **prod snapshot contains only `https://TBD.example/api/v1` and the `levelup.example` legal URLs — no staging host, no mock harness, no magic OTPs** (the mock code is not in the prod import graph at all); phone hint `01021871999` ships; `DebugProbesKt.bin` and all-locale AndroidX resources ship (benign). iOS: **no artefact has ever existed — UNVERIFIED — REQUIRES LOCAL RELEASE BUILD.**

## 16. Reviewer-experience findings (`parts/16`)

- **S1 (HEAD as built):** onboarding → login → every request fails → "You are offline" on a live network (REV-01). Both reviews fail at the first screen.
- **S2 (prod URL + reviewer number assumed):** login → OTP → if the number is new, a 4-screen wizard demanding DOB, parent phone, governorate/school (or university/faculty/year) within a 10-minute token → Home with three "Coming soon" cards and an inert "See All" → bottom tabs: Learn (works if content is seeded), **Leaderboard "Coming soon"**, Home, **Message "Coming soon"**, Account → Profile rows: Refer a Friend (stub), Customer Support (stub, disabled "Create Ticket"), Favorites/Progress "Not available yet", Go to Uni ("Switching tracks isn't available yet"), Privacy/Terms "not published", Settings (four notification toggles that render **ON** yet are disabled — a 2.3 / deceptive-behaviour point, REV-09 — and no system theme), Privacy and Terms rows that open the *same* stub widget and sentence (REV-36), Upload photo "isn't available yet", Logout (works). Quiz works with FLAG_SECURE (black screenshots). No delete-account row.
- **Hazards:** per-student session eviction with two reviewers or Robo's device farm; per-IP OTP throttles behind one NAT; deletion test destroys the account for 30 days; Egyptian SMS cannot reach a US reviewer → fixed OTP mandatory; external TestFlight has its own Beta App Review queue (zero days budgeted); non-Egyptian E.164 numbers are accepted (3.2.2(v) exposure lower than first thought) but the `+20` chevron does nothing.
- **Cross-platform:** bundle id `com.levelup.levelUpApp` vs application id `com.levelup.level_up_app`; icons/label/display name; locales declared; iPad vs Android tablets; screenshot semantics; Keychain vs Keystore persistence; PrivacyInfo vs Data safety; signing; build machine (Mac required).

## 17. External / console requirements (cannot be verified from the repository)

**App Store Connect:** App ID + name reservation; team/signing; Sign-in required fields + Notes (text in `parts/12` POL-03, amended per `parts/19` BS-C-05/06); Support URL with legal address/email/phone; Privacy Policy URL; App Privacy label (draft in `parts/14`); age rating questionnaire (13+; Contests yes; UGC/social answers); Content Rights; export compliance "No"; EU trader status ("not a trader" if EU excluded); territories (exclude US → no Texas/Utah/Louisiana age-assurance obligations); Mac/Vision availability opt-out; iPad screenshots or iPhone-only; Xcode 26 build; TestFlight Beta App Review.
**Play Console:** account type (org → D-U-N-S, public address/phone; personal created after 2023-11-13 → 12 testers × 14 days) and developer verification before 2026-09-30; application id decision; Play App Signing + upload key; Data safety (draft in `parts/14`; gates closed track); App access instructions; privacy policy URL; target audience + Families decision (legal memo); content rating (IARC); Financial features / Health / Government / Ads / News declarations (all "none" — **unanswered forms block updates since 2025-10-30**, `parts/12` POL-12(1)); Advertising ID "No"; store listing (512 icon, 1024×500 feature graphic, ≥2 screenshots per language, `ar` + `en` — Play has no `ar-EG` variant), **category Apps → Education (not Games → Educational; part of the Child Safety Standards N/A condition)**; US export-laws acknowledgement at app creation; closed test → production-access application. The public web deletion-request URL must **not reveal whether a phone number has an account** (enumeration surface, `parts/20` BS-D-18d).
**Backend / legal / product:** see §7 questions; hosted privacy policy, terms, support page, web deletion-request page; reviewer + tester accounts; adr-171 decision (link or no link; amendment of §4); D-007 amendment; app name; hide-or-finish stubs; orientation lock; crash-reporting stance; iPhone-only decision; age floor + parent-phone basis.

---

## 18. Things the developer might easily forget

1. **iPad screenshots are mandatory** because `TARGETED_DEVICE_FAMILY = "1,2"`; shipping iPhone-only removes the requirement and the iPadOS 26 resizable-window exposure.
2. **A reviewer testing account deletion destroys the demo account for 30 days** (session revoked at the 202, phone blocked) — provide a sacrificial number and rewrite the Notes.
3. **Play's Data safety form gates the closed testing track**, so the 12×14 tester clock cannot start until deletion exists and the six false answers are true; production access is itself a reviewed application.
4. **ASC Content Rights** and **Sign-in required (username/password)** are structured fields the team has not planned for.
5. **The adr-171 premise "the app already refetches entitlements on resume" is false** — the provider is never watched and the app has no lifecycle observer.
6. **url_launcher's `inAppBrowserView` falls back to an embedded WebView on Android** when Custom Tabs are missing; the manifest also lacks the `CustomTabsService` query — the redemption link, if ever built, must gate on `supportsLaunchMode` and fall back to `externalApplication`.
7. **R8 is ON** (Flutter default) although every project doc says off; the mapping ships inside the AAB, but keep `mapping.txt` for any APK you distribute.
8. **The app always launches in Arabic** and the iOS bundle declares English only; add `CFBundleLocalizations` and decide whether to respect the device locale.
9. **An error on `GET /me` hides privacy policy, terms, Settings and Logout** for a signed-in user.
10. **iOS Keychain survives uninstall** → a reinstalled or hand-me-down device resumes the previous student's session; also makes the contract's "regenerated on reinstall" claim false on iOS.
11. **device_info_plus has an undeclared DiskSpace required-reason API with no upstream fix**; the app only needs `model`, which is itself a declaration ambiguity — drop it.
12. **ScreenProtectorKit has a reported iOS 26.0 launch crash and an Apple DTS objection**, and no privacy manifest.
13. **Flutter's iOS floor is moving to 15** (already on master); the project is at 13.0 with no warning from the 3.44.7 tool.
14. **UIScene auto-migration rewrites `AppDelegate.swift` and `Info.plist` on the first Mac build**; SwiftPM is default-on so the build may be hybrid; mandatory from Xcode 27.
15. **Session eviction is per student**: two reviewers, or Play's Robo device farm, evict each other; per-IP OTP throttles have no numeric limit and no `Retry-After`.
16. **The contract's mandated deletion copy uses "paid" and "refund"**, words adr-171 bans app-wide.
17. **Play's UGC policy requires terms acceptance before users create UGC** — there is no acceptance action anywhere; leaderboard names count as UGC.
18. **Marketing screenshots of the quiz cannot be taken from a release build** on either platform (secure layer / FLAG_SECURE).
19. **The application id becomes permanent at first upload** and is still the template slug; the App Store name is unreserved.
20. **The privacy policy cannot be written** until the backend answers retention/erasure/subprocessor questions (Q4–Q7); `security.md` cited by the contract does not exist.
21. **DOB is required but read by no logic** (Apple 5.1.4(a) purpose limitation); parent phone is a non-user's PII with no erasure route.
22. **Play may reject listing art that "suggests" under-13 appeal** (bird logo, streaks, podium) even with a 13+ declaration; Families' phone clause is TelephonyManager-scoped, so phone-OTP is fine.
23. **Mac and Vision Pro availability are on by default** in App Store Connect.
24. **Age-rating descriptors:** "Contests" must be ticked today; "Unrestricted Web Access" flips if the link ships; September-2026 social/age-assurance questions are live.
25. **Restore Credentials (Play, April 2027)** collides with one-device-one-session; **16 KB** is already met; **Android 16** edge-to-edge/predictive back unverified on device.
26. **No release/tag/upload pipeline exists**; gradle wrapper has no checksum; CI actions are unpinned; CI has never run on `merged`; no macOS job.
27. **Six requested guard tests do not exist** (logging, exact permissions, draft/web endpoints, placeholder hosts, `launchUrl` query params, banned vocabulary) — the placeholder prod URL shipped because none does.
28. **Arabic plurals** are naive in three keys; **tap targets** at 35–36 dp; **no open-source licence page**; **default listing language** (Play offers `ar` and `en`; there is no `ar-EG` listing).
29. **"Message" tab name** raises Child Safety Standards / 1.2 questions in a 13–17 product even as a placeholder.
30. **Registration draft is lost on process kill** with a 10-minute token — a reviewer who backgrounds to read the privacy policy starts over.
31. **"Option 0" for the leaderboard** — never render a peer's display name (rank, points, avatar only) — removes Apple 1.2 and Play UGC duties (report/block, terms acceptance) outright and is the cheapest fix in this audit (`parts/12` POL-06).
32. **ScreenPreventerKit** — a second closed-source pod behind ScreenProtectorKit — was never inventoried; no privacy manifest (ITMS-91061 exposure). ScreenProtectorKit's **open issue #11** leaves a residual overlay that blacks out `SFSafariViewController` after protection is disabled — it would collide with any in-app-browser redemption link and with quiz `dispose()`.
33. **The contract documents an app-session path through `redeemSubscriptionCode`** (`openapi.yaml:1908-1913`) — a contributor can read it as permission; only a guard test prevents the call (RED-03).
34. **The public web deletion-request URL is printed on the Play listing** and must not reveal whether a phone number has an account (enumeration).
35. **Play category matters for Child Safety Standards**: Apps → Education keeps the policy out of scope only together with removing the "Message" tab; Games → Educational would not. Play listings use `ar`, not `ar-EG`.

---

## 19. Severity ledger

### 🔴 Blockers (A) — 17 items in four disjoint groups (matches §1)
*Code/config (6):* (1) FE-01/AND-01/SEC-01 prod host placeholder · (2) FE-02/SEC-02/REV-03 privacy policy unreachable in-app · (3) FE-03/04, API-01/03, BS-C-06 account deletion + cancel + 403 redirect (+ sacrificial number) · (4) IOS-03/APL-04 undeclared required-reason API + no Runner manifest (rule wording UNVERIFIED at source; upload gate) · (5) FE-09/AND-03/04/IOS-02/APL-09/GP-06 template identity (listing publish gate) · (6) FE-10/APL-11/GP-10 two placeholder primary tabs.
*Backend/contract (3):* (7) API-02/22/23, POL-03, BS-C-05, BS-D-16 reviewer-login mechanism (staging-only bypass, per-student eviction, no prod server) · (8) API-04/API-24/RED-06 web deletion URL + deletion copy vocabulary · (9) API-13/BS-C-14 retention answers Q4–Q7 that the privacy policy and forms need.
*Release build (2):* (10) AND-02/GP-05 unsigned artefact / no keystore / no AAB pipeline · (11) IOS-01/05/08 iOS never built — UNVERIFIED — REQUIRES LOCAL RELEASE BUILD.
*Console/product (6):* (12) POL-11/GP-03/BS-D-01 six false declarations + Data safety gating the closed track · (13) BS-C-01 iPad screenshots (or iPhone-only) · (14) BS-C-04 Content Rights · (15) BS-D-02 production-access review · (16) APL-08/POL-01 redemption link on iOS (if shipped — decision) · (17) BS-D-03 developer account type / D-U-N-S / verification.

### 🟠 High risk (B) — 15 groups
(1) FE-05/SEC-03/IOS-09 release-entrypoint trap · (2) FE-06/SEC-08/PRIV-03 image cache survives logout · (3) FE-07/SEC-04 toString leaks · (4) FE-15/API-09/BS-C-07/08/PRIV-04 minors: age floor, DOB unused, parent phone, no consent/terms acceptance (also weakens the 13+ declarations — `parts/12` POL-05) · (5) FE-11/12/13, POL-09 remaining stubs (Home cards, Profile stubs, referral field, inert controls) · (6) REV-02/IOS-07 always-Arabic + `en`-only bundle · (7) ENT-01 dead resume refetch · (8) RED-01 WebView fallback (design constraint for any link) · (9) API-10/POL-06/BS-D-06 UGC when the board ships (unless Option 0) · (10) IOS-06/API-19/PRIV-02 Keychain survival · (11) IOS-19/APL-13 screen_protector iOS (crash report, issue #11, ScreenPreventerKit) · (12) BS-C-02 iPadOS 26 resizing (if iPad kept) · (13) BS-D-04 child-appealing listing art · (14) BS-D-07/BS-C-11/APL-16/GP-11 marketing screenshots blocked by capture protection · (15) BS-D-09/BS-C-12 application id permanence + name reservation.

### 🟡 Medium (C) — 24 groups
(1) FE-14/SEC-11 no error handlers/crash signal · (2) FE-16 text scaling · (3) FE-17 orientation · (4) FE-18 phone hint · (5) FE-27 errorBuilder · (6) FE-30/REV-11 draft persistence + token TTL · (7) FE-32/33/34 digits + countdown · (8) ENT-03/04/05/09 entitlement display rules · (9) AND-06 R8 docs stale · (10) AND-07/SEC-05/06 CI scope + hooks · (11) AND-08/BS-A-04 six missing guard tests · (12) API-21 rate limits / Retry-After · (13) IOS-18/20 deployment floor + SwiftPM hybrid · (14) DEP-08/11 secure_storage major behind, no licence page · (15) BS-A-01/03 naive plurals, splash colours · (16) BS-B-01/02/09/11 wrapper checksum, unpinned actions, no release pipeline · (17) BS-C-03/09/10/15 Mac/Vision availability, Contests, Web Access flip, tab removal design · (18) BS-D-10/11/12/14/15 AD_ID declaration, listing language, category, vitals, `model` · (19) REV-07b/14/27 See All, +20 chevron, no system theme · (20) Q12 redemption during grace · (21) Restore Credentials 2027 vs device binding · (22) APL-08 residual business risk at HEAD · (23) RED-03 contract text invites an app call · (24) POL-11(e)/(f) privacy-policy content duties.

### 🔵 External / console (E)
See §17.

### 🟢 Verified (F)
§2 APL-18, §3 GP-15, §4 FE-PASS, §5 AND-PASS, §6 IOS-PASS, §8, §10 PASS rows, §11 PRIV-PASS, §13 PASS, BUILD: `flutter test` 1427 passed / 0 failed.

### ⚪ Not applicable (G)
Sign in with Apple; ATT/`NSUserTrackingUsageDescription`; purpose strings; Kids Category; Child Safety Standards (N/A only if **both** the "Message" tab is removed **and** the Play category is Apps → Education — `parts/20`); Age-Restricted Content; Play Billing / IAP / external-offers programs; deep links / App Links / Universal Links; WebView policy; foreground services / exact alarms / full-screen intents; photo-video / contacts picker policies; location / health / financial features; Texas/Utah/Louisiana age assurance and French encryption declaration if US/France are excluded; 3.2.2(vi)/(vii); 5.3 contests with prizes.

---

## 20. Go / No-Go factual summary

| Category | Count | Items (disjoint; see §19) |
|---|---|---|
| Verified blockers — code/config, evidenced at SOURCE/ARTEFACT | **6** | prod host placeholder (ARTEFACT); privacy policy unreachable in-app (SOURCE); no deletion/cancel flow (SOURCE, contract STAGING-probed); undeclared required-reason API + no Runner manifest (SOURCE; rule wording UNVERIFIED at source); template identity (ARTEFACT md5); two placeholder primary tabs (SOURCE) |
| Blockers — backend/contract, evidenced in the vendored contract | **3** | reviewer-login mechanism staging-only + per-student eviction + no prod server; web deletion URL unowned + "paid"/"refund" copy; retention answers absent |
| Blockers — release build, owner-run | **2** | unsigned artefact / no keystore / no AAB pipeline (ARTEFACT); iOS never built (**UNVERIFIED — REQUIRES LOCAL RELEASE BUILD**) |
| Blockers — console/product decisions | **6** | six false declarations + Data safety gating the closed track; iPad screenshots or iPhone-only; Content Rights; production-access review; adr-171 link decision; developer account type/D-U-N-S |
| High-risk unresolved groups | **15** | §19 🟠 |
| Medium-risk unresolved groups | **24** | §19 🟡 |
| External/console items | App Store Connect **13** · Play Console **12** · backend/legal/product **10** | §17 (as enumerated there) |
| Release-artefact status | Android: prod APK/AAB built and inspected (ARTEFACT), unsigned, not run on a device from this build. iOS: **no artefact has ever existed** — no IPA, archive, Privacy Report or signing (UNVERIFIED) |
| Verified areas (F), with the caveat attached | **12** | permissions (ARTEFACT); zero third-party SDK egress (ARTEFACT); transport security (SOURCE); token storage (SOURCE); backups excluded (ARTEFACT); no logging sinks (SOURCE — latent `toString` leak is the B item FE-07); error surfaces (SOURCE); purchase-silence + zero web-only/draft calls (SOURCE + ARTEFACT); mock/staging strings absent from the prod artefact built with `-t lib/main_prod.dart` (ARTEFACT — the flagless-build trap remains the B item FE-05); 16 KB / target 36 / AAB / R8 (ARTEFACT); Sign in with Apple, ATT, purpose strings not applicable (SOURCE + WEB); ARB parity 259/259 (BUILD) |

> **The repository cannot currently be considered technically ready for submission** to either store. Six code/config blockers are evidenced in the repository itself; three more are evidenced in the vendored contract and belong to the backend; two are release-build facts (the Android artefact is unsigned, the iOS artefact does not exist); six are console or product decisions that cannot be verified from the repository and are listed separately. Even if every console item were complete today, the placeholder host, the unreachable privacy policy, the missing deletion flow, the placeholder tabs, the template identity, the undeclared required-reason API, the unsigned artefact and the unbuilt iOS target would each stop a submission on their own. The verdict does not depend on any of the four policy quotes that remain UNVERIFIED at source (APL-04, APL-06, APL-13, the Xcode 26 floor).

The dependency-ordered remediation sequence and the pre-submission checklist are in `store_submission_checklist.md`; the category × platform matrix is in `store_readiness_matrix.md`.
