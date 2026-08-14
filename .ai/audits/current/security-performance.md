# Agent 9 — Security & Performance

**Scope:** Secrets & git history · token handling & PII in generated code · logging ·
storage · transport · platform hardening · release config · startup cost · expensive
builds · image decode · list/network waste · retained memory.

**Baseline:** dev @ e3651e6

**Repository areas inspected:**
- `android/` (all 3 manifests, `app/build.gradle.kts`, `build.gradle.kts`,
  `gradle.properties`, `res/xml/data_extraction_rules.xml`, `.gitignore`,
  `key.properties.example`), `ios/Runner/Info.plist`, `ios/.gitignore`
- `.gitignore`, `pubspec.yaml`, `pubspec.lock`, `.flutter-plugins-dependencies`
- `docs/RELEASE_SIGNING.md`, `docs/DECISIONS.md`, `docs/KNOWN_BUGS.md`
- Vault rules: `01_Flutter_Specs/{Storage_and_Security,Performance,Platform_Specifics,Flutter_Common_Mistakes}.md`
- `lib/bootstrap.dart`, `lib/app.dart`, `lib/main*.dart`
- `lib/core/{storage,network,network/interceptors,config,providers,router,widgets}/`
- `lib/features/auth/{models,notifier,repository,screens}/`,
  `lib/features/profile/{models,notifier,screens,widgets}/`,
  `lib/features/catalog/{notifier,screens}/`,
  `lib/features/registration/{models,notifier,screens,widgets}/`,
  `lib/features/quiz/{bloc,screens,widgets}/`, `lib/features/{home,shell}/`
- All 18 `*.freezed.dart` files (generated `toString`)
- Full git history: 46 commits, 677 blobs, `git log -p --all` (82,296 patch lines) scanned

---

# PART A — SECURITY

## Summary of what is already right (do not re-litigate)

Verified, not assumed:

- **Zero hardcoded secrets anywhere.** No API key, token, password, private key,
  keystore path or credential in `lib/`, `android/`, `ios/`, `pubspec.yaml` or any
  tracked config. The only tracked signing artefact is `android/key.properties.example`
  with `CHANGE_ME` placeholders (`android/key.properties.example:14,20`).
- **Git history is clean.** All 46 commits' patches scanned for `AIza…`, `sk_live/test`,
  `pk_live/test`, `AKIA…`, `ghp_…`, `xox[baprs]-…`, `eyJhbGciOi…` (JWT), PEM
  `-----BEGIN … PRIVATE KEY-----`, and non-placeholder `storePassword=`/`keyPassword=`.
  **Zero hits.** `git log --all --diff-filter=A --name-only` shows `key.properties`,
  `*.jks`, `*.keystore`, `*.pem`, `*.p12`, `.env`, `local.properties`,
  `google-services.json` were **never** added in any commit. The only secret-shaped
  literals in history are test fixtures (`'access.jwt'`, `'refresh.jwt'`).
- `.gitignore` correctly delegates signing patterns to `android/.gitignore:12-14`
  (`key.properties`, `**/*.keystore`, `**/*.jks`) with an explanatory pointer at
  `.gitignore:38-39` rather than duplicating them.
- **Release signing fails closed.** `android/app/build.gradle.kts:52-70` uses
  `signingConfigs.findByName("release")` — null when `key.properties` is absent, so the
  release build is left *unsigned*, never debug-signed. **The debug-keystore fallback
  the brief asked about does not exist**: the string `"debug"` appears nowhere in
  `signingConfigs` or `buildTypes`, only in the warning comments at `:12-26` and
  `:63-66` that explain why it was removed. This is correct and well documented.
- **Zero `print`/`debugPrint`/`developer.log`/`LogInterceptor` in `lib/`.** Confirmed by
  exhaustive grep. Dio is constructed with exactly two interceptors
  (`lib/core/network/dio_client.dart:40`) — `AuthInterceptor` then `ErrorInterceptor`.
  No request/response logging exists at any flavor.
- **`AppException.toString()` prints only the code** (`lib/core/network/exceptions.dart:15`)
  — never `detail`, never a body. Error copy is chosen by stable `code` alone
  (`lib/features/registration/registration_error_copy.dart:14-52`); server
  `title`/`detail`/`errors` message strings are documented as never rendered and the
  code honours that (only `errors.keys` crosses into UI, `exceptions.dart:62`).
- **Transport is HTTPS-only.** The single `http://` in the repo is
  `lib/dev/mock_backend.dart:47` (`http://mock.local/api/v1`) — a `DioAdapter` base URL
  that never opens a socket. No `usesCleartextTraffic`, no `networkSecurityConfig`,
  no `NSAppTransportSecurity`/`NSAllowsArbitraryLoads` anywhere.
- **Backup claims hold.** `android/app/src/main/AndroidManifest.xml:6-10` sets
  `allowBackup=false`, `fullBackupContent=false`, `dataExtractionRules=@xml/…`;
  `android/app/src/main/res/xml/data_extraction_rules.xml:17-31` excludes `root`,
  `file`, `database`, `sharedpref`, `external` from **both** `cloud-backup` and
  `device-transfer`. Correct and complete for API 31+.
- **Exactly one exported component** — `.MainActivity` with the LAUNCHER filter
  (`AndroidManifest.xml:12-14`). No exported receivers, services or providers.
