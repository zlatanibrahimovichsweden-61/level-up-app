# Part 14 — Store declarations + permission inventory (Wave 2-B, form-ready) — HEAD bf967d6, 2026-09-22

Read-only. No repo file outside this one was created, edited, or deleted. No builds performed.
Verification level **SOURCE** (repo grep/read, this session) unless marked **ARTEFACT** (a part-02/03
inspected build output) or **PARTS** (taken from a cited part file without independent re-derivation).

**Inputs read in full or by section, not re-derived:** `07_privacy_data_map_deps.md` (Task 1, the
20-row data map) · `12_policy_gap_analysis.md` §POL-11 (data-declaration mapping + the six false
declarations) · `03_android_src.md` §2–3 (permissions ARTEFACT + plugin manifests) · `04_ios_src.md`
§2 + §4 (Info.plist, plugin privacy manifests) · `09_policy_google.md` item 5 (Data safety category
definitions) · `08_policy_apple.md` note 5 (nutrition-label rules + manifest facts) · `06_security_release.md`
SEC-07 · `10_frontend_gaps_edge_cases.md` §3 (FLAG_SECURE route coverage).

**A live WebFetch of Apple's `NSPrivacyCollectedDataTypes` reference page was attempted this session**
(`developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacycollecteddatatypes`
and the parent `privacy_manifest_files` page) — both returned only the page `<title>`, no body content
(JS-rendered), matching part 08's own note ("Apple's page was unreadable from this session (404 /
JS-rendered)"). The constant names below are therefore marked **UNVERIFIED** — best-available names,
not confirmed against Apple's live reference in this session.

Do not file either store form from this document alone: both deliverables below hold **pending**
rows that become false declarations until Seif answers part 05 Q4–Q7 and until POL-11's six
corrections and POL-04 (account deletion) land. See "Blockers" in each section.

---

## DELIVERABLE 1 — Apple App Privacy (nutrition label) draft

### Tracking

**Tracking: No.** No ATT prompt, no `NSUserTrackingUsageDescription`, no ad SDK, no cross-app/cross-site
data linkage of any kind (part 08 note 5; DEP-03 PASS, part 07). Every row below has
`NSPrivacyCollectedDataTypeTracking = false`.

### Linked-to-you

Every collected row is **Linked to you** — the account is a phone number, and every field ties back
to `StudentProfile`/the session (part 08 note 5: "every row Linked to you (the account is a phone
number)"). No row qualifies for anonymous/de-identified treatment.

### Data type rows

