# Validation run - 2026-08-14T19:09:09Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 207 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 806 passed / 0 failed |

**OVERALL: PASS**

Started 2026-08-14T19:09:09Z Â· finished 2026-08-14T19:12:27Z

---

## 1. Environment

```text
started (UTC)  : 2026-08-14T19:09:09Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9168
repo root      : F:/level/level_up/level_up_app
branch         : dev
commit         : e3651e6
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
```

## 2. Toolchain

```text
Flutter 3.44.7 ΓÇó channel stable ΓÇó https://github.com/flutter/flutter.git
Framework ΓÇó revision 84fc5cbb22 (4 weeks ago) ΓÇó 2026-07-17 10:20:17 -0700
Engine ΓÇó hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (29 days ago) ΓÇó 2026-07-15 20:46:58.000Z
Tools ΓÇó Dart 3.12.2 ΓÇó DevTools 2.57.0

Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "windows_x64"
```

## 3. Dependencies (`flutter pub get`)

```text
Resolving dependencies...
Downloading packages...
  _fe_analyzer_shared 99.0.0 (105.0.0 available)
  analyzer 12.1.0 (14.1.0 available)
  build 4.0.7 (4.0.10 available)
  build_config 1.3.1 (1.3.2 available)
  build_daemon 4.1.2 (4.1.5 available)
  build_runner 2.15.1 (2.16.0 available)
  built_value 8.12.6 (8.12.7 available)
  connectivity_plus 7.3.0 (7.3.1 available)
  dart_style 3.1.8 (3.1.12 available)
  dio 5.10.0 (5.11.0 available)
  dio_web_adapter 2.2.0 (2.2.1 available)
  flutter_riverpod 3.3.2 (3.4.2 available)
  flutter_secure_storage 10.3.1 (11.0.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.0 available)
  flutter_secure_storage_linux 3.0.1 (3.0.2 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.0.3 available)
  freezed 3.2.6-dev.1 (4.0.0-dev.3 available)
  go_router 17.3.0 (17.5.0 available)
  hive_ce_generator 1.11.2 (1.11.3 available)
  hooks 2.0.2 (2.1.0 available)
  intl 0.20.2 (0.20.3 available)
  jni 1.0.0 (1.0.3 available)
  jni_flutter 1.0.1 (1.0.2 available)
  jovial_svg 1.1.29 (1.1.30 available)
  json_serializable 6.14.0 (6.14.1 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.0 (1.19.0 available)
  mockito 5.6.4 (5.8.1 available)
  objective_c 9.4.1 (9.5.0 available)
  package_config 2.2.0 (3.0.0 available)
  record_use 0.6.0 (1.1.0 available)
  riverpod 3.3.2 (3.4.2 available)
  riverpod_analyzer_utils 1.0.0-dev.10 (1.0.0-dev.11 available)
  riverpod_annotation 4.0.3 (4.0.6 available)
  riverpod_generator 4.0.4 (4.0.8 available)
  source_gen 4.2.3 (4.2.4 available)
  source_helper 1.3.12 (1.3.13 available)
  test 1.31.0 (1.31.2 available)
  test_api 0.7.11 (0.7.13 available)
  test_core 0.6.17 (0.6.19 available)
  vector_graphics 1.2.2 (1.2.3 available)
  vector_graphics_compiler 1.2.6 (1.3.0 available)
  vector_math 2.2.0 (2.4.2 available)
  win32 6.3.0 (6.4.0 available)
  xml 6.6.1 (7.0.1 available)
Got dependencies!
46 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 207 hand-written Dart files

Formatted 60 files (0 changed) in 0.28 seconds.
Formatted 60 files (0 changed) in 0.31 seconds.
Formatted 60 files (0 changed) in 0.72 seconds.
Formatted 27 files (0 changed) in 0.32 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 42.2s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**806 passed, 0 failed** (exit 0)


### Full test output

```text
00:00 +0: loading F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart
00:00 +0: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: toJson ΓÇö contract `format: date` (yyyy-MM-dd) emits a bare date, never an ISO-8601 timestamp
00:00 +1: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: toJson ΓÇö contract `format: date` (yyyy-MM-dd) zero-pads month and day
00:00 +2: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: toJson ΓÇö contract `format: date` (yyyy-MM-dd) a local midnight does NOT shift a day (Egypt is UTC+2 ΓÇö a DoB is a calendar date, not an instant)
00:00 +3: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: fromJson parses a contract date string
00:00 +4: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: fromJson round-trips
00:00 +5: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: NullableDateOnlyConverter passes null through both ways
00:00 +6: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: NullableDateOnlyConverter formats a value identically to the non-null converter
00:00 +7: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required ΓåÆ refresh once ΓåÆ original retried ΓåÆ success
00:01 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded ΓåÆ forceLogout(superseded), cleared, no refresh
00:01 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh ΓåÆ refresh_token_invalid ΓåÆ forceLogout(sessionExpired)
00:01 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s ΓåÆ refresh called exactly once, all retried
00:01 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again ΓåÆ not refreshed/retried a 2nd time
00:01 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh ΓåÆ NO logout, surfaces the network error
00:04 +13: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException carries the ProblemDetails field map
00:04 +14: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException is still an ApiException (existing handlers keep working)
00:04 +15: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a missing/malformed errors map yields empty fields, not a crash
00:04 +16: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a non-list value is tolerated as a single message
00:04 +17: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:04 +18: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 ΓåÆ UnauthorizedException carrying the code
00:04 +19: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 ΓåÆ ApiException carrying status + code
00:04 +20: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error ΓåÆ NetworkException (drives Offline)
00:04 +21: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException is typed, and is NOT otp_throttled
00:04 +22: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a delta-seconds Retry-After parses
00:04 +23: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an ABSENT header yields null ΓÇö and does not throw
00:04 +24: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a GARBAGE header yields null ΓÇö and does not throw
00:04 +25: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:04 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:04 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:04 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:05 +29: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:05 +30: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:05 +31: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:05 +32: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:05 +33: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:05 +34: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:05 +35: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:05 +36: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:05 +37: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:05 +38: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:05 +39: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:05 +40: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:05 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too ΓÇö one path, not two
00:05 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:14 +43: F:/level/level_up/level_up_app/test/core/secure_storage_test.dart: clearTokens() deletes tokens but PRESERVES the device id
00:14 +44: F:/level/level_up/level_up_app/test/core/secure_storage_test.dart: clear() wipes everything, including the device id
00:16 +45: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:16 +46: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: no provider is both invalidated and exempted
00:16 +47: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: the exemption list has no stale entries
00:16 +48: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: both sign-out paths call the invalidation
00:16 +49: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: forceLogout keeps its re-entry guard
00:17 +50: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +51: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +52: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +53: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +54: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +55: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +56: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +57: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +58: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +59: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:17 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:19 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:21 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:21 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:21 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:21 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:21 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:21 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:22 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:22 +84: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +85: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +86: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +87: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +88: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +89: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +90: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:23 +91: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:24 +92: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:24 +93: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:25 +94: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:26 +95: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:26 +96: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable ΓÇö the 159:1852 variant
00:26 +97: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:26 +98: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:26 +99: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:26 +100: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:26 +101: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:26 +102: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:26 +103: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:26 +104: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:26 +105: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:26 +106: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent ΓÇö a repeat call replays the same summary
00:26 +107: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me ΓÇö what invalidating the profile shows
00:26 +108: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered ΓÇö expected, not a bug
00:26 +109: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 ΓÇö the polling path is walkable
00:26 +110: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:26 +111: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:27 +112: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:27 +113: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:27 +114: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:27 +115: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:27 +116: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:27 +117: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:27 +118: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:27 +119: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:27 +120: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:27 +121: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:27 +122: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:27 +123: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:27 +124: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:27 +125: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:27 +126: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:27 +127: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:27 +128: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:28 +129: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token ΓåÆ unauthenticated
00:28 +130: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token ΓåÆ authenticated
00:28 +131: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:28 +132: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:28 +133: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:29 +134: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:29 +135: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` registrationRequired ΓåÆ RegistrationRequiredResult with token + ttl
00:29 +136: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity ΓÇö required fields have no defensive defaults TokenPair throws when a required field is missing
00:29 +137: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:31 +138: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:33 +139: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:34 +140: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:35 +141: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +142: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +143: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +144: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +145: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +146: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +147: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +148: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +149: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +150: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +151: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +152: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +153: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:36 +154: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:37 +155: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:37 +156: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
00:37 +157: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
00:37 +158: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
00:37 +159: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
00:37 +160: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
00:37 +161: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:37 +162: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) is disabled while offline, like Send OTP
00:38 +163: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: Subject parses a row of GET /catalog/subjects
00:39 +164: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: Subject a missing required field throws rather than defaulting
00:39 +165: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction is answered/total
00:39 +166: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction a subject with no questions is 0, not NaN
00:39 +167: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction is clamped, so bad server data cannot overflow the bar
00:39 +168: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree parses the whole nested structure from one payload
00:39 +169: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree an empty level parses as empty, not as an error
00:39 +170: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree a tree with no units at all parses
00:39 +171: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree a missing required field throws
00:39 +172: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree an unknown track value throws ΓÇö the discriminator is closed
00:39 +173: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree parses the university branch of the oneOf
00:39 +174: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree lectures carry a questionCounter ΓÇö unlike school units/chapters
00:39 +175: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree quizTypes parse as the contract enum, in server order
00:39 +176: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a quiz type outside the contract enum throws
00:39 +177: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a subject with no lectures parses ΓÇö that is EMPTY, not an error
00:39 +178: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a missing required field throws
00:39 +179: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: the sealed union both branches ARE a SubjectTree, and are told apart by type
00:39 +180: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: the sealed union the runtime type and the parsed track agree
00:41 +181: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +182: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +183: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +184: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +185: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +186: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +187: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +188: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +189: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +190: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +191: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +192: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +193: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +194: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:43 +195: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +196: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +197: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +198: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +199: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +200: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +201: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +202: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +203: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +204: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +205: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:44 +206: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:45 +207: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: going back up and down again still does not re-fetch
00:47 +208: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:48 +209: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:49 +210: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:49 +211: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:49 +212: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:50 +213: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:50 +214: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:50 +215: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:50 +216: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +217: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +218: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +219: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +220: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +221: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +222: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +223: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +224: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:51 +225: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:52 +226: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:52 +227: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:52 +228: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:52 +229: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:52 +230: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:52 +231: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:52 +232: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +233: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +234: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +235: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +236: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +237: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +238: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +239: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:52 +240: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +241: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +242: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +243: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +244: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +245: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +246: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +247: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:52 +248: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +249: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:53 +263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +281: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +282: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:54 +283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +284: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +285: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +288: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +289: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +290: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +291: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +292: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +293: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +294: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +295: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +296: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +297: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +298: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +299: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +300: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:55 +301: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:55 +302: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:55 +303: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:55 +304: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all ΓåÆ no tab row, and the list still renders
00:55 +305: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me ΓÇö the hub already fetched it
00:56 +306: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +307: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +308: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +309: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +310: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +311: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +312: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +313: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:56 +314: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:56 +315: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:56 +316: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:56 +317: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:56 +318: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:56 +319: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:56 +320: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:56 +321: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:56 +322: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:57 +323: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +324: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +325: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +326: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +327: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +328: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +329: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +330: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +331: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +332: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +333: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +334: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +335: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +336: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +337: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:57 +338: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:58 +339: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:58 +340: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +341: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +342: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +343: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +344: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +345: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +346: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +347: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +348: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +349: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +350: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +351: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +352: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +353: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +354: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +355: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +356: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +357: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +358: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +359: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +360: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +361: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:58 +362: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +363: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +364: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +365: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +366: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +367: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +368: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +369: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +370: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +371: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +372: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +373: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +374: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +375: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +376: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +377: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +378: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +379: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +380: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +381: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +382: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +383: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +384: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +385: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +386: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +387: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +388: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +389: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +390: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +391: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +392: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +393: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +394: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +395: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +396: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +397: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:59 +398: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:59 +399: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:59 +400: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:59 +401: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:59 +402: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +403: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +404: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +405: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +406: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +407: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +408: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +409: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +410: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +411: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +412: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +413: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +414: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +415: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +416: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +417: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +418: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
01:00 +419: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name and the DEFAULT quiz type
01:00 +420: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name and the DEFAULT quiz type
01:00 +421: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
01:00 +422: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
01:00 +423: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
01:01 +424: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
01:01 +425: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: disabled rows are present AND non-interactive profile_row_favorites renders but has no tap target
01:01 +426: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:01 +427: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:01 +428: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:01 +429: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:01 +430: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:01 +431: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +432: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +433: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +434: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +435: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +436: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +437: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +438: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +439: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +440: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +441: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +442: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +443: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +444: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +445: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +446: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +447: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +448: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +449: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +450: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +451: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +452: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +453: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +454: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +455: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +456: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +457: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +458: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +459: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +460: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +461: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +462: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +463: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +464: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +465: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +466: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +467: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +468: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +469: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +470: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +471: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +472: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +473: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +475: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +476: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +477: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +478: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +479: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +480: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +481: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +482: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +483: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +484: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +485: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +486: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:04 +487: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +488: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +489: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +490: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +491: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +492: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +493: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +494: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +495: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +496: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +497: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +498: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +499: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +500: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +501: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +502: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +503: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +504: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +505: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +506: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +507: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +508: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +509: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +510: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +511: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +512: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +513: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +514: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +515: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +516: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +517: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +518: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +519: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +520: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +521: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +522: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +523: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +524: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +525: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
01:07 +526: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
01:07 +527: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +528: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +529: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +530: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +531: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +532: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +533: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +534: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +535: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:07 +536: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:08 +537: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
01:08 +538: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:08 +539: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:08 +540: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:08 +541: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:08 +542: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:08 +543: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:09 +544: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:10 +545: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:10 +546: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:10 +547: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:10 +548: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:11 +549: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:11 +550: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:11 +551: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:11 +552: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:11 +553: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:12 +554: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:12 +555: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:12 +556: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:12 +557: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +558: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +559: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +560: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +561: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +562: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +563: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +564: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +565: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +566: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +567: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +568: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +569: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +570: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +571: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +572: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +573: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +574: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +575: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +576: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +577: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +578: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +579: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +580: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +581: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +582: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +583: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +597: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +598: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +599: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +600: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +601: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +602: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +603: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +604: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) invalid parent phone blocks Continue
01:16 +605: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
01:17 +606: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:17 +607: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:17 +608: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:17 +609: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:17 +610: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:17 +611: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:17 +612: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:17 +613: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +614: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +615: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +616: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +617: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +618: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +619: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +620: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +621: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +622: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +623: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +624: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +625: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +626: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +627: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +628: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +629: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +630: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +631: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +632: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +633: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +634: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +635: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +636: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +637: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +638: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +639: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +640: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +641: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:20 +642: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:20 +643: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:20 +644: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:20 +645: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
01:20 +646: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout shows the frame fields in order after Date of Birth
01:20 +647: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout shows the frame fields in order after Date of Birth
01:20 +648: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
01:21 +649: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save offline shows the offline line, not a generic error
01:21 +650: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout includes the Date of Birth field the Figma frame is missing (DESIGN_ISSUES #2 ΓÇö contract-required)
01:21 +651: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:21 +652: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:22 +653: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:22 +654: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:22 +655: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:22 +656: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:22 +657: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:23 +658: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:23 +659: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:23 +660: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:23 +661: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:23 +662: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:23 +663: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:23 +664: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:23 +665: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +666: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +667: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +668: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +669: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +670: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +671: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +672: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +673: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:24 +674: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:25 +675: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:25 +676: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:25 +677: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:25 +678: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:25 +679: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:25 +680: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:26 +681: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:26 +682: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:26 +683: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:26 +684: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:26 +685: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:27 +686: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:27 +687: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:27 +688: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:27 +689: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:27 +690: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:27 +691: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:28 +692: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:28 +693: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) flipping leaderboardVisible sends ONLY leaderboardVisible
01:28 +694: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) flipping leaderboardVisible sends ONLY leaderboardVisible
01:28 +695: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) flipping leaderboardVisible sends ONLY leaderboardVisible
01:28 +696: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +697: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +698: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +699: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +700: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +701: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +702: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +703: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +704: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +705: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:29 +706: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:29 +707: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:29 +708: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:29 +709: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:29 +710: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:29 +711: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:30 +712: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:30 +713: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:30 +714: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:30 +715: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:30 +716: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:30 +717: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:30 +718: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:30 +719: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:30 +720: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:30 +721: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: switching tabs preserves Home ΓÇö /me is not re-fetched
01:30 +722: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:30 +723: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:30 +724: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:30 +725: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:30 +726: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:31 +727: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:31 +728: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
01:31 +729: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +730: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +731: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +732: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +733: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +734: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +735: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +736: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +737: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +738: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:31 +739: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:32 +740: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:32 +741: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:32 +742: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:32 +743: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:32 +744: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:32 +745: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:32 +746: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
01:33 +747: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
01:33 +748: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:33 +749: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:33 +750: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:34 +751: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:34 +752: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:34 +753: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:34 +754: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:34 +755: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:34 +756: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:34 +757: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:35 +758: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states empty ΓåÆ the localized empty line, not a blank field
01:35 +759: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages ΓÇö the existing locale switch both names are written in their own language, in both locales
01:35 +760: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages ΓÇö the existing locale switch both names are written in their own language, in both locales
01:35 +761: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: leaving the back chip pops to where the student came from
01:35 +762: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:35 +763: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:35 +764: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:35 +765: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:35 +766: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:35 +767: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:36 +768: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:36 +769: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:36 +770: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:36 +771: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:36 +772: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:37 +773: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:37 +774: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:37 +775: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark the legal screen is localized in Arabic
01:37 +776: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a language writes it too
01:37 +777: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:38 +778: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:38 +779: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:38 +780: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:39 +781: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:39 +782: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_support is structurally non-interactive
01:39 +783: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity ΓåÆ the offline banner
01:39 +784: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_system is structurally non-interactive
01:39 +785: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:39 +786: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) tapping one changes nothing and sends nothing
01:39 +787: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) tapping one changes nothing and sends nothing
01:40 +788: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) tapping one changes nothing and sends nothing
01:40 +789: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
01:40 +790: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) each announces itself disabled, with a reason
01:40 +791: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:40 +792: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic renders the Arabic section titles under RTL
01:40 +793: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:41 +794: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:41 +795: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:42 +796: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
01:42 +797: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" the picker is the default; the escape is a link under it
01:43 +798: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:43 +799: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" typing lands on the controller and clears the coded id
01:44 +800: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
01:45 +801: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
01:46 +802: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:46 +803: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:47 +804: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
01:48 +805: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable picking a school afterwards un-skips the field
01:48 +806: All tests passed!
```

