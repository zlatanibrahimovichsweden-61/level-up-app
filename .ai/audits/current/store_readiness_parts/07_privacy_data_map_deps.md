# Part 07 — Privacy data map + dependency/SDK inventory (Wave 1-B) — HEAD bf967d6, 2026-09-22

Read-only. No builds performed. Verification level **SOURCE** (repo grep + pub-cache inspection) unless
marked **STAGING**/**WEB** (pub.dev fetch, today). Reuses parts 02–06 by citation rather than
re-deriving; this part adds the field-by-field trace and the dependency/font census those parts left open.

---

## TASK 1 — Privacy data map at HEAD

Base URL for every call below: `https://level-up-backend-staging.up.railway.app/api/v1` (staging; prod is
`https://TBD.example/api/v1`, unreachable placeholder — part 03 AND-01, part 06 SEC-01). Nothing is logged
client-side anywhere (part 06 §2 "Zero logging in `lib/`").

| # | Data item | Collected where (screen/file:line) | Sent to (endpoint, file:line) | Stored on device (where / encrypted?) | Survives logout? | Survives uninstall? | Shared w/ 3rd party? | User-deletable? | Apple category (linked/tracking) | Play category |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Student phone (E.164) | `lib/features/auth/screens/login_screen.dart:94` (`Phone.tryParse`, field at `:180-182`) | `POST /auth/otp/request` `{'phone':phone}` — `auth_repository.dart:31`; `POST /auth/otp/verify` — `:58-60`; both registration bodies (`school_registration.dart`, `university_registration.dart`, via `RegistrationBody.toJson()`) | Not persisted as a standalone field — only recoverable via the JWT / server profile; UI holds it in a `TextEditingController` (memory only) | n/a (not stored) | n/a | No | Immutable in-app (no phone-change flow); server-side only via `/auth/recovery/*` (draft, unused) | Contact Info (linked) | Personal info: Phone |
| 2 | Parent/guardian phone | `signup_identity_screen.dart:175` (`_DialCodePhoneField` → `_parentPhoneController`), read at `:75` | `POST /auth/register` — `parentPhone` required field, both `SchoolRegistration`/`UniversityRegistration` (`school_registration.dart:66`, `university_registration.dart:62`) | Memory only (wizard draft, `RegistrationDraft`); not in `StudentProfile` (write-only — part 05 API-09, S34) | n/a | n/a | No | **No** — not readable back (`GET /me` omits it, S20) and not editable | Contact Info (linked) | Personal info: Phone |
| 3 | Full name | `signup_identity_screen.dart:159-160` (`_nameController`) | `POST /auth/register` (`name`, required, both bodies); `PATCH /me` (`profile_update.dart:114`, optional) via `edit_profile_screen.dart` | `StudentProfile.name` held in the (non-autoDispose) `meProvider` (`me_notifier.dart`) — memory only, no disk cache of the profile object | No (provider invalidated on logout, `session_scope.dart:60-99`) | n/a (not on disk) | No | Yes — editable via Edit Profile → `PATCH /me` | Contact Info (linked) | Personal info: Name |
| 4 | Date of birth | `school_detail_screen.dart:125-129` (`DateOfBirthField`, TODO(design) — not in Figma) | `POST /auth/register` (`dateOfBirth`, `@DateOnlyConverter`, required, both bodies) | Memory only (draft + `StudentProfile`) | No | n/a | No | **No** — immutable in-app, no min/max validated client- or server-side (part 05 API-09) | Sensitive-adjacent / Contact Info | Personal info |
| 5 | Email (optional) | `edit_profile_screen.dart` only (never at registration — deliberately not collected, `school_registration.dart:35-37`) | `PATCH /me` via `EmailPatch` 3-state (`profile_update.dart:113-123`) — `set`/`cleared`/`unchanged` | Memory only (`StudentProfile.email`) | No | n/a | No | Yes — clears with explicit JSON `null` (`profile_update.dart:118`), the one place `includeIfNull:false` would silently break (memory: `patch-me-email-tri-state.md`) | Contact Info (linked) | Personal info: Email |
| 6 | Governorate / city / school / stage / education system | `school_detail_screen.dart:135-235` (`ReferenceDropdown`, `city_field.dart`, `school_picker_field.dart`) | `POST /auth/register` school arm: `governorateId`/`cityId`/`cityName`/`schoolId`/`stage`/`educationSystem` (`school_registration.dart:56-67`) | Memory only | No | n/a | No | No — immutable in-app | Other User Data | Personal info |
| 7 | University / faculty / study year / governorate / city | `university_detail_screen.dart:126-247` (`ReferenceDropdown`) | `POST /auth/register` university arm: `universityId`/`facultyId`/`studyYearId`/`governorateId`/`cityId`/`cityName` (`university_registration.dart:52-61`, all required) | Memory only | No | n/a | No | No — immutable in-app | Other User Data | Personal info |
| 8 | Avatar choice (`avatarId`) | `edit_profile_screen.dart:205` (`avatarId: _pickedAvatarId`) via `avatar_sheets.dart` picker over `GET /reference/avatars` — registration does **not** collect one (server default, `school_registration.dart:35-37`) | `PATCH /me` (`profile_update.dart:120`, optional) | Memory (`StudentProfile.avatar`); the **image itself** is disk-cached, see row 17 | No (provider) / **image cache: yes**, see row 17 | n/a / **yes for the cached file** (Android No / iOS Keychain N/A — this is `cached_network_image` disk, not Keychain) | No | Yes — re-picking changes it; no "remove avatar" (custom upload is draft, unused) | User Content | Personal info / Photos |
| 9 | `deviceId` (client-generated, random 128-bit) | `device_info_provider.dart` via `Random.secure()`, generated once | `POST /auth/otp/verify` (`device.toJson()`), both registration bodies (`device: device` required), `POST /auth/refresh` (deviceId alone) — part 05 "DeviceInfo" section | `flutter_secure_storage` (Android: `EncryptedSharedPreferences`/Keystore; iOS Keychain `first_unlock_this_device`) — `secure_storage.dart:72-83` | **Yes, by design** (adr-019) | **iOS: YES** (Keychain items outlive uninstall — part 04 IOS-06, unmitigated) / **Android: NO** (Keystore-backed prefs are removed with the app's data) | No | `SecureStorage.clear()` exists (`secure_storage.dart:64`) but **has zero callers** (part 06 SEC-17) — not user-triggerable today | Device or other IDs (linked) | Device or other IDs |
| 10 | Device model + platform | `device_info_provider.dart:19-27` (`device_info_plus` `androidInfo.model` / `iosInfo.model`; `platform` from `dart:io`) | Same three call sites as row 9 (bundled inside `DeviceInfo.toJson()`) | Not persisted separately — read fresh from OS each call | n/a | n/a | No (device_info_plus makes no network call itself — verified: no `http/https` literals in its Dart or native source beyond doc comments) | n/a | Device or other IDs (linked) | Device or other IDs |
| 11 | Access / refresh tokens | Issued by server on OTP verify / register / refresh | Sent as `Authorization: Bearer` header only (`auth_interceptor.dart:58`) — never in a URL or query string | `flutter_secure_storage` — `secure_storage.dart:46-47` | **Yes** — cleared by `clearTokens()` (`auth_controller.dart:69,82`) | **iOS: YES** (Keychain, same IOS-06 caveat) / **Android: NO** | No | Cleared on logout; no server-side "revoke all devices" UI, but `POST /auth/logout` revokes the chain (part 05 API-15) | Not user data per se (excluded from Apple's data-type list — auth tokens) | — (not a Data safety category; excluded as auth data) |
| 12 | Theme mode + locale | Settings screen | Not sent to any endpoint — pure client preference | `shared_preferences` — `preferences_store.dart:35-36,57-61,80-81` | No, by design (deliberately non-PII, survives logout) | Android: NO / iOS: NO (SharedPreferences/NSUserDefaults are app-sandboxed and removed on uninstall — not Keychain) | No | n/a (not personal data) | Not collected | Not collected |
| 13 | Image cache — avatar images | `board_avatar.dart`, `profile_header_card.dart:207`, `home_header.dart:171` via `CachedNetworkImage` | Fetch-only: `GET` on `avatar.url` (from `StudentProfile`/`/reference/avatars`) | `flutter_cache_manager` → sqflite metadata DB (`eTag`, `url`, `relativePath`, `validTill`, `touched`, `length` — `cache_object.dart:8-15`) under `getApplicationSupportDirectory()`, files under `getTemporaryDirectory()` (`file_system_io.dart:14`); default `stalePeriod` **30 days** (`cache_manager.dart:226,262`, `config.dart`) | **No — bug** (part 06 SEC-08: `invalidateSessionScope` exempts storage; no `emptyCache()` call anywhere in `lib/`) | Android: NO (app-sandboxed cache dir) / iOS: NO (Caches/Application Support are wiped on uninstall — unlike Keychain) | No | No in-app "clear cache" control | Photos (User Content, cached) | Photos and videos (or "User content") |
| 14 | Image cache — question images | `mcq_renderer.dart:90` via `CachedNetworkImage` | Fetch-only, image URL from quiz/question payload | Same store as row 13 — **this is new/notable**: question content, not just avatars, is written to unencrypted app-sandbox disk (part 06 SEC-08 calls this out as contradicting "questions never touch disk") | No (same bug as row 13) | Android: NO / iOS: NO | No | No | User Content | App activity / Photos (ambiguous — question content is arguably App activity, not Photos; flag for the Play form) |
| 15 | Quiz answers / self-grades / scores / points / level / badges | Quiz + Flashcards screens | `POST /quizzes` (create), `.../answers` (submit), `.../finish` — `quiz_repository.dart:52,93,117`; `GET .../explanation` — `:151`; `PUT /me/flashcard-progress`-style self-grade — `flashcards_repository.dart:109`; points/level/badges arrive embedded in `StudentProfile` from `GET /me` | Memory only (`meProvider`, quiz bloc state) — no local quiz-history DB (`listQuizHistory` is a draft op the app doesn't call, part 05) | No | n/a | No | Unknown — no per-item deletion; only whole-account deletion (`requestAccountDeletion`, contract-defined, **app does not call it**, part 05 API-01) would remove this | App activity (not linked per Apple's examples, since it's gameplay not identifiable-by-itself — but combined with `studentId` it is linkable) | App activity: App interactions / Other actions |
| 16 | Leaderboard visibility (`leaderboardVisible`) + `scoreHidden` | `settings_screen.dart:300,306-312` (two switches) | `PATCH /me` (`profile_update.dart:121-122`) | Server-side only; local echo via `meProvider` | No | n/a | **Yes — to other students** by design when `leaderboardVisible=true` (peer's `studentId`, `name`, `avatarUrl`, `points` are shown, part 05 API-10) | Yes — the toggles themselves ARE the deletion/opt-out control | User Content / App activity | App activity |
| 17 | Referral code | `signup_identity_screen.dart:183-187` (`FieldLabel(l10n.referralCodeOptional)`, `_referralController`) — collected into `RegistrationDraft.referralCode` (`registration_draft.dart:41`) | **Confirmed never sent** — absent from `SchoolRegistration.toJson()` and `UniversityRegistration.toJson()` (grep: `referralCode` appears nowhere in either `@freezed` field list, only in doc comments at `school_registration.dart:96`, `university_registration.dart:78`, and `registration_controller.dart:38`; no contract field exists — DESIGN_ISSUES #7) | Held only in the wizard draft (in-memory Riverpod state), discarded once the wizard advances/completes | No | n/a | No | n/a (never transmitted) | Not collected | Not collected |
| 18 | IP address (implicit) | Every HTTPS request, at the TCP/TLS layer — not read or sent explicitly by app code | Implicit to Railway/whatever reverse proxy fronts staging; contract's rate-limiting is documented as "per-identifier/device/**IP**" (`openapi.yaml:169`, part 05 API-13) | Not stored by the app | n/a | n/a | Unknown — server logs/backups retention is an open question to Seif (part 05 UNKNOWN Q5) | Unknown | Not disclosed by the app itself (server-side concern) | Approximate/precise location is NOT collected from IP by the app; still worth a line on the Play form for "IP address" if the backend uses it for abuse detection — ask backend |
| 19 | FCM / push token | — | **None.** `registerFcmToken` (`PUT /me/fcm-token`) is stable in the contract but the app calls it nowhere; no Firebase dependency in `pubspec.lock` (part 05 API-07, part 02 Maven graph: "No Firebase, no Google Play services") | n/a | n/a | n/a | No | n/a | Not collected | Not collected |
| 20 | Email/phone hint placeholders (`you@example.com`, `01021871999`) | ARB strings, `login_screen.dart` phone hint, edit-profile email hint | **Not data** — these are static placeholder/hint strings shown in empty fields, never round-tripped to the server. Confirmed: `01021871999` is a hard-coded ARB hint (part 02 string-scan finding, "real-looking number ships" — a **display/copy** issue, FE-18, not a privacy-collection issue) | n/a | n/a | n/a | No | n/a | Not collected | Not collected |

### Mismatches vs `docs/STORE_READINESS.md` §5

`docs/STORE_READINESS.md` §5 is dated relative to HEAD bf967d6 (its own audit trail does not carry a
date stamp in the file; compared against the 2026-09-21 parts 03/05/06 and today's grep).

| STORE_READINESS.md §5 row | Status | Note |
|---|---|---|
| "No third-party SDK receives anything." | **STILL TRUE** | Confirmed again: zero network literals in any plugin's own source (row 10 above); no Firebase/analytics in the Maven graph (part 02). |
| "Nothing is logged client-side (zero logging in lib/)." | **STILL TRUE** | Reconfirmed by part 06 §2 grep. |
| Phone number (student) row — "Stored on device: in-memory only" | **STILL TRUE** | No standalone phone field in secure storage or shared_preferences; only embedded in server-issued tokens/profile, both memory-scoped. |
| Parent/guardian phone — "not even readable back (GET /me omits it — S20)" | **STILL TRUE** | Reconfirmed part 05 API-09. |
| Device ID row — "survives logout by design; cleared only by unused `clear()`" | **STILL TRUE, ADDS DETAIL** | This audit adds the **iOS-uninstall-survival** dimension the old table's "Leaves device" column didn't carry: iOS Keychain survives uninstall (IOS-06, unmitigated), Android does not. The old table only tracked logout, not uninstall — **the table's column set itself was incomplete**, which is why this audit's brief asked for a dedicated "survives uninstall" column. |
| Avatar images + question images row — "cached_network_image disk cache — SURVIVES LOGOUT... ❌ not cleared" | **STILL TRUE** | Reconfirmed live at HEAD: no `emptyCache()`/`CacheManager` call exists in `lib/` (fresh grep, this session). Cache default `stalePeriod` (30 days) and storage location added as new detail (row 13/14 above) — the old table didn't specify the duration or exact directory. |
| Quiz answers / scores / leaderboard rank — "Deletion behavior: UNKNOWN" | **STILL TRUE, PARTIALLY RESOLVED ELSEWHERE** | Part 05 (2026-09-21) found the contract DOES now define `POST /me/deletion-request` (whole-account, 30-day grace) — the old table's blanket "no deletion endpoint" premise (its §5 preamble doesn't say this explicitly, but §6 does per part 05's summary) is **CHANGED**: a deletion mechanism exists in the contract; the app still does not call it (API-01, sev A). No **per-item** (single quiz result) deletion exists either way. |
| Privacy toggles row — "✅ user-controllable" | **STILL TRUE** | Reconfirmed at `settings_screen.dart:300-312`. |
| "Not collected anywhere: location, contacts, photos (upload disabled), microphone, biometrics, advertising ID, clipboard, SMS-read" | **STILL TRUE** | Reconfirmed: no `Clipboard`, `share_plus`, camera/location permissions anywhere (part 06 §2); avatar upload (`PUT /me/avatar`) remains draft and uncalled (part 05 census). |
| Referral code | **NOT IN THE OLD TABLE AT ALL — NEW ROW** | This audit's grep is the first documented confirmation that `referralCode` is collected on-screen but never serialized into either registration body. Recorded in memory (`purchase-silent-and-stale-parent-briefs.md` mentions it only in passing re: zna.md) but not previously tabulated with file:line proof. |
| No row for "email/phone hint placeholders" | **NEW ROW, by this audit's own request** | Added to close out the task's checklist item; not a privacy item, included for completeness. |

---

## TASK 2 — Dependency / SDK inventory

`flutter pub deps --style=compact --no-dev` ran successfully (read-only; no code generation, no build).
173 total lock entries; 21 direct-main, the rest transitive. Full pinned-version list captured from
`pubspec.lock` (`source: hosted` only — no `git:`/`path:` deps, confirming part 06 SEC-12).

### Packages with native code (Android/iOS folders in the pinned pub-cache version, or FFI)

| Package | Pinned ver | Native capability | Permissions (cite) | Privacy manifest (cite) | Bundles `.so`? (cite) | Own network calls? | Device IDs read? | Analytics/telemetry | Licence | Store-policy implication |
|---|---|---|---|---|---|---|---|---|---|---|
| connectivity_plus | 7.3.0 | Android: `ConnectivityManager` BroadcastReceiver; iOS: `NWPathMonitor` | `ACCESS_NETWORK_STATE` only (part 03 §3) | `PrivacyInfo.xcprivacy`, AccessedAPITypes `[]` (part 04 §4) | No | **No** (verified: only a GitHub-issue doc-comment URL, no runtime HTTP) | No | None | BSD-3 (Chromium-style header) | Clean; standard connectivity check |
| device_info_plus | 13.2.0 | Android (Kotlin, `Build.*` fields only — grep for `ANDROID_ID`/`Settings.Secure`/`Build.SERIAL`/`getDeviceId` → **0 hits**); iOS (`identifierForVendor` read but unused by app, part 04 IOS-03) | none | **Gap**: iOS manifest declares **no** `NSPrivacyAccessedAPITypes` despite reading `NSFileSystemFreeSize`/`NSFileSystemSize` (part 04 IOS-03, undeclared required-reason API — likely Apple submission blocker) | No | No (verified: doc-comment/StackOverflow-link false positives only) | Reads `identifierForVendor` on iOS (unused) and `Build.MODEL` on Android; app itself only consumes `.model` (part 03 §2, part 06 §2) | None | BSD-3 | **IOS-03 stands** — see DEP-06 below |
| flutter_secure_storage (+ `_darwin`/`_linux`/`_windows`) | 10.3.1 / 0.3.2 / 3.0.1 / 4.2.2 | Android Keystore via Tink (`EncryptedSharedPreferences`, `MasterKey`); iOS/macOS Keychain | none | `PrivacyInfo.xcprivacy` on `_darwin`, AccessedAPITypes `[]` (part 04 §4) | Tink native lib bundled transitively via `com.google.crypto.tink:tink-android` + relinker (part 02 Maven graph) | No | No | None | BSD-3 | Version is **1 major behind** — see DEP-08 |
| jni / jni_flutter | 1.0.0 / 1.0.1 | Android only — the FFI bridge `path_provider_android` now rides on (`libdartjni.so`, part 03 §3) | none | n/a (not an iOS-relevant plugin) | **Yes** — `libdartjni.so`, 16 KB-page-aligned (part 02/03) | No | No | None | BSD-3 | None |
| screen_protector | 1.5.3 | Android `FLAG_SECURE` toggle; iOS `ScreenProtectorKit` wrapper (source not in pub cache — part 04 IOS-15) | none | **None shipped** — no `PrivacyInfo.xcprivacy` in the plugin; depends on ScreenProtectorKit 1.5.1 whose manifest status is unknown (part 04 §4) | No | No (doc-comment link only) | No | None | Apache-2.0 | No NOTICE file bundled; Apache-2.0 doesn't need one beyond LICENSE text — LicenseRegistry covers it IF the app ever shows a licence page (it doesn't — see DEP-11) |
| shared_preferences (+ `_android`/`_foundation`) | 2.5.5 / 2.4.27 / 2.5.6 | Android DataStore; iOS/macOS `NSUserDefaults` | none | `PrivacyInfo.xcprivacy` on `_foundation`, `UserDefaults` API type declared `[1C8F.1]` (part 04 §4 — correctly declared, unlike device_info_plus) | `libdatastore_shared_counter.so` via androidx.datastore (part 02) | No | No | None | BSD-3 | None — this is the one plugin whose manifest is fully correct |
| sqflite (+ `_android`/`_darwin`) | 2.4.3 / 2.4.3 / 2.4.3+1 | Platform SQLite — used transitively by `flutter_cache_manager` for the image-cache metadata DB (row 13/14 above), NOT used directly by app code (part 06 §3: "no direct... sqflite in lib/") | none | `PrivacyInfo.xcprivacy` on `_darwin`, `[]` (part 04 §4) | Platform SQLite (no extra `.so`) | No | No | None | BSD-2 | None |
| path_provider (+ `_android`/`_foundation`/`_linux`/`_windows`) | 2.1.6 / 2.3.1 / 2.6.0 / … | **No native folder at these pinned versions** — `_android` rides Dart-over-jni (part 03 §3), `_foundation` is Dart-FFI via `objective_c`/`ffi` (part 04 §4) | none | n/a — FFI has no bundle to carry a manifest; Apple still lists `path_provider` on its named-SDK list regardless (part 04 §4 caveat) | No dedicated `.so` (rides `libdartjni.so` on Android) | No | No | None | BSD-3 | None |
| url_launcher (+ `_android`/`_ios`) | 6.3.2 / 6.3.32 / 6.4.1 | Android `WebViewActivity` (unused, `LaunchMode.externalApplication` only — part 03 §3); iOS `SFSafariViewController`/`UIApplication.open` | none (no `<queries>` needed, `canLaunchUrl` never called — part 03 §2) | `PrivacyInfo.xcprivacy`, `[]` (part 04 §4) | No | No | No | None | BSD-3 | None — confirmed dead-but-shipped WebView Activity is harmless (part 02) |

### Pure-Dart packages (no native capability) — confirmed, no further action

`dio` 5.10.0, `go_router` 17.3.0, `flutter_riverpod`/`riverpod` 3.3.2, `flutter_bloc`/`bloc` 9.1.1/9.2.1,
`freezed_annotation` 3.1.0, `json_annotation` 4.12.0, `intl` 0.20.2, `uuid` 4.6.0, `cached_network_image`
(+ `_platform_interface`/`_web`) 3.4.1, `flutter_cache_manager` 3.4.2, `octo_image` 2.1.0, `rxdart` 0.28.0,
`provider` 6.1.5+1, `flutter_svg` 2.3.0, `vector_graphics*`, `country_flags` 4.1.2, `pinput` 6.0.2,
`jovial_svg` 1.1.29. All verified to have no `android/ios/darwin/macos/windows/linux` folder at their pinned
version and no `dart:ffi` import (except where already covered above via a native platform-interface
dependency). Licences: MIT (dio, flutter_bloc/bloc, riverpod/flutter_riverpod, freezed_annotation,
cached_network_image, flutter_cache_manager, octo_image, provider, pinput, country_flags), BSD-3 (go_router,
intl, path*, shared_preferences*, url_launcher*, vector_graphics*, jovial_svg, uuid — Chromium/Flutter/Dart-
authors style header), Apache-2.0 (rxdart, screen_protector). None require an in-app NOTICE beyond the
bundled LICENSE text (checked: no `NOTICE` file ships in any of `screen_protector`/`rxdart`/`connectivity_plus`/
`device_info_plus`).

### `win32`, `win32_registry`, `ffi` — desktop-only, not shipped on mobile

Pulled transitively (`flutter_secure_storage_windows`, `path_provider_windows`) for desktop-target support;
irrelevant to the Android/iOS store submissions this audit covers. No `.so`/native folder at the pinned
version for `win32`/`win32_registry` themselves (pure Dart FFI bindings to Windows DLLs already on the OS).

### DEP findings

- **DEP-01** — No package shows its own outbound network call (`http://`/`https://` literal, `Uri.parse`
  against a remote host, or a bundled HTTP client) outside doc comments/license headers. Checked every
  native-capable plugin's `lib/` + `android/`/`ios/`/`darwin/` tree. **PASS.**
- **DEP-02** — No package reads a hardware device identifier that the app itself consumes. `device_info_plus`
  reads `identifierForVendor` (iOS) internally but the app only takes `.model` (part 03/04/06, reconfirmed).
  Android side: zero `ANDROID_ID`/`Settings.Secure`/`Build.SERIAL`/`getDeviceId` references in
  `device_info_plus`'s Android Kotlin source. **PASS**, with the caveat that the plugin *could* expose more
  than the app uses — not a store-policy issue, just a note for future maintainers.
- **DEP-03** — No analytics/telemetry SDK anywhere in the dependency graph (reconfirmed against part 02's
  Maven-graph finding of "No Firebase, no Google Play services, no ads, no analytics, no Play Billing").
- **DEP-04** — `dio` 5.10.0 sets **no default `User-Agent` override**: `dio.dart:24`'s
  `HttpHeaders.userAgentHeader: 'dio'` line is a *documentation example* of how a caller could set one, not
  default behaviour, and the app's own `dio_client.dart:19` only sets `Content-Type: application/json`. On
  the IO adapter (`io_adapter.dart:257-261`) dio hands requests to a bare `dart:io HttpClient()`, so the
  wire-level `User-Agent` is whatever the Dart VM's default is (`Dart/<version> (dart:io)`), which reveals a
  Dart runtime but nothing about the device or account. Not a privacy leak; informational only.
- **DEP-05** — `cached_network_image` → `flutter_cache_manager` (3.4.2) default config: cache dir
  `getApplicationSupportDirectory()` for the sqflite metadata DB (`cache_object_provider.dart:217`) and
  `getTemporaryDirectory()` for the actual files (`file_system_io.dart:14`); default `stalePeriod`
  **30 days** (`cache_manager.dart:226,262`); each `CacheObject` row stores `url`, `key`, `relativePath`,
  `eTag`, `validTill`, `touched`, `length` (`cache_object.dart:8-15`) — **the eTag response header is
  persisted, but full response headers are not**. This directly substantiates row 13/14 of the privacy map
  and part 06 SEC-08 (neither prior part had the retention window or exact fields).
- **DEP-06** — `device_info_plus` is **already pinned at 13.2.0, the latest published version** (WEB,
  fetched today) and its changelog through 13.2.0 **still contains no mention** of `PrivacyInfo.xcprivacy`,
  `DiskSpace`, `NSFileSystemFreeSize`/`NSFileSystemSize`, or required-reason code `E174.1` — i.e. **there is
  no upstream fix to pick up**. Part 04's IOS-03 (undeclared required-reason API use) is not a version-lag
  problem; it is a live upstream gap the app must work around (drop the plugin on iOS, or add an app-level
  manifest — see IOS-03's own remediation options). Upgrading will not fix it.
- **DEP-07** — `intl` is pinned at 0.20.2; latest on pub.dev is **0.20.3** (WEB, published ~2 months ago) —
  one patch behind, not discontinued/unlisted.
- **DEP-08** — `flutter_secure_storage` is pinned at 10.3.1; latest on pub.dev is **11.2.0**, published
  **5 days ago** (WEB) — **one major version behind**. Not discontinued/unlisted. Given this plugin holds
  the auth tokens and `deviceId` (rows 9/11 of the privacy map), a version audit before submission is
  worth doing, though nothing in this session's source read of 10.3.1 shows a defect.
- **DEP-09** — `screen_protector` (1.5.3), `pinput` (6.0.2), `country_flags` (4.1.2) are each **already
  pinned at the latest published pub.dev version** (WEB, fetched today); none are flagged discontinued or
  unlisted. Part 06 SEC-12's "abandoned-status... UNVERIFIED" is now **RESOLVED: not abandoned**, though
  publish cadence for `screen_protector` (~2 months) and `country_flags`/`pinput` (~7 months) is slow-but-
  not-stale.
- **DEP-10** — No package outside the two already-documented `.so`-bundling cases (`jni`/`libdartjni.so`,
  `shared_preferences_android`/`libdatastore_shared_counter.so` via androidx.datastore, both reconfirmed
  from part 02) ships a native binary; every other native-capable plugin above is source-compiled at build
  time (Kotlin/Swift/ObjC) with no separate `.so` artifact of its own.
- **DEP-11 (new finding, not in parts 01-06)** — `git grep -n "LicensePage\|showLicensePage\|LicenseRegistry" lib/`
  returns **zero hits**. The app never surfaces a licences screen at all — not merely missing the fonts'
  OFL text (part 06 SEC-13), but missing the *entire* open-source attribution surface that
  `flutter pub` licence data (and the `NOTICES.Z` file already embedded in the AAB, part 02) exists to
  drive. `MaterialApp`/`CupertinoApp`'s automatic "About" licences page is opt-out by default in Flutter,
  so this is either (a) deliberately suppressed somewhere, or (b) there is no About/Settings entry point to
  it at all. Neither Apple nor Google requires a licences page, but MIT/BSD/Apache-2.0 attribution is a
  standard app-store courtesy and several of these licences (MIT, Apache-2.0) technically require the
  copyright/permission notice to be preserved in copies/substantial portions of the software — bundling the
  LICENSE text via `LicenseRegistry` (which Flutter does automatically from `pubspec.lock` + each package's
  `LICENSE` file, no extra work needed) is the standard way to satisfy that without a manual per-package
  audit. Recommend surfacing `showLicensePage`/`PackageInfo` somewhere in Settings.

---

## TASK 3 — Font licences (VERIFIED via `fontTools`, not UNVERIFIED as parts 06/SEC-13 left it)

`python3 -c "import fontTools; print(fontTools.__version__)"` → **4.61.1**, present on this machine.
Read nameID 13 (License Description) and nameID 14 (License URL) from the `name` table of every bundled
`.ttf` in `assets/fonts/` (10 files, 3 families):

| Family | Files checked | nameID 13 (License Description) | nameID 14 (License URL) |
|---|---|---|---|
| **Inter** | `Inter_18pt-{Bold,Medium,Regular,SemiBold}.ttf` (4) | "This Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: https://openfontlicense.org" | `https://openfontlicense.org` |
| **Cairo** | `Cairo-{Bold,Regular,SemiBold}.ttf` (3) | "This Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: http://scripts.sil.org/OFL" | `http://scripts.sil.org/OFL` |
| **Tajawal** | `Tajawal-{Bold,Medium,Regular}.ttf` (3) | Same OFL 1.1 text as Cairo, same URL | `http://scripts.sil.org/OFL` |

**Result: all 10 files embed the OFL 1.1 licence text in their own name table.** This resolves part 06
SEC-13's "Whether the TTFs carry the licence in the name table: UNVERIFIED" — it is **VERIFIED TRUE**. The
app is not exposed by the *absence* of a tracked `OFL.txt` (SEC-13's original remediation, "add OFL.txt per
family", remains good practice for repo hygiene/attribution completeness, but the fonts are legally
self-describing even without it). Note Inter uses the newer `openfontlicense.org` canonical URL while
Cairo/Tajawal still point at the legacy `scripts.sil.org/OFL` mirror — both are the same OFL 1.1 text,
just different official URLs from different font-release vintages; not a discrepancy worth fixing.

---

## Could not determine / out of scope for this pass

- Production base URL's data flows (prod host is still `TBD.example` — nothing to probe).
- Server-side retention/backup/subprocessor facts (open questions to Seif, part 05 UNKNOWN Q3–Q7, restated
  not re-litigated here).
- Whether `ScreenProtectorKit` (iOS native dependency of `screen_protector`, source not in pub cache) makes
  any network call or reads any identifier — its source was not resolvable from this Windows machine (same
  gap part 04 IOS-15 already flagged).
- Exact publish dates for `screen_protector`/`pinput`/`country_flags` relative to their pinned versions
  (WEB tool returned relative "N months ago" phrasing, not absolute dates).
