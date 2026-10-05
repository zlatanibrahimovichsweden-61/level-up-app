# Level Up — Flutter Frontend Workflow

**Audit date:** 2026-09-08 · **Branch:** `merged` @ `7e7129c` (dirty working tree — see §0.3) · **Contract pin:** `184d6ec` (v3.0.0-m1) — **upstream is at `5b6e797` (v3.9.2-m1), 12 commits ahead; see §6.4** · **Toolchain:** Flutter 3.44.7 / Dart 3.12.2 · **Method:** read-only trace of the working tree, `git log`, the vendored contract and the project's own records. Nothing in the project was modified.

This document answers one question: *"If a senior Flutter developer joins this project today, how does this application work from startup to the user's final interaction?"* It is built from the actual code, not from the briefs. Where a brief or a doc disagrees with the code, the code is described and the disagreement is noted. Companion file: `flutter_project_audit.html` (the management/audit report).

Verification levels used throughout follow the project's own ladder (`docs/WAVE_STATUS.md`): **SOURCE** (read), **BUILD** (suite green), **ARTEFACT** (built output inspected), **DEVICE**, **CI**. Everything in this document is SOURCE-level unless stated otherwise; the one BUILD-level fact is the recorded validation run of 2026-09-08 (`.ai/audits/current/test-results.md`: format PASS, analyze PASS, **890 tests / 0 failed** on the dirty tree).

---

## 0. Orientation

### 0.1 What the product is

A single Flutter app (Android + iOS) for Egyptian students, forked at registration into a **School** track and a **University** track. Students verify a phone by OTP, register once, browse a subject catalog (Learn), take multiple-choice quizzes that award server-computed points and levels, and manage a profile. The app is **purchase-silent** by contract (adr-049 §3): there is no paywall, price, upgrade link or checkout anywhere; purchases happen on the website. Many users are minors, which drives the storage, logging and backup rules below.

### 0.2 Repository shape (as it actually is)

```
level_up_app/
├── lib/                       190 Dart files · 38,802 lines (22,228 hand-written, 16,574 generated)
│   ├── main.dart              forwards to main_dev.dart
│   ├── main_dev.dart · main_staging.dart · main_prod.dart · main_mock.dart
│   ├── bootstrap.dart         shared boot sequence
│   ├── app.dart               LevelUpApp (MaterialApp.router)
│   ├── core/                  config · models · network · providers · router · session · storage · theme · widgets
│   ├── dev/mock_backend.dart  1,629-line canned Dio interceptor (dev harness only)
│   ├── features/              account_shells · auth · catalog · home · leaderboard* · onboarding · profile
│   │                          · quiz · registration · settings · shell · subscription(empty) · track(empty)
│   └── l10n/                  app_en.arb · app_ar.arb (251 keys each) + generated AppLocalizations
├── test/                      65 test files + 11 harness/fixture files · 18,608 lines · 18 golden PNGs
├── contract/                  vendored OpenAPI (36 operations: 21 stable · 15 draft), error-codes, changelog, realtime
├── tool/                      validate.ps1/.sh · verify_guards.ps1 · verify_release_manifest.ps1 · smoke harness
├── docs/                      36 Markdown records (WAVE_STATUS is the source of truth)
├── .ai/audits/current/        30-file audit package (2026-08-11 snapshot + dated notes)
├── .claude/skills/            22 skills (7 project-specific) · skills/ = stale untracked mirror
├── .github/workflows/ci.yml · .githooks/pre-commit · pre-push
└── android/ · ios/            Android configured (unsigned release); iOS never built
```

`*` `lib/features/leaderboard/` is **untracked** — new, uncommitted work (§4.11).

### 0.3 The working tree at audit time

`git status` shows 49 modified tracked files and 6 untracked paths. Three unrelated pieces of work are mixed together and none is committed:

| Work | Files | Nature |
| --- | --- | --- |
| Documentation reconciliation to contract 3.0.0-m1 (2026-09-05) | 28 `.md`/`.json` under `docs/`, `.ai/`, `.claude/skills/`, `CLAUDE.md` | prose only |
| Release-entrypoint guard (2026-09-05) | `test/guards/workflow_test.dart` (+129), `tool/verify_guards.ps1`, `docs/RELEASE_SIGNING.md` | test + tooling |
| **Leaderboard feature** (2026-09-05 → 09-08) | `lib/features/leaderboard/**` (10 files, 1,577 lines), `test/features/leaderboard/**` (3 files), `app_router.dart`, `app_colors.dart` (+6 tokens), `tab_placeholder.dart`, both ARBs (+9 keys), `main_shell_test.dart` | new feature |

The validation record of 2026-09-08 was produced on this dirty tree, so the 890-green figure already includes the leaderboard tests and the new guard.

---

## 1. Application Startup

### 1.1 The trace

```
flutter run                       flutter run -t lib/main_prod.dart        flutter run -t lib/main_mock.dart
      │                                      │                                        │
lib/main.dart ──► lib/main_dev.dart   lib/main_prod.dart                     lib/main_mock.dart
      │ (forwards)                           │                                        │
      └──────────────┬───────────────────────┘                                        │
                     ▼                                                                │
           lib/bootstrap.dart  bootstrap(Flavor)                                      │
                     │                                                                │
   1. WidgetsFlutterBinding.ensureInitialized()                                       │
   2. AppConfig.init(flavor)          ← lib/core/config/app_config.dart               │
        dev/staging → https://level-up-backend-staging.up.railway.app/api/v1          │
        prod        → https://TBD.example/api/v1   (PLACEHOLDER — fails closed)       │
   3. await PreferencesStore.load()   ← SharedPreferences, read BEFORE runApp so the  │
        first frame is already in the stored theme + locale (no flash)                │
   4. runApp(ProviderScope(overrides: [preferencesStoreProvider ← store],             │
             child: LevelUpApp()))                                                    │
                     │                            main_mock additionally overrides ◄──┘
                     │                            dioProvider ← buildMockDio() and clears
                     ▼                            tokens on every launch (kResetSessionOnLaunch)
           lib/app.dart  LevelUpApp (ConsumerWidget)
                     │
   watches: routerProvider · localeProvider · themeModeProvider
                     │
           MaterialApp.router(
             theme: AppTheme.light, darkTheme: AppTheme.dark, themeMode: <student choice, default light>,
             locale: <stored or 'ar'>, localizationsDelegates: AppLocalizations,
             builder: AnnotatedRegion<SystemUiOverlayStyle> (the app's ONLY status-bar style),
             routerConfig: GoRouter from routerProvider)
                     │
           routerProvider builds GoRouter(initialLocation: '/', refreshListenable: authListenable)
                     │
           authControllerProvider.build() → AuthUnknown, then async reads the access token
                     │
           redirect(AuthUnknown) → null (wait, no flicker)  →  first frame renders '/'
                     │
                     ├── token present  → AuthAuthenticated  → redirect '/' → '/home'
                     └── token absent   → AuthUnauthenticated → stays on '/' (OnboardingScreen)
```

### 1.2 Dependencies (Riverpod is the DI container — no `get_it`)

All core dependencies are plain providers in `lib/core/providers/core_providers.dart`:

| Provider | Type | Notes |
| --- | --- | --- |
| `secureStorageProvider` | `Provider<SecureStorage>` | tokens + `device_id` only (Keychain/Keystore) |
| `preferencesStoreProvider` | `Provider<PreferencesStore?>` | **null by default**; every entrypoint overrides it; tests see null and skip persistence |
| `refreshDioProvider` | `Provider<Dio>` | bare client, `ErrorInterceptor` only — used solely for `POST /auth/refresh` |
| `dioProvider` | `Provider<Dio>` | main client: `AuthInterceptor` → `ErrorInterceptor`; the refresh closure lazily reads `authRepositoryProvider` (a documented static cycle broken by an explicit type annotation) |
| `connectivityProvider` / `isOnlineProvider` | `Provider` / `StreamProvider<bool>` | drives every Offline state |

Feature repositories are `Provider`s that `ref.watch(dioProvider)`. There is no service locator, no global singletons except `AppConfig.instance`.

### 1.3 Configuration