- **`shared_preferences` holds nothing sensitive.** Two keys only:
  `pref.theme_mode` and `pref.locale` (`lib/core/storage/preferences_store.dart:35-36`).
  No PII, no auth material. Matches `Storage_and_Security.md` exactly.
- **`hive_ce`/`hive_ce_flutter` are declared in `pubspec.yaml:46-47` but never imported
  in `lib/`.** Zero `Hive`/`Box<` usage. Nothing is persisted unencrypted. (Deliberate:
  `quiz_state.dart:20` and `quiz_screen.dart:32` both state questions are never cached.)
- **`flutter_secure_storage` iOS options are deliberate and correct** —
  `first_unlock_this_device` + `synchronizable: false`
  (`lib/core/storage/secure_storage.dart:32-35`), with a written rationale tying the
  `_this_device` suffix to adr-019 device binding. The comment at `:27-31` explains the
  Android side: `encryptedSharedPreferences` is **deprecated in FSS 10.x** (10.3.1 is
  locked in `pubspec.lock`) and setting it opts *back into* the retired Jetpack Security
  path. **The brief's expectation is inverted for this version — not setting it is
  correct here.** No finding.
- **`device_info_plus` collects the minimum**: `model` only, plus `Platform.isIOS`
  (`lib/features/auth/repository/device_info_provider.dart:19-25`). Sent only to
  `POST /auth/otp/verify` for adr-019 device binding. No advertising ID, no serial,
  no IMEI.
- **`lib/dev/mock_backend.dart` is unreachable from any shipping flavor.** Its only
  `lib/` importer is `lib/main_mock.dart:30`, which no shipping entrypoint references —
  `main_dev`/`main_staging`/`main_prod` all call `bootstrap()` only. Dart tree-shaking
  removes all 1,527 lines from every shipped binary.
- `url_launcher` is called once, on three `static const` HTTPS literals
  (`lib/features/auth/screens/login_screen.dart:40-42,111-113`). No user-controlled URL
  reaches `launchUrl`.

## Findings

### F-9-01 [HIGH] [BUG] Release builds have no `INTERNET` permission — every network call will fail
**Evidence:** `android/app/src/main/AndroidManifest.xml` — the file contains **no**
`<uses-permission android:name="android.permission.INTERNET"/>`. It appears only in
`android/app/src/debug/AndroidManifest.xml:6` and
`android/app/src/profile/AndroidManifest.xml:6`, which do **not** merge into a release
build. This is the stock Flutter template, which grants INTERNET to debug/profile solely
for the VM service, and documents that an app needing network must declare it in `main`.
No dependency supplies it either: `connectivity_plus` declares `ACCESS_NETWORK_STATE`,
`device_info_plus`/`url_launcher_android`/`shared_preferences_android`/
`flutter_secure_storage` declare no network permission, and `cached_network_image`/
`dio` are pure Dart.
**Why it matters:** A release APK would fail every single request with
`SocketException: … errno = 13 (Permission denied)` at DNS resolution. Login, OTP, the
whole catalog — nothing works. The failure is completely invisible during development
because debug and profile builds *do* get the permission. This is a first-release
show-stopper hiding behind a build-type difference. It also compounds F-9-02: an
unsigned release build never gets installed, so nobody has yet run a release build to
discover this.
**Recommended fix:** Add `<uses-permission android:name="android.permission.INTERNET"/>`
to `android/app/src/main/AndroidManifest.xml` above `<application>`.
**Risk of fixing:** None. It is the minimum network permission and is already granted in
two of three build types.
**Validation required:** **Yes — toolchain.** `flutter build apk --release` then
`aapt dump permissions build/app/outputs/flutter-apk/app-release.apk`, or inspect
`build/app/intermediates/merged_manifests/release/AndroidManifest.xml`. This finding is
derived from reading the three manifests plus the dependency set; a merged-manifest dump
is the definitive check and must be run before release.

### F-9-02 [HIGH] [BUG] Every freezed model prints its secrets and PII in full via generated `toString()`
**Evidence:** freezed generates a `toString` that interpolates every field. Confirmed by
reading the generated files:
- `lib/features/auth/models/token_pair.freezed.dart:40` (and `:245` for the copy-with
  impl) — `'TokenPair(accessToken: $accessToken, … refreshToken: $refreshToken, …)'`.
  **Both bearer tokens, in full.**
- `lib/features/auth/models/auth_result.freezed.dart:242` —
  `'AuthResult.authenticated(tokens: $tokens, profile: $profile)'`, which recurses into
  both of the above.
- `lib/features/auth/models/auth_result.freezed.dart:326` —
  `'AuthResult.registrationRequired(registrationToken: $registrationToken, …)'`.
- `lib/features/profile/models/student_profile.freezed.dart:48` (and `:353`) —
  `'StudentProfile(id: …, name: $name, phone: $phone, email: $email,
  dateOfBirth: $dateOfBirth, … school: $school, … geography: $geography, …)'`. **A
  minor's full name, phone number, date of birth, school and governorate.**
- `lib/features/profile/models/student_profile.freezed.dart:763` —
  `'ProfileGeography(countryCode:, governorate:, city:)'`;
  `:1415` — `'ProfileSchool(school:, stage:, educationSystem:)'`.
