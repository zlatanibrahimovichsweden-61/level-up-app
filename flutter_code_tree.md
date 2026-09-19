# Level Up — Flutter code tree & contract status

**Generated 2026-09-19** from the source at `HEAD 9f415dd` plus the session's uncommitted
elevation work. It is a **snapshot**, not a live view: re-generate it rather than hand-editing it
when the tree moves.

Two things live here, deliberately together:

1. **The architecture** — every module, what it is for, and the files that make it up (38
   modules).
2. **The API reality** — every operation in the pinned contract, and whether this app actually
   calls it.

---

## How to read the status badges

The two axes are **independent** and must not be collapsed into one another. An operation can be
perfectly stable in the contract and never called by the app; it can be called by the app while
still marked draft.

| Badge | Meaning |
| --- | --- |
| 🟢 **STABLE CONTRACT** | the operation carries `x-stability: stable` at the pinned contract commit |
| 🔵 **LIVE API CONNECTED** | the app has a complete call path and really issues this request at runtime |
| 🟡 **STABLE BUT NOT LIVE** | stable in the contract, but the app does not call it today |
| 🟠 **DRAFT / MOCK / NOT READY** | present in the contract or the code, but not stable / not runtime-ready |
| ⚪ **NO API / LOCAL ONLY** | local functionality, or a client path that never fires |

**"Live" means the whole chain exists and a user can reach it**, traced forwards:

```
screen (or router redirect / app-start bootstrap)
  → Riverpod provider / notifier, or a Bloc
    → repository method
      → Dio client
        → endpoint
```

A repository method that compiles is **not** evidence of a live connection. Each verdict below was
traced in both directions.

---

## Contract source of truth

| | |
| --- | --- |
| Vendored from | `https://github.com/seifhamdii-collab/level-up-contract` |
| **Pinned commit** | **`2dca3c5`** |
| **`info.version`** | **`3.13.0-m1`** |
| Vendored on | 2026-09-12 |
| Previous pin | `184d6ec` (v3.0.0-m1) |

Counted from `contract/openapi.yaml` structurally for this document — operation keys at indent 4
under a path key at indent 2 — **not** by grepping `x-stability: stable`, which over-counts because
the string also appears in header prose and inside a `description`.

**29 stable · 13 draft · 42 total.** That matches `contract/SOURCE.md`'s own census exactly.

### Totals at a glance

| | Count |
| --- | --- |
| 🟢 Stable in contract | **29** |
| 🟢🔵 Stable **and** live-connected | **21** |
| 🟡 Stable but **not** live | **8** |
| 🟠 Draft in contract | **13** |
| 🔵 Live call paths traced in the app | **21** |
| ⚪ Client path exists but is gated | **2** |
| ⚪ Repository method never reached | **1** |
| Client calls matching no contract operation | **0** |

---

## Every contract operation