| # | Apple data type | Concrete item(s) | Collected? | Linked? | Tracking | Purpose | Evidence (file:line, where it leaves the device) | Notes / ambiguities |
|---|---|---|---|---|---|---|---|---|
| DECL-01 | Contact Info → **Name** | Full name | Y | Y | N | App Functionality | `signup_identity_screen.dart:159-160` → `POST /auth/register` (`name`, required, both bodies); `PATCH /me` (`profile_update.dart:114`) | None. |
| DECL-02 | Contact Info → **Phone Number** | Student phone (E.164, account identifier) | Y | Y | N | App Functionality | `login_screen.dart:94,180-182` → `POST /auth/otp/request` (`auth_repository.dart:31`), `/otp/verify` (`:58-60`), both registration bodies | This is also the account key; no separate "Account credentials" Apple type exists — Contact Info/Phone Number is the correct (only) row. |
| DECL-03 | Contact Info → **Phone Number** | Parent/guardian phone (third party's number, entered by the student) | Y | Y | N | App Functionality | `signup_identity_screen.dart:175`, read at `:75` → `POST /auth/register` `parentPhone`, **required** on both bodies (`school_registration.dart:66`, `university_registration.dart:62`; contract `openapi.yaml:2311,2337`) | **POL-11(a):** the nutrition label has no concept of "someone else's data" — declare where the data type lives, and the privacy policy (not the label) must say a parent's number is collected. Field needs a purpose string (POL-05, unbuilt). |
| DECL-04 | Contact Info → **Email Address** | Email (optional, edit-profile only) | Y | Y | N | App Functionality | `profile_update.dart:113-123` (`EmailPatch` 3-state) via `edit_profile_screen.dart`; `PATCH /me` | Genuinely optional — never collected at registration (`school_registration.dart:35-37`). |
| DECL-05 | Identifiers → **User ID** | Server account id (`StudentProfile.id`) | Y | Y | N | App Functionality | Issued by server on OTP verify/register; embedded in `GET /me` response | Keep this row distinct from Device ID below (POL-11(b)). |
| DECL-06 | Identifiers → **Device ID** | App-generated random `deviceId` (32 hex chars, `Random.secure()`) | Y | Y | N | App Functionality | `lib/core/storage/secure_storage.dart:72-83` → `POST /auth/otp/verify`, both registration bodies, `POST /auth/refresh` | **POL-11(b), agree — "Device ID" not "User ID"** (not derived from the person, not a hardware ID). ⚠️ **DECL-06a:** the contract's own description — "regenerated on reinstall" (`openapi.yaml:2239-2247`) — is **false on iOS**: Keychain survives uninstall (IOS-06, unmitigated). Do not let the privacy policy or App Review notes repeat that claim until IOS-06 is fixed. |
| DECL-07 | User Content → **Gameplay Content** | Quiz answers, self-grades, scores, points, level, badges, leaderboard rank | Y | Y | N | App Functionality | `quiz_repository.dart:52,93,117` (`POST /quizzes`, `.../answers`, `.../finish`); `flashcards_repository.dart:109` | **POL-11(d), agree.** Do **not** also add a Usage Data → Product Interaction row — the app logs no navigation/analytics telemetry (DEP-03 PASS); that would over-declare. ⚠️ **Retention trap (DECL-07a):** quiz attempts are "kept forever" (adr-017) and erasure scope at `effectiveAt` is UNKNOWN (part 05 Q4). Hold this row's "supports deletion" framing until Q4 is answered. |
| DECL-08 | User Content → **Other User Content** | Avatar choice (`avatarId`, picked from a server catalogue) | Y | Y | N | App Functionality | `edit_profile_screen.dart:205` → `PATCH /me` (`profile_update.dart:120`); picker reads `GET /reference/avatars` | This is a catalogue **selection**, not an uploaded photo — no image ever leaves the device, so **no "Photos or Videos" row today.** Registration does not collect one (server default). If `PUT /me/avatar` (contract `x-stability: draft`, unused) ever ships, this becomes Apple Photos/Videos (Linked) plus a SafeSearch-vendor processor disclosure (POL-11(f)). |
| DECL-09 | Other Data | Date of birth; governorate/city/school/stage/education system (School arm) or university/faculty/study year/governorate/city (University arm) | Y | Y | N | App Functionality | `school_detail_screen.dart:125-235`, `university_detail_screen.dart:126-247` → `POST /auth/register`, all fields required on their respective arm | DOB's Apple hook is 5.1.4(a) — "birthdate and parental contact information only for the purpose of complying with [minors'] statutes" (part 08 note 9); the privacy policy should say so. No client- or server-side min/max age validation exists (part 05 API-09) — flag to product/legal, not a label issue. |
| DECL-10 | Usage Data | — | **N** | — | — | — | DEP-03 PASS: no analytics/telemetry SDK anywhere in the dependency graph; zero navigation/event logging in `lib/`. | Do not add a row. Adding "Product Interaction" here would be the exact over-declaration POL-11(d) warns against. |
| DECL-11 | Diagnostics | — | **N** | — | — | — | No crash reporter (IOS-13, part 04); no analytics (DEP-03). | Do not add a row. |
| DECL-12 | Purchases | — | **N/A** | — | — | — | No IAP, no Play Billing, no billing SDK in the dependency graph (DEP-03; adr-049 §3, "purchase-silent"). | Must stay N/A. The app is contractually purchase-silent — never build a payment surface (CLAUDE.md non-negotiable), so this row cannot change without a product decision that is out of this app's scope. |
| DECL-13 | Location | — | **N** | — | — | — | No location plugin/permission anywhere (part 01, part 06 PASS list). | — |
| DECL-14 | Health & Fitness / Financial Info / Sensitive Info / Contacts / Browsing History / Search History | — | **N** (all) | — | — | — | No corresponding plugin, permission, or field in the data map (part 07 Task 1, complete 20-row trace). | Confirmed absent, not merely unexamined. |
| DECL-15 | IP address (implicit, connection-layer) | — | **No row, pending** | — | — | — | Contract confirms IP is processed server-side for rate limiting (`openapi.yaml:169`) but the *app* never reads or transmits it explicitly. | **POL-11(e):** Apple's "collect" test is about app-transmitted payloads, not connection artefacts — no row today. **Revisit the moment Seif answers part 05 Q5** (log/IP retention); if IP is retained beyond transient abuse control, a row becomes necessary. |
| DECL-16 | Referral code | — | **N (never transmitted)** | — | — | — | Collected on-screen (`signup_identity_screen.dart:183-187`) into `RegistrationDraft.referralCode` but **confirmed absent** from both `SchoolRegistration.toJson()`/`UniversityRegistration.toJson()` (grep, this session's part 07 re-check). | Not a privacy-label issue — it is a POL-09 "misrepresents functionality" completeness problem (remove the dead field), not a data-minimisation finding (part 12 POL-12 item 7). |

### App-level `PrivacyInfo.xcprivacy` — `NSPrivacyCollectedDataTypes` keys needed

**UNVERIFIED — Apple's live reference page returned no body content to this session's WebFetch (see
preamble); names below are the best-available constants, not confirmed live.** A Runner-level manifest
(none exists today, part 04 §3 IOS-03) would need one dictionary per DECL row above with
`NSPrivacyCollectedDataType*`, `NSPrivacyCollectedDataTypeLinked = true`, `NSPrivacyCollectedDataTypeTracking = false`,
and `NSPrivacyCollectedDataTypePurposes = [NSPrivacyCollectedDataTypePurposeAppFunctionality]`:

- `NSPrivacyCollectedDataTypeName` (DECL-01)
- `NSPrivacyCollectedDataTypePhoneNumber` (DECL-02, DECL-03)
- `NSPrivacyCollectedDataTypeEmailAddress` (DECL-04)
- `NSPrivacyCollectedDataTypeUserID` (DECL-05)
- `NSPrivacyCollectedDataTypeDeviceID` (DECL-06)
- `NSPrivacyCollectedDataTypeOtherUserContent` (DECL-07 gameplay, DECL-08 avatar selection)
- `NSPrivacyCollectedDataTypeOtherDataTypes` (DECL-09 — DOB/school/university/geography)

This is **separate** from the already-confirmed `NSPrivacyAccessedAPITypes` category IDs in part 08 note
5 (`NSPrivacyAccessedAPICategoryUserDefaults` `CA92.1`, `…FileTimestamp` `C617.1`, `…SystemBootTime`
`35F9.1`, `…DiskSpace` `E174.1`, `…ActiveKeyboards` `54BD.1`) — those describe *API access*, not
*data collection*, and only `UserDefaults` (`shared_preferences_foundation`) is truthfully declarable
today. **Do not add `…DiskSpace`/`E174.1`** to any manifest — DECL item flagged as false declaration
#6 below (`device_info_plus` triggers the API but the app has no disk-space purpose; see IOS-03 remediation
options in part 04).