- `lib/features/registration/models/registration_draft.freezed.dart` — the same for
  `registrationToken`, `phone`, `parentPhone`, `dateOfBirth`, `schoolId`
  (source fields at `registration_draft.dart:37-40,48`).
- `lib/features/auth/models/device_info.freezed.dart:40` — `deviceId` (the adr-019
  binding key).

`Storage_and_Security.md:22` states the rule unconditionally: *"Never log tokens,
credentials, personal data … including debug builds (logs leak via crash reports,
recordings, shared devices)."* `Flutter_Common_Mistakes.md:16` repeats it. This is a
**divergence from a written project rule.**
**Why it matters:** Today the leak is *latent but one line from live*, and the mitigating
factor is itself a gap: the app installs **no** `FlutterError.onError`, no
`runZonedGuarded`, no `PlatformDispatcher.onError`, no `ProviderObserver`, no
`BlocObserver` and no crash-reporting SDK (verified — zero matches in `lib/`). So
nothing currently *calls* these `toString()`s. But (a) Flutter's default
`FlutterError.onError` dumps to stderr → logcat in **release** too, so any framework
error whose diagnostics reach one of these objects prints it on a real device; (b) the
moment Crashlytics/Sentry is added — the obvious next step for a shipping app — every
captured non-fatal from the auth or profile path uploads a live access token and a
minor's DOB and phone to a third-party server; (c) a single `ref.listen` debug line or a
`ProviderObserver` added by any future contributor turns it on instantly. For an app
holding minors' PII in Egypt this is the highest-consequence latent defect in the
codebase.
**Recommended fix:** Override `toString()` on the sensitive classes. freezed respects a
hand-written `toString` in the mixin-target class when the class has a private
constructor (`const TokenPair._();`), e.g.
`@override String toString() => 'TokenPair(access: <redacted>, refresh: <redacted>, accessExpiresInSeconds: $accessExpiresInSeconds)';`
Apply to `TokenPair`, `AuthResult` (both arms), `StudentProfile`, `RegistrationDraft`,
`DeviceInfo`, `ProfileGeography`, `ProfileSchool`. Add a `test/` guard asserting
`profile.toString()` does not contain the phone/DOB fixture values — cheap, and it
survives regeneration. Then, when crash reporting is introduced, install it *after* this
is done, not before.
**Risk of fixing:** Low. `toString` is not used for equality, serialization or the UI
anywhere in `lib/`. Existing tests that print a model in a failure message become less
informative — an acceptable trade.
**Validation required:** Re-run `build_runner` and the suite after adding the private
constructors; freezed's handling of a user-supplied `toString` should be confirmed by
inspecting the regenerated `.freezed.dart`.

### F-9-03 [HIGH] [BUG] A previous student's profile survives logout in memory and is shown to the next student
**Evidence:** `lib/features/auth/notifier/auth_controller.dart:56-59` (`forceLogout`) and
`:63-71` (`logout`) clear the tokens and flip `AuthStatus` — and **invalidate nothing
else**. Every provider holding session data is deliberately non-`autoDispose`:
`meProvider` (`lib/features/profile/notifier/me_notifier.dart:39`, holding the full
`StudentProfile`), `entitlementsProvider` (`:73`), `subjectsProvider`
(`lib/features/catalog/notifier/subjects_notifier.dart:31`), `subjectTreeProvider`
family (`lib/features/catalog/notifier/subject_tree_notifier.dart:47`),
`registrationControllerProvider`
(`lib/features/registration/notifier/registration_controller.dart:194`). The only
`ref.invalidate` calls in `lib/` are `meProvider` after an edit
(`edit_profile_notifier.dart:57`) and after a quiz (`quiz_screen.dart:213`) — never on
logout (verified by exhaustive grep for `invalidate`).
**Why it matters:** Two distinct harms. (1) **Cross-account PII display.**
`session_superseded` (adr-019, another device signed in) triggers `forceLogout` → router
redirects to `/login`. A different student then completes OTP on the same handset;
`markAuthenticated()` flips the router to `/home`; `HomeScreen` at
`lib/features/home/screens/home_screen.dart:38` does `ref.watch(meProvider)`, which is
still `AsyncData(<previous student's profile>)` — so student B sees student A's name,
avatar, level and points until something invalidates. Nothing does. On shared family
handsets — explicitly the threat model in `Storage_and_Security.md:22` — this is a real
PII disclosure between minors, and it is also a correctness bug (points/level shown are
the wrong account's). (2) **Retention.** A `StudentProfile` (name, phone, DOB, school,
governorate) and every cached `SubjectTree` stay resident in the `ProviderContainer` for
the process lifetime after sign-out.
**Recommended fix:** In `AuthController`, on the transition to
`AuthUnauthenticated`, invalidate the session-scoped providers — the tidiest form is a
small `_clearSessionCaches()` called from both `forceLogout` and `logout`:
`ref.invalidate(meProvider); ref.invalidate(entitlementsProvider); ref.invalidate(subjectsProvider); ref.invalidate(subjectTreeProvider); ref.invalidate(registrationControllerProvider);`
(`ref.invalidate` on a family provider clears every key). Guard it with a widget test:
force-logout, sign in as a different fixture, assert Home shows the second name.
**Risk of fixing:** Low, but real: invalidating `meProvider` while `/home` is still
mounted during the redirect frame would briefly re-fire `GET /me` with no token. Order
matters — flip `state` to `AuthUnauthenticated` **first** (so the router has already
redirected away from `/home`), then invalidate. Add the test before the fix.
**Validation required:** Widget/integration test through the router, per above.