### `/auth`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟢🔵 | `logout` | `POST /auth/logout` | 🟢 stable | 🔵 LIVE | lib/features/auth/repository/auth_repository.dart:109 | One of the exact four operations exempt from 403 account_pending_deletion during the 30-day grace window (adr-114) |
| 🟢🔵 | `requestOtp` | `POST /auth/otp/request` | 🟢 stable | 🔵 LIVE | lib/features/auth/repository/auth_repository.dart:31 |  |
| 🟢🔵 | `verifyOtp` | `POST /auth/otp/verify` | 🟢 stable | 🔵 LIVE | lib/features/auth/repository/auth_repository.dart:58 |  |
| 🟠 | `confirmRecovery` | `POST /auth/recovery/confirm` | 🟠 draft | ⚪ not called | — |  |
| 🟠 | `submitNewPhone` | `POST /auth/recovery/new-phone` | 🟠 draft | ⚪ not called | — |  |
| 🟠 | `startRecovery` | `POST /auth/recovery/start` | 🟠 draft | ⚪ not called | — | Part of the anonymous-recovery carve-out described at line 804 |
| 🟠 | `verifyParentOtp` | `POST /auth/recovery/verify-parent` | 🟠 draft | ⚪ not called | — |  |
| 🟢🔵 | `refreshTokens` | `POST /auth/refresh` | 🟢 stable | 🔵 LIVE | lib/features/auth/repository/auth_repository.dart:86 (on the BARE refreshDioProvider |  |
| 🟢🔵 | `completeRegistration` | `POST /auth/register` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/registration_repository.dart:39 |  |

### `/catalog`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟠 | `listModules` | `GET /catalog/modules` | 🟠 draft | ⚪ not called | — | Contract states the module overlay 'is not implemented yet' and `subjectIds` may become embedded objects (line 1114); build the stable 'All subjects' view first, do not ship a module-only picker |
| 🟢🔵 | `listSubjects` | `GET /catalog/subjects` | 🟢 stable | 🔵 LIVE | lib/features/catalog/repository/catalog_repository.dart:26 | x-behaviour-changed: 2.3.0-m1 (openapi.yaml:997). Empty catalog is legal before Term 1 start — 'Clients MUST NOT render empty-as-error' (line 1026) |
| 🟢🔵 | `getSubjectTree` | `GET /catalog/subjects/{subjectId}/tree` | 🟢 stable | 🔵 LIVE | lib/features/catalog/repository/catalog_repository.dart:53 | x-behaviour-changed: 2.3.0-m1 (openapi.yaml:1057). Per SOURCE.md, 3.12.0-m1 added `hasFlashcards` to UniversitySubjectTree lectures only — deliberately NOT on SchoolSubjectTree |

### `/flashcards`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟡 | `setFlashcardSelfGrade` | `PUT /flashcards/cards/{flashcardId}/self-grade` | 🟢 stable | ⚪ not called | — | Newly stable at this pin (3.13.0-m1). Contract notes four indistinguishable 403/404 causes (line 1593) |
| 🟡 | `getFlashcardsForLecture` | `GET /flashcards/lectures/{lectureId}/cards` | 🟢 stable | ⚪ not called | — | Newly stable at this pin (3.13.0-m1); surface itself added draft in 3.12.0-m1. 403 codes include flashcard_subscription_required alongside insufficient_scope and account_pending_deletion (line 1531) |

### `/leaderboard`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟡 | `getLeaderboard` | `GET /leaderboard` | 🟢 stable | ⚪ gated | lib/features/leaderboard/repository/leaderboard_repository.dart:50 | x-behaviour-changed: 3.4.0-m1 (openapi.yaml:1638). Newly stable at this pin (3.5.0-m1). Bounded to AT MOST the top 200 visible students ever, so `isMe` may never appear — 'DO NOT page looking for isMe' (line 1665). Since 3.7.0-m1 a page may return FEWER rows than `limit`, including zero, while hasMore is true — keep paging until hasMore is false. Cursor is a signed, expiring token (3.1.0-m1): do not decode, build or persist. 403 account_pending_deletion DECLARED from 3.5.1-m1 but REACHABLE since 3.3.0-m1 (line 1731). Gated client-side by DECISIONS.md D-008, which SOURCE.md says now needs an explicit re-decision |
| 🟡 | `getMyRank` | `GET /leaderboard/me` | 🟢 stable | ⚪ not called | — | x-behaviour-changed: 3.9.0-m1 (openapi.yaml:1743). Newly stable at this pin (3.5.0-m1). 404 not_ranked for a student who has never scored — ordinary state, not an error and not a missing endpoint. 403 score_hidden_leaderboard_unavailable for a scoreHidden caller (adr-113). Rank is exact and UNCAPPED — unaffected by the 200-row display bound. 403 account_pending_deletion DECLARED from 3.5.1-m1 but REACHABLE since 3.3.0-m1 (line 1805) |

### `/me`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟢🔵 | `getMyProfile` | `GET /me` | 🟢 stable | 🔵 LIVE | lib/features/profile/repository/profile_repository.dart:27 | One of the exact four operations exempt from 403 account_pending_deletion (adr-114) |
| 🟢🔵 | `updateMyProfile` | `PATCH /me` | 🟢 stable | 🔵 LIVE | lib/features/profile/repository/profile_repository.dart:57 | Staging observation 2026-09-04 (smoke-staging-2026-09-04.md): answers 405 on staging — stable in contract, not served there |
| 🟠 | `uploadCustomAvatar` | `PUT /me/avatar` | 🟠 draft | ⚪ not called | — |  |
| 🟡 | `requestAccountDeletion` | `POST /me/deletion-request` | 🟢 stable | ⚪ not called | — | Newly stable at this pin (3.8.0-m1); exempt from 403 account_pending_deletion (adr-114); answers seif_fight S38 |
| 🟡 | `cancelAccountDeletion` | `DELETE /me/deletion-request` | 🟢 stable | ⚪ not called | — | Newly stable at this pin (3.8.0-m1); exempt from 403 account_pending_deletion (adr-114) |
| 🟡 | `getMyEntitlements` | `GET /me/entitlements` | 🟢 stable | ⚪ not reached | lib/features/profile/repository/profile_repository.dart:80 | Staging observation 2026-09-04: answers 404 on staging — stable in contract, not served there |
| 🟠 | `listFavorites` | `GET /me/favorites` | 🟠 draft | ⚪ not called | — |  |
| 🟠 | `registerFcmToken` | `PUT /me/fcm-token` | 🟠 draft | ⚪ not called | — |  |
| 🟢🔵 | `getMyMistakes` | `GET /me/mistakes` | 🟢 stable | 🔵 LIVE | lib/features/mistakes/repository/mistakes_repository.dart:50 | Newly stable at this pin (shipped stable-on-arrival in 3.10.0-m1, adr-133). Empty is a NORMAL response — 'Clients MUST NOT' treat empty as error (line 896). Per SOURCE.md/S44 the only staging test account has an empty catalog, so this can only ever answer empty there |
| 🟢🔵 | `getMyMistakesForSubject` | `GET /me/mistakes/subjects/{subjectId}` | 🟢 stable | 🔵 LIVE | lib/features/mistakes/repository/mistakes_repository.dart:82 | Newly stable at this pin (3.10.0-m1, adr-133). 403 insufficient_scope and 403 account_pending_deletion are deliberately indistinguishable causes — read `code` (line 991) |

### `/questions`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟡 | `getExplanation` | `GET /questions/{questionId}/explanation` | 🟢 stable | ⚪ gated | lib/features/quiz/repository/quiz_repository.dart:151 | KNOWN NO BACKEND ROUTE (openapi.yaml:1360): 'DELIBERATELY UNIMPLEMENTED - there is no backend route for this operation today, and a call to it will not succeed.' Published stable on purpose and explicitly NOT being demoted (owner ruling 2026-09-08, ADR-123; flagged in changelog 3.9.2-m1). Model against the shape but do not put it on a user-facing path; `AnswerResult.explanationAvailable` is a hard false until it ships |
| 🟠 | `addFavorite` | `PUT /questions/{questionId}/favorite` | 🟠 draft | ⚪ not called | — |  |
| 🟠 | `removeFavorite` | `DELETE /questions/{questionId}/favorite` | 🟠 draft | ⚪ not called | — |  |

### `/quizzes`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟢🔵 | `createQuiz` | `POST /quizzes` | 🟢 stable | 🔵 LIVE | lib/features/quiz/repository/quiz_repository.dart:52 | x-behaviour-changed: 3.11.0-m1 (openapi.yaml:1144) — re-stamped per adr-136 on adr-135. `mode: retakeWrong` now takes an optional leaf id (lessonId school / lectureId university, never both) that NARROWS the pool. Description also still carries the earlier 2.3.0-m1 behavioural note (adr-091). SOURCE.md flags this as the one behavioural delta touching already-shipped code: lib/features/quiz/repository/quiz_repository.dart — zero build signal |
| 🟠 | `listQuizHistory` | `GET /quizzes` | 🟠 draft | ⚪ not called | — |  |
| 🟠 | `getQuizReview` | `GET /quizzes/{quizId}` | 🟠 draft | ⚪ not called | — |  |
| 🟢🔵 | `submitAnswer` | `POST /quizzes/{quizId}/answers` | 🟢 stable | 🔵 LIVE | lib/features/quiz/repository/quiz_repository.dart:93 |  |
| 🟢🔵 | `finishQuiz` | `POST /quizzes/{quizId}/finish` | 🟢 stable | 🔵 LIVE | lib/features/quiz/repository/quiz_repository.dart:117 |  |

### `/reference`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟢🔵 | `listDefaultAvatars` | `GET /reference/avatars` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:175 |  |
| 🟢🔵 | `listCities` | `GET /reference/cities` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:72 |  |
| 🟢🔵 | `listCountries` | `GET /reference/countries` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:26 |  |
| 🟢🔵 | `listGovernorates` | `GET /reference/countries/{countryCode}/governorates` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:46 |  |
| 🟢🔵 | `listEducationSystems` | `GET /reference/education-systems` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:135 |  |
| 🟢🔵 | `searchSchools` | `GET /reference/schools` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:105 |  |
| 🟢🔵 | `listUniversities` | `GET /reference/universities` | 🟢 stable | 🔵 LIVE | lib/features/registration/repository/reference_repository.dart:155 |  |

### `/subscription-codes`

| | Operation | Endpoint | Contract | Runtime | Repository | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 🟠 | `redeemSubscriptionCode` | `POST /subscription-codes/redemptions` | 🟠 draft | ⚪ not called | — | Only purchase-adjacent operation in the contract; the app is purchase-silent (adr-049 §3) and it is draft regardless |

---

## Where "live" was genuinely hard to call

1. GET /questions/{questionId}/explanation — the hardest call. Every link in the client chain exists and a user does see the "explain" affordance, so a purely structural trace says LIVE. But QuizBloc gates the fetch on `grade.explanationAvailable` (quiz_bloc.dart:190) and the contract says that field is a hard `false` and the route has no backend implementation (openapi.yaml:1358-1369). I classified it PLACEHOLDER_GATED because zero requests are issued at runtime today, but the gate is *server data*, not a client feature flag — it is unlike the leaderboard, where a human must edit a line of router code. If your definition of "gated" requires a client-side gate, reclassify this as LIVE-but-never-fires.

2. POST /auth/refresh — no screen reaches it; it is issued by AuthInterceptor on 401. I called it LIVE under the brief's "router redirect / app-start bootstrap" allowance, since it fires in ordinary sessions the moment an access token expires. If you require a screen->provider->repository chain literally, it is unclassifiable by that rule rather than not-live.

3. GET /me/entitlements — I am confident the notifier is never built (no `watch`/`read`/`listen` anywhere; `ref.invalidate` on an unlistened provider is a no-op in Riverpod), so IMPLEMENTED_NOT_REACHED. The residual doubt is only about Riverpod 3 invalidate semantics, which I reasoned about rather than executed. I did not run the app; this is a SOURCE-level verdict, not DEVICE.

4. PATCH /me — LIVE by code path, but the memory record says staging answered 405 on 2026-09-04. "Reachable in a normal build" and "succeeds against the deployed server" are different claims; I graded reachability only.

5. Two near-duplicate school-search providers. `schoolsProvider` (reference_providers.dart:53) has zero consumers; `schoolSearchProvider` (school_search_notifier.dart:147) is the live one. I attributed searchSchools to the live one; the dead provider is worth a separate cleanup ticket.

6. Not listed because there is NO code at all (not even a repository method), so they are outside the four categories: getMyRank (`GET /leaderboard/me`) — deliberately never called, and the leaderboard repository's doc explains why (no synthetic self-rank row); requestAccountDeletion / cancelAccountDeletion (`/me/deletion-request`); getFlashcardsForLecture and setFlashcardSelfGrade (`/flashcards/*`). All four surfaces became stable at the current pin (contract/SOURCE.md) and have no client yet.

7. No UNMAPPED paths. All 23 Dio call sites in lib/ (plus the interceptor's `_retryDio.fetch` re-issue of an already-mapped request, auth_interceptor.dart:109) build literal paths that match a contract operationId exactly, and all 24 operations above are `x-stability: stable` at the current pin.

8. Verification level: SOURCE only. I read the code, the router and the contract; I did not build, run, or exercise the app, and I made no edits to the repository.

### The mock backend

`lib/dev/mock_backend.dart` (1901 lines) is a hand-rolled Dio `Interceptor` that short-circuits every request with canned, contract-shaped JSON before it reaches a socket. `buildMockDio()` (mock_backend.dart:46) builds a Dio with baseUrl `http://mock.local/api/v1` and a two-interceptor chain: MockBackendInterceptor then the REAL ErrorInterceptor (so non-2xx still map to the typed AppException hierarchy). There is no AuthInterceptor in the mock chain.

WHEN IT IS ACTIVE: only under `lib/main_mock.dart`, and only via one line — `dioProvider.overrideWith((ref) => buildMockDio())` at main_mock.dart:63. No file under lib/features or lib/core references the mock; the override is the whole injection. main_mock.dart is explicitly "NOT a shipping flavor" (its own header) and it also clears stored tokens on launch (`kResetSessionOnLaunch = true`, main_mock.dart:40,49). Note it still calls `AppConfig.init(Flavor.dev)` because `refreshDioProvider` is NOT overridden — so a POST /auth/refresh under the mock would go to the real staging host; in practice the mock never answers 401, so that path is unreachable there.

The three shipping entrypoints — main_dev.dart, main_staging.dart, main_prod.dart — all call `bootstrap(flavor)` (lib/bootstrap.dart:10), which overrides only `preferencesStoreProvider`. `lib/main.dart` just forwards to main_dev. AppConfig (lib/core/config/app_config.dart:51-55) resolves dev AND staging to the real host `https://level-up-backend-staging.up.railway.app/api/v1`; prod is still the placeholder `https://TBD.example/api/v1` with a do-not-ship TODO.

DOES IT CHANGE ANY VERDICT? No. Nothing in the list above is MOCK_ONLY. Every LIVE verdict rests on a shipping entrypoint pointed at the real staging server, which the brief counts as LIVE. The mock is strictly a subset: it answers 24 route patterns (mock_backend.dart:130-401) and 404s everything else with `No mock for {method} {path}`. It does NOT implement PATCH /me or GET /leaderboard, and it does implement GET /me/entitlements (:217) and GET /questions/{id}/explanation (:327) — but implementing them in the mock does not make them reachable, because the gaps for those two are on the client side (no watcher) and in the answer payload gate respectively, not in the transport.

---

## The module tree

Each block is one module: what it is for, its files, and the state, models, API and tests that belong to it. Paths are relative to the repository root.

### App entrypoints & root — `lib/main*.dart`, `lib/app.dart`

The three flavor entrypoints plus the root `MaterialApp.router`. Every `main_*.dart` is a two-line call into `bootstrap()`, which awaits `PreferencesStore.load()` **before** `runApp` so the first frame is already in the student's stored canvas and language; `LevelUpApp` then hands `MaterialApp.router` both themes, both locales and the app's single `SystemUiOverlayStyle`.

```
lib/
├── main.dart            # bare `flutter run` → delegates to main_dev
├── main_dev.dart
├── main_staging.dart
├── main_prod.dart
├── main_mock.dart       # device-walkthrough harness, not a shipping flavor
├── bootstrap.dart       # shared boot sequence for the three flavors
└── app.dart
```

- **Screens:** none — `app.dart` only mounts `routerProvider`.
- **Widgets:** `LevelUpApp` (`ConsumerWidget`); the `_lightOverlay` / `_darkOverlay` status-bar constants.
- **State:** Riverpod. `ProviderScope` is created here; `bootstrap()` overrides `preferencesStoreProvider`, `main_mock.dart` additionally overrides `dioProvider` with `buildMockDio()`. `LevelUpApp` watches `routerProvider`, `localeProvider`, `themeModeProvider`.
- **Tests:** none that boot the app. `test/widget_test.dart` is still the scaffold placeholder (`expect(1 + 1, 2)`); `test/guards/workflow_test.dart` is the only guard here — it fails any release command missing `-t lib/main_prod.dart`, because the flagless build compiles `lib/main.dart` and ships staging.
- Surprising: `bootstrap.dart` is the real shared entrypoint but sits outside the `main*`/`app*` naming; `main_mock.dart` clears tokens on every launch (`kResetSessionOnLaunch`) and is documented as deletable together with `lib/dev/mock_backend.dart`.

### core/config — `lib/core/config/`

Flavor enum plus the process-wide `AppConfig` singleton (base URL, `isDev`), initialised once per entrypoint before the app boots.

```
lib/core/config/
└── app_config.dart
```

- **Models:** `Flavor` (dev/staging/prod), `AppConfig`.
- **Repositories / API:** no calls — it supplies `baseUrl` to `DioClient`. `dev` and `staging` both resolve to the real staging host from the contract's `servers:` block; **prod is still the placeholder `https://TBD.example/api/v1`**, deliberately a reserved TLD so it fails closed.
- **Tests:** no dedicated test. Only touched indirectly by `test/dev/mock_backend_quiz_test.dart` and the release-target guard in `test/guards/workflow_test.dart`.
- Surprising: a mutable static singleton that throws `StateError` if read before `init()`, with no test pinning that behaviour.

### core/models — `lib/core/models/`

Two cross-feature primitives: the sealed screen-state union every data screen renders, and the `format: date` JSON converter.

```
lib/core/models/
├── screen_state.dart
└── date_only_converter.dart
```

- **Models:** `ScreenState<T>` sealed base with `ScreenLoading` / `ScreenEmpty` / `ScreenLoaded` / `ScreenError` (carries a localization *key*, not English) / `ScreenOffline`; `DateOnlyConverter` and `NullableDateOnlyConverter` (emit `yyyy-MM-dd` with no UTC conversion, so an Egyptian midnight birthday does not shift a day).
- **Tests:** `test/core/models/date_only_converter_test.dart`.
- Surprising: `ScreenState` is consumed by ~18 files under `lib/features/` and has **no test of its own** — it is only exercised through screen tests.

### core/network — `lib/core/network/`

The whole HTTP layer: two Dio builders and the two interceptors that make Dio invisible to the rest of the app.

```
lib/core/network/
├── dio_client.dart
├── exceptions.dart
└── interceptors/
    ├── auth_interceptor.dart
    └── error_interceptor.dart
```

- **Models:** the sealed `AppException` tree — `OfflineException`, `NetworkException`, `ApiException`, `UnauthorizedException`, `ValidationException` (holds the contract's `field -> [messages]` map; only field *names* are used, messages are never rendered or logged), `RateLimitedException` (`Retry-After`, delta-seconds only), `UnknownException`, plus the `isOffline(Object?)` helper.
- **Repositories / API:** `DioClient.create` (AuthInterceptor → ErrorInterceptor) and `DioClient.createBare` (ErrorInterceptor only). `AuthInterceptor` attaches the Bearer token on every request and, on 401, drives `POST /auth/refresh` through the bare client via an injected `TokenRefresher` closure — single-flight (`_refreshing`), retried at most once (`extra['__retried']`), and state-only: `session_superseded` / dead refresh call `AuthController.forceLogout` and let the router redirect, never navigating itself.
- **Tests:** `test/core/network/auth_interceptor_test.dart`, `test/core/network/error_interceptor_test.dart`.
- Surprising: `DioClient` itself has no direct test; the closure indirection exists purely to break the `dio → interceptor → repo → dio` construction cycle.

### core/providers — `lib/core/providers/`

Riverpod *is* the DI container here (no get_it). This folder holds the root dependency graph and the two device-preference controllers.

```
lib/core/providers/
├── core_providers.dart
├── locale_provider.dart
└── theme_provider.dart
```

- **State:** Riverpod throughout — `secureStorageProvider`, `preferencesStoreProvider` (nullable by design: unoverridden it is `null`, so widget tests need no plugin stub), `refreshDioProvider`, `dioProvider`, `connectivityProvider`, `isOnlineProvider` (`StreamProvider<bool>` off `connectivity_plus`, drives every Offline state); `LocaleController` / `localeProvider` (`NotifierProvider<…, Locale>`, AR default, `toggle()` + `select()`); `ThemeModeController` / `themeModeProvider` (`NotifierProvider<…, ThemeMode>`, light default, `select()` only — `ThemeMode.system` is never set).
- **Repositories / API:** `dioProvider` wires the live client and lazily reads `authRepositoryProvider` for the refresh closure; `refreshDioProvider` serves `POST /auth/refresh` alone.
- **Tests:** `test/core/preferences_store_test.dart` (both controllers' read/write round-trip), `test/features/settings/settings_screen_test.dart`, `test/core/session/session_scope_discipline_test.dart`.
- Surprising: both controllers write preferences fire-and-forget (`unawaited`) and rely on `PreferencesStore` swallowing its own failures; `dioProvider` needs an explicit left-side type annotation to break a static reference cycle with `authRepositoryProvider`.

### core/router — `lib/core/router/`

The single `GoRouter`: the auth redirect, the 5-branch `StatefulShellRoute`, and every route in the app.

```
lib/core/router/
└── app_router.dart
```

- **Screens:** two private ones live here — `_QuizUnavailableScreen` (cold deep-link to `/quiz/:quizId` with no `Quiz` in `extra`; unrecoverable by design because quiz state is memory-only) and `_Placeholder`.
- **State:** Riverpod `routerProvider` (`Provider<GoRouter>`); `AuthController` state is mirrored into a `ValueNotifier` fed to `refreshListenable`. `authRedirect(AuthStatus, String)` is a pure function, unit-tested directly: `AuthUnknown` waits, unauthenticated off an auth route → `/login`, authenticated sitting on `/` or `/login` → `/home`. The whole `/register*` wizard is pre-auth.
- **Routes:** `/`, `/login`, `/otp`, `/register`(+`/track`,`/school`,`/university`), `/track-select`, shell branches `/home` · `/leaderboard` · `/learn` (nested `mistakes/subject/:subjectId/unit/:unitId/chapter/:chapterId` and `subject/:subjectId/…`) · `/message` · `/account`, then outside the shell `/quiz/setup`, `/quiz/:quizId`(+`result`,`result/review`), `/profile`(+`edit`), `/settings`, `/refer`, `/support`, `/friends`, `/legal/privacy`, `/legal/terms`.
- **Tests:** `test/core/router/app_router_test.dart`; exercised further by `test/features/registration/registration_router_flow_test.dart` and `test/features/catalog/catalog_navigation_test.dart`.
- Surprising: three gates. `/track-select` is the last `_Placeholder`; `/leaderboard` serves `LeaderboardPlaceholderScreen` even though the real screen is built and tested, because `GET /leaderboard` is `draft` at the vendored pin; `/friends` is routed but has **no entry point** in the app — no frame draws the row.

### core/session — `lib/core/session/`

One function that drops every provider scoped to a single signed-in student, so the next student on a shared handset cannot see the previous one's data.

```
lib/core/session/
└── session_scope.dart
```

- **State:** `invalidateSessionScope(Ref)` invalidates `meProvider`, `entitlementsProvider`, `editProfileProvider`, `subjectsProvider`, `subjectTreeProvider`, `mistakesOverviewProvider`, `mistakesTreeProvider`, `loginProvider`, `otpProvider`, `registrationControllerProvider`, `registrationSubmitProvider`, `schoolSearchProvider`, `quizSetupProvider`. Deliberately excluded and documented: `authControllerProvider`, `localeProvider`/`themeModeProvider`, `deviceInfoProvider` + the `device_id`, and the seven reference providers.
- **Tests:** `test/core/session/session_isolation_test.dart`, plus `test/core/session/session_scope_discipline_test.dart` — a guard that fails when a new non-`autoDispose` notifier appears anywhere in `lib/features/` without being classified here.

### core/storage — `lib/core/storage/`

Two stores with deliberately different threat models: secrets in Keychain/Keystore, preferences in SharedPreferences.

```
lib/core/storage/
├── secure_storage.dart
└── preferences_store.dart
```

- **Models:** `SecureStorage` — `writeTokens` / `readAccessToken` / `readRefreshToken` / `clearTokens` / `clear` / `readOrCreateDeviceId` (32 hex chars). iOS uses `first_unlock_this_device` + `synchronizable: false` so a restored iCloud backup cannot carry a live session onto another phone; Android passes no options on purpose (`encryptedSharedPreferences` is deprecated in the 10.x backend). `PreferencesStore` — synchronous `readThemeMode` / `readLocale`, async `writeThemeMode` / `writeLocale`, every read and write wrapped so a damaged prefs file cannot block startup.
- **Tests:** `test/core/secure_storage_test.dart`, `test/core/preferences_store_test.dart`.
- Surprising: logout **must** use `clearTokens()`, never `clear()` — wiping `device_id` makes the next login look like a new device and mis-fires `session_superseded`. The theme is stored as a name, and `ThemeMode.system` *removes* the key rather than storing a third value.

### core/theme — `lib/core/theme/`

Every design token in the app: colours, type scale, and the full elevation/Glass model, all as `ThemeExtension`s so they switch with brightness. This is the one folder allowed to hold a raw hex or a `fontSize`.

```
lib/core/theme/
├── app_colors.dart       # 1,747 lines
├── app_typography.dart
├── app_theme.dart
├── app_elevation.dart    # 2,083 lines
└── glass_mapping.dart
```

- **Models:** `Brand` (green light / purple dark — two seeds, not one inverted), `AppColors extends ThemeExtension<AppColors>` with `.light` / `.dark`, `AppTheme.light` / `AppTheme.dark`, `abstract final class AppType` (the designer's verbatim scale, no `fontFamily` so the Tajawal/Cairo fallback survives for Arabic), `AppElevation extends ThemeExtension<AppElevation>` plus `FigmaShadow`, `GlassStyle` (G1–G20), `Backlight`, `ScrimStyle`, and the conversion constants in `glass_mapping.dart` (`kFigmaBlurToSigma`, `kGlassFrostToSigma`, `kGlassRim*`).
- **Tests:** `test/core/theme/app_colors_test.dart`, `app_elevation_test.dart`, `palette_discipline_test.dart`, `typography_discipline_test.dart`, `test/guards/project_rules_test.dart` (fontSize and raw-elevation ratchets, both at zero), `test/goldens/elevation_primitives_test.dart`.
- Surprising: `glass_mapping.dart` distinguishes *definitions* that must never be tuned (`kFigmaBlurToSigma = 0.5`, because Flutter's own `convertRadiusToSigma` is ~2x too soft at the 1.3px blur used on every back chip) from *calibrated* model constants; the two canvases elevate by different mechanisms — light by drop shadow, dark by Glass + lavender back-light — so an empty shadow list in dark is a reading, not a gap.

### core/widgets — `lib/core/widgets/`

Shared chrome used across features, plus `elevation/` — the only code in the app permitted to turn an elevation token into paint.

```
lib/core/widgets/
├── state_widget.dart
├── offline_banner.dart
├── titled_chrome.dart
├── circle_back_button.dart
├── language_pill.dart
├── form_fields.dart
└── elevation/
    ├── elevated_surface.dart
    ├── figma_shadow_painter.dart
    ├── glass_surface.dart
    ├── primary_cta.dart
    ├── segmented_track.dart
    └── app_modal.dart
```

- **Widgets:** `StateWidget<T>` (the only place that switches on `ScreenState`), `OfflineBanner`, `TitledChrome`, `CircleBackButton` + `BackChipVariant` (standard / registration), `LanguagePill`, and the form primitives `FieldLabel` / `FieldShell` / `InlineFieldError` / `PlainTextField`. Under `elevation/`: `ElevatedSurface`, `PrimaryCta` + `CtaTone`, `SegmentedTrack<T>` + `SegmentedTrackStyle`, `GlassBackdrop`, `paintFigmaShadows()`, and the modal entry points `showAppDialog<T>()` / `showAppModalSheet<T>()` (private `_BlurredDialogRoute` / `_BlurredModalBottomSheetRoute` override `ModalRoute.filter` for the scrim blur).
- **Tests:** `test/core/widgets/shared_chrome_test.dart`; `test/core/widgets/elevation/` — `elevated_surface_test.dart`, `figma_shadow_painter_test.dart`, `primary_cta_test.dart`, `segmented_track_test.dart`, `app_modal_test.dart`, `glass_rim_calibration_test.dart`; `test/goldens/cta_golden_test.dart`, `test/goldens/design_goldens_test.dart`; `test/features/elevation/cta_call_sites_test.dart`.
- Surprising: **`SegmentedTrack` has zero call sites in `lib/`** — its own doc names three screens (quiz-type tabs, leaderboard scope toggle, Settings › Language) and none of them use it yet; it exists only behind its test and the goldens. `StateWidget`, `TitledChrome` and `PlainTextField` have no test file of their own. `TitledChrome`'s doc records a known duplicate, `EditProfileChrome`, left uncollapsed on purpose.

### l10n — `lib/l10n/`

The AR/EN copy and its gen-l10n output. AR is the default locale and RTL comes free from the delegates; no user-facing string may exist outside these files.

```
lib/l10n/
├── app_en.arb              # 259 keys (template)
├── app_ar.arb              # 259 keys
├── app_localizations.dart      # generated, checked in
├── app_localizations_en.dart   # generated, checked in
├── app_localizations_ar.dart   # generated, checked in
└── .dart_tool/
    └── native_assets.yaml
```

- **Models:** `AppLocalizations` (+ `supportedLocales`, `localizationsDelegates`, `nullable-getter: false`, so `AppLocalizations.of(context)` is non-null), `AppLocalizationsEn`, `AppLocalizationsAr`. Config lives in `l10n.yaml` at the repo root.
- **Tests:** `test/guards/project_rules_test.dart` — two guards: all user-facing copy must go through `AppLocalizations`, and both ARB files must carry the same keys (`arbKeyDrift` in `test/guards/rules.dart`, proven to fire in `rules_test.dart`), because a missing Arabic key silently falls back to English rather than throwing.
- Surprising: the generated `app_localizations*.dart` (2,570 lines) are committed rather than built; `l10n.yaml`'s own comment still says the import path is `package:flutter_gen/gen_l10n/app_localizations.dart` while every file actually imports the checked-in `lib/l10n/app_localizations.dart`; and `lib/l10n/.dart_tool/native_assets.yaml` is a stray dartdev artifact sitting inside the ARB source directory.

### dev — `lib/dev/`

A hand-rolled Dio interceptor that answers the stable contract surface with canned, contract-faithful JSON, so the login → OTP → registration → Home → quiz walk runs on a real device with no server and no network.

```
lib/dev/
└── mock_backend.dart       # 1,901 lines
```

- **State:** none — injected by a single `dioProvider` override in `lib/main_mock.dart`. Nothing under `lib/core/` or `lib/features/` knows it exists.
- **Repositories / API:** `buildMockDio()` chains `MockBackendInterceptor` with the **real** `ErrorInterceptor`, so mock non-2xx responses map to the same typed `AppException`s as production. Endpoints served: `POST /auth/otp/request`, `/auth/otp/verify`, `/auth/refresh`, `/auth/register`, `/auth/logout`; `GET /reference/countries`, `/cities`, `/schools`, `/education-systems`, `/universities`, `/avatars`; `GET`+`PATCH /me`, `/me/entitlements`, `/me/mistakes`; `/catalog/subjects`; the `/quizzes` loop. Fixtures: `_countries`, `_egGovernorates`, `_allSchools`, `_universities`, `_subjects`, `_subjectTrees`, `_universitySubjectTrees`, `_avatars`, `_entitlements`, `_schoolMistakes*`, `_universityMistakes*`, `_MockQuiz`, and a cursor encoder for paginated reference lists.
- **Tests:** `test/dev/mock_backend_catalog_test.dart`, `mock_backend_profile_test.dart`, `mock_backend_quiz_test.dart`, `mock_backend_v11_test.dart`.
- Surprising: the mock is deliberately **strict, not permissive** — it rejects `schoolName` and both-cities exactly as the contract has since v1.1.0-m1, so a device walkthrough cannot accidentally confirm the old contract. Canned JSON is parsed by the real freezed models, so a model change breaking the mock is the harness working as intended. OTP `000000` signs in as a School student, `111111` as University, any other 6-digit code forks to registration.

### account_shells — `lib/features/account_shells/`

Four deliberately inert destinations for designed features that have **no endpoint at all** (seif_fight S5/S30/S33/S36). Each renders the frame's shape — title, icon, one line, the primary control greyed out — and invents no data: no referral code, no ticket, no friend row, no legal paragraph.

```
lib/features/account_shells/
├── screens/
│   ├── customer_support_screen.dart
│   ├── friends_screen.dart
│   ├── legal_document_screen.dart
│   └── refer_a_friend_screen.dart
└── widgets/
    └── shell_body.dart
```

- **Screens:** `CustomerSupportScreen` (`/support`), `ReferAFriendScreen` (`/refer`), `FriendsScreen` (`/friends`), `LegalDocumentScreen` (`/legal/privacy`, `/legal/terms`; one class, `LegalDocument` enum picks the title)
- **Widgets:** `ShellBody`, `DisabledActionButton` (hand-rolled instead of `FilledButton(onPressed: null)` so the disabled control has **no `InkWell` anywhere in its subtree** — that is what the tests assert)
- **State:** none. All four are `StatelessWidget`; no provider, no notifier, no repository.
- **Repositories / API:** none — that is the entire point of the module.
- **Tests:** `test/features/settings/shell_screens_test.dart`

Surprising: `FriendsScreen` **has no entry point** — the Profile hub draws ten rows and Friends is not one of them, so it is reachable only by typing the route (`app_router.dart:364` routes it purely so it is testable). `LegalDocumentScreen` is the only one blocked on *content*, not on Seif. Its tests live under `test/features/settings/`, not a folder of its own.

---

### auth — `lib/features/auth/`

Phone-first sign-in: request an OTP, verify it, and let the **server** fork the student into `/home` or `/register`. Also owns the app-wide session: token storage, silent refresh and the logout reason.

```
lib/features/auth/
├── auth_error_copy.dart
├── models/
│   ├── auth_outcome.dart
│   ├── auth_result.dart  (+ .freezed.dart, .g.dart)
│   ├── device_info.dart  (+ .freezed.dart, .g.dart)
│   ├── otp_args.dart
│   ├── otp_request_result.dart  (+ .freezed.dart, .g.dart)
│   ├── phone.dart
│   └── token_pair.dart  (+ .freezed.dart, .g.dart)
├── notifier/
│   ├── auth_controller.dart
│   ├── login_notifier.dart
│   └── otp_notifier.dart
├── repository/
│   ├── auth_repository.dart
│   └── device_info_provider.dart
└── screens/
    ├── login_screen.dart
    └── otp_screen.dart
```

- **Screens:** `LoginScreen` (`//login`), `OtpScreen` (`/otp`, takes `OtpArgs` via router `extra`) — private parts: `_PhoneField`, `_LegalLine`, `_ResendRow`, `_ResendTimerPill`, `_SuccessView`, `_SuccessBadge`, `_InlineMessage`
- **State (Riverpod):** `authControllerProvider` (`NotifierProvider<AuthController, AuthStatus>`; `AuthStatus` = `AuthUnknown`/`AuthAuthenticated`/`AuthUnauthenticated`, plus `LogoutReason`), `loginProvider` (`AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>`), `otpProvider` (`NotifierProvider.autoDispose.family<OtpNotifier, OtpUiState, OtpArgs>`), `deviceInfoProvider` (`FutureProvider<DeviceInfo>`)
- **Models:** `AuthResult` (freezed union on `result`: `AuthenticatedResult` / `RegistrationRequiredResult`), `AuthOutcome` sealed (`AuthenticatedOutcome`, `RegistrationRequiredOutcome`), `TokenPair`, `DeviceInfo`, `OtpRequestResult`, `OtpArgs`, `Phone` (E.164, folds Arabic-Indic digits)
- **Repositories / API:** `AuthRepository` → `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/refresh`, `POST /auth/logout`. It holds **two Dio clients**: refresh goes through a bare `refreshDio` with no `AuthInterceptor` so a 401 on refresh cannot re-enter the retry path.
- **Tests:** `test/features/auth/{auth_controller,auth_result,login_logout_message,login_validation,otp_screen,phone,verify_fork}_test.dart`

Notable: `AuthenticatedResult.profile` is carried as an opaque `Map<String, dynamic>` on purpose — these two screens never read it. Parse failures are wrapped as `UnknownException(detail: 'parse: ${e.runtimeType}')`, runtimeType only, because bodies carry minors' data. There is no dedicated `device_info` test.

---

### catalog — `lib/features/catalog/`

The Learn browse stack. One fetch of the whole subject tree, then four screens read from that one cached object — school drills units → chapters → lessons, university is flat and the lecture hands straight off to `/quiz/setup`.

```
lib/features/catalog/
├── models/
│   ├── subject.dart       (+ .freezed.dart, .g.dart)
│   └── subject_tree.dart  (+ .freezed.dart, .g.dart)
├── notifier/
│   ├── subject_tree_notifier.dart
│   └── subjects_notifier.dart
├── repository/
│   └── catalog_repository.dart
├── screens/
│   ├── chapters_screen.dart
│   ├── lectures_screen.dart
│   ├── lessons_screen.dart
│   ├── subject_tree_screen.dart
│   ├── subjects_screen.dart
│   └── units_screen.dart
└── widgets/
    ├── catalog_scaffold.dart
    ├── catalog_states.dart
    ├── quiz_type_tabs.dart
    ├── subject_card.dart
    └── tree_list_row.dart
```

- **Screens:** `SubjectsScreen` (`/learn`), `SubjectTreeScreen` (`/learn/subject/:subjectId` — the only one that fetches; switches on the parsed discriminator into `UnitsView` or `LecturesView`), `ChaptersScreen`, `LessonsScreen`. Despite their file names, `units_screen.dart`/`lectures_screen.dart` define `UnitsView`/`LecturesView` — **bodies, not routes**.
- **Widgets:** `CatalogScaffold`, `CatalogHeader`, `CatalogAsyncView<T>`, `CatalogMessage`, `CatalogBlock`, `CatalogListSkeleton`, `ScopeErrorCopy` (enum), `QuizTypeTabs`, `SubjectCard`, `TreeListRow`, `TreeRowPalette`
- **State (Riverpod):** `subjectsProvider` (`AsyncNotifierProvider<SubjectsNotifier, List<Subject>>`), `subjectTreeProvider` (`AsyncNotifierProvider.family<SubjectTreeNotifier, SubjectTree, String>`) — both non-autoDispose and both pass `retry: noCatalogRetry`, because Riverpod 3's silent auto-retry would pin the screen on its skeleton forever. Free functions `cachedSubjectName`, `filterSubjects`, `normalizeForSearch` (Arabic harakat/tatweel stripping + أ/إ/آ→ا folding). Quiz-type selection on Lectures is `setState`, never a provider.
- **Models:** `Subject`, `QuestionCounter`, sealed `SubjectTree` → `SchoolSubjectTree` / `UniversitySubjectTree`, `Unit`, `Chapter`, `Lesson`, `Lecture`
- **Repositories / API:** `CatalogRepository` → `GET /catalog/subjects` (bare array, no envelope), `GET /catalog/subjects/{subjectId}/tree`. Neither takes scope params — the server derives scope from the token.
- **Tests:** `test/features/catalog/{catalog_models,catalog_navigation,catalog_notifier,catalog_repository,lectures_screen,subjects_screen}_test.dart` + `catalog_fixtures.dart`, `catalog_harness.dart`

Surprising: subject search is client-side by design (no endpoint, and none wanted). The frame's "Search Chapters" field on the Lectures screen is deliberately **not** built (DESIGN_ISSUES #17). `ChaptersScreen`/`LessonsScreen` have no screen-level tests of their own — only `catalog_navigation_test.dart`.

---

### home — `lib/features/home/`

The first nav tab. One screen for both tracks, powered entirely by `GET /me` borrowed from the profile feature; everything else on the frame is an honest "coming soon".

```
lib/features/home/
├── screens/
│   └── home_screen.dart
└── widgets/
    ├── coming_soon_section.dart
    ├── home_banner.dart
    ├── home_header.dart
    └── level_card.dart
```

- **Screens:** `HomeScreen` (`/home`) — `_Loaded`, `_Skeleton`, `_Block`, `_Failure`. No empty state: `/me` either returns a profile or fails.
- **Widgets:** `HomeHeader` (`_BellChip`, `_Avatar`, `_Fallback`), `LevelCard` (`_Stat`), `HomeBanner`, `ComingSoonSection`
- **State (Riverpod):** **none of its own.** It watches `meProvider` (from `lib/features/profile/notifier/me_notifier.dart`) and `isOnlineProvider`.
- **Models / Repositories:** none — `models/`, `notifier/` and `repository/` exist but contain only `.gitkeep`.
- **Tests:** `test/features/home/home_screen_test.dart`, `test/features/home/home_header_unread_test.dart`; `LevelCard` also appears in `test/goldens/design_goldens_test.dart`

Notable: `level_card.dart` holds the only derived number on the screen — `kPointsPerLevel = 500`, `kMaxLevel = 12`, `levelProgressFraction`, `nextLevelThreshold` — and it drives **the bar only**; level, points and badges are rendered exactly as the server sent them. The bell chip is intentionally inert (no notifications endpoint), the banner is a single static box rather than the designed carousel, and Daily Tasks / Learning Tools / Continue Learning / Top Student render as `ComingSoonSection` rather than with the designer's mock values.

---

### leaderboard — `lib/features/leaderboard/`

The ranked board: a scope switcher whose options are derived from the caller's own profile, a top-3 podium, and a cursor-paged list below it.

```
lib/features/leaderboard/
├── models/
│   └── leaderboard_models.dart  (+ .freezed.dart, .g.dart)
├── notifier/
│   └── leaderboard_notifier.dart
├── repository/
│   └── leaderboard_repository.dart
├── screens/
│   └── leaderboard_screen.dart
└── widgets/
    ├── board_avatar.dart
    ├── leaderboard_row.dart
    ├── podium.dart
    └── scope_toggle.dart
```

- **Screens:** `LeaderboardScreen` (`ConsumerStatefulWidget`; `_Header`, `_Board`, `_BoardList`, `_Message`)
- **Widgets:** `Podium` (`_PodiumPlace`, `_RankBadge`), `LeaderboardRow`, `BoardAvatar`, `ScopeToggle` (`_Segment`)
- **State (Riverpod):** `leaderboardProvider` (`AsyncNotifierProvider.autoDispose.family<LeaderboardNotifier, LeaderboardResults, LeaderboardScope>`, `retry: _noRetry`) — one notifier per scope so a cursor can never cross scopes. `LeaderboardResults` keeps `appendError` separate from the `AsyncValue` so a failed "load more" does not blow away rows already on screen. Selected segment is local `setState`. Also watches `meProvider`.
- **Models:** `LeaderboardScope` (enum `system`/`governorate`/`cohort`/`global`, with `scopesFor(StudentProfile)` and `wire`), `LeaderboardEntry`. Pages come back as `CursorPage<LeaderboardEntry>` — reused from `lib/features/registration/models/reference_models.dart`.
- **Repositories / API:** `LeaderboardRepository` → `GET /leaderboard?scope=&cursor=&limit=`. `GET /leaderboard/me` is deliberately **not** called: no synthetic self-rank row.
- **Tests:** `test/features/leaderboard/{leaderboard_notifier,leaderboard_screen}_test.dart` + `leaderboard_fixtures.dart`

Surprising: **the screen is built and tested but not reachable.** `app_router.dart:152-163` mounts `LeaderboardPlaceholderScreen` on the `/leaderboard` branch instead, because `GET /leaderboard` is `x-stability: draft` at our pin (already stable upstream); the swap is one line, the audit is not (D-008). Also: `items.isEmpty` alone is **not** empty — the server may return zero rows with `hasMore: true`, so `isEmpty` requires both. `limit` is asserted, never clamped. `LeaderboardEntry` carries no `level` even though the Figma podium writes one.

---

### mistakes — `lib/features/mistakes/`

"What I got wrong": a per-subject overview and a pruned drill-down tree, structurally a twin of the catalog stack but with different empty/403 semantics.

```
lib/features/mistakes/
├── models/
│   ├── mistakes_subject.dart  (+ .freezed.dart, .g.dart)
│   └── mistakes_tree.dart     (+ .freezed.dart, .g.dart)
├── notifier/
│   └── mistakes_notifiers.dart
├── repository/
│   └── mistakes_repository.dart
├── screens/
│   ├── mistakes_overview_screen.dart
│   ├── mistakes_subject_screen.dart
│   └── mistakes_tree_screens.dart
└── widgets/
    └── mistakes_subject_card.dart
```

- **Screens:** `MistakesOverviewScreen` (`/learn/mistakes`), `MistakesSubjectScreen` (`/learn/mistakes/subject/:subjectId` — the only fetch), `MistakesChaptersScreen`, `MistakesLessonsScreen`; bodies `MistakesUnitsView`, `MistakesLecturesView`
- **Widgets:** `MistakesSubjectCard`; the chrome is borrowed from catalog (`CatalogScaffold`, `CatalogAsyncView`, `TreeListRow`)
- **State (Riverpod):** `mistakesOverviewProvider` (`AsyncNotifierProvider<MistakesOverviewNotifier, List<MistakesSubject>>`, plain), `mistakesTreeProvider` (`AsyncNotifierProvider.autoDispose.family<MistakesTreeNotifier, MistakesTree, String>`), both `retry: noMistakesRetry`. `MistakesTreeNotifier` carries a `_disposed` flag and captures the repository **before** the first await — the W3-1 `UnmountedRefException` hazard.
- **Models:** `MistakesSubject`, sealed `MistakesTree` → `SchoolMistakesTree` / `UniversityMistakesTree`, `MistakesUnit`, `MistakesChapter`, `MistakesLesson`, `MistakesLecture`
- **Repositories / API:** `MistakesRepository` → `GET /me/mistakes` (bare array), `GET /me/mistakes/subjects/{subjectId}`. Neither paginates; the only client-supplied value on the surface is `subjectId`.
- **Tests:** `test/features/mistakes/{mistakes_repository,mistakes_screens}_test.dart` + `mistakes_fixtures.dart`

Surprising: the tree is `autoDispose` while the catalog tree is not — `mistakeCount` is recomputed server-side on every read, so a warm cache would show counts a student already cleared. `403 insufficient_scope` means **two different things** on the two routes (no active enrolment vs. subject-not-yours) and the screens pass different `ScopeErrorCopy` accordingly. There is a documented open gap: nothing invalidates the overview after a quiz, so returning to a warm overview can show stale counts. `MistakesOverviewNotifier` has no dedicated notifier test — only repository and screen tests.

---

### onboarding — `lib/features/onboarding/`

The signed-out first screen: illustration, a bottom sheet with two buttons, and a language pill. Purely presentational.

```
lib/features/onboarding/
└── screens/
    └── onboarding_screen.dart
```

- **Screens:** `OnboardingScreen` (route `/`), plus private `_Illustration` and `_Sheet`
- **State (Riverpod):** none of its own. It is a `ConsumerWidget` for exactly one reason — `localeProvider` for the language pill. No notifier, no "onboarding seen" flag (the router's `authRedirect` sends a signed-in student straight to `/home`).
- **Models / Repositories:** none.
- **Tests:** `test/features/onboarding/onboarding_screen_test.dart`

Surprising: **both** "Get Started" and "Log In" go to `/login`, which is correct, not a copy-paste slip — `/register` cannot be entered directly (it needs a `registrationToken` that only a successful `POST /auth/verify-otp` can mint), and routing Get Started there was the P0 dead-end from the 2026-08-04 device walkthrough. The language pill is not in the frame; it was added deliberately and logged as DESIGN_ISSUES #27.

The 14 folders under `lib/features/` in alphabetical order are: `account_shells`, `auth`, `catalog`, `home`, `leaderboard`, `mistakes`, `onboarding`, `profile`, `quiz`, `registration`, `settings`, `shell`, `subscription`, `track`. The **second half** is the last seven — documented below.

### profile — `lib/features/profile/`
The signed-in student's own record: `GET /me` (identity, geography, server-authoritative points/level/badges, privacy, embedded entitlements), the Edit Profile form that `PATCH /me` backs, and the entitlement read that the purchase-silent app displays but never offers to change.

```
lib/features/profile/
  profile_error_copy.dart
  models/entitlement_state.dart
  models/entitlement_state.freezed.dart
  models/entitlement_state.g.dart
  models/profile_update.dart
  models/student_profile.dart
  models/student_profile.freezed.dart
  models/student_profile.g.dart
  notifier/edit_profile_notifier.dart
  notifier/me_notifier.dart
  repository/profile_repository.dart
  screens/edit_profile_screen.dart
  screens/profile_screen.dart
  widgets/avatar_sheets.dart
  widgets/profile_confirm_dialog.dart
  widgets/profile_header_card.dart
  widgets/profile_menu_row.dart
  widgets/profile_stat_card.dart
  widgets/read_only_field.dart
```

- **Screens:** `ProfileScreen` (the `/account` tab), `EditProfileScreen` (+ `EditProfileChrome`).
- **Widgets:** `ProfileHeaderCard`, `ProfileStatCard`, `ProfileMenuRow` (`ProfileRowTone`), `ReadOnlyField`, `AvatarActionSheet` / `ChooseAvatarSheet` (`AvatarAction`), `profile_confirm_dialog.dart`.
- **State (Riverpod):** `meProvider` (`MeNotifier`, `AsyncNotifier`, deliberately **not** autoDispose so tab switches don't re-fetch, `retry: _noRetry`); `entitlementsProvider` (`EntitlementsNotifier`, refetches on app resume via `AppLifecycleListener`); `editProfileProvider` (`EditProfileNotifier`, autoDispose command notifier with a `_disposed` guard for saves that outlive the screen); `profileRepositoryProvider`.
- **Models:** `StudentProfile` (+ `ProfileAvatar`, `ProfileGeography`, `ProfileCity.coded`/`.freeText`, `ProfileSchool`, `ProfilePoints`, `ProfilePrivacy`), `Track`, `EntitlementState` / `EntitlementsResponse` / `EntitlementType` (`baseSubscription`, `flashcardSubscription`, `unknown` — `unknownEnumValue` extensibility hook), and the hand-written `ProfileUpdate`.
- **Repositories / API:** `ProfileRepository` → `GET /me`, `PATCH /me`, `GET /me/entitlements`. Non-Dio decode failures are re-wrapped as `UnknownException(detail: 'parse: <runtimeType>')` so no response body (minors' data) can leak into an error.
- **Tests:** `test/features/profile/{profile_screen_test,edit_profile_screen_test,me_notifier_test,profile_repository_test,profile_models_test,profile_update_test}.dart` with `profile_fixtures.dart` / `profile_harness.dart`; `test/dev/mock_backend_profile_test.dart`; `profile_confirm_dialog.dart` is also exercised by `test/features/elevation/cta_call_sites_test.dart`.
- **Surprising:** `ProfileUpdate` is hand-serialized on purpose — `email` is the one field in the app with three wire states (absent / value / explicit `null` to clear), which `includeIfNull: false` would silently break. `widgets/avatar_sheets.dart` reaches across features to registration's `avatarsProvider`. Several empty `.gitkeep` files survive in populated folders.

### quiz — `lib/features/quiz/`
The quiz engine: create a quiz, run one session question-by-question against the server, poll for AI explanations, then show the result and a review list. The only Bloc island in the app, and the only screens with screenshot protection.

```
lib/features/quiz/
  bloc/quiz_bloc.dart
  bloc/quiz_event.dart
  bloc/quiz_state.dart
  bloc/quiz_state.freezed.dart
  models/answer_result.dart
  models/answer_result.freezed.dart
  models/answer_result.g.dart
  models/explanation_result.dart
  models/explanation_state.dart
  models/quiz.dart
  models/quiz.freezed.dart
  models/quiz.g.dart
  models/quiz_mode.dart
  models/quiz_option.dart
  models/quiz_option.freezed.dart
  models/quiz_option.g.dart
  models/quiz_question.dart
  models/quiz_question.freezed.dart
  models/quiz_question.g.dart
  models/quiz_review_args.dart
  models/quiz_setup_args.dart
  models/quiz_summary.dart
  models/quiz_summary.freezed.dart
  models/quiz_summary.g.dart
  models/quiz_type.dart
  notifier/quiz_setup_notifier.dart
  repository/quiz_repository.dart
  screens/quiz_result_screen.dart
  screens/quiz_review_screen.dart
  screens/quiz_screen.dart
  screens/quiz_setup_screen.dart
  screens/screen_protection.dart
  widgets/ai_explanation_panel.dart
  widgets/limit_sheet.dart
  widgets/mcq_renderer.dart
  widgets/question_option_tile.dart
  widgets/question_renderer.dart
  widgets/quiz_error_copy.dart
```

- **Screens:** `QuizSetupScreen`, `QuizScreen` (hosts the `BlocProvider<QuizBloc>`), `QuizResultScreen`, `QuizReviewScreen`.
- **Widgets:** `QuestionRenderer` (abstract) + `McqRenderer` + `QuestionPresentation`, `QuestionOptionTile` (`OptionTileState`), `AiExplanationPanel`, `LimitSheet`, `quiz_error_copy.dart`.
- **State (Bloc):** `QuizBloc` over the sealed `QuizEvent` (`QuizStarted`, `OptionSelected`, `AnswerSubmitted`, `AnswerRetried`, `NextQuestionRequested`, `PreviousQuestionRequested`, `ExplanationRequested`, `QuizFinishRequested`, `ExplanationUpdated`) and the sealed `QuizState` (`QuizInitial`, `QuizActive` → `QuizInProgress`, `AnswerConfirming`, `AnswerFailed`, `QuizFinishing`, `FinishFailed`, and `QuizCompleted`), with the freezed `QuizSession` payload. Explanation polling is a 2s backoff capped at 10 polls (`_kExplanationPollInterval`, `_kMaxExplanationPolls`).
- **State (Riverpod):** `quizSetupProvider` (`QuizSetupNotifier`, a one-shot command — setup is deliberately *not* in the Bloc), `quizRepositoryProvider`, `screenProtectionProvider`.
- **Models:** `Quiz`, `QuizQuestion`, `QuizOption`, `AnswerResult`, `QuizSummary`, `QuizMode` (`normal`, `retakeWrong`, `favorites`), `QuizLength`, `QuizType`, `ExplanationResult` (`ExplanationReady` / `ExplanationGenerating`), `ExplanationState` (`Idle`/`Pending`/`Loaded`/`Failed`), `QuizSetupArgs`, `QuizReviewArgs`, `QuizResultArgs` (declared inside `screens/quiz_screen.dart`).
- **Repositories / API:** `QuizRepository` → `POST /quizzes`, `POST /quizzes/{quizId}/answers`, `POST /quizzes/{quizId}/finish`, `GET /questions/{questionId}/explanation`. Optional scope fields are omitted, never sent as `null`.
- **Tests:** `test/features/quiz/{quiz_bloc_test,quiz_models_test,quiz_repository_test,quiz_screen_test,quiz_setup_screen_test,quiz_result_screen_test,quiz_review_screen_test}.dart` with `quiz_fixtures.dart` / `quiz_harness.dart`; `test/dev/mock_backend_quiz_test.dart`.
- **Surprising:** `QuizReviewScreen` consumes **no endpoint** — everything comes forward in `QuizReviewArgs`, so it has only an empty state (historical review needs `GET /quizzes/{quizId}`, still `x-stability: draft`). `screens/screen_protection.dart` is not a screen but a platform-channel seam so protection can be asserted in widget tests; review re-enables it because `QuizScreen` disables it in `dispose`.

### registration — `lib/features/registration/`
The post-OTP sign-up wizard: identity → track choice → a School or University detail form, all accumulated into one draft and submitted once to `POST /auth/register`. Also owns every `/reference/*` lookup the rest of the app borrows.

```
lib/features/registration/
  registration_error_copy.dart
  models/reference_models.dart
  models/reference_models.freezed.dart
  models/reference_models.g.dart
  models/registration_args.dart
  models/registration_body.dart
  models/registration_draft.dart
  models/registration_draft.freezed.dart
  models/registration_validation.dart
  models/school_registration.dart
  models/school_registration.freezed.dart
  models/school_registration.g.dart
  models/stage.dart
  models/university_registration.dart
  models/university_registration.freezed.dart
  models/university_registration.g.dart
  notifier/reference_providers.dart
  notifier/registration_controller.dart
  notifier/registration_submit_notifier.dart
  notifier/school_search_notifier.dart
  repository/reference_repository.dart
  repository/registration_repository.dart
  screens/registration_expired_view.dart
  screens/school_detail_screen.dart
  screens/signup_identity_screen.dart
  screens/signup_track_screen.dart
  screens/university_detail_screen.dart
  widgets/city_field.dart
  widgets/date_of_birth_field.dart
  widgets/reference_dropdown.dart
  widgets/registration_chrome.dart
  widgets/school_picker_field.dart
```

- **Screens:** `SignupIdentityScreen` (no network), `SignupTrackScreen` (no network), `SchoolDetailScreen`, `UniversityDetailScreen`, `RegistrationExpiredView` (the 10-minute `registrationToken` window lapsed, or a deep link with no live draft).
- **Widgets:** `CityField`, `DateOfBirthField`, `ReferenceDropdown` (+ `localizedRefName`), `SchoolPickerField`, `RegistrationChrome`.
- **State (Riverpod):** `registrationControllerProvider` (`RegistrationController extends Notifier<RegistrationDraft?>` — the draft accumulator), `registrationSubmitProvider` (`RegistrationSubmitNotifier` → `RegistrationSubmitted`), `schoolSearchProvider` (`SchoolSearchNotifier`, autoDispose, `SchoolSearchResults`), and the reference family in `reference_providers.dart`: `countriesProvider`, `governoratesProvider`, `citiesProvider` (`CitiesQuery`), `schoolsProvider`, `educationSystemsProvider`, `universitiesProvider`, `avatarsProvider`; plus `referenceRepositoryProvider`, `registrationRepositoryProvider`.
- **Models:** `RegistrationDraft`, `RegTrack`, `Stage`, `SchoolRegistration`, `UniversityRegistration`, `RegistrationArgs`, the body builder with its `IncompleteRegistrationDraft` / `ForbiddenRegistrationField` guards, `RegFieldIssue` + `DraftValidationFailure`, and the reference refs (`Country`, `NamedRef`, `EducationSystemRef`, `UniversityRef`, `Avatar`).
- **Repositories / API:** `RegistrationRepository` → `POST /auth/register`. `ReferenceRepository` → `GET /reference/countries`, `/reference/countries/{countryCode}/governorates`, `/reference/cities`, `/reference/schools`, `/reference/education-systems`, `/reference/universities`, `/reference/avatars`.
- **Tests:** `test/features/registration/{registration_controller_test,registration_submit_notifier_test,registration_repository_test,reference_repository_test,register_body_test,school_search_notifier_test,registration_screens_test,school_detail_screen_test,university_detail_screen_test,registration_router_flow_test}.dart` with `registration_harness.dart`; `test/goldens/design_goldens_test.dart`; `test/features/elevation/cta_call_sites_test.dart`.
- **Surprising:** `UniversityDetailScreen` deliberately reorders the Figma frame (University → Faculty → Year) because the design's order is unanswerable. `CityField`'s free-text escape exists in no frame at all — its spec of record is a partner notice. `DateOfBirthField` carries an open `TODO(design)`. The goldens named `track_screen_light/dark.png` belong to **this** module's `SignupTrackScreen`, not to `features/track/`.

### settings — `lib/features/settings/`
The Settings page: language, theme mode, the two leaderboard-privacy toggles, and a notifications block. It owns no data layer of its own — it drives core locale/theme providers and the profile module's providers.

```
lib/features/settings/
  screens/settings_screen.dart
  widgets/settings_rows.dart
  widgets/settings_section.dart
```

- **Screens:** `SettingsScreen` (private sections `_LanguagesSection`, `_ModeSection`, `_RankSection`, `_NotificationsSection`, with `_SectionLoading` / `_SectionMessage`).
- **Widgets:** `SettingsSection`, `SettingsChoiceRow` (`_RadioRing`), `SettingsSwitchRow`.
- **State (Riverpod, all borrowed):** `localeProvider`, `themeModeProvider` from `core/providers/locale_provider.dart`; `meProvider` and `editProfileProvider` from the profile module. No provider is declared in this folder.
- **Repositories / API:** none directly — the Rank toggles write through `editProfileProvider` (`PATCH /me`) and read `meProvider` (`GET /me`).
- **Tests:** `test/features/settings/settings_screen_test.dart` with `settings_harness.dart`.
- **Surprising:** `_RankSection` reads `me.value` rather than `when(...)` on purpose, so a toggle flip doesn't drop working rows to a skeleton while `/me` re-fetches. `test/features/settings/shell_screens_test.dart` sits in this module's test folder but actually covers `features/account_shells/` screens — misfiled.

### shell — `lib/features/shell/`
The five-tab bottom-nav chrome (Home · Leaderboard · Learn · Message · Account) built on `StatefulShellRoute.indexedStack`, plus the coming-soon screens for the tabs that have no real destination yet.

```
lib/features/shell/
  main_shell.dart
  screens/tab_placeholder.dart
```

- **Screens:** `TabPlaceholder`, `LeaderboardPlaceholderScreen`, `MessagePlaceholderScreen`.
- **Widgets:** `MainShell`, `_NavTab`, `_CentreTab` (raised into the bar's own notch), `_NavBarPainter`, `_NavBarClipper`.
- **State:** none — no providers or notifiers; the shell is driven entirely by `go_router`'s `navigationShell`.
- **Repositories / API:** none.
- **Tests:** `test/features/shell/main_shell_test.dart`, `test/features/shell/nav_centre_tab_test.dart`, `test/goldens/nav_bar_golden_test.dart` (ten goldens, light/dark × tabs 0–4).
- **Surprising:** `LeaderboardPlaceholderScreen` gates a **fully built and tested** `lib/features/leaderboard/` behind a placeholder purely because `GET /leaderboard` is still `draft` at the pinned contract — held, not unwritten. `MainShell`'s own doc comment ("Only Home is real so far; the other four are coming-soon placeholders") is stale: `tab_placeholder.dart` records that Learn became the real Subjects screen on Day 5 and Account the real `ProfileScreen` on Day 8. The bar is hand-rolled rather than a Material `NavigationBar`.

### subscription — `lib/features/subscription/`
Nothing is implemented. An empty scaffold retained from before the app went purchase-silent.

```
lib/features/subscription/
  models/.gitkeep
  notifier/.gitkeep
  repository/.gitkeep
  screens/.gitkeep
```

- **Surprising:** dead folder, and deliberately so — `lib/core/router/app_router.dart` records that `/subscription` and `/subscription/return` "went with the purchase surface (adr-049 — the app is purchase-silent; D-007), which settled the product decision Wave 3 recorded… removed, not built." Entitlement *state* lives in the profile module instead. No screens, no state, no API, **no tests**.

### track — `lib/features/track/`
Nothing is implemented. Four empty directories only.

```
lib/features/track/
  models/.gitkeep
  notifier/.gitkeep
  repository/.gitkeep
  screens/.gitkeep
```

- **Surprising:** the `Track` concept is live but lives elsewhere — the `Track` enum is in `lib/features/profile/models/student_profile.dart`, the track fork is `RegTrack` plus `SignupTrackScreen` in the registration module, and the `track_screen_*.png` goldens belong to that registration screen. Nothing in the tree imports from this folder. No screens, no state, no API, **no tests**.

## The data & API layer — a second lens

The blocks above are organised the way the folders are. This section re-cuts the same code by
**data flow** instead, because an API question ("who actually issues this request, and what maps
its errors?") does not follow the folder layout — a single call crosses `core/network`,
`core/providers`, a feature's `repository/` and its `models/`. Some files therefore appear twice,
once in each view. That is deliberate.

### HTTP core — `lib/core/network/`

The whole app's contact point with Seif's API: two Dio factories, the Bearer/refresh interceptor, and the mapping from raw `DioException` to a sealed typed error hierarchy. Nothing outside this folder (plus the repositories and `lib/dev/mock_backend.dart`) imports `package:dio/dio.dart`.

```
lib/core/network/
├── dio_client.dart
├── exceptions.dart
└── interceptors/
    ├── auth_interceptor.dart
    └── error_interceptor.dart
```

- **Models:** `AppException` (sealed) with `OfflineException`, `NetworkException`, `ApiException`, `UnauthorizedException`, `ValidationException` (carries the ProblemDetails `field -> [messages]` map), `RateLimitedException` (parses `Retry-After`, delta-seconds only), `UnknownException`; the free function `isOffline(error)`.
- **Repositories / API:** `DioClient.create` builds the main client (`AuthInterceptor` then `ErrorInterceptor`); `DioClient.createBare` builds a refresh-only client with *no* `AuthInterceptor` so `POST /auth/refresh` can never re-enter the retry path. `AuthInterceptor` attaches `Authorization: Bearer`, single-flights concurrent 401s through one refresh future, retries the original request at most once via `extra['__retried']`, and calls `AuthController.forceLogout` on `session_superseded` / `refresh_token_invalid` — it never navigates. Refresh is injected as the `TokenRefresher` typedef closure to break the dio → interceptor → repo → dio provider cycle.
- **Tests:** `test/core/network/auth_interceptor_test.dart`, `test/core/network/error_interceptor_test.dart`.

### Core DI graph & runtime config — `lib/core/providers/`, `lib/core/config/`

Riverpod *is* the DI container (no get_it). This is where the Dio instances, connectivity and the flavor base URL are constructed.

```
lib/core/
├── config/
│   └── app_config.dart
└── providers/
    ├── core_providers.dart
    ├── locale_provider.dart
    └── theme_provider.dart
```

- **State (Riverpod):** `secureStorageProvider`, `preferencesStoreProvider` (`Provider<PreferencesStore?>`, deliberately null unless an entrypoint overrides it, so widget tests need no plugin channel), `refreshDioProvider`, `dioProvider` (explicitly typed to break the static cycle with `authRepositoryProvider`), `connectivityProvider`, `isOnlineProvider` (`StreamProvider<bool>` off `connectivity_plus`); `localeProvider` / `themeModeProvider` in the two sibling files read and write `PreferencesStore`.
- **Repositories / API:** `AppConfig.init(Flavor)` is called by each entrypoint; `baseUrl` feeds `DioClient._baseOptions`. Surprising: `Flavor.prod` still resolves to `https://TBD.example/api/v1` — a deliberate fail-closed placeholder, so a prod build cannot ship until Seif announces the host. `dev` and `staging` both point at the same Railway staging host.
- **Tests:** no dedicated test for `app_config.dart` or `core_providers.dart`; `AppConfig` is only touched incidentally by `test/guards/workflow_test.dart` and `test/dev/mock_backend_quiz_test.dart`. The two preference providers are covered by `test/features/settings/settings_screen_test.dart` (+ `settings_harness.dart`).

### Device storage & session teardown — `lib/core/storage/`, `lib/core/session/`

Two stores with deliberately different threat models, plus the one function that drops every user-scoped cached value at logout.

```
lib/core/
├── storage/
│   ├── preferences_store.dart
│   └── secure_storage.dart
└── session/
    └── session_scope.dart
```

- **Models:** `SecureStorage` (keys `access_token`, `refresh_token`, `device_id`; iOS `first_unlock_this_device` + `synchronizable: false` so a restored iCloud backup can't inherit a live session; `clearTokens()` for logout vs `clear()` for a true reset, because wiping `device_id` mis-fires the `session_superseded` eviction; `readOrCreateDeviceId()` mints 32 hex chars). `PreferencesStore` wraps `SharedPreferences` for theme + locale, synchronous reads so the first frame paints the stored canvas, and swallows its own read/write failures.
- **State:** `invalidateSessionScope(Ref)` invalidates `meProvider`, `entitlementsProvider`, `editProfileProvider`, `subjectsProvider`, `subjectTreeProvider`, `mistakesOverviewProvider`, `mistakesTreeProvider`, `loginProvider`, `otpProvider`, `registrationControllerProvider`, `registrationSubmitProvider`, `schoolSearchProvider`, `quizSetupProvider` — the session inventory in one place, with a documented list of what is deliberately *not* cleared (device prefs, the seven reference providers, `device_id`).
- **Tests:** `test/core/secure_storage_test.dart`, `test/core/preferences_store_test.dart`, `test/core/session/session_scope_discipline_test.dart` (fails if a new non-autoDispose notifier appears under `lib/features/` unclassified), `test/core/session/session_isolation_test.dart`.

### Shared data primitives — `lib/core/models/`

Two things every feature's data path leans on: the `format: date` JSON converter and the sealed screen-state model.

```
lib/core/models/
├── date_only_converter.dart
└── screen_state.dart
```

- **Models:** `DateOnlyConverter` / `NullableDateOnlyConverter` — emit `yyyy-MM-dd` with no UTC conversion, because json_serializable's default would send a full ISO timestamp and a UTC shift would move an Egyptian date of birth back a day. `ScreenState<T>` sealed: `ScreenLoading`, `ScreenEmpty`, `ScreenLoaded`, `ScreenError(messageKey)`, `ScreenOffline`.
- **Tests:** `test/core/models/date_only_converter_test.dart`. Surprising: `screen_state.dart` and its renderer `lib/core/widgets/state_widget.dart` have **no dedicated test** — `ScreenState` appears in only one test file, `test/features/profile/profile_screen_test.dart`.

### Auth data — `lib/features/auth/models/`, `lib/features/auth/repository/`

The OTP → verify → refresh → logout surface, plus the device-binding payload.

```
lib/features/auth/
├── auth_error_copy.dart
├── models/
│   ├── auth_outcome.dart
│   ├── auth_result.dart  (+ .freezed.dart, .g.dart)
│   ├── device_info.dart  (+ .freezed.dart, .g.dart)
│   ├── otp_args.dart
│   ├── otp_request_result.dart  (+ .freezed.dart, .g.dart)
│   ├── phone.dart
│   └── token_pair.dart  (+ .freezed.dart, .g.dart)
└── repository/
    ├── auth_repository.dart
    └── device_info_provider.dart
```

- **State (Riverpod):** `authControllerProvider` (`NotifierProvider<AuthController, AuthStatus>`), `loginProvider` (`AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>`), `otpProvider` (`NotifierProvider.autoDispose.family`), `deviceInfoProvider` (`FutureProvider<DeviceInfo>`, reads `device_id` from `SecureStorage` and the model string from `device_info_plus`).
- **Models:** `AuthResult` (sealed freezed union: `AuthenticatedResult` | `RegistrationRequiredResult`), `AuthOutcome` / `AuthenticatedOutcome` / `RegistrationRequiredOutcome`, `OtpRequestResult`, `TokenPair`, `DeviceInfo`, `Phone`, `OtpArgs`.
- **Repositories / API:** `AuthRepository` — `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/refresh` (on the **bare** `refreshDio`), `POST /auth/logout`. `authErrorMessage()` in `auth_error_copy.dart` is the one place a stable code (`otp_invalid`, `otp_expired`, `otp_throttled`, `validation_failed`) becomes localized copy; server `title`/`detail` are never rendered.
- **Tests:** `test/features/auth/auth_controller_test.dart`, `auth_result_test.dart`, `verify_fork_test.dart`, `otp_screen_test.dart`, `login_validation_test.dart`, `login_logout_message_test.dart`, `phone_test.dart`. Surprising: there is **no `auth_repository_test.dart`** — every other repository has one; `AuthRepository` is only ever exercised through `class Mock… implements AuthRepository` in eight test files, so its own Dio calls and `fromJson` wrapping are untested.

### Registration & reference data — `lib/features/registration/models/`, `.../repository/`

The `POST /auth/register` bodies (discriminated on `track`) and the seven unauthenticated `/reference/*` lookups that feed the wizard's pickers.

```
lib/features/registration/
├── registration_error_copy.dart
├── models/
│   ├── reference_models.dart  (+ .freezed.dart, .g.dart)
│   ├── registration_args.dart
│   ├── registration_body.dart
│   ├── registration_draft.dart  (+ .freezed.dart)
│   ├── registration_validation.dart
│   ├── school_registration.dart  (+ .freezed.dart, .g.dart)
│   ├── stage.dart
│   └── university_registration.dart  (+ .freezed.dart, .g.dart)
└── repository/
    ├── reference_repository.dart
    └── registration_repository.dart
```

- **State (Riverpod):** `countriesProvider`, `governoratesProvider` (family), `citiesProvider` (family over `CitiesQuery`), `schoolsProvider`, `educationSystemsProvider`, `universitiesProvider`, `avatarsProvider` — all `FutureProvider`, all deliberately *not* cleared at logout; plus `registrationControllerProvider`, `registrationSubmitProvider`, `schoolSearchProvider`.
- **Models:** `RegistrationBody` (abstract interface) implemented by `SchoolRegistration` and `UniversityRegistration` — two independent freezed classes, not one union, because university has no `countryCode` at all; `RegistrationDraft`, `RegTrack`, `Stage`, `RegFieldIssue`, `DraftValidationFailure`, and the two loud programming-error throws `IncompleteRegistrationDraft` / `ForbiddenRegistrationField`. Reference side: `NamedRef`, `Country`, `EducationSystemRef`, `UniversityRef`, `FacultyRef`, `StudyYearRef`, `Avatar`, and the generic `CursorPage<T>` — the app's only pagination envelope, which lives here and is imported by the leaderboard.
- **Repositories / API:** `RegistrationRepository.register` → `POST /auth/register` (throws `UnknownException` if the server answers with a `RegistrationRequiredResult`, rather than coercing it). `ReferenceRepository` → `GET /reference/countries`, `/reference/countries/{code}/governorates`, `/reference/cities`, `/reference/schools` (cursor-paginated), `/reference/education-systems`, `/reference/universities`, `/reference/avatars`. Surprising: `FacultyRef` and `StudyYearRef` have no endpoints of their own — they arrive nested inside `/reference/universities`.
- **Tests:** `test/features/registration/registration_repository_test.dart`, `reference_repository_test.dart`, `register_body_test.dart`, `registration_controller_test.dart`, `registration_submit_notifier_test.dart`, `school_search_notifier_test.dart`, `registration_router_flow_test.dart`, `registration_screens_test.dart`, `school_detail_screen_test.dart`, `university_detail_screen_test.dart`, `registration_harness.dart`.

### Profile & entitlements data — `lib/features/profile/models/`, `.../repository/`

`GET /me`, the hand-written `PATCH /me` body, and the entitlement read that the purchase-silent app displays but never computes.

```
lib/features/profile/
├── profile_error_copy.dart
├── models/
│   ├── entitlement_state.dart  (+ .freezed.dart, .g.dart)
│   ├── profile_update.dart
│   └── student_profile.dart  (+ .freezed.dart, .g.dart)
└── repository/
    └── profile_repository.dart
```

- **State (Riverpod):** `meProvider` (`AsyncNotifierProvider<MeNotifier, StudentProfile>`), `entitlementsProvider` (`EntitlementsNotifier`, refetches on resume), `editProfileProvider` (`EditProfileNotifier`, invalidates `meProvider` after a successful PATCH rather than writing through).
- **Models:** `StudentProfile` with `Track`, `ProfileAvatar`, `ProfileGeography`, `ProfileCity` (sealed — coded vs free-text), `ProfileSchool`, `ProfileUniversity`, `ProfilePoints`, `ProfilePrivacy`; `EntitlementState` + `EntitlementType` + `EntitlementsResponse`. `ProfileUpdate` is **hand-serialized** — `email` is the one field in the app with three wire states (absent / value / explicit `null` to clear), modelled as the sealed `EmailPatch`; the repo-wide `includeIfNull: false` habit would silently make "clear my email" impossible.
- **Repositories / API:** `ProfileRepository` — `GET /me`, `PATCH /me`, `GET /me/entitlements` (unwraps `EntitlementsResponse.items`). `profile_error_copy.dart` maps the PATCH failure to a banner and maps `ProblemDetails.errors` field **names** (not messages) to inline errors, dropping any field the screen doesn't render.
- **Tests:** `test/features/profile/profile_repository_test.dart`, `profile_models_test.dart`, `profile_update_test.dart`, `me_notifier_test.dart`, `profile_screen_test.dart`, `edit_profile_screen_test.dart`, `profile_fixtures.dart`, `profile_harness.dart`.

### Catalog data — `lib/features/catalog/models/`, `.../repository/`

The browse stack's two reads, and the fork between the School and University tree shapes.

```
lib/features/catalog/
├── models/
│   ├── subject.dart  (+ .freezed.dart, .g.dart)
│   └── subject_tree.dart  (+ .freezed.dart, .g.dart)
├── repository/
│   └── catalog_repository.dart
└── widgets/
    └── catalog_states.dart
```

- **State (Riverpod):** `subjectsProvider` (`AsyncNotifierProvider<SubjectsNotifier, List<Subject>>`), `subjectTreeProvider` (family by subject id).
- **Models:** `Subject`, `QuestionCounter`; `SubjectTree` sealed over `SchoolSubjectTree` (`Unit` → `Chapter` → `Lesson`) and `UniversitySubjectTree` (`Lecture`).
- **Repositories / API:** `CatalogRepository` — `GET /catalog/subjects` (a bare array, no envelope) and `GET /catalog/subjects/{subjectId}/tree`. Neither call takes scope parameters: the server derives scope from the token, and the header comment says adding `?stage=` means the contract is being worked around. `catalog_states.dart` holds the shared `AsyncValue` → `ScreenState` mapping (including the `insufficient_scope` message key) and is reused by the Mistakes screens as well as the catalog's.
- **Tests:** `test/features/catalog/catalog_repository_test.dart`, `catalog_models_test.dart`, `catalog_notifier_test.dart`, `catalog_navigation_test.dart`, `subjects_screen_test.dart`, `lectures_screen_test.dart`, `catalog_fixtures.dart`, `catalog_harness.dart`.

### Quiz data — `lib/features/quiz/models/`, `.../repository/`, `.../bloc/`

The only Bloc-driven feature in the app; the repository is the four-endpoint quiz loop and the Bloc is its state machine.

```
lib/features/quiz/
├── models/
│   ├── answer_result.dart  (+ .freezed.dart, .g.dart)
│   ├── explanation_result.dart
│   ├── explanation_state.dart
│   ├── quiz.dart  (+ .freezed.dart, .g.dart)
│   ├── quiz_mode.dart
│   ├── quiz_option.dart  (+ .freezed.dart, .g.dart)
│   ├── quiz_question.dart  (+ .freezed.dart, .g.dart)
│   ├── quiz_review_args.dart
│   ├── quiz_setup_args.dart
│   ├── quiz_summary.dart  (+ .freezed.dart, .g.dart)
│   └── quiz_type.dart
├── repository/
│   └── quiz_repository.dart
├── bloc/
│   ├── quiz_bloc.dart
│   ├── quiz_event.dart
│   └── quiz_state.dart  (+ .freezed.dart)
└── widgets/
    └── quiz_error_copy.dart
```

- **State (Bloc + one Riverpod notifier):** `QuizBloc` over the sealed `QuizEvent` (`QuizStarted`, `OptionSelected`, `AnswerSubmitted`, `AnswerRetried`, `NextQuestionRequested`, `PreviousQuestionRequested`, `ExplanationRequested`, `QuizFinishRequested`, `ExplanationUpdated`) and the sealed `QuizState` (`QuizInitial`, `QuizActive` → `QuizInProgress` / `AnswerConfirming` / `AnswerFailed` / `QuizFinishing` / `FinishFailed`, `QuizCompleted`) carrying a freezed `QuizSession`. The setup sheet alone is Riverpod: `quizSetupProvider` (`AsyncNotifierProvider.autoDispose`).
- **Models:** `Quiz`, `QuizQuestion`, `QuizOption`, `AnswerResult`, `QuizSummary` + `QuizSummaryQuestion`, `QuizMode` (`normal`/`retakeWrong`/`favorites`), `QuizLength`, `QuizType` + `QuizTypeLabel`, `ExplanationResult` (`ExplanationReady` | `ExplanationGenerating`) and the UI-side `ExplanationState`.
- **Repositories / API:** `QuizRepository` — `POST /quizzes`, `POST /quizzes/{quizId}/answers`, `POST /quizzes/{quizId}/finish`, `GET /questions/{questionId}/explanation`. Answers and finish rely on documented **server-side idempotency** rather than a client "already sent" guard. `quiz_error_copy.dart` maps every code the four endpoints can return; the two 403s (`weekly_question_limit_reached`, `subscription_required`) open a sheet instead of an inline error — and, per the purchase-silent rule, that sheet carries no price or checkout hand-off.
- **Tests:** `test/features/quiz/quiz_repository_test.dart`, `quiz_bloc_test.dart`, `quiz_models_test.dart`, `quiz_screen_test.dart`, `quiz_setup_screen_test.dart`, `quiz_result_screen_test.dart`, `quiz_review_screen_test.dart`, `quiz_fixtures.dart`, `quiz_harness.dart`.

### Mistakes data — `lib/features/mistakes/models/`, `.../repository/`

The per-student wrong-answer history: the most privacy-sensitive read in the app, which is why its overview provider is explicitly listed in the session teardown.

```
lib/features/mistakes/
├── models/
│   ├── mistakes_subject.dart  (+ .freezed.dart, .g.dart)
│   └── mistakes_tree.dart  (+ .freezed.dart, .g.dart)
└── repository/
    └── mistakes_repository.dart
```

- **State (Riverpod):** `mistakesOverviewProvider` (non-autoDispose by design — it survives the drill-down, so `invalidateSessionScope` must drop it), `mistakesTreeProvider` (`AsyncNotifierProvider.autoDispose.family`, because counts decay on every read).
- **Models:** `MistakesSubject`; `MistakesTree` sealed over `SchoolMistakesTree` (`MistakesUnit` → `MistakesChapter` → `MistakesLesson`) and `UniversityMistakesTree` (`MistakesLecture`).
- **Repositories / API:** `MistakesRepository` — `GET /me/mistakes` (bare array) and `GET /me/mistakes/subjects/{subjectId}`. Neither paginates and neither takes scope parameters; `subjectId` is the only client-supplied value on the whole surface.
- **Tests:** `test/features/mistakes/mistakes_repository_test.dart`, `mistakes_screens_test.dart`, `mistakes_fixtures.dart`.

### Leaderboard data — `lib/features/leaderboard/models/`, `.../repository/`

One paginated read, with an explicit product decision baked into the repository doc.

```
lib/features/leaderboard/
├── models/
│   └── leaderboard_models.dart  (+ .freezed.dart, .g.dart)
└── repository/
    └── leaderboard_repository.dart
```

- **State (Riverpod):** `leaderboardProvider` (`AsyncNotifierProvider.autoDispose`, `LeaderboardNotifier` over a `LeaderboardResults` value).
- **Models:** `LeaderboardScope` (enum with a `wire` value), `LeaderboardEntry`; pages come back as `CursorPage<LeaderboardEntry>` borrowed from `registration/models/reference_models.dart`.
- **Repositories / API:** `LeaderboardRepository.getLeaderboard({scope, cursor, limit})` → `GET /leaderboard`. `GET /leaderboard/me` is deliberately **never called** — no synthetic self-rank row. `limit` is asserted against 1–100 but never clamped, and the cursor is opaque/scope-bound and echoed back unchanged; callers must page on `hasMore`, not on page size.
- **Tests:** `test/features/leaderboard/leaderboard_notifier_test.dart`, `leaderboard_screen_test.dart`, `leaderboard_fixtures.dart`. Surprising: like `AuthRepository`, there is **no `leaderboard_repository_test.dart`** — the repository is only reached through mocks.

### Mock backend harness — `lib/dev/`

A hand-rolled Dio interceptor that answers the whole stable surface with contract-faithful canned JSON, so the login → OTP → registration → Home → quiz walk runs on a real device with no server and no network.

```
lib/dev/
└── mock_backend.dart
```

- **Repositories / API:** `buildMockDio()` chains `MockBackendInterceptor` then the **real** `ErrorInterceptor`, so mock non-2xx responses still map to the same typed `AppException`s; there is no `AuthInterceptor` because the mock never answers 401. It serves `/auth/*`, `/reference/*`, `/me`, `/me/entitlements`, `/catalog/*` and the quiz loop, and is strict where the server is strict (it rejects `schoolName` and both-cities the way the contract has since v1.1.0-m1). Wired in by a single `dioProvider.overrideWith((ref) => buildMockDio())` in `lib/main_mock.dart` — nothing under `lib/core` or `lib/features` knows the file exists.
- **Tests:** `test/dev/mock_backend_catalog_test.dart`, `mock_backend_profile_test.dart`, `mock_backend_quiz_test.dart`, `mock_backend_v11_test.dart`. Surprising: at 1901 lines it is larger than all nine real repositories combined (~900 lines).

---

**Cross-cutting notes**

- Every repository follows the identical four-arm catch: `on DioException` → unwrap the already-mapped `AppException`; `on AppException` → rethrow; `on Object` → `UnknownException(detail: 'parse: ${e.runtimeType}')`, because `fromJson` runs outside Dio and schema drift throws a plain `TypeError`. Only the runtime type is ever recorded — never the body, since the users are minors.
- Error → copy mapping is per-feature and deliberately duplicated in four "one place" files: `lib/features/auth/auth_error_copy.dart`, `lib/features/registration/registration_error_copy.dart`, `lib/features/profile/profile_error_copy.dart`, `lib/features/quiz/widgets/quiz_error_copy.dart`. There is no central code→message table.
- **Dead scaffolding:** `lib/features/track/` and `lib/features/subscription/` contain only `.gitkeep` files — no Dart at all. `lib/features/home/models/` and `home/repository/` are likewise empty: the Home screen is entirely API-silent. Stray `.gitkeep` files also remain in already-populated folders (`auth/models`, `catalog/repository`, `quiz/repository`, `profile/repository`, …).