`AppConfig` (`lib/core/config/app_config.dart`) is the only runtime configuration: `flavor`, `baseUrl`, `isDev`. Since 2026-10-06 Android has two Gradle product flavors, `prod` (`com.levelupworld.app`, "Level Up") and `staging` (`com.levelupworld.app.stg`, "Level Up STG"), and Gradle refuses a flavor compiled from the wrong `-t` entrypoint; iOS schemes are still pending (Wave 3, needs a Mac). Every build and run command is `--flavor <prod|staging> -t lib/main_<x>.dart` — see `docs/ENVIRONMENTS.md` §4. The pre-flavor hazard (a flagless `flutter build apk` shipped the staging host, ARTEFACT-proven 2026-09-05) is now a build failure, and a text guard still scans every release command in `docs/`, `tool/`, `.github/`, `.githooks/`. `isDev` is computed and never read anywhere.

### 1.4 Storage

| Store | Backing | Holds | Cleared by |
| --- | --- | --- | --- |
| `SecureStorage` (`lib/core/storage/secure_storage.dart`) | `flutter_secure_storage` (iOS `first_unlock_this_device`, non-synchronizable; Android 10.x default encryption) | `access_token`, `refresh_token`, `device_id` (32-hex, generated once) | `clearTokens()` on logout (keeps `device_id`); `clear()` exists for account deletion and has **zero call sites** |
| `PreferencesStore` (`lib/core/storage/preferences_store.dart`) | `shared_preferences` | `pref.theme_mode` (`light`/`dark` names, never index), `pref.locale` (language code) | never on logout (deliberate — not PII) |
| `cached_network_image` disk cache | plugin default | avatar images | **never** (documented gap — a minor's avatar survives logout on a shared device) |
| Memory | Riverpod providers | everything else — profiles, catalog trees, quiz session | `invalidateSessionScope()` on both sign-out paths |

There is **no offline cache layer**. `hive_ce` was declared and removed (2026-08-15) because nothing ever used it.

### 1.5 Localization and direction

`l10n.yaml` generates `AppLocalizations` from `lib/l10n/app_en.arb` (template) and `app_ar.arb`; both carry 251 keys and a guard test fails on any drift. Default locale is **Arabic** (`LocaleController.build()` returns `Locale('ar')` when nothing is stored). `Directionality` follows the locale automatically; screens use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional` throughout. Phone numbers and OTP boxes are force-LTR. Fonts are bundled (`Inter` for Latin, fallback chain `['Tajawal', 'Cairo']` for Arabic) — no runtime font fetch.

### 1.6 Theme

`AppTheme` (`lib/core/theme/app_theme.dart`) builds two `ThemeData`s from two seeds — light = green `#384F47` on cream `#FCFBF9`, dark = purple `#AE87E7` on `#232428`. Custom tokens travel as a `ThemeExtension<AppColors>` (~60 tokens, `lib/core/theme/app_colors.dart`, 896 lines). Typography is a verbatim transcription of the designer's 2026-08-21 handoff (`AppType`, 18 styles on `28→24→20→18→16→14→12→10`, plus `11` for the nav bar), projected onto Material's `TextTheme` so framework widgets stop drawing stock sizes. Two guard tests hold both at zero exceptions: no colour and no `fontSize:`/`fontWeight:` outside `lib/core/theme/`. `ThemeMode.system` is deliberately not offered — the student picks light or dark in Settings.

### 1.7 State management at the root

Three root-level `Notifier`s: `AuthController` (`AuthStatus`), `LocaleController` (`Locale`), `ThemeModeController` (`ThemeMode`). All three are synchronous by design so the first frame is correct.

### 1.8 Initial screen

`initialLocation: '/'` → `OnboardingScreen` for a signed-out student (illustration + sheet with **Get Started** and **Log In**, both of which go to `/login` — phone-first auth means the server decides new-vs-existing at OTP time). A signed-in student never sees it: `authRedirect` bounces `/` and `/login` to `/home` before paint. No "onboarding seen" flag exists or is needed.

---

## 2. Authentication Workflow

### 2.1 The real flow

```
App start
   │
AuthController.build() → AuthUnknown ── reads access token from SecureStorage
   │                                            │
   │                             ┌──────────────┴──────────────┐
   │                        token present                  token absent
   │                             │                              │
   │                      AuthAuthenticated              AuthUnauthenticated
   │                             │                              │
   │                        /home (shell)                  '/' Onboarding
   │                                                            │ Get Started / Log In
   │                                                        /login  LoginScreen
   │                                                            │ phone → Phone.tryParse (E.164, Arabic-digit fold)
   │                                                            │ LoginNotifier.sendOtp → POST /auth/otp/request (202)
   │                                                            │ ALWAYS advances (anti-enumeration)
   │                                                        /otp  OtpScreen(OtpArgs{phone, resendAfterSeconds, expiresInSeconds})
   │                                                            │ 6-digit Pinput, auto-submit on completion
   │                                                            │ OtpNotifier.verify → deviceInfoProvider (device_id + platform + model)
   │                                                            │                    → POST /auth/otp/verify {phone, code, device}
   │                                                            │
   │                                            ┌───────────────┴────────────────┐
   │                                   result: "authenticated"          result: "registrationRequired"
   │                                            │                                │
   │                          writeTokens → markAuthenticated()      RegistrationRequiredOutcome
   │                                            │                    (registrationToken + TTL, NO tokens)
   │                               success view + Continue                        │
   │                                            │                    ref.listen → RegistrationController.start(args)
   │                                     context.go('/home')                     → context.go('/register', extra: args)
   │                                                                              │
   │                                                                   wizard (§4.3) → POST /auth/register (201)
   │                                                                              │ writeTokens → markAuthenticated()
   │                                                                              └── context.go('/home')
   ▼
Authenticated state: every request carries `Authorization: Bearer <access>` via AuthInterceptor.onRequest
```

### 2.2 Authentication state

`AuthStatus` is a sealed class in `lib/features/auth/notifier/auth_controller.dart`: `AuthUnknown` (first frame only), `AuthAuthenticated`, `AuthUnauthenticated([LogoutReason?])` with `LogoutReason { supersededOtherDevice, sessionExpired, userInitiated }`. `AuthController` is a plain `Notifier<AuthStatus>` and is **the single source of auth truth** — the interceptor flips it, the router reacts to it, nothing navigates from inside the network layer.

### 2.3 Login

`LoginScreen` (`ConsumerStatefulWidget`) validates the phone client-side with `Phone.tryParse` (contract pattern `^\+[1-9][0-9]{7,14}$`, folds Arabic-Indic digits, prepends `+20` to a local number). `LoginNotifier` is an `AsyncNotifier<OtpRequestResult?>`; the screen renders loading (button spinner), error (inline message mapped by `authErrorMessage`), and offline (pinned `OfflineBanner` + disabled buttons). Both "Send OTP" and "Create New Account" do the same thing — the fork is the server's. The three legal links point at `https://levelup.example/...` placeholders (`TODO(legal)`).

### 2.4 OTP

`OtpScreen` uses `otpProvider` — `NotifierProvider.autoDispose.family<OtpNotifier, OtpUiState, OtpArgs>` — a hand-rolled immutable `OtpUiState` (countdown, verifying, resending, error, invalid-code styling, outcome). The resend countdown is a `Timer.periodic` inside the notifier, cancelled on dispose. A `_disposed` flag guards `state =` after every `await`. **Open defect W3-1:** `verify()` still calls `ref.read(...)` after two `await`s *before* the `_disposed` check; Riverpod 3.3.2 throws `UnmountedRefException` on a dead ref, so popping the OTP screen mid-verify throws (confirmed 2026-09-04, fix not applied — `docs/RISKS.md` R-2).

### 2.5 Token handling and refresh

`AuthInterceptor` (`lib/core/network/interceptors/auth_interceptor.dart`):

- `onRequest`: reads the access token and adds `Authorization: Bearer`.
- `onError` on **401** only, reading the raw ProblemDetails `code`:
  - `session_superseded` → `forceLogout(supersededOtherDevice)`, pass the error on.
  - `authentication_required` → **single-flight** refresh (`_refreshing ??=`), on a **separate bare Dio** (no `AuthInterceptor`, so refresh can never recurse), then re-issue the original request **once** (`extra['__retried']`).
  - refresh returns `refresh_token_invalid` → `forceLogout(sessionExpired)`; no refresh token in storage → same; network/offline failure → rejected as typed error, **no logout** (transient).
- It never navigates. `routerProvider` mirrors `AuthStatus` into a `ValueNotifier` used as `refreshListenable`, so any flip re-runs `authRedirect`.

Tests prove the single-flight under concurrent 401s (`test/core/network/auth_interceptor_test.dart`).

### 2.6 Persistence and session restoration

Tokens are written by `OtpNotifier.verify` (authenticated fork) or `RegistrationSubmitNotifier.submit` (registration fork) **before** `markAuthenticated()`. On the next cold start `AuthController._resolveInitial()` reads the access token; presence alone means authenticated (the first request will refresh if it has expired). No test boots the app with a token already in storage (gap).

### 2.7 Logout and forced logout

| Path | Trigger | Steps |
| --- | --- | --- |
| `AuthController.logout()` | Profile hub → Logout row → `ProfileConfirmDialog` | best-effort `POST /auth/logout` (401 swallowed) → `clearTokens()` → `AuthUnauthenticated(userInitiated)` → `invalidateSessionScope(ref)` |
| `AuthController.forceLogout(reason)` | interceptor (eviction / dead refresh) | idempotent early-return if already signed out (breaks the invalidate→401→logout loop) → `clearTokens()` → `AuthUnauthenticated(reason)` → `invalidateSessionScope(ref)` |

`invalidateSessionScope` (`lib/core/session/session_scope.dart`) is the **session inventory**: `meProvider`, `entitlementsProvider`, `editProfileProvider`, `subjectsProvider`, `subjectTreeProvider` (family), `loginProvider`, `otpProvider` (family), `registrationControllerProvider`, `registrationSubmitProvider`, `schoolSearchProvider` (family), `quizSetupProvider`. A guard test fails if a new non-`autoDispose` notifier appears in `lib/features/` without being listed here or in the documented exemptions. **The new `leaderboardProvider` is autoDispose and therefore escapes the guard — it is not invalidated and not listed as exempt.** `device_id` survives on purpose (wiping it would mis-fire `session_superseded` on the next login). `LoginScreen` shows the reason once via `clearReason()`.

### 2.8 Guards and redirects

`authRedirect(status, matchedLocation)` is a pure function (unit-tested): `AuthUnknown` → stay; unauthenticated on a protected route → `/login`; authenticated on `/` or `/login` → `/home`. Auth routes are `{'/', '/login', '/otp'}` plus anything under `/register` (the whole wizard is pre-auth by design because the account does not exist yet).

---

## 3. Routing Workflow

### 3.1 Router

One `GoRouter` in `lib/core/router/app_router.dart` (366 lines), exposed as `routerProvider`. `initialLocation: '/'`, `refreshListenable` mirrors auth, `redirect` is `authRedirect`. There is **no deep-link configuration** on either platform (no intent filters beyond the launcher, no associated domains) — deep links are an internal navigation concept only.

### 3.2 Complete route map

```
'/'  Onboarding ······································· pre-auth (signed-in → /home)
 ├── /login  LoginScreen ······························· pre-auth (signed-in → /home)
 │    └── /otp  OtpScreen  extra: OtpArgs (required, `extra!`)
 │         ├── (authenticated) ──────────────────────────────────────────────► /home
 │         └── (registrationRequired) → /register  SignupIdentityScreen  extra: RegistrationArgs?
 │                └── /register/track  SignupTrackScreen
 │                     ├── /register/school      SchoolDetailScreen ──┐
 │                     └── /register/university UniversityDetailScreen ┴─ POST /auth/register ► /home
 ├── /track-select  _Placeholder('Track select') ······ DEAD ROUTE — nothing navigates here
 │
 ├── StatefulShellRoute.indexedStack  →  MainShell (5-tab notched nav bar, one Navigator per branch)
 │    ├── [0] /home         HomeScreen
 │    ├── [1] /leaderboard  LeaderboardScreen  (UNTRACKED; was LeaderboardPlaceholderScreen)
 │    ├── [2] /learn        SubjectsScreen  (centre tab)
 │    │        └── subject/:subjectId        SubjectTreeScreen (school → UnitsView · university → LecturesView)
 │    │             └── unit/:unitId         ChaptersScreen                     (school only)
 │    │                  └── chapter/:chapterId  LessonsScreen                  (school only)
 │    ├── [3] /message      MessagePlaceholderScreen  ("Coming soon" — no endpoint exists)
 │    └── [4] /account      ProfileScreen
 │
 ├── /quiz/setup            QuizSetupScreen   extra: QuizSetupArgs (required, `extra!`)   ─┐ outside the shell:
 ├── /quiz/:quizId          QuizScreen        extra: Quiz  (null → _QuizUnavailableScreen)  │ full-screen tasks,
 │    └── result            QuizResultScreen  extra: QuizResultArgs (`extra!`), pushReplacement │ nav bar hidden
 ├── /profile               ProfileScreen (same hub as /account, reachable outside the shell)
 │    └── edit              EditProfileScreen
 ├── /settings              SettingsScreen
 ├── /refer                 ReferAFriendScreen      (disabled shell)
 ├── /support               CustomerSupportScreen   (disabled shell)
 ├── /friends               FriendsScreen           (disabled shell, NO entry point anywhere)
 ├── /legal/privacy         LegalDocumentScreen(privacy)  ("not published")
 └── /legal/terms           LegalDocumentScreen(terms)
```

Removed on 2026-09-04: `/subscription` and `/subscription/return` (purchase surface deleted per adr-049).

### 3.3 Parameters and payloads

- **Path parameters** carry catalog ids (`subjectId`, `unitId`, `chapterId`, `quizId`). All three catalog levels read the *same* cached `subjectTreeProvider(subjectId)`; the ids select from the tree, they are not fetch keys.
- **`extra`** carries in-memory objects that cannot be rebuilt from the server: `OtpArgs`, `RegistrationArgs`, `QuizSetupArgs`, `Quiz`, `QuizResultArgs`. Only `/quiz/:quizId` guards a null `extra` gracefully; `/otp`, `/quiz/setup` and `/quiz/:quizId/result` use `state.extra!` and would throw on a cold link.

### 3.4 Navigation patterns

| Pattern | Where | Why |
| --- | --- | --- |
| `context.go` | auth forks, wizard exits, catalog drill-down (subjects → tree → chapters), result → `/learn` | replaces the stack / rebuilds the branch |
| `context.push` | login → otp, wizard steps, lessons/lectures → `/quiz/setup`, profile rows | keeps a back stack |
| `context.pushReplacement` | quiz → result | the finished session must not sit under Back |
| `navigationShell.goBranch(i, initialLocation: i == current)` | nav bar | re-tapping the active tab pops it to root |
| `PopScope` + confirm dialog | Edit Profile (dirty form), Quiz (leave quiz?) | guard destructive back |
| Dialogs, not routes | Logout, Go to University | a modal must not be a cold-link target |

The catalog mixes `go` (subjects, units, chapters) and `push` (lessons, lectures) for "drill one level down" — it works because the routes are nested, but it is two idioms for one gesture.

---

## 4. Feature Workflows

The generic shape every data feature follows:

```
User action → Screen (Consumer*Widget) → ref.read(notifier).method() / ref.watch(provider)
  → Notifier (AsyncNotifier / Notifier / QuizBloc) → Repository (Dio) → AuthInterceptor → ErrorInterceptor
  → HTTPS → JSON → freezed fromJson → AsyncValue / sealed state → ScreenState → StateWidget → UI rebuild
```

The mapping from `AsyncValue` to the four required screen states (loading / empty / error / offline) is done per feature; most features route through the shared `ScreenState` + `StateWidget`; Home does not (§4.4).

### 4.1 Onboarding

- **Entry:** `/`. `OnboardingScreen` is presentational (`ConsumerWidget` only for the language pill). No provider, no endpoint, no state.
- **Actions:** Get Started → `/login`; Log In → `/login`; language pill toggles locale.
- **States:** none apply. Tests: 13 widget tests.

### 4.2 Auth (Login + OTP)

Covered in §2. Providers: `loginProvider` (`AsyncNotifier`, non-autoDispose, cleared on sign-out), `otpProvider` (autoDispose family), `deviceInfoProvider` (`FutureProvider`, **no `retry:`**), `authControllerProvider`. Endpoints: `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/refresh`, `POST /auth/logout`. Models: `OtpRequestResult`, `AuthResult` (freezed union on the `result` discriminator: `authenticated{tokens, profile(opaque Map)}` | `registrationRequired{registrationToken, expiresInSeconds}`), `TokenPair`, `DeviceInfo`, `Phone` (value type). Error copy: `authErrorMessage` maps `otp_invalid` / `otp_expired` / `otp_throttled` / `validation_failed` / offline → localized strings; server `title`/`detail` are never shown. Tests: 7 files (phone parsing, validation, forced-logout message, verify fork, OTP countdown, controller). Untested: pressing Resend (no test asserts a second `requestOtp`), the dispose-mid-verify race.

### 4.3 Registration wizard

```
OTP registrationRequired ─► RegistrationController.start(args)  [seeded in ref.listen, NOT initState — BUG-001]
  │  RegistrationDraft{registrationToken, tokenExpiresAt(now+TTL), phone, name, parentPhone, referralCode,
  │                    track, dateOfBirth, countryCode, governorateId, cityId|cityName, schoolId, stage,
  │                    educationSystem, universityId, facultyId, studyYearId}
  ▼
/register  SignupIdentityScreen ── name · read-only phone · parent phone · optional referral (no backend field)
  ▼ push
/register/track  SignupTrackScreen ── two illustrated track cards
  ▼ push
/register/school  SchoolDetailScreen                         /register/university  UniversityDetailScreen
  DOB → Country → Governorate(EG only) → City|"my city       DOB → University → Faculty → Academic Year(active only)
  isn't listed" free text → Education system → Grade →        → Governorate (EG hard-coded) → City|free text
  School picker (EG only, searchable, skippable "I can't find my school")
  ▼                                                          ▼
RegistrationSubmitNotifier.submit()  ── validateSchoolDraft / validateUniversityDraft (contract field names)
  → SchoolRegistration.fromDraft / UniversityRegistration.fromDraft  (city union: exactly one of cityId/cityName,
    forbidden fields OMITTED not nulled, includeIfNull:false, dateOfBirth as bare yyyy-MM-dd, device object)
  → POST /auth/register → 201 AuthResult.authenticated → writeTokens → markAuthenticated()
  → screen listener: context.go('/home'); reset() post-frame
  → 401 registration_token_invalid / 409 phone_already_registered → SnackBar → reset → /login
```

- **Providers:** `registrationControllerProvider` (`Notifier<RegistrationDraft?>`, cascade-clearing setters), `registrationSubmitProvider` (`AsyncNotifier<RegistrationSubmitted?>`, **not** autoDispose, **no `retry:`**, reset only via the controller — a failed submit's error can persist across tracks), `schoolSearchProvider` (autoDispose family, cursor paging, `_disposed` guard, **no `retry:`**), seven reference `FutureProvider`s (`countries`, `governorates(cc)`, `cities(CitiesQuery)`, `schools(SchoolsQuery)` — **unused**, `educationSystems`, `universities`, `avatars`) — all session-cached, **none with `retry:`** (Riverpod 3 will silently auto-retry a failed load, so the picker's error/offline/429 views may be unreachable on a device; the project already records this as deferred).
- **Endpoints:** `POST /auth/register`, the seven `GET /reference/*` operations (cursor-paged `/reference/schools?q&governorateId&cityId&cursor&limit` → `CursorPage<NamedRef>`).
- **States:** every dropdown handles loading (in-field spinner) / error (`_PickerFailure` with offline vs rate-limited vs generic copy + Retry) / empty (`noOptions`) / gated (`disabledHint`) in one shared `ReferenceDropdown`; screens pin `OfflineBanner`; submit failure → `SubmitFailureBanner` + per-field `InlineFieldError` from `ValidationException.fields`; expiry → `RegistrationExpiredView` (passive check on rebuild, no ticker).
- **Tests:** 11 files incl. a router-driven BUG-001 regression. Untested: the school search sheet widget (debounce, scroll-append), `registration_error_copy.dart`, the success/`/home` and restart paths at screen level.

### 4.4 Home

- **Entry:** shell branch 0. `HomeScreen` watches `meProvider` (`AsyncNotifierProvider<MeNotifier, StudentProfile>`, non-autoDispose so tab switches do not refetch, `retry: _noRetry`).
- **API:** `GET /me` → `StudentProfile` (name, avatar, track, geography with the `ProfileCity` coded/freeText union, school or university block, `points{school, university, total}`, `level` 1–12, `badges`, `privacy`, embedded `entitlements`).
- **What renders:** header (avatar, greeting, bell chip with a permanently-false unread dot), `LevelCard` (server `level`/`points` verbatim; the *bar* uses a client constant of 500 points per level, which the contract prose confirms). Everything else is a `ComingSoonSection` stub: Daily Tasks, Learning Tools (university only), Continue Learning, Top Student, plus a placeholder banner. No navigation leaves Home.
- **States:** skeleton (`_Skeleton`) / error (`_Failure` + Retry → `refresh()`) / offline (same view with wifi icon, plus a pinned `OfflineBanner` when data is on screen) / empty: not applicable. **Home hand-rolls `me.when(...)` and its own `_Failure`/`_Block` instead of the shared `StateWidget` — the only data screen that does.**
- **Entitlements:** `entitlementsProvider` (`GET /me/entitlements`, app-resume refresh via `AppLifecycleListener`) exists but is **read by no widget**, so the request never fires in production and the resume refresh never registers (the contract asks for a refetch on resume).
- **Tests:** 2 files (19 cases).

### 4.5 Catalog / Learn

```
/learn SubjectsScreen ── subjectsProvider (AsyncNotifier<List<Subject>>, session-cached, retry: none)
  │  GET /catalog/subjects (no params; bare array) → Subject{id, name, termId?, termNumber?, questionCounter}
  │  local search (Arabic diacritic/alef folding) · "Mistakes" button = coming-soon SnackBar
  ▼ go('/learn/subject/:id')
SubjectTreeScreen ── subjectTreeProvider(subjectId) (AsyncNotifier family, non-autoDispose, cached per subject)
  │  GET /catalog/subjects/{id}/tree → repository switches on json['track'] BEFORE parsing:
  │     'school'     → SchoolSubjectTree{units[chapters[lessons]]}     → UnitsView   (units_screen.dart)
  │     'university' → UniversitySubjectTree{quizTypes[], lectures[]}  → LecturesView (lectures_screen.dart) + QuizTypeTabs
  ├── school:  go('.../unit/:unitId') ChaptersScreen → go('.../chapter/:chapterId') LessonsScreen
  │            → push('/quiz/setup', extra: QuizSetupArgs.lesson(lessonId, scopeName))
  └── university: lecture row → push('/quiz/setup', extra: QuizSetupArgs.lecture(lectureId, scopeName, quizType))
```

- **States:** all four screens funnel through `CatalogAsyncView<T>` → `ScreenState` → shared `StateWidget`: skeletons, `noSubjects` / `nothingHere` / `noLectures` empties, error + Retry, offline + Retry + pinned banner; `403 insufficient_scope` gets `subjectUnavailable` copy with no Retry. Unknown `unitId`/`chapterId` or a university tree on a school route renders **empty**, not a crash.
- **Gaps:** `termNumber` is parsed and never rendered — the contract says a year-long university course is two subjects with the same name to be grouped by term; the grid shows two identical cards. The filenames `units_screen.dart` / `lectures_screen.dart` contain views, not screens (they are not routed, which reads as dead code until you follow the import).
- **Tests:** 8 files, ~140 cases, all router-driven through the real nav bar; the strongest coverage in the app.

### 4.6 Quiz (the only Bloc)

```
/quiz/setup  QuizSetupScreen ── length chips 10/30/50 (default 30) · mode: 'normal' only
  │  QuizSetupNotifier (AsyncNotifier<Quiz?>, autoDispose, _disposed guard) → POST /quizzes
  │     body {mode, length, lessonId | lectureId + quizType}  (nulls omitted) → 201 Quiz{id, mode, questions[]}
  │  403 weekly_question_limit_reached | subscription_required → LimitSheet (title + body + "Not now" ONLY —
  │     no upgrade CTA, no price, no link: purchase-silent)      422 not_enough_questions → inline error
  ▼ reset(); push('/quiz/:id', extra: quiz)
/quiz/:quizId  QuizScreen ── BlocProvider(QuizBloc(repository: ref.read(quizRepositoryProvider)))..add(QuizStarted)
  │  screen protection ON in initState (screen_protector), OFF in dispose — always
  │  QuizBloc states: QuizInitial → QuizInProgress(selected?) ⇄ AnswerConfirming ⇄ AnswerFailed
  │                                                 → QuizFinishing → FinishFailed | QuizCompleted(summary)
  │  OptionSelected (local) → AnswerSubmitted → POST /quizzes/{id}/answers {questionId, optionId}
  │     → AnswerResult{correct, correctOptionId, pointsDelta, explanationAvailable} (server idempotent on (quiz,question))
  │  ExplanationRequested (graded only) → GET /questions/{id}/explanation: 200 text | 202 → poll every 2 s, max 10
  │  Next only when graded; Finish only on the LAST graded question; X → "Leave quiz?" dialog (no finish)
  │  QuizFinishRequested → POST /quizzes/{id}/finish → QuizSummary{quizId, score, totalQuestions, answeredCount,
  │     pointsAwarded, leveledUp, newBadge, questions[]}   (3.0.0-m1: NO totalPoints, NO level)
  ▼ listener: ref.invalidate(meProvider); pushReplacement('/quiz/:id/result', extra: QuizResultArgs(summary, scopeName))
/quiz/:quizId/result  QuizResultScreen (StatelessWidget) ── ring, correct/wrong(/skipped) buckets,
     "pointsAwarded" only (D-006), "Review Questions" DISABLED (endpoint draft), Back to Learn → go('/learn')
```

- **Boundaries:** `quiz_bloc.dart` imports no Riverpod; the one provider mutation (`invalidate(meProvider)`) happens in the screen's `BlocConsumer.listener`. A guard test fails the build if `flutter_bloc` is imported outside `lib/features/quiz/`.
- **No timer exists** (the contract defines no time limit; the `bloc` skill's promise of one is stale).
- **Errors:** typed `AppException`s on `AnswerFailed.error` / `FinishFailed.error`; parse failures are sealed at both the repository and the Bloc (F-7-01) so no state can strand on a spinner.
- **States:** setup — offline banner + disabled Start, loading spinner in the button, inline error / sheet; taking — one-frame spinner, `_RetryRow` under the question for answer/finish failures (offline arrives as the same row, no banner); result — pure, no async.
- **Defects found by reading:** (1) navigating away from a question while its explanation is pending stops polling but leaves the panel on `ExplanationPending` forever; (2) early finish is unreachable from the UI, so a student can never skip and `QuizSummary.skipped` / the third bucket are dead in production; (3) `AnswerFailed` has no exit except retry or abandon; (4) a zero-question quiz would `RangeError`.
- **Tests:** 6 files (31 `blocTest`s, 22 screen, 16 setup, 14 result, 18 repository, 26 model) + a mock-backend quiz test. Untested: `_QuizUnavailableScreen`, poll cancellation across questions, the renderer seam, the setup notifier's dispose guard.

### 4.7 Profile hub

- **Entry:** shell branch 4 (`/account`) and `/profile`. Reads the `meProvider` Home already fetched — no request on tab switch.
- **Rows:** Settings → `/settings` · Favorite questions (disabled, S11) · Your progress (disabled, S32) · Refer a Friend → `/refer` · Customer Support → `/support` · Privacy & policy → `/legal/privacy` · Terms → `/legal/terms` · GO to University → confirm dialog with a *disabled* Confirm (no track-switch endpoint, S31) · Logout → confirm dialog → `AuthController.logout()`. **No Subscription row** — removed, not disabled (asserted by a test).
- **Stats:** `points.total` verbatim; Solved Questions and Rank are omitted outright because the contract has no source for them.
- **States:** `StateWidget<StudentProfile>` with skeleton / error / offline + pinned banner; empty not applicable. Disabled rows are structurally dead (`IgnorePointer` + opacity + `Semantics(enabled:false)`), not merely null callbacks.
- **Tests:** 30 cases through the real router.

### 4.8 Edit Profile

- **Entry:** pencil on the hub → `/profile/edit`. `editProfileProvider` (`AsyncNotifier.autoDispose<StudentProfile?>`, `_disposed` guard after the awaited PATCH; **no `retry:`** but its `build` cannot fail).
- **Editable:** name (≤100), email (tri-state `EmailPatch{unchanged|set|cleared}` — the one place an explicit JSON `null` is correct; `includeIfNull:false` would make "clear my email" impossible), avatar (`GET /reference/avatars` picker; "Upload photo" permanently disabled — `PUT /me/avatar` is draft and moderated).
- **Read-only:** phone, city (exhaustive `switch` over `ProfileCity`), and the track block. Parent's Number is not shown at all — `GET /me` never returns it (S34, write-only field).
- **API:** `PATCH /me` with only the changed keys → `StudentProfile`; success → `ref.invalidate(meProvider)` → pop. **Staging answers 405 for `PATCH /me`** and the dev mock has no handler, so this screen's save has no runnable environment anywhere.
- **States:** all wrapped in `EditProfileChrome` so the back chip exists in every state; `PopScope` discard guard; validation → inline errors + banner. **Tests:** 39 cases.

### 4.9 Settings

`/settings`. Languages (`localeProvider.select` → `PreferencesStore`), Mode (`themeModeProvider.select`; the frame's third "system" circle is deliberately not offered), Rank (`leaderboardVisible`, `scoreHidden` → one-field `PATCH /me` each via `editProfileProvider`, non-optimistic, per-section loading/unavailable/error states), Notification Preferences (four toggles, all dead — nothing in the contract stores them). Offline banner pinned. **Tests:** 28 cases, pumping the real `LevelUpApp` so theme/locale changes are proven at the root.

### 4.10 Account shells

`/refer`, `/support`, `/friends`, `/legal/privacy`, `/legal/terms` — four `StatelessWidget`s over `TitledChrome` + `ShellBody`. They fetch nothing and every control is a hand-drawn `DisabledActionButton` (no `InkWell` in the subtree). The legal screens render one line ("not published") and carry a `TODO(content)` that explicitly forbids writing legal copy. `FriendsScreen` has no entry point in the app. **Tests:** 14 cases (structural deadness, titles, back chip, AR + dark).

### 4.11 Leaderboard (UNTRACKED — in-flight work)

```
/leaderboard  LeaderboardScreen ── watches meProvider first (scope list needs the track/country)
  │  scopes: school → [system, governorate(EG only)] · university → [global, cohort]  (ScopeToggle; hides if <2)
  │  leaderboardProvider(scope)  AsyncNotifierProvider.autoDispose.family<…, LeaderboardResults, LeaderboardScope>, retry: _noRetry
  │  GET /leaderboard?scope=&cursor=&limit=20 → CursorPage<LeaderboardEntry{rank, studentId, name, avatarUrl, points, isMe}>
  │  first load hops past short pages (max 10); infinite scroll → loadMore; expired cursor → restart
  │  GET /leaderboard/me deliberately NOT called
  ▼
Podium (top 3, medal-coloured rings) + rows; server `isMe` → "You" row highlight (rows only — Podium ignores isMe)
States: StateWidget — spinner / leaderboardEmpty / error (retry withheld on 429; `account_pending_deletion` copy) / offline + banner
```

**Both endpoints are `x-stability: draft` in the *vendored* contract** (`contract/openapi.yaml:1221`, `:1263`) — but the partner's repository moved on: fetched read-only on 2026-09-08, upstream `main` (`5b6e797`, v3.9.2-m1) promoted both to **stable on 2026-09-05 (3.5.0-m1)** after staging verification, and the leaderboard code cites exactly that newer contract ("3.7.0-m1", adr-111/114, the top-200 bound, `account_pending_deletion` — all real upstream). So the feature is not a draft-endpoint violation; the defect is that `contract/` and `contract/SOURCE.md` were never re-vendored, so the repository's own copy, records and guards still describe a contract nine versions old. The client's list-endpoint behaviour (short-page hops, top-200, opaque cursor, 403 copy, never paging for `isMe`, `/leaderboard/me` not called) matches upstream 3.9.2-m1. Other gaps: no `/leaderboard` handler in the dev mock, `leaderboardProvider` not in `invalidateSessionScope`, no repository test, no pull-to-refresh, `LeaderboardResults.me` unused, share button permanently disabled. 23 tests exist and resolve every symbol they reference; the 890-green run includes them.

### 4.12 Message tab

`/message` → `MessagePlaceholderScreen` ("Coming soon"). No endpoint of any kind exists (S33). Not fixable client-side.

---

## 5. State Management Workflow

### 5.1 What is used

| Technique | Where | Count |
| --- | --- | --- |
| **Riverpod** `Notifier` (sync) | `AuthController`, `LocaleController`, `ThemeModeController`, `RegistrationController`, `OtpNotifier` | 5 |
| **Riverpod** `AsyncNotifier` | `LoginNotifier`, `RegistrationSubmitNotifier`, `SchoolSearchNotifier`, `MeNotifier`, `EntitlementsNotifier`, `EditProfileNotifier`, `SubjectsNotifier`, `SubjectTreeNotifier`, `QuizSetupNotifier`, `LeaderboardNotifier` | 10 |
| **Riverpod** `FutureProvider` | 7 reference pickers + `deviceInfoProvider` | 8 |
| **Riverpod** `StreamProvider` | `isOnlineProvider` | 1 |
| **Riverpod** `Provider` (DI) | storage, Dio ×2, connectivity, 6 repositories, router, screen protection | ~12 |
| **flutter_bloc** `Bloc` | `QuizBloc` — the quiz session only (guard-enforced) | 1 |
| `ValueNotifier` | router's auth mirror | 1 |
| `setState` | 12 files — purely local UI (typed text, selected chip, dirty flag, scope) | 20 sites |
| `ChangeNotifier` / `Provider` package / streams elsewhere | — | 0 |

`autoDispose` is used on 11 providers; `family` on 7. `retry:` (returning null, to defeat Riverpod 3's default auto-retry so error states actually render) is set on 6 providers and **missing on 10** that can fail. `.select()` is used 0 of ~69 `ref.watch` sites (a documented, deliberately un-mechanised rule).

### 5.2 How state travels

```
ref.watch(provider)  ──► AsyncValue<T> ──► (per feature) ScreenState<T> ──► StateWidget ──► child widgets
      ▲                                                                              │
      │                                                                              ▼
notifier.method()  ◄──────────────────────── user gesture ◄────────────────────── Consumer*Widget
      │
      └─► repository → Dio → typed AppException ──► AsyncValue.guard → AsyncError(e) → ScreenError/ScreenOffline
```

Cross-feature reads are explicit: Profile, Leaderboard and Home all read `meProvider`; Settings writes through `editProfileProvider`; Quiz invalidates `meProvider`; the session scope invalidates eleven providers.

### 5.3 Inconsistencies (reported, judged where clear)

| Observation | Assessment |
| --- | --- |
| Home hand-rolls `AsyncValue.when` + private `_Failure`/`_Block`; catalog, profile, edit-profile, settings, leaderboard use `ScreenState` → `StateWidget` | Clear architectural drift against `state_widget.dart`'s own rule; already K-31 in the fix queue |
| Four near-identical "icon + line + retry" widgets and three skeleton blocks | Duplication, not a bug |
| `retry:` present on 6 fail-able providers, absent on 10 | A real behavioural inconsistency — a failed reference load may never show its error view on a device |
| `OtpNotifier` and `EditProfileNotifier` both use a `_disposed` flag, but OTP touches `ref` after `await` before checking it | Confirmed defect (W3-1) |
| `LeaderboardNotifier.refresh()` calls `build()` directly, re-registering `onDispose` each time | Hygiene |
| `QuizState` is a hand-written sealed hierarchy without `==`; `QuizSession` is freezed | Deliberate and documented |

---

## 6. API / Backend Workflow

### 6.1 The path of a request

```
UI ─► Notifier/Bloc ─► Repository (one per feature; only place that touches Dio)
  ─► dioProvider Dio  [AuthInterceptor.onRequest: + Bearer]
  ─► HTTPS  https://level-up-backend-staging.up.railway.app/api/v1  (dev & staging; prod = TBD.example)
  ─► response
       2xx ─► res.data (Map/List) ─► freezed/json_serializable fromJson ─► model ─► Repository returns it
       non-2xx ─► [AuthInterceptor.onError: 401 refresh/retry/forceLogout]
              ─► [ErrorInterceptor.onError: DioException → typed AppException on DioException.error]
              ─► Repository `_asAppException` unwraps and rethrows the typed error
       parse failure (TypeError/FormatException outside Dio) ─► wrapped as UnknownException(detail:'parse: <type>')
  ─► Notifier: AsyncValue.guard / try-catch → state
  ─► UI: isOffline(error) → Offline view · ApiException.code → localized copy via *_error_copy.dart
```

### 6.2 Client

`DioClient.create` (`lib/core/network/dio_client.dart`): `BaseOptions(baseUrl, connectTimeout 15 s, receiveTimeout 20 s, Content-Type json)`, interceptors `[AuthInterceptor, ErrorInterceptor]` in that order. `DioClient.createBare`: `ErrorInterceptor` only (refresh). No logging interceptor anywhere (minors' data — enforced by `avoid_print` and review).

### 6.3 Error model

`lib/core/network/exceptions.dart` — sealed `AppException(code, detail)`:
`OfflineException('offline')`, `NetworkException('network_error')` (connection/timeouts), `ApiException(status, code)`, `UnauthorizedException(401)`, `ValidationException(400, errors: field→[messages])`, `RateLimitedException(429, retryAfter from delta-seconds header only)`, `UnknownException`. `ErrorInterceptor` maps by status + ProblemDetails `code`; anything unmapped becomes `ApiException(status, code)` so the code is carried through. `ProblemDetails.traceId` is never read (K-15). Copy mapping lives per feature in `auth_error_copy.dart`, `registration_error_copy.dart`, `profile_error_copy.dart`, `quiz_error_copy.dart`.

### 6.4 Endpoints consumed

| Operation | Stability | Consumer | Verified on staging (2026-09-04, backend `78c6e5d`) |
| --- | --- | --- | --- |
| `POST /auth/otp/request` · `/verify` · `/refresh` · `/logout` | stable | `AuthRepository` | ✅ decoded |
| `POST /auth/register` | stable | `RegistrationRepository` | ⏸ probe skipped (number already registered) |
| `GET /reference/countries` · `/countries/{cc}/governorates` · `/cities` · `/schools` · `/education-systems` · `/universities` · `/avatars` | stable | `ReferenceRepository` | ✅ all 7 decoded |
| `GET /me` | stable | `ProfileRepository` | ✅ decoded |
| `PATCH /me` | stable | `ProfileRepository` | ❌ **405** (route not implemented on staging) |
| `GET /me/entitlements` | stable | `ProfileRepository` (provider never read in-app) | ❌ **404** |
| `GET /catalog/subjects` | stable | `CatalogRepository` | ✅ `200 []` (no subjects seeded for the test cohort) |
| `GET /catalog/subjects/{id}/tree` | stable | `CatalogRepository` | ⏸ unreachable (empty catalog) |
| `POST /quizzes` · `/{id}/answers` · `/{id}/finish` · `GET /questions/{id}/explanation` | stable | `QuizRepository` | ⏸ unreachable (no questions to draw) |
| `GET /leaderboard` | draft in vendored 3.0.0-m1 · **stable upstream since 3.5.0-m1** | `LeaderboardRepository` (untracked) | never probed (upstream says verified on staging at `6744c43`) |

Score against the vendored pin: **21/21 stable operations have client code; 13/21 have decoded a real response; the 3.0.0-m1 `finish` body has never been observed on the wire.** The remaining draft operations (recovery ×4, avatar upload, FCM token, modules, quiz history/review, favorites ×3, subscription-code redemption `[web]`, `/leaderboard/me`) are untouched.

**Upstream drift (verified 2026-09-08).** The partner's repository is at `5b6e797` (v3.9.2-m1), 12 mirror commits past the pin: 38 operations, **25 stable**. New since the pin: leaderboard privacy/cursor/top-200/short-page rules (3.1–3.7), **both leaderboard operations stable** (3.5.0, 09-05), **account deletion `POST`/`DELETE /me/deletion-request` stable** (3.8.0, 09-07) with a global `403 account_pending_deletion` on every authenticated endpoint except four and an optional `StudentProfile.pendingDeletion`, `/leaderboard/me` `404 not_ranked` (3.9.0), and a red-flagged note (3.9.2, 09-08) that **`GET /questions/{id}/explanation` has never had a backend route** (`explanationAvailable` stays hard `false`; `GET /me/entitlements` is named as the other stable-but-unrouted operation). None of this is in `contract/`; the app has absorbed only the leaderboard list rules.

### 6.5 Serialization conventions

- freezed + json_serializable; **generated code is committed** (18 `.freezed.dart`, 16 `.g.dart`, 3 `app_localizations*.dart`); CI drift-checks them on `main` only.
- The wire is camelCase (adr-026) — **no `@JsonKey(name:)` bridges anywhere**; two skills still say snake_case (stale).
- Required contract fields are non-nullable with no defaults so drift throws (then is sealed as `UnknownException`).
- Unknown enum values: `EntitlementType` uses `unknownEnumValue`; `Track`, `QuizType` and `LeaderboardScope` are closed and throw.
- Hand-written serializers where freezed's envelope is wrong: `ProfileCity` union (discriminated on the presence of `id`), `ProfileUpdate`/`EmailPatch` (explicit `null`), `AuthResult` (`unionKey: 'result'`), `DateOnlyConverter` (`yyyy-MM-dd`).
- Optional request fields are omitted (`@JsonKey(includeIfNull: false)`, Dart null-aware map elements) — never sent as `null`.

### 6.6 Pagination and caching

Pagination is cursor-based via the shared `CursorPage<T>{items, nextCursor?, hasMore}` (defined in `registration/models/reference_models.dart`, reused by the leaderboard). Two consumers: school search (`SchoolSearchNotifier`, 350 ms debounce, scroll-append) and the leaderboard (infinite scroll). There is **no HTTP cache and no persistent cache**: session caching is the lifetime of non-`autoDispose` providers (`meProvider`, `subjectsProvider`, `subjectTreeProvider` family, the seven reference providers). Avatars use `cached_network_image` with `memCacheWidth` at 4 of 5 sites.

### 6.7 The dev mock

`lib/main_mock.dart` + `lib/dev/mock_backend.dart` replace `dioProvider` with a canned interceptor answering the stable surface (OTP `000000` = school student, `111111` = university, anything else → registration fork). It is strict where the server is strict (rejects `schoolName`, both cities), covers the quiz loop and error triggers, and is exercised by `test/dev/*`. It has **no `PATCH /me` and no `/leaderboard` handler**, awards points at finish rather than at answer (contract says at answer), and contains hardcoded OTPs plus a real-looking phone number. It is excluded from production by convention only (proven absent from the 2026-09-05 prod APK/AAB by string scan; no guard prevents `flutter build -t lib/main_mock.dart`).

---

## 7. UI Architecture

### 7.1 Layers

- **Screens** — one per route, `ConsumerWidget`/`ConsumerStatefulWidget` when they touch a provider, `StatelessWidget` otherwise (account shells, quiz result). 24 files hold Consumer widgets; 61 files hold `StatelessWidget`s.
- **Feature widgets** — `lib/features/<f>/widgets/` (catalog cards/rows/skeletons, profile rows/cards/sheets, quiz renderer/option tile/explanation panel/limit sheet, leaderboard podium/row/avatar/toggle, registration fields/pickers/chrome, settings rows/sections, home header/banner/level card).
- **Shared widgets** — `lib/core/widgets/`: `StateWidget` (the intended single `ScreenState` switch), `OfflineBanner`, `CircleBackButton` (Figma `90:208` chip, mirrored per direction), `LanguagePill`, `TitledChrome` (Account cluster title bar), `form_fields.dart` (`FieldLabel`, `FieldShell`, `InlineFieldError`, `PlainTextField`).
- **Shell** — `MainShell`: hand-painted notched bar (`CustomPainter` + `CustomClipper`, parametric path so the notch stays circular at any width), five SVG glyphs, centre Learn tab raised into the notch and selected by fill.

### 7.2 Design system

| Concern | Implementation | Enforcement |
| --- | --- | --- |
| Colour | `AppColors` ThemeExtension (~60 tokens, light + dark, every value annotated with its Figma node) + `Brand` seeds + `colorScheme` slots | `palette_discipline_test.dart`: zero hex / `Colors.black|white` / `SystemUiOverlayStyle` outside `lib/core/theme/` (+ `lib/app.dart`) |
| Typography | `AppType` — 18 designer styles; `AppTheme.textTheme` bridge; colour applied at call sites only | `typography_discipline_test.dart`: zero `fontSize:`/`fontWeight:` outside the theme; scale locked to `{28,24,20,18,16,14,12,11,10}`; no `fontFamily` on a style |
| Spacing / radii | ad hoc constants per widget, read from frames (20 dp gutters, r20 buttons, r16 fields, 60 dp buttons) | none (human review) |
| Surfaces | `dialogTheme` / `datePickerTheme` pinned to `cardFill` with no surface tint (one dialog system) | golden tests (18 PNGs, light + dark, EN only) |
| Icons/assets | 14 SVGs (`assets/icons`, `/nav`, `/images`), all referenced; 10 bundled TTFs (Cairo ×3 effectively unreachable behind Tajawal) | `docs/ASSET_MANIFEST.md` |

### 7.3 Responsive behaviour and accessibility

No breakpoints and no tablet layout; screens are single-column with `SafeArea` and `SingleChildScrollView`. `docs/RESPONSIVE.md` (eight rules incl. a `textScaler` clamp at 1.3) is **proposed, not applied** — the clamp is a pending product decision (K-11), and three known overflow defects trigger between 1.2× and 1.3× text scale (K-8, K-9). Touch targets and semantics labels are generally present (`Semantics(button/selected/readOnly)`, screen-reader sentence for the OTP timer). No test renders at a non-default text scale.

### 7.4 RTL / LTR

Arabic is the baseline. Every inset is directional; the back chevron flips per `Directionality`; phone/OTP inputs are forced LTR; Arabic digits are folded on input. Functional RTL is asserted in 19 widget-test files; **pixel-level RTL coverage is zero** (all 18 goldens are `Locale('en')`). Known RTL debt: Arabic renders Latin digits (#19), Tajawal has no w600 face so 45 semibold sites fall back (K-10).

---

## 8. Testing Workflow

### 8.1 Layout and kinds

```
test/
├── core/        11 files — converters, interceptors (real Dio + stubbed adapter), preferences, router redirect,
│                secure storage, session isolation (A logs out, B signs in), 3 discipline guards
├── dev/          4 files — the mock backend driven through a real Dio (contract conformance of the harness)
├── features/    44 tests + 9 harnesses/fixtures — notifier tests (ProviderContainer), widget tests, and
│                router-driven flow tests through the REAL routerProvider + nav bar
├── goldens/      2 files (5 declarations → 18 PNGs, light+dark, EN only), @Tags(['golden'])
├── guards/       rules.dart (pure detectors) · rules_test (23 fixture cases) · project_rules_test (ratchets)
│                · workflow_test (CI/hooks/scripts/release-command guards)
└── widget_test.dart — placeholder `1 + 1 == 2`
```

Counts: 467 `test(`, 361 `testWidgets(`, 31 `blocTest(` declarations → **890 cases** at the last run. No `integration_test/` directory, no `skip:`, no `@Skip`.

### 8.2 How the API is mocked

mocktail mocks **at the repository boundary** for feature tests (`MockAuthRepository`, `MockProfileRepository`, `MockCatalogRepository`, `MockQuizRepository`, `MockLeaderboardRepository`, `MockReferenceRepository`); a real `Dio` with a stubbed adapter for repository and interceptor tests; `lib/dev/mock_backend.dart` only for `test/dev/*`. Harnesses (`catalog_harness`, `quiz_harness`, `profile_harness`, `settings_harness`, `registration_harness`, `golden_harness`) build a `ProviderContainer` with overrides, call `markAuthenticated()`, and pump `MaterialApp.router` (or `LevelUpApp` itself for settings). `RecordingScreenProtection` counts FLAG_SECURE on/off.

### 8.3 The guard suite (rules that are tests)

Bloc containment · no provider write in `initState` · autoDispose notifiers carry a disposal flag · `Text('literal')` ratchet (**4**) · hardcoded `fontSize` ratchet (**0**) · ARB key parity · palette discipline · typography discipline · session-scope inventory (+ both sign-out paths call it, `forceLogout` keeps its re-entry guard) · CI discovers tests by tree, not path · goldens tagged · single SDK pin · release manifest declares `INTERNET` and CI inspects the APK · release commands name `lib/main_prod.dart` (+ positive companion) · NUL-safe scripts · ASCII-only PowerShell. `tool/verify_guards.ps1` proves each guard fires in isolation (three-point probe, SHA-verified restore).

### 8.4 Important tested flows

login → OTP → `/register` → track through the real router (BUG-001 regression) · concurrent 401s share one refresh · session isolation and idempotent forced logout · redirect matrix · the full quiz Bloc transition table incl. explanation polling and F-7-01 · screen protection on/off · every catalog drill-down through the nav bar in AR and EN · PATCH /me email tri-state end to end · theme/locale persistence incl. a corrupt preferences file · leaderboard paging, expired cursor, per-scope isolation, no auto-retry · mock backend contract strictness.

### 8.5 Important untested flows

pressing OTP Resend · dispose-mid-`await` races (W3-1 class, structural guard only) · cold start with a persisted token · Arabic/RTL pixels (0 goldens) · text scaling (0 tests) · deep/cold links to `/otp`, `/quiz/setup`, `/quiz/:id/result` · real `screen_protector` channel · real-network 401→refresh pipeline (only the out-of-suite smoke harness) · leaderboard repository and scroll-triggered `loadMore` · `_QuizUnavailableScreen` · registration school-search sheet widget · `registration_error_copy.dart`.

### 8.6 The validation loop

`tool/validate.ps1` (or `.sh`) = `pub get` → `dart format --set-exit-if-changed` (hand-written files only) → `flutter analyze` → `flutter test` (goldens included on Windows), writing `.ai/audits/current/test-results.md`. The same definition runs in `.githooks/pre-push` (opt-in; **not enabled on this clone** — `core.hooksPath` is unset) and in `.github/workflows/ci.yml` (analyze+test on every push/PR to `dev`/`main`/`merged`; advisory Windows goldens job; codegen drift and unsigned release-APK compile gate with `aapt2` INTERNET proof on `main` only). `merged` is fully pushed (`origin/merged` == HEAD), so CI runs should exist for the 2026-09-04 push — **no run has been inspected and this audit could not reach GitHub Actions** (R-3 stays open at "unobserved").

---

## 9. Complete Frontend Architecture Diagram

```
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  ENTRYPOINTS   main.dart→main_dev · main_staging · main_prod · main_mock (dioProvider override) │
└───────────────────────────────────────────┬──────────────────────────────────────────────────┘
                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  BOOTSTRAP     AppConfig.init(flavor) → PreferencesStore.load() → ProviderScope(overrides)     │
│  ROOT          LevelUpApp: MaterialApp.router · AppTheme light/dark · AppLocalizations ar/en    │
└───────────────────────────────────────────┬──────────────────────────────────────────────────┘
                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  ROUTING       GoRouter (routerProvider) · authRedirect(AuthStatus) · StatefulShellRoute ×5    │
│                pre-auth: / /login /otp /register/**   shell: /home /leaderboard /learn/** /message /account │
│                outside shell: /quiz/** /profile/** /settings /refer /support /friends /legal/** │
└──────┬─────────────────┬──────────────────┬──────────────────┬──────────────────┬────────────┘
       ▼                 ▼                  ▼                  ▼                  ▼
┌────────────┐  ┌───────────────┐  ┌───────────────┐  ┌────────────────┐  ┌───────────────────┐
│ onboarding │  │ auth          │  │ registration  │  │ home · catalog │  │ profile · settings │
│ shell      │  │ login · otp   │  │ 4 screens     │  │ quiz (Bloc)    │  │ account_shells     │
│            │  │               │  │ 7 pickers     │  │ leaderboard*   │  │                    │
└────────────┘  └──────┬────────┘  └──────┬────────┘  └──────┬─────────┘  └─────────┬─────────┘
   PRESENTATION: Consumer widgets · feature widgets · core/widgets (StateWidget, OfflineBanner, chrome)
                       ▼                  ▼                  ▼                    ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  STATE         Riverpod: Notifier ×5 · AsyncNotifier ×10 · FutureProvider ×8 · StreamProvider ×1 │
│                Bloc: QuizBloc (quiz session only, guard-enforced)                               │
│                AuthController = auth truth · invalidateSessionScope = session inventory         │
│                AsyncValue → ScreenState{loading,empty,loaded,error,offline} → StateWidget        │
└───────────────────────────────────────────┬──────────────────────────────────────────────────┘
                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  DATA          Repositories ×6 (auth, reference, registration, profile, catalog, quiz) + leaderboard* │
│                freezed/json_serializable models (camelCase, committed codegen) · CursorPage<T>  │
└───────────────────────────────────────────┬──────────────────────────────────────────────────┘
                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  NETWORK       dioProvider  [AuthInterceptor: Bearer · 401 single-flight refresh · forceLogout] │
│                             [ErrorInterceptor: DioException → sealed AppException]              │
│                refreshDioProvider (bare)      isOnlineProvider (connectivity_plus)               │
└───────────────────────────────────────────┬──────────────────────────────────────────────────┘
                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  STORAGE       SecureStorage (tokens, device_id) · PreferencesStore (theme, locale) · memory   │
└───────────────────────────────────────────┬──────────────────────────────────────────────────┘
                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────┐
│  BACKEND       Seif's API — contract/openapi.yaml 3.0.0-m1 (21 stable · 15 draft)              │
│                staging: level-up-backend-staging.up.railway.app/api/v1 (13/21 stable verified)  │
│                prod: TBD.example (placeholder)   realtime (SignalR): not drafted                │
└──────────────────────────────────────────────────────────────────────────────────────────────┘
   * untracked, uncommitted, built against upstream contract 3.7.0-m1 while the repo still pins 3.0.0-m1
```

---

## 10. Appendix — where to look first

| Question | File |
| --- | --- |
| What is true right now | `docs/WAVE_STATUS.md`, `docs/RISKS.md`, `.ai/audits/current/known-issues.md` |
| Why a decision was made | `docs/DECISIONS.md` (D-001…D-007), `docs/KNOWN_BUGS.md` (BUG-001) |
| What the design cannot supply | `docs/DESIGN_ISSUES.md` (#1…#51) |
| What the backend still owes | `docs/seif_fight.md` Part B (S1…S41), `zna.md` |
| Which contract commit is pinned | `contract/SOURCE.md` (`184d6ec`, 3.0.0-m1 — upstream `main` is `5b6e797`, 3.9.2-m1; re-vendor before building anything new) |
| The quality gate | `tool/validate.ps1` · `tool/verify_guards.ps1` · `.github/workflows/ci.yml` |
| Release/store state | `docs/STORE_READINESS_AUDIT_2026-09-05.md` (verdict: NOT READY) |
| Run it without a backend | `flutter run -t lib/main_mock.dart` (OTP `000000` school / `111111` university) |
| Run it against staging | `flutter run -t lib/main_dev.dart` (test number `+2010000000001`) |
| Build a release | `flutter build apk --release -t lib/main_prod.dart` (unsigned until `android/key.properties` exists; prod URL is a placeholder) |