### F-9-04 [MEDIUM] [QUALITY IMPROVEMENT] Screenshot protection ships two of the four steps the spec mandates, and covers none of the PII screens
**Evidence:** `lib/features/quiz/screens/screen_protection.dart:34,37` calls only
`ScreenProtector.preventScreenshotOn()` / `preventScreenshotOff()`, applied in
`quiz_screen.dart:63-73` (initState/dispose — correctly unconditional on every exit
path). `Platform_Specifics.md` §"Quiz screenshot protection ✅ decided 2026-06-22"
specifies **four** things: `preventScreenshotOn()` **plus
`protectDataLeakageWithBlur()`**, `*Off()` in dispose, and
**`ScreenProtector.addListener(...)` to log screenshot/recording attempts**. Two are
missing. Separately, `screen_protection.dart:17-18` scopes protection to the quiz screens
only — deliberate and documented ("the bank is the product").
**Why it matters:** Two gaps. (a) `protectDataLeakageWithBlur()` is what blanks the
**app-switcher / recents thumbnail** on iOS; without it, iOS caches a snapshot of the
in-progress quiz. On Android `FLAG_SECURE` already covers recents, so this is
iOS-specific — but the spec named it and the client was told "secure black-out + detection".
(b) `addListener` is the "detection" half of what the spec says was promised *in writing*
to the client; nothing detects or reports a capture attempt today.
The screen-scoping decision is sound for content protection, but note the consequence:
`edit_profile_screen.dart` (name, email, DOB, avatar), `profile_screen.dart` and
`otp_screen.dart` (phone + the OTP itself) render minors' PII with no `FLAG_SECURE`, so
they appear in the Android recents thumbnail and are freely screenshot-able. That is a
**PRODUCT DECISION** to confirm, not an engineering defect — but it should be confirmed
out loud given the audience.
**Recommended fix:** Add `protectDataLeakageWithBlur()`/`…Off()` to
`PluginScreenProtection` (the seam already exists, so it stays testable). Decide
explicitly whether the OTP screen warrants protection. If capture-attempt logging is
wanted, note it must not log the OTP or any PII (F-9-02's rule).
**Risk of fixing:** Low — the abstraction at `screen_protection.dart:19-25` means only
two methods change and the existing override-based test still applies.
**Validation required:** Device check on iOS (app-switcher blur) and Android
(screenshot blocked in quiz, allowed elsewhere).

### F-9-05 [MEDIUM] [QUALITY IMPROVEMENT] R8/shrinking is off and Dart obfuscation is undocumented, against a written rule
**Evidence:** `android/app/build.gradle.kts:57-69` — the `release` build type sets only
`signingConfig`. No `isMinifyEnabled`, no `isShrinkResources`, no `proguardFiles`. No
`proguard-rules.pro` exists anywhere under `android/` (full file listing confirms). AGP's
default for a release build type is `minifyEnabled false`, so **R8 is OFF**. Nothing in
`docs/` or `.claude/` mentions `--obfuscate` or `--split-debug-info` (grep: zero hits).
`Flutter_Common_Mistakes.md:16` lists *"obfuscation at release"* as a security rule.
**Why it matters:** Dart is AOT-compiled, so R8 only touches the Java/Kotlin plugin
layer — the impact is modest and **absence of R8 alone is defensible** for a Flutter app.
The Dart side is the one that matters and it is genuinely unaddressed: without
`flutter build appbundle --release --obfuscate --split-debug-info=…`, Dart class,
method and field names ship in the clear in the AOT snapshot, so `SecureStorage`,
`AuthInterceptor`, the `_kAccess`/`_kRefresh` key names and every contract field name are
readable from the APK. There is no CI to encode the flags in, so today they depend on
whoever types the build command remembering them — which is exactly how a release ships
without them.
**Recommended fix:** (1) Record the exact release command, with `--obfuscate
--split-debug-info=build/symbols/<version>`, in `docs/RELEASE_SIGNING.md` next to the
signing steps, and note that the symbol directory must be archived per release or
crash reports become unreadable. (2) Optionally set `isMinifyEnabled = true` +
`isShrinkResources = true` with an empty `proguard-rules.pro` seeded with keep rules for
the reflective plugins (`screen_protector`, `device_info_plus`) — but only if someone
will build and smoke-test a release APK, since R8 misconfiguration surfaces as a runtime
`ClassNotFoundException`, not a build failure.
**Risk of fixing:** Documenting the flags: none. Enabling R8: medium — must be validated
on a real release build, and `--obfuscate` makes stack traces unreadable without the
retained symbol files.
**Validation required:** Yes, toolchain. Build a release bundle and smoke-test on device.

### F-9-06 [LOW] [OPTIONAL IMPROVEMENT] No certificate pinning
**Evidence:** No `badCertificateCallback`, no custom `HttpClientAdapter`, no pinning
package. `lib/core/network/dio_client.dart:15-20` uses stock `BaseOptions`.
**Why it matters:** **Absence is defensible and I am not recommending it be added.**
The base URLs are still `TBD.example` placeholders (`lib/core/config/app_config.dart:41-43`)
so there is no certificate to pin to; pinning against an unknown host is impossible.
More importantly, pinning is a liability for a two-person team with no CI and no
remote-config: a certificate rotation with a pinned build in the field bricks every
installed app until a store update propagates. Modern Android/iOS already reject
untrusted CAs, and `usesCleartextTraffic` is correctly unset.
**Recommended fix:** None now. Revisit only if a threat model appears that TLS does not
cover, and only alongside a kill-switch. Worth one line in `docs/DECISIONS.md` recording
that this was considered and declined, so the next auditor does not re-raise it.
**Risk of fixing:** N/A.
**Validation required:** None.

### F-9-07 [LOW] [OPTIONAL IMPROVEMENT] `ErrorInterceptor` re-attaches the raw `Response` to the rejected `DioException`
**Evidence:** `lib/core/network/interceptors/error_interceptor.dart:44-51` —
`handler.reject(DioException(requestOptions: …, response: err.response, type: …, error: mapped))`.
The typed `AppException` is in `error`, but the full `Response` (headers **and** body)
rides along on the same object.
**Why it matters:** Small and currently harmless — `DioException.toString()` prints
`message` and `error` only, not the response, and nothing in `lib/` reads `.response` off
a rejected error. But `err.requestOptions.headers` at that point still carries
`Authorization: Bearer <token>` (set at `auth_interceptor.dart:57`), and the response
body of a `GET /me` failure is a student's profile. If crash reporting is ever added with
a Dio integration — most of which serialize `requestOptions` and `response` by design —
this object is the vehicle. It is the same class of latent leak as F-9-02, one layer
down.
**Recommended fix:** Drop `response:` from the rejected `DioException` unless a caller
needs it (none do), or strip `Authorization` from the carried `requestOptions`. Note that
`AuthInterceptor` runs *before* `ErrorInterceptor` and legitimately needs
`err.response?.data` at `auth_interceptor.dart:158`, so only the outbound rejection needs
changing.
**Risk of fixing:** Low — one test file (`test/core/network/error_interceptor_test.dart`)
may assert on the carried response; check before changing.
**Validation required:** Run `test/core/network/error_interceptor_test.dart`.

### F-9-08 [LOW] [ARCHITECTURE ISSUE] Android product flavors are not wired, so `--flavor` cannot separate dev and prod installs
**Evidence:** `android/app/build.gradle.kts:38-50` — a single `defaultConfig` with
`applicationId = "com.levelup.level_up_app"` and no `productFlavors {}` block.
`Platform_Specifics.md` §Flavors specifies *"Bundle-ID suffix + base URL + app-name suffix
per flavor · Android `productFlavors` · iOS schemes · `flutter run --flavor dev -t
lib/main_dev.dart`"*. Only the Dart half (`lib/main_*.dart` + `AppConfig`) exists.
Separately, the template TODO at `build.gradle.kts:40` ("Specify your own unique
Application ID") is still present, and `docs/RELEASE_SIGNING.md` flags settling that value
**before** generating the production keystore.
**Why it matters:** A dev and a prod build share one `applicationId`, so they cannot
coexist on a tester's phone and a dev build can overwrite a prod install (and vice versa,
which fails on signature mismatch). Also `--flavor dev` will fail outright: Gradle has no
such flavor. Low today because there is no backend to point at; it becomes blocking the
week staging goes live.
**Recommended fix:** Add `flavorDimensions`/`productFlavors` with
`applicationIdSuffix = ".dev"`/`".staging"` and matching iOS schemes, and settle the
final `applicationId` before the production keystore is generated.
**Risk of fixing:** Changing `applicationId` after a Play listing exists is irreversible —
do it now, not later.
**Validation required:** Yes, toolchain.

---

# PART B — PERFORMANCE

## Summary of what is already right

- **Startup is close to optimal.** `lib/bootstrap.dart:10-30` does exactly four things
  before `runApp`: `ensureInitialized()`, `AppConfig.init` (pure, synchronous —
  `app_config.dart:29-35`), one `await PreferencesStore.load()`, then `runApp`. **No
  network call, no secure-storage read, no Hive/DB open on the pre-first-frame path.**
  The one blocking I/O is `SharedPreferences.getInstance()`, and `bootstrap.dart:14-24`
  argues for it correctly: it is a single small XML read behind the native splash, and
  moving it into a provider would cost a visible wrong-theme flash on every cold start.
  The access-token read is explicitly kept *off* the startup path — `AuthController.build()`
  returns `AuthUnknown` synchronously and resolves on the next microtask
  (`auth_controller.dart:34-47`), with the router treating `unknown` as "wait". This is
  the right shape for a low-end Android device.
- **Every long list uses a builder.** `ListView.separated` ×5, `ListView.builder` ×2,
  `GridView.builder` ×2. The single `ListView(children:)` is
  `lib/features/settings/screens/settings_screen.dart:55`, a fixed short settings list —
  correct. `SingleChildScrollView` is used only on bounded form/detail screens.
- **Pagination exists where it matters.** The schools picker is cursor-paginated with a
  400 ms debounce and a scroll-threshold `loadMore`
  (`lib/features/registration/widgets/school_picker_field.dart:167,176-182,236`), plus a
  per-page retry footer rather than a silent auto-retry.
- **The pubspec's tab-switch claim holds.** `pubspec.yaml:60-61` promises Home does not
  re-download the avatar on tab switch. Verified on two independent axes:
  `StatefulShellRoute.indexedStack` (`app_router.dart:135`) keeps one Navigator per
  branch so Home is never disposed, **and** `meProvider` is deliberately non-`autoDispose`
  (`me_notifier.dart:11-13,39`) so even a rebuild does not refetch. `subjectsProvider`
  and `subjectTreeProvider` carry the same reasoning, documented at
  `subjects_notifier.dart:8-10` and `subject_tree_notifier.dart:9-18` — the whole
  drill-down reads one cached tree instead of a request per level.
- **Riverpod 3 auto-retry is disabled deliberately** on `meProvider`,
  `entitlementsProvider`, `subjectsProvider` and `subjectTreeProvider`
  (`retry: _noRetry`/`noCatalogRetry`, `me_notifier.dart:41,76`,
  `subjects_notifier.dart:33`, `subject_tree_notifier.dart:50`), with a written rationale:
  silent exponential-backoff retries hammer the endpoint and drain a student's data
  bundle on a dead network. This is a genuinely good catch that most codebases miss.
- **Disposal is complete.** All 7 controller-owning `State`s dispose everything they own
  (`login_screen.dart:71`, `otp_screen.dart:39`, `subjects_screen.dart:36`,
  `edit_profile_screen.dart:189`, `signup_identity_screen.dart:61`, `city_field.dart:76`,
  `school_picker_field.dart:151-157` — which also cancels the debounce `Timer` *and*
  removes the scroll listener before disposing the controller). The one notifier-owned
  `Timer` is cancelled via `ref.onDispose` (`otp_notifier.dart:77`). `QuizBloc`'s
  explanation poller cancels by token and checks `isClosed` before every `add`
  (`quiz_bloc.dart:235-266`). **No leak found.**
- No `AnimationController` anywhere; the only animation is a declarative
  `AnimatedContainer` (`main_shell.dart:344`). No `Opacity` in a hot path.

## Findings

### F-9-09 [MEDIUM] [BUG] No image is size-capped for decode — full-resolution avatars and question images decode into memory
**Evidence:** All five `CachedNetworkImage` call sites, and **not one** sets
`memCacheWidth`, `memCacheHeight`, `maxWidthDiskCache` or wraps in `ResizeImage`
(exhaustive grep: zero occurrences of any of these in `lib/`):
- `lib/features/home/widgets/home_header.dart:162` — 51 px avatar
- `lib/features/profile/widgets/profile_header_card.dart:126` — 69 px avatar
- `lib/features/profile/screens/edit_profile_screen.dart:530` — avatar
- `lib/features/profile/widgets/avatar_sheets.dart:329` — **no `width`/`height` at all**,
  in a horizontally-scrolling `ListView.separated` of the 20 default avatars
  (`avatar_sheets.dart:280-289`), each laid out into a 69 px circle
  (`:320-321`)
- `lib/features/quiz/widgets/mcq_renderer.dart:86` — **no `width`/`height`**, a
  full-bleed question illustration

`width`/`height` on `CachedNetworkImage` constrain *layout*, not *decode*: the
`ImageProvider` still decodes at the source resolution and the full bitmap is what enters
`PaintingBinding.imageCache`. `Flutter_Common_Mistakes.md:13` lists "image caching/sizing"
under Performance; `Performance.md:7` sets the target as *"smooth on a mid-range Android
device"*.
**Why it matters:** A server-uploaded custom avatar at, say, 2000×2000 decodes to
2000×2000×4 = **16 MB of RAM** to paint a 51 px circle. The avatar picker opens 20 images
at once; if the defaults are served at even 512×512 that is 20 MB resident, and the
sheet's images are not evicted while it is open. Flutter's default `imageCache` is
capped at 100 MB / 1000 entries, so this shows up as GC pressure and jank first, and as
an OOM kill on a 2 GB device second. The question image in `mcq_renderer` is the worst
case: uncapped, full-bleed, and on the one screen where jank is most visible. This is the
single largest gap between the code and `Performance.md`'s stated goal.
**Recommended fix:** Set `memCacheWidth` (or `memCacheHeight`) on every call site, sized
in *physical* pixels — i.e. logical size × `MediaQuery.devicePixelRatioOf(context)`, or
simply a generous constant such as `memCacheWidth: 160` for the 51/69 px avatars and
`memCacheWidth: 1080` for the question image. Also consider `maxWidthDiskCache` so the
disk cache does not hold originals. The avatar sheet should additionally pass explicit
`width`/`height`.
**Risk of fixing:** Low. Under-sizing produces a visibly soft image, so pick the cap from
the largest slot the widget can occupy, not the design's nominal size. Golden tests exist
for the home header (`test/goldens/`) and may need regenerating if decode size changes
sampling.
**Validation required:** DevTools memory + raster timeline on a real mid-range device,
per `Performance.md:17`.

### F-9-10 [LOW] [QUALITY IMPROVEMENT] `MediaQuery.of(context)` in the schools bottom sheet rebuilds the whole sheet on every keyboard frame
**Evidence:** `lib/features/registration/widgets/school_picker_field.dart:192` —
`padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)` inside the
sheet's `build`. `MediaQuery.of` registers a dependency on the **entire** `MediaQueryData`,
so every change to any of its ~20 fields rebuilds this subtree. Contrast
`lib/features/shell/main_shell.dart:49`, which correctly uses the scoped
`MediaQuery.viewPaddingOf(context)` — the codebase already knows the right idiom, it is
just not applied here.
**Why it matters:** This sheet is a search field over a paginated `ListView.builder`, and
it is *the* screen where the keyboard is open. The keyboard animation ticks
`viewInsets.bottom` every frame for ~250 ms, so the whole sheet — `Column`, `FractionallySizedBox`,
`PlainTextField`, and the `switch` over `AsyncValue` that rebuilds the `ListView.builder`
— is rebuilt each of those frames, exactly while the user is typing and the list is
scrolling. It is the one place in `lib/` where the classic `MediaQuery.of` misuse
(`Flutter_Common_Mistakes.md:12`) has a real cost. Only 2 `MediaQuery` references exist in
the whole app, so the fix is one line.
**Recommended fix:** `MediaQuery.viewInsetsOf(context).bottom`, and lift the `Padding` to
wrap only what needs to move (the sheet body) rather than sitting above the `ListView`.
**Risk of fixing:** None — `viewInsetsOf` is a drop-in with a narrower dependency.
**Validation required:** None beyond the existing widget tests.

### F-9-11 [LOW] [QUALITY IMPROVEMENT] Subject filtering re-normalises the whole list on every rebuild, not just on query change
**Evidence:** `lib/features/catalog/screens/subjects_screen.dart:72` calls
`filterSubjects(data, _query)` inside `build`. `filterSubjects`
(`subjects_notifier.dart:67-73`) calls `normalizeForSearch` on **every** subject name
per invocation, and `normalizeForSearch` (`:83-95`) allocates a `StringBuffer` and walks
every rune, doing a map lookup per character. It runs on every keystroke (via
`setState`) **and** on every unrelated rebuild — including each emission of
`isOnlineProvider` watched two lines above at `:47`.
**Why it matters:** The comment at `subjects_notifier.dart:61-63` justifies client-side
search correctly (closed, small per-student set; no round trip on an Egyptian
connection) and I am not disputing that. The cost is the re-derivation: `Performance.md:14`
says *"No API calls or heavy work inside `build()`"*, and rune-walking + `StringBuffer`
allocation per name per frame is on the wrong side of that line, even if N is ~10.
It is a small, real, easy win rather than a defect.
**Recommended fix:** Either memoise the normalised needle+haystack (cache
`normalizeForSearch(s.name)` on the `Subject` or in a `Map` beside the notifier), or
compute the filtered list in `didUpdateWidget`/on the `onChanged` callback into a field
instead of in `build`. Note `filterSubjects` and `normalizeForSearch` are pure and
already unit-testable — keep them that way.
**Risk of fixing:** Low. Any cache must be keyed on the subjects list identity so a
`refresh()` invalidates it.
**Validation required:** None.

### F-9-12 [LOW] [OPTIONAL IMPROVEMENT] `subjectTreeProvider` is an unbounded, never-evicted family
**Evidence:** `lib/features/catalog/notifier/subject_tree_notifier.dart:47-51` —
`AsyncNotifierProvider.family<…, SubjectTree, String>`, not `autoDispose`, and never
invalidated anywhere (grep for `invalidate` returns only the six unrelated call sites).
The keeping-warm behaviour is deliberate and documented at `:14-15`.
**Why it matters:** One entry per subject the student ever opens, retained for the process
lifetime. Each `SubjectTree` is the subject's **entire** unit→chapter→lesson tree in one
payload (`:10-11`). With ~10 subjects that is bounded and fine — the decision is correct
as written. The concern is only that nothing bounds it *by construction*: if a future
track has 40 subjects, or the tree grows lecture-level metadata, the ceiling moves with
no signal. It also compounds F-9-03 (nothing clears it at logout).
**Recommended fix:** No change to the caching decision. Either cap it (keep the N most
recent subject ids) or — cheaper and more useful — invalidate the family on logout as
part of F-9-03's fix, which handles both the privacy and the retention side at once.
**Risk of fixing:** Low; do not convert to `autoDispose` — that would undo the documented
no-refetch-on-back-navigation behaviour, which is the whole point of the design.
**Validation required:** Memory profile with several subjects opened, on a real device.

### F-9-13 [LOW] [OPTIONAL IMPROVEMENT] No `precacheImage` strategy for the avatar picker
**Evidence:** Zero `precacheImage` calls in `lib/`. The choose-avatar sheet
(`lib/features/profile/widgets/avatar_sheets.dart:280-289`) opens and immediately
requests 20 network images, each showing a grey placeholder until it lands.
**Why it matters:** Genuinely minor and **absence is defensible** — `cached_network_image`
already handles the second visit, the placeholders are graceful, and precaching 20 images
the student may never open would spend a metered Egyptian connection's data on nothing.
Recording it so it is not raised again as a gap.
**Recommended fix:** None. If the sheet ever feels slow on second open, the fix is
`maxWidthDiskCache` (F-9-09), not precaching.
**Risk of fixing:** N/A.
**Validation required:** None.

**Checked and found clean (no finding):** SVGs are not re-parsed per frame —
`flutter_svg` 2.x caches decoded pictures by asset key, and the 9 `SvgPicture.asset` call
sites pass constant asset paths (`main_shell.dart:290,353` etc.); only the `ColorFilter`
varies, which does not invalidate the parse. `intl` construction inside `build` occurs
once, at `lib/features/registration/widgets/date_of_birth_field.dart:59`
(`DateFormat.yMMMd(...)` per build) — on a static form field that rebuilds on user
interaction only, not in a list or an animation; not worth a finding. No `RegExp` is
constructed inside any `build` (`phone.dart:20` is `static final`; the two
`FilteringTextInputFormatter` regexes at `login_screen.dart:358` and
`signup_identity_screen.dart:352` are in `const`-adjacent decoration lists built per
form, not per frame). No duplicate/redundant network calls found: the catalog is one
fetch per subject, `/me` is one fetch per session, `/reference/*` providers cache per
family key (`reference_providers.dart:10-14`), and `entitlementsProvider`'s
resume-refresh (`me_notifier.dart:57-58`) is contract-mandated and correctly disposes its
`AppLifecycleListener`.

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

1. **F-9-01 cannot be closed without building a release APK.** The merged-manifest
   permission set is the only definitive proof. Until someone runs
   `flutter build apk --release` and dumps permissions, "the app works" is only known for
   debug and profile builds. Note F-9-02 (unsigned release) means nobody has had a reason
   to install one yet — the two gaps hide each other.
2. **Crash reporting is a loaded gun pointed at F-9-02.** There is no Crashlytics/Sentry
   today, which is the only reason token/PII `toString()` has not leaked. Adding one
   before fixing F-9-02 would ship minors' DOB and live bearer tokens to a third party on
   the first non-fatal. Sequence the work: redact `toString`, then add crash reporting.
3. **F-9-03's second half is untested by construction.** There is no
   `integration_test/`, and the multi-account-on-one-device path is exactly the kind of
   flow unit tests do not reach. The fix needs a test written alongside it or it will
   regress.
4. **`AppConfig` base URLs are still `TBD.example`** (`app_config.dart:41-43`). Every
   transport conclusion in this report is about the code's *shape*; none of it has been
   exercised against a real TLS endpoint.
5. **Play Data Safety / Apple App Privacy forms** (`Storage_and_Security.md:24`) must
   declare: phone number, name, email, DOB, school/geography, and device model. Nothing
   in the repo tracks what has been declared. Out of my scope to verify, flagged because
   it is the compliance counterpart to the technical controls that *are* in place.

## Deferred Improvements

- A lint or test asserting no `print`/`debugPrint` in `lib/` — currently true, nothing
  keeps it true (`analysis_options.yaml` is stock `flutter_lints`, per the shared context).
  The same guard could assert no sensitive-model `toString` interpolation.
- `leak_tracker` in dev, as `Performance.md:15` calls for. Disposal is currently correct
  by inspection; a tool would keep it correct.
- `cacheExtent` tuning on the catalog lists (`Performance.md:16`) — only after profiling
  on a real device shows it is needed.
- A `DECISIONS.md` entry recording that certificate pinning was considered and declined
  (F-9-06), so it is not re-raised each audit.

## Recommendations (ranked)

1. **Add `INTERNET` to the main Android manifest** (F-9-01). One line; without it no
   release build can reach the network at all. Verify via a merged-manifest dump.
2. **Redact `toString()` on `TokenPair`, `AuthResult`, `StudentProfile`,
   `RegistrationDraft`, `DeviceInfo`** (F-9-02), and add a test that asserts it. Do this
   *before* any crash-reporting SDK is introduced. Highest-consequence item for an app
   holding minors' PII.
3. **Invalidate session providers on logout** (F-9-03) — fixes a cross-account PII
   disclosure on shared devices *and* the retention issue in F-9-12 in one change. Flip
   auth state first, invalidate second; write the test first.
4. **Cap image decode with `memCacheWidth` at all five `CachedNetworkImage` sites**
   (F-9-09). The clearest gap between the code and `Performance.md`'s "smooth on a
   mid-range device" target, and a real OOM risk on cheap Android hardware.
5. **Document the obfuscated release command in `RELEASE_SIGNING.md`** (F-9-05) —
   `--obfuscate --split-debug-info=…`, with a note that symbols must be archived per
   release. Cheap, and it closes a written security rule. R8 itself is optional.
6. **Complete the screenshot-protection spec** (F-9-04): add
   `protectDataLeakageWithBlur()`, and decide explicitly whether the OTP and profile
   screens — which render a minor's phone, DOB and name — should carry `FLAG_SECURE`.
7. **One-line `MediaQuery.viewInsetsOf`** in the schools picker (F-9-10), and memoise the
   subject filter (F-9-11). Both trivial.
8. **Wire Android `productFlavors`** and settle the final `applicationId` before the
   production keystore is generated (F-9-08) — irreversible once a Play listing exists.
