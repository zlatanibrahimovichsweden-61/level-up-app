# Store Readiness Re-check — Independent Blocker Ledger (2026-10-04)

Companion to `store_readiness_recheck.md`. Investigation only: no application, configuration, contract, CI or dependency file was modified. Verification levels: SOURCE (file read) → BUILD (compiled/tested today) → ARTEFACT (today's production AAB inspected) → CONTRACT (vendored pin 0df5cf4, 3.28.0-m1) → WEB (official page fetched 2026-10-04, see the main report §7–§8) → UNVERIFIED (needs macOS, a signed build, a device, or a console).

Baseline: branch `merged`, HEAD `f4cd5a9` (2026-10-04), 4 commits ahead of `origin/merged`, 12 commits after the previous audit's HEAD `bf967d6`. Dirty tree: 20 modified + 5 untracked files (settings/elevation work and audit artefacts); `git status --porcelain | sha1sum` = `fee80139…` before and after the build and test runs below.

---

## A. Previous 17 blockers — current verification

| # | Previous finding (2026-09-22) | Current status | Evidence (today) | Confidence |
|---|---|---|---|---|
| 1 | Production API host is a placeholder shipping in the artefact | **Confirmed current blocker** | `lib/core/config/app_config.dart:54` `Flavor.prod => 'https://TBD.example/api/v1'`; today's prod AAB `base/lib/arm64-v8a/libapp.so` contains `TBD.example/api/v1` (ARTEFACT); `contract/openapi.yaml:107-109` `servers:` lists staging only at 3.28.0-m1; `contract/contract-changelog.md` has no production-host entry through 3.28.0-m1 | High |
| 2 | Privacy policy unreachable in-app (placeholder URLs, stub screens) | **Confirmed current blocker** | `lib/features/auth/screens/login_screen.dart:46-48` three `https://levelup.example/legal/*` constants, launched at `:123`; all three strings present in today's AAB (ARTEFACT); `/legal/privacy` and `/legal/terms` (`app_router.dart:427-434`) render `LegalDocumentScreen` → `l10n.legalNotPublished` = "This document hasn't been published yet." (`lib/l10n/app_en.arb:644`); `docs/seif_fight.md:632` S30 "NO COPY SUPPLIED … Open". The earlier sub-claim that a `/me` error hides the rows was not re-derived today | High |
| 3 | No account-deletion or cancel-deletion flow | **Confirmed current blocker** | `grep -rn deletion lib` → only the `403 account_pending_deletion` mapping (`lib/core/network/exceptions.dart:134-135`) and error copy (`app_en.arb:692`); no call to `requestAccountDeletion`/`cancelAccountDeletion`, no route, no profile row (`profile_screen.dart:234-323` rows: settings, favorites, progress, refer, support, privacy, terms, go-to-uni, logout); contract ops are `x-stability: stable` at `openapi.yaml:1070-1136`; `docs/STORE_READINESS.md:33` (working copy, 2026-09-29) agrees | High |
| 4 | Undeclared required-reason API + no Runner privacy manifest | **Confirmed (SOURCE); upload effect needs macOS** | `device_info_plus-13.2.0/ios/.../FPPDeviceInfoPlusPlugin.m:38-43` reads `NSFileSystemFreeSize`/`NSFileSystemSize` inside `getDeviceInfo`; the plugin's own `PrivacyInfo.xcprivacy` declares `NSPrivacyAccessedAPITypes` as an **empty array**; `ios/Runner/PrivacyInfo.xcprivacy` does not exist (`ls`); the app calls `plugin.iosInfo` (`lib/features/auth/repository/device_info_provider.dart:20-22`). Whether ITMS-91053 fires can only be seen at an App Store Connect upload | Medium-High |
| 5 | Store identity is the Flutter template (icons, label, splash) | **Partially fixed — re-graded HIGH, no longer a blocker** | Icons fixed: `6fe1125` (2026-09-30); `mipmap-xxxhdpi/ic_launcher.png` md5 `e70a5834…` ≠ template `57838d52…`; iOS 1024 icon md5 `d98eeda4…` ≠ template `c785f893…`, 1024×1024 RGB (no alpha); adaptive icon with designer foreground. Remaining: `AndroidManifest.xml:27` `android:label="level_up_app"` (ships in AAB, ARTEFACT); `Info.plist:16` `CFBundleName level_up_app`, `:8` `CFBundleDisplayName "Level Up App"`; splash is the template on both platforms (`launch_background.xml` white layer-list; `LaunchImage@3x.png` md5 = template); identifiers unratified (D-021 PROPOSED, `docs/DECISIONS.md:1021-1046`) | High |
| 6 | Two of five primary tabs are "Coming soon" placeholders | **Partially fixed — one tab remains; still blocker-grade** | Leaderboard un-gated in `09dca36` (2026-09-22, hours after the previous audit HEAD) → `LeaderboardScreen` at `app_router.dart:188-191`. Message tab still `MessagePlaceholderScreen` → `TabPlaceholder` "Coming soon" (`lib/features/shell/screens/tab_placeholder.dart:54-61`; `app_router.dart:313-316`; `lib/features/shell/main_shell.dart:60` shows the tab). The inbox endpoints it needs went stable at 3.28.0-m1 (`contract/SOURCE.md`) | High |
| 7 | No production reviewer-login mechanism (OTP bypass staging-only, per-student eviction) | **Confirmed — needs backend action** | `openapi.yaml:96-98` "whitelisted in staging config only — fixed OTP `000000` … Absent from production configuration"; `servers:` staging only; `contract-changelog.md` has no reviewer-account or production entry (grep `production|reviewer`) | High |
| 8 | Web deletion URL unowned; mandated deletion copy uses "paid"/"refund" | **Confirmed** (URL = Play prerequisite; vocabulary = decision) | `openapi.yaml:1089-1093` "**An active paid subscription is forfeited** — there is no partial refund"; no deletion web URL anywhere in `docs/`, `contract/` or `lib/` | High |
| 9 | Backend retention / erasure / sub-processor answers absent | **Confirmed — needs backend action; question never filed** | Contract documents only deletion timing (`openapi.yaml:1079,1111`); `security.md` is cited at `openapi.yaml:98` but is **not in** `contract/` (`ls`); `docs/STORE_READINESS.md:39,60,98` still "retention UNKNOWN"; `grep -i retention docs/seif_fight.md` → **no question filed** (the previous audit's Q4–Q7 lived only in `store_readiness_parts/05`) | High |
| 10 | Release artefact unsigned; no keystore; no AAB pipeline | **Confirmed fact — re-classified as a release prerequisite, not a defect** | `android/app/build.gradle.kts:19-25,52-71` fail-closed by design (`findByName("release")`), warning at `:76-81`; `docs/RELEASE_SIGNING.md` and `android/key.properties.example` exist; no `key.properties`/`*.jks` (gitignored, `android/.gitignore:12-14`); today's AAB has **no** `META-INF/*.RSA|SF|MF` (ARTEFACT); CI builds an unsigned APK compile gate only (`.github/workflows/ci.yml:318-377`), no AAB or upload job | High |
| 11 | iOS never built | **UNVERIFIED — needs macOS/Xcode** | No `ios/Podfile` (Flutter generates it on first `flutter build ios`; absence is not a defect), no `DEVELOPMENT_TEAM` in `project.pbxproj`, `CODE_SIGN_STYLE = Automatic` (`:383`), no entitlements, no archive. `.flutter-plugins-dependencies` (regenerated by today's build) records `swift_package_manager_enabled: ios:false` | n/a |
| 12 | Six false privacy-form answers; Data safety gates closed testing | **Needs console action; dependent on #2/#3/#9** | Not a repository fact; truthful answers require deletion (#3), a hosted policy (#2) and retention answers (#9). Gating rule → main report §8 (WEB) | n/a |
| 13 | iPad screenshots mandatory, or go iPhone-only | **Decision + console** | `project.pbxproj:353` `TARGETED_DEVICE_FAMILY = "1,2"` unchanged; `Info.plist:37-43` iPad orientations present; no `UIRequiresFullScreen`. Rule → main report §7 (WEB) | n/a |
| 14 | ASC Content Rights unanswered | **Console** | Not a repository fact; question bank is server content | n/a |
| 15 | Play production-access review | **Console/process** | Not a repository fact; account type unknown | n/a |
| 16 | adr-171 redemption link = Apple 3.1.1(a) violation if shipped | **Not a blocker at HEAD — decision item** | Only external links in `lib` are the three legal URLs (`grep launchUrl lib` → one call site, `login_screen.dart:123`, `LaunchMode.externalApplication`); no redemption/purchase URL in source or artefact (`subscription-codes`, `redemption` absent from `libapp.so`) | High |
| 17 | Developer account type / D-U-N-S / verification | **Account prerequisite** | Not a repository fact | n/a |

**Tally of the previous 17:** still confirmed blockers **8** (#1 #2 #3 #4 #6 #7 #8 #9) · partially fixed and re-graded below blocker **1** (#5) · re-classified as release/console/account prerequisites, not engineering blockers **7** (#10 #11 #12 #13 #14 #15 #17) · stale as a blocker **1** (#16: nothing to ship today) · fixed outright **0** (two partial fixes: #5 icons, #6 one of two tabs).

---

## B. Independent blocker ledger (derived today; categories disjoint, each item counted once)

### B1. Engineering / content blockers — require a change in this repository, the backend, or supplied content

| ID | Area | Finding | Current evidence | Severity | Blocks Apple? | Blocks Play? | Blocks both? | Owner | Required action |
|---|---|---|---|---|---|---|---|---|---|
| E-1 | Config / backend | Production API host is a reserved-TLD placeholder; the production build cannot reach any server | `app_config.dart:46-54`; `TBD.example/api/v1` in today's AAB (ARTEFACT); `openapi.yaml:107-109` | Blocker | Yes (2.1 completeness, app non-functional) | Yes (broken functionality) | **Yes** | Seif (announce host via contract) → app (one line) | Publish the production `servers:` entry; replace line 54; rebuild with `-t lib/main_prod.dart` |
| E-2 | Privacy / legal | No reachable privacy policy or terms: placeholder URLs ship; in-app screens say "not published"; no approved copy exists | `login_screen.dart:46-48,123`; `legal_document_screen.dart` → `app_en.arb:644`; `seif_fight.md:632` S30; strings in AAB | Blocker | Yes (5.1.1(i) link in app + metadata) | Yes (User Data policy: console URL + in-app link) | **Yes** | Product/legal (copy + hosting) → app (URL swap) | Supply hosted AR+EN policy and terms (depends on E-7 answers); replace `.example` URLs; render or link the documents at `/legal/*` |
| E-3 | Account | No account-deletion request or cancel flow, although both contract operations are stable | No repository method/route/row (`profile_screen.dart:234-323`); only error mapping (`exceptions.dart:134`); `openapi.yaml:1070-1136` | Blocker | Yes (5.1.1(v)) | Yes (answer 13327111 in-app path) | **Yes** | App (+ design for the adr-114 D3 confirm copy) | Build request + confirm screen (mandated copy `openapi.yaml:1089-1097`), cancel screen from `GET /me` `pendingDeletion`, global `403 account_pending_deletion` route, local wipe |
| E-4 | iOS privacy manifest | Required-reason API (disk space) reached through `device_info_plus` with no declaration anywhere in the bundle | Plugin reads `NSFileSystemFreeSize`/`NSFileSystemSize` (`FPPDeviceInfoPlusPlugin.m:38-43`); plugin manifest declares none; no `ios/Runner/PrivacyInfo.xcprivacy`; app calls `iosInfo` (`device_info_provider.dart:20-22`) | Blocker (Apple upload gate, SOURCE-level) | Yes (ITMS-91053 at upload) | No | No | App (one file) | Add `ios/Runner/PrivacyInfo.xcprivacy` declaring `NSPrivacyAccessedAPICategoryDiskSpace` with a permitted reason, or stop calling `iosInfo`/replace the plugin; verify with an Xcode archive Privacy Report |
| E-5 | Product completeness | One of five primary navigation tabs ("Message") is a "Coming soon" placeholder | `tab_placeholder.dart:54-61`; `app_router.dart:313-316`; `main_shell.dart:60`; `app_en.arb:251` | Blocker (likely 2.1 placeholder-content rejection; Play "broken functionality" risk) | Yes | Likely | **Yes** | Product (hide) or app (build the inbox — endpoints stable at 3.28.0-m1) | Hide the tab for release 1 or ship the inbox; do not submit with a placeholder tab |
| E-6 | Backend / review access | No production reviewer-login mechanism: the OTP bypass is staging-only by contract; no production server declared | `openapi.yaml:96-98,107-109`; changelog silent | Blocker | Yes (2.1(a) demo account; reviewers cannot receive Egyptian SMS) | Yes (App access instructions must work) | **Yes** | Seif | Provide ≥3 production reviewer numbers with a fixed OTP, entitled and seeded, exempt from per-student eviction; document in the contract |
| E-7 | Backend / privacy | Retention, erasure-of-non-deleted-data, logging and sub-processor facts do not exist in any artefact the app team can cite; the question was never filed | `security.md` cited at `openapi.yaml:98` but absent; `STORE_READINESS.md:39,60,98` UNKNOWN; no `seif_fight.md` entry | Blocker (prerequisite for E-2 text and for both privacy forms) | Yes (App Privacy label accuracy) | Yes (Data safety accuracy) | **Yes** | Seif / legal | File the question in `docs/seif_fight.md`; obtain written retention periods, log retention, sub-processors (hosting, SMS/WhatsApp OTP provider), erasure scope |
| E-8 | Play account deletion | No public web deletion-request URL exists | None in `docs/`, `contract/`, `lib/` | Blocker (Play Data safety requires the URL for apps with account creation) | No | Yes | No | Seif / web | Stand up a web deletion-request page that does not reveal whether a phone number has an account; hand the URL to the console owner |

**Engineering / content blocker count: 8** (5 need a change in this repository or supplied content: E-1 app half, E-2, E-3, E-4, E-5; 4 need the backend: E-1 host, E-6, E-7, E-8). E-1 is counted once.

### B2. Release prerequisites — human, console or account steps; no code defect; each must still happen before upload

| ID | Prerequisite | Evidence that it is outstanding | Owner |
|---|---|---|---|
| P-1 | Android upload keystore + Play App Signing enrolment | Fail-closed design; today's AAB unsigned (ARTEFACT); `docs/RELEASE_SIGNING.md` procedure exists | Release manager |
| P-2 | iOS build, signing team, archive and Privacy Report on macOS/Xcode | No `DEVELOPMENT_TEAM`, no archive, never built (UNVERIFIED) | iOS release engineer |
| P-3 | Ratify production identifiers and display names before the first upload (they become permanent) | `DECISIONS.md:1021-1046` D-021 PROPOSED; `RISKS.md:129-135` R-9; `build.gradle.kts:42-43` template TODO | Product owner |
| P-4 | Console forms answered truthfully: Data safety, App Privacy, App access, Content Rights, content rating, target audience, AD_ID "No", export compliance | Depend on E-2, E-3, E-7 | Console owner |
| P-5 | Listing assets: screenshots per language (iPad set unless family becomes "1"), 512 icon, 1024×500 feature graphic, `ar` + `en` copy; quiz screenshots need a non-protected build | `project.pbxproj:353`; `screen_protection.dart:34-37` | Design / product |
| P-6 | Developer accounts and verification (Play org vs personal; Apple Developer Program) | Not a repository fact | Client |
| P-7 | Play closed-test cohort if the account is personal (12 testers × 14 days) | Not a repository fact; rule → main report §8 | Product |

### B3. High-risk, likely-rejection or reviewer-visible items (not hard blockers)

| ID | Finding | Evidence | Note |
|---|---|---|---|
| H-1 | **NEW:** the leaderboard now ships peer display names and avatars with no report/block control and no terms acceptance; names are not server-moderated (only avatars are) | `leaderboard_row.dart:99`, `podium.dart:154`, `top_student_section.dart:285-291`; `openapi.yaml:870` moderates `PUT /me/avatar` only; no acceptance control in `lib/features/auth` or `registration` | Apple 1.2 / Play UGC exposure became live on 2026-09-22. "Option 0" (rank, points, avatar only) or a moderation/report decision |
| H-2 | Template label, bundle name and splash | `AndroidManifest.xml:27`; `Info.plist:8,16`; template `launch_background.xml` and `LaunchImage@3x.png` | Reviewer-visible template residue; D-021 Q3 covers names |
| H-3 | Inert controls: four notification toggles render ON and disabled; three Home "Coming soon" cards; Refer/Support/Friends shells with disabled controls | `settings_screen.dart:394-415` (`value: true`, no `onChanged`); `home_screen.dart:94-129`; `account_shells/screens/*` use `ShellBody` | "Designed to do nothing" impression under 2.1 / 4.2 |
| H-4 | Always-Arabic launch while the iOS bundle declares English only | `locale_provider.dart:24` `?? const Locale('ar')`; `project.pbxproj:188-191` knownRegions `en, Base`; no `CFBundleLocalizations` in `Info.plist` | Metadata accuracy; App Store language list |
| H-5 | Minors: no age floor (DOB picker allows today), DOB collected but unused, parent phone collected, no consent or terms acceptance anywhere | `date_of_birth_field.dart:38-40` (`lastDate: now`); `registration_validation.dart:79` | Weakens any 13+ declaration; 5.1.4 purpose limitation |
| H-6 | Entitlement refetch on resume is dead code; adr-171's premise is false | `session_scope.dart:64` is the only reference; `AppLifecycleListener` lives inside the never-built `EntitlementsNotifier` (`me_notifier.dart:78-99`) | Matters the day web redemption goes live |
| H-7 | `screen_protector` 1.5.3 → CocoaPod `ScreenProtectorKit 1.5.1`, no privacy manifest; reported iOS 26 launch crash | `screen_protector.podspec:19`; 0 `PrivacyInfo.xcprivacy` in the plugin; crash report not re-fetched today (carried from `parts/11`, UNVERIFIED) | Needs a Mac/device test on iOS 26 |

### B4. Medium / informational (carried only where re-derived today)

| ID | Finding | Evidence |
|---|---|---|
| M-1 | No guard test prevents calling the three web-only operations; the contract's replay note still says the `201` replay "is reached by an **app session**" | `grep x-consumers\|redeemSubscriptionCode test/` → none; `openapi.yaml:1969` op, note ≈`:1996-2000` |
| M-2 | R8 is ON (mapping shipped) while the living register says OFF | `BUNDLE-METADATA/…/proguard.map` in today's AAB; `docs/STORE_READINESS.md:68,195` |
| M-3 | `/track-select` is a dead placeholder route with no callers | `app_router.dart:488-496`; `grep "'/track-select'" lib` → only the router |
| M-4 | CI: no AAB job, no macOS job, no mock-build guard; release APK compile gate on `main` only | `ci.yml:318-377`; `grep main_mock test/guards` → none |
| M-5 | `url_launcher_android` 6.3.32 still falls back to an embedded WebView for `inAppBrowserView`; unreachable at HEAD (only `externalApplication` is used) | `UrlLauncher.java:118-125`; `login_screen.dart:123` |
| M-6 | Dirty tree (20 modified + 5 untracked) and 4 unpushed commits: the tree that would be built is not the committed tree | `git status`, `git status -sb` |
| M-7 | `pubspec.yaml:2` description is the template string (not shipped) | `pubspec.yaml:2` |

---

## C. Stale or incorrect previous statements (as of today)

| Previous statement | Today | Evidence |
|---|---|---|
| "Two placeholder primary tabs" | One (Message) | `09dca36`; `tab_placeholder.dart:7` "**One is left: Message.**" |
| "Icons md5-identical to the template" | Fixed 2026-09-30 | md5 comparison above; `6fe1125` |
| "SwiftPM is default-on, the build may be hybrid" | Not supported by the project's tool state | `.flutter-plugins-dependencies` → `"swift_package_manager_enabled":{"ios":false}` (regenerated 2026-10-04) |
| "ScreenPreventerKit, a second closed-source pod, was never inventoried" | Unverified: derived from the upstream `master` source, not the pinned pod | `screen_protector.podspec:19` names `ScreenProtectorKit 1.5.1` only; transitive deps need pod resolution on macOS |
| "No Podfile" listed among iOS buildability facts | Not a defect: Flutter writes the Podfile on the first iOS build; buildability remains UNVERIFIED | `ios/` listing |
| "adr-171 link is an A-conditional blocker" | Nothing links out today; a decision item only | one `launchUrl` call site, legal URLs only |
| "Retention answers Q4–Q7 are outstanding with Seif" | Outstanding, but **never filed** | no `retention` in `docs/seif_fight.md` |
| `ar-EG` listing language (draft v1) | Already corrected to `ar` in v2; re-check of Play's language table → main report §8 | — |
| "7 points" of mandated deletion copy (draft v1) | Already corrected in v2; the mandated block is `openapi.yaml:1089-1097` | — |

---

## D. Verified today (BUILD / ARTEFACT)

- `flutter test` (full suite, 2026-10-04): **2036 passed / 0 failed / 0 skipped**, exit 0 (BUILD).
- `flutter build appbundle --release -t lib/main_prod.dart`: `app-release.aab` 62,144,628 bytes (59.3 MB), 705 entries, ABIs `arm64-v8a`, `armeabi-v7a`, `x86_64`; **unsigned**; `proguard.map` + native `.sym` files present; manifest carries `INTERNET`, `ACCESS_NETWORK_STATE`, `allowBackup`; no `VIEW` intent filter, no `POST_NOTIFICATIONS`, no `AD_ID`; strings: `TBD.example/api/v1` ×1, `levelup.example/legal/*` ×3, **no** `railway.app`, `mock.local`, `picsum.photos`, `subscription-codes`, `redemption` (ARTEFACT).
- Tree fingerprint unchanged by the build and tests (`fee80139…`); `build/` is ignored.