### Blockers before this form can be filed

1. DECL-07a — quiz-attempt retention (part 05 Q4) unresolved.
2. DECL-15 — IP retention (part 05 Q5) unresolved.
3. IOS-03 (`device_info_plus` undeclared `DiskSpace` API use) unresolved — affects the manifest, not the label rows, but blocks a clean Xcode Privacy Report.

---

## DELIVERABLE 2 — Google Play Data safety draft

### Questionnaire-order answers

| Question | Answer today | Evidence |
|---|---|---|
| (a) Does your app collect or share any of the required user data types? | **Yes** | Rows below — name, phone (×2), email, DOB, geography, User IDs, Device IDs, App activity all transmitted off-device. |
| (b) Is all collected data encrypted in transit? | **Yes** | No `usesCleartextTraffic`, no permissive `networkSecurityConfig`; all base URLs HTTPS; `http://mock.local` exists only in the dev-mock flavour, never shipped (part 03 §2 PASS "No cleartext"). |
| (c) Do you provide a way for users to request deletion? | **NO — cannot be answered Yes today** | **DECL-11 (false declaration #1, POL-04):** contract defines `POST /me/deletion-request` (30-day grace) but the app never calls it; `SecureStorage.clear()` has zero callers (SEC-17). No in-app entry point, no web deletion URL shipped (`login_screen.dart:43-46` points at a `.example` placeholder). Must ship the in-app flow (entry, confirm screen, cancel screen, global 403 redirect per POL-12 action-list item 4) and a reachable web URL before this question can be answered truthfully. |

### Category / type rows

| # | Category → Type | Collected? | Shared? | Ephemeral? | Required/Optional | Purpose(s) | Evidence |
|---|---|---|---|---|---|---|---|
| DECL-17 | Personal info → Name | Y | N | N (persists in `StudentProfile`, memory-scoped) | Required | Account management | `signup_identity_screen.dart:159-160`; `school_registration.dart`/`university_registration.dart` `name` |
| DECL-18 | Personal info → Email address | Y | N | N | **Optional** | Account management | `profile_update.dart:113-123`, edit-profile only |
| DECL-19 | Personal info → User IDs | Y | N | N | Required | App functionality | Server account id, `GET /me` |
| DECL-20 | Personal info → Phone number (student) | Y | N | N | Required | Account management | `login_screen.dart:94`; `POST /auth/otp/*` |
| DECL-21 | Personal info → Phone number (parent/guardian) | Y | N | N | **Required** ⚠️ | Account management (+ App functionality once recovery ships) | `signup_identity_screen.dart:175`; `POST /auth/register parentPhone`, required both bodies |
| DECL-22 | Personal info → Other info | Y | N | N | Required (all fields on their arm) | Account management / App functionality | DOB + school/university/governorate/city/stage/faculty/study year, `POST /auth/register` |
| DECL-23 | Financial info | **Not collected** | — | — | — | — | No billing SDK, no IAP, no payment fields in any request body (DEP-03; adr-049 §3). |
| DECL-24 | Health / Location / Messages | **Not collected** (all three) | — | — | — | — | No plugin/permission/field for any (part 01/06/07). |
| DECL-25 | Photos and videos | **Not collected** | — | — | — | — | Avatar = server-catalogue `avatarId` selection, not an uploaded image; no `image_picker`/camera dependency (part 01 Permissions PASS). If `PUT /me/avatar` ships: becomes Y, Optional, App functionality, plus a processor line for the SafeSearch vendor. |
| DECL-26 | App activity → App interactions | Y | **Peer-visible, not "shared" in Play's third-party sense** (other end users aren't third parties — POL-11(f)) | N — "kept forever" per adr-017 | Required (core gameplay) | App functionality | `quiz_repository.dart:52,93,117`; `flashcards_repository.dart:109`; leaderboard rank/points embedded in `GET /me` |
| DECL-27 | App activity → In-app search history | **Not collected** | — | — | — | — | No search feature exists in the data map (part 07 Task 1, 20 rows, none is a search field). |
| DECL-28 | App activity → Other user-generated content | **Not collected beyond DECL-26/DECL-17** | — | — | — | — | No free-text UGC field beyond name/avatar (already declared) and gameplay data. |
| DECL-29 | App activity → Other actions | Y | Peer-visible when `leaderboardVisible=true` | N | **Optional** — user-controlled toggle | App functionality | `settings_screen.dart:300,306-312` (`leaderboardVisible`, `scoreHidden`) → `PATCH /me` |
| DECL-30 | App info & performance → Crash logs | **Not collected** | — | — | — | — | No crash reporter (IOS-13; DEP-03). |
| DECL-31 | App info & performance → Diagnostics | **Not collected** | — | — | — | — | Same as DECL-30. |
| DECL-32 | Device or other IDs | Y | N | N (persists via `flutter_secure_storage`, survives logout by design, adr-019) | Required | App functionality (session/device binding) | `device_info_provider.dart` `Random.secure()`; `secure_storage.dart:72-83` |

### Ambiguity carried forward from POL-11(c) — device `model`

Device model/platform (`device_info_provider.dart:19-27`) has **no listed Play Data-safety type**.
The instinct to fold it into "Device or other IDs" is wrong — a model string is not an identifier,
and declaring it there forces an untrue identifier answer. **Recommended fix: stop transmitting `model`
at all** (it's optional in the contract, and its stated purpose — "display label for eviction
messaging" — is never rendered by the app). This removes the ambiguity from both store forms in one
change and is the same fix POL-07/IOS-03 already recommends for the iOS manifest gap. No row is
added for `model` above; do not add one.

### Flagged answers that would be FALSE if filed today

| # | Question / row | Why false today | What must change first |
|---|---|---|---|
| DECL-11 | (c) "Users can request deletion" = Yes | No in-app or web deletion path exists (POL-04; SEC-17 zero callers) | Ship the in-app deletion screen wired to `POST /me/deletion-request`, plus a reachable web URL naming the app (Play requires **both**, per part 09 item 3) |
| DECL-07a | DECL-26 "supports per-type deletion" answered unconditionally Yes | Quiz attempts are retained "kept forever" (adr-017); erasure scope at `effectiveAt` is UNKNOWN (part 05 Q4) | Seif must answer Q4 before this row's deletion-support answer can be truthful |
| DECL-21 | DECL-21 marked **Optional** | Contract requires `parentPhone` on both registration bodies (`openapi.yaml:2311,2337`) | Mark **Required**, not Optional |
| DECL-06a | Any policy/label text repeating "deviceId regenerated on reinstall" | False on iOS — Keychain survives uninstall (IOS-06, unmitigated) | Fix IOS-06 (first-run flag in `shared_preferences` → `SecureStorage.clear()`) before repeating the contract's claim anywhere store-facing |
| POL-11(c) | Declaring device `model` under "Device or other IDs" | Over-declaration — a model string is not an identifier | Drop the row; better, stop sending `model` (see above) |
| DECL-16 | Declaring `referralCode` on any form | Non-issue, not a false declaration risk, but including it would be spurious — the field is never transmitted | Remove the dead field from the UI (POL-09), not a form change |

### What is unusually strong and should be stated on the form (not just true by omission)

Play **"Encrypted in transit: Yes"** (HTTPS-only, ARTEFACT); **no ads, no analytics, no third-party
SDKs** — ARTEFACT-provable from the AAB's `dependencies.pb` (part 02); Financial/Health/Government/News
declarations should all be answered **No** — a content subscription unlocked server-side is not a
financial-features product (part 12 POL-12 item 1), and this must be *answered*, not skipped (blocks
updates since 30 Oct 2025).

---

## DELIVERABLE 3 — Permission inventory

| ID | Platform | Permission | Declared where | Requested at runtime where | Why | Feature | Actually necessary? | Runtime handling exists? | Behaviour when denied | Behaviour when permanently denied | Store policy requirement | Declared to store (form)? | Removable? |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| PERM-01 | Android | `INTERNET` | App's own manifest, `android/app/src/main/AndroidManifest.xml:19`; ARTEFACT-confirmed via `aapt2 dump permissions` (part 03 §2) | N/A — normal permission, granted at install, no runtime prompt | Every API call (Dio/HTTPS) to Seif's backend | All network-backed screens (auth, home, quiz, flashcards, leaderboard, profile, settings) | Yes — core | N/A (not a dangerous/runtime permission) | Cannot be denied by the user | N/A | Normal permission; no store declaration required (part 09 item 7a) | N/A — not a Data-safety-form item | No |
| PERM-02 | Android | `ACCESS_NETWORK_STATE` | Merged manifest, contributed by `connectivity_plus` 7.3.0 (part 03 §2 ARTEFACT permission set; §3 plugin table) | N/A — normal permission | Feeds `ConnectivityManager` BroadcastReceiver → `isOnlineProvider` for offline-state UI | Every screen's offline banner/state (CLAUDE.md non-negotiable: every screen handles loading/empty/error/offline) | Yes | N/A | N/A (not user-deniable) | N/A | Normal permission; no declaration (part 09 item 7a) | N/A | No |
| PERM-03 | Android | `com.levelup.level_up_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | Merged manifest, signature-level, contributed transitively by AndroidX core 1.18.0 (part 03 §2 PASS list, §3 "AndroidX transitives" row) | N/A — signature permission, auto-defined/auto-granted to same-signature apps only, never shown to the user | AndroidX's dynamic `BroadcastReceiver` registration mechanism required by Android 13+'s `RECEIVER_NOT_EXPORTED`/`RECEIVER_EXPORTED` split | Framework plumbing only (`InitializationProvider`, `ProfileInstallReceiver`), not tied to a product feature | Yes — required by AndroidX itself, not removable without dropping AndroidX | N/A | N/A | N/A | Standard AndroidX boilerplate; no store-facing implication | N/A | No — dependency-introduced, transitively required |
| PERM-04 | Android | `<queries>` → `PROCESS_TEXT` intent action | App's own manifest, `AndroidManifest.xml:66-71` (Flutter default template, per part 03 §2 PASS "only `PROCESS_TEXT` (Flutter template)") | N/A — package-visibility declaration, not a runtime permission | Lets the system "Process Text" selection menu enumerate apps that can handle selected text | None — no `ACTION_PROCESS_TEXT` intent-filter handling exists anywhere in `lib/` (grep clean) | **No** — vestigial Flutter template boilerplate; the app has no text-processing feature | N/A | N/A | N/A | Package-visibility `<queries>` need no Play declaration (part 09 item 7a) | N/A | **Yes** — safe, cosmetic cleanup candidate |
| PERM-05 | iOS | *(none declared — see absent keys)* | `ios/Runner/Info.plist` (49 lines, part 04 §2): confirmed **absent**: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`/`NSPhotoLibraryAddUsageDescription`, `NSLocationWhenInUseUsageDescription`/`NSLocationAlwaysAndWhenInUseUsageDescription`, `NSContactsUsageDescription`, `NSMicrophoneUsageDescription`, `NSBluetoothAlwaysUsageDescription`, `NSLocalNetworkUsageDescription`, `NSUserTrackingUsageDescription`, `NSFaceIDUsageDescription` | N/A — none of these APIs are called | N/A | N/A | **Correctly absent** — part 04 §5 PASS item 5: "No purpose strings needed: no camera/photo/location/Bluetooth/contacts/local-network API in any plugin source"; part 01: "no permission_handler, camera, image_picker, location, contacts, microphone, share, webview, firebase, or notification packages in `pubspec.lock`" | N/A | N/A | N/A | Apple requires a purpose string only for APIs actually called; none are — correctly no keys present | N/A — nothing to declare | N/A — nothing present to remove |
| PERM-06 (FUTURE) | Android | `POST_NOTIFICATIONS` | Not present today | Would need a runtime prompt on Android 13+, requested "in the correct context, not at launch" (part 09 item 7 quote) | Push-notification opt-in, if FCM lands | None today — `registerFcmToken` (`PUT /me/fcm-token`) is stable in the contract but the app calls it nowhere; no Firebase dependency in `pubspec.lock` (part 05 API-07; part 07 row 19) | N/A until push ships | None exists | N/A | N/A | Runtime permission since Android 13; must not request at first launch | Would need new Data-safety rows (Firebase installation ID) | N/A — not present |
| PERM-07 (FUTURE) | iOS | APNs / Push Notifications capability + `UIBackgroundModes` (Remote notifications) | Not present today | Native APNs registration prompt, if Firebase/FCM lands | Same pairing as PERM-06 | None today | N/A | None exists | N/A | N/A | FirebaseMessaging "records the APNs token and associates it with a collected app installation ID" plus device model, language, time zone, OS version (part 08 note 10, SECONDARY) | Would need new nutrition-label Identifiers/Device ID + Diagnostics rows | N/A — not present |
| PERM-08 (FUTURE) | Android + iOS | Photo picker (system picker, no broad media permission) | Not present today — `PUT /me/avatar` is `x-stability: draft`, never called (part 07 row 8, part 05) | Would use Android Photo Picker / iOS `PHPickerViewController` — neither needs a manifest permission if the system picker is used | Avatar upload, if it ships | None today — avatar is a catalogue `avatarId` selection only | N/A | None exists | N/A | N/A | Play "Photo/Video permissions policy (picker)" fully enforced since 28 May 2025 mandates the system picker over broad media permissions (part 09 item 7c) | Would need Play "Photos and videos" = Y + Apple "Photos or Videos" row + a SafeSearch-vendor processor disclosure (POL-11(f)) | N/A — not present |
| PERM-09 (FUTURE, blocked) | Android + iOS | Camera | Not present today, and not planned | N/A | N/A | Blocked by product domain rule (camera capture is out of scope for this app's feature set) | N/A — explicitly excluded | N/A | N/A | N/A | N/A | N/A | N/A — never added |

**Note on PERM-09:** the audit brief that requested this row cites "domain rule 9" as the reason
camera capture is out of scope; this session could not locate a numbered rule list under that name in
`docs/` or the `level-up-domain` skill to cite a precise source. Treat the exclusion as confirmed
product policy (no camera dependency exists anywhere in `pubspec.lock`, part 01), not as an
independently re-verified rule citation — **UNVERIFIED** as to the exact source document.

### Sub-lists

**Declared but unused:** none found — every declared permission (PERM-01 through PERM-03) has an
active runtime consumer. `PROCESS_TEXT` (PERM-04) is declared and technically "usable" by the OS
text-selection menu, but the app itself never handles the intent — closest thing to "declared but
unused," flagged as removable above.

**Used but undeclared:** none found. Part 03 §2's ARTEFACT permission diff (`aapt2 dump permissions`)
shows exactly three permissions in the shipped APK/AAB and all three are accounted for above; part 03
AND-08 separately flags that *no automated guard* would catch a future plugin silently adding one
(e.g. `AD_ID`, `READ_PHONE_STATE`) — a process gap, not a current undeclared-permission finding.

**Dependency-introduced (not authored by app code):** `ACCESS_NETWORK_STATE` (PERM-02, via
`connectivity_plus`) and `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (PERM-03, via AndroidX core
transitively) are both plugin/library-introduced, not written by the app team. `INTERNET` (PERM-01)
and the `PROCESS_TEXT` `<queries>` block (PERM-04) are both in the app's own manifest (the latter is
Flutter-template boilerplate, effectively also "framework-introduced" rather than product-authored).

---

## DELIVERABLE 4 — Screenshot/record protection & clipboard/share summary

No permission is required for any of the below on either platform — included for the store review
notes and privacy-policy completeness, not for a permissions form.

### Screen-capture protection route coverage (PARTS: 06 SEC-07, 10 §3)

| Route | Screen | Renders a specific Q/A or correct answer? | Protection call | Verdict |
|---|---|---|---|---|
| `/quiz/:quizId` | `QuizScreen` | Yes — live question + choices during attempt | `enable()`/`disable()` in `initState`/`dispose` (Android `FLAG_SECURE`; iOS secure-layer, **not a hard block**) — `quiz_screen.dart:69-70,78` | Protected |
| `/quiz/:quizId/result` | `QuizResultScreen` | No — aggregate score/counts only | none | Correctly unprotected — no answer content rendered |
| `/quiz/:quizId/result/review` | `QuizReviewScreen` | Yes — per-question correct/incorrect review | `enable()`/`disable()` — `quiz_review_screen.dart:64-65,69-70` | Protected |
| `/learn/mistakes*` (4 screens) | `MistakesOverviewScreen`/`MistakesSubjectScreen`/`MistakesChaptersScreen`/`MistakesLessonsScreen` | No — subject/unit/chapter/lesson names + integer counts only, rows are `onTap: null` (inert) | none | Correctly unprotected |

**Conclusion (part 10's own, re-cited):** every screen that actually renders a specific question's
correct answer is protected; every unprotected screen renders no answer content by current design.
**No unprotected answer-bearing screen exists at HEAD** — this closes AND-13/SEC-07 as a PASS, not an
open item. Residual notes, both already tracked, not new: (1) `MainActivity` is a bare `FlutterActivity`
with no global `FLAG_SECURE`, so Play's pre-launch report and reviewer screenshots work everywhere
except the two protected quiz screens — intended, but worth stating in the store-screenshot runbook
so a reviewer doesn't file it as a bug; (2) iOS protection is explicitly documented as **not a hard
block** (`screen_protection.dart` doc comment) and Apple has no guideline requiring one (part 08 note 6,
DTS forum thread citing 2.5.1 — "a side effect… subject to change without notice").

### Clipboard / share / intents (PARTS: 06 §"Clipboard / share / intents", 01 Permissions)

- **No** `Clipboard.*` usage anywhere in `lib/` (grep clean, part 01, part 06).
- **No** `share_plus`, `receive_sharing_intent`, or `open_file` dependency in `pubspec.lock`.
- **No** `SelectableText` widget anywhere — nothing lets a user copy on-screen content via long-press selection.
- The leaderboard's "Share" affordance is **label-only** — `leaderboard_screen.dart:146-150` — it does
  not invoke any share sheet, intent, or clipboard write.
- `url_launcher` opens exactly three constant URLs externally (`LaunchMode.externalApplication`); no
  `canLaunchUrl` call anywhere, so iOS needs no `LSApplicationQueriesSchemes` (part 04 §5 PASS item 6).

**Net effect for the store forms:** nothing here creates a Data-safety or nutrition-label row — no
data is copied, shared, or handed to another app. Worth one line in App Review / Play reviewer notes
only if a reviewer questions the inert "Share" label (ties to part 12 POL-12 item 10a's "Message tab"
naming concern — cosmetic/naming accuracy, not data collection).

---

## Cross-references

- Six false-declaration corrections: `12_policy_gap_analysis.md` §POL-11 (verbatim source for
  DECL-06a, DECL-11/DECL-07a, DECL-21, POL-11(c) device-model item, and the IOS-03 manifest item).
- Retention unknowns blocking DECL-07a/DECL-11: `05_api_backend.md` "UNKNOWN — must ask backend
  (Seif)" Q4–Q7.
- Account-deletion build requirement: `12_policy_gap_analysis.md` consolidated action list, order 4.
- Permission ARTEFACT proof: `03_android_src.md` §2 (`aapt2 dump permissions`), `02_release_artefact_android.md`
  (AAB/APK inspection this table does not re-derive).
- iOS plugin manifest gap driving DECL blockers: `04_ios_src.md` IOS-03, §4 per-plugin table.
