# Validation run - 2026-08-22T19:52:30Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 217 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 856 passed / 0 failed |

**OVERALL: PASS**

Started 2026-08-22T19:52:30Z - finished 2026-08-22T19:55:13Z

---

## 1. Environment

```text
started (UTC)  : 2026-08-22T19:52:30Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9168
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 20cb836
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 ΓÇó channel stable ΓÇó https://github.com/flutter/flutter.git
Framework ΓÇó revision 84fc5cbb22 (5 weeks ago) ΓÇó 2026-07-17 10:20:17 -0700
Engine ΓÇó hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (1 months ago) ΓÇó 2026-07-15 20:46:58.000Z
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
  code_assets 1.2.1 (2.0.0 available)
  connectivity_plus 7.3.0 (7.3.1 available)
  dart_style 3.1.8 (3.1.12 available)
  dbus 0.7.14 (0.7.15 available)
  dio 5.10.0 (5.11.0 available)
  dio_web_adapter 2.2.0 (2.2.1 available)
  flutter_riverpod 3.3.2 (3.4.2 available)
  flutter_secure_storage 10.3.1 (11.0.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.0 available)
  flutter_secure_storage_linux 3.0.1 (3.0.2 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.0.3 available)
  freezed 3.2.6-dev.1 (4.0.0 available)
  go_router 17.3.0 (17.5.0 available)
  hooks 2.0.2 (2.2.0 available)
  intl 0.20.2 (0.20.3 available)
  jni 1.0.0 (1.0.3 available)
  jni_flutter 1.0.1 (1.0.2 available)
  jovial_svg 1.1.29 (1.1.30 available)
  json_serializable 6.14.0 (6.14.1 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.0 (1.19.0 available)
  mockito 5.6.4 (5.8.1 available)
  objective_c 9.4.1 (9.6.0 available)
  package_config 2.2.0 (3.0.0 available)
  record_use 0.6.0 (1.1.1 available)
  riverpod 3.3.2 (3.4.2 available)
  riverpod_analyzer_utils 1.0.0-dev.10 (1.0.0-dev.11 available)
  riverpod_annotation 4.0.3 (4.0.6 available)
  riverpod_generator 4.0.4 (4.0.8 available)
  source_gen 4.2.3 (4.3.0 available)
  source_helper 1.3.12 (1.3.13 available)
  source_maps 0.10.13 (0.10.14 available)
  synchronized 3.4.1+1 (3.4.1+2 available)
  test 1.31.0 (1.31.2 available)
  test_api 0.7.11 (0.7.13 available)
  test_core 0.6.17 (0.6.19 available)
  vector_graphics 1.2.2 (1.2.3 available)
  vector_graphics_compiler 1.2.6 (1.3.0 available)
  vector_math 2.2.0 (2.4.2 available)
  vm_service 15.2.0 (15.3.0 available)
  win32 6.3.0 (6.4.0 available)
  xml 6.6.1 (7.0.1 available)
Got dependencies!
50 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 217 hand-written Dart files

Formatted 60 files (0 changed) in 0.44 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 60 files (0 changed) in 0.51 seconds.
Formatted 37 files (0 changed) in 0.34 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 16.8s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**856 passed, 0 failed** (exit 0)


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
00:01 +7: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required ΓåÆ refresh once ΓåÆ original retried ΓåÆ success
00:01 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded ΓåÆ forceLogout(superseded), cleared, no refresh
00:01 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh ΓåÆ refresh_token_invalid ΓåÆ forceLogout(sessionExpired)
00:01 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s ΓåÆ refresh called exactly once, all retried
00:01 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again ΓåÆ not refreshed/retried a 2nd time
00:01 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh ΓåÆ NO logout, surfaces the network error
00:02 +13: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException carries the ProblemDetails field map
00:02 +14: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException is still an ApiException (existing handlers keep working)
00:02 +15: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a missing/malformed errors map yields empty fields, not a crash
00:02 +16: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a non-list value is tolerated as a single message
00:02 +17: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:02 +18: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 ΓåÆ UnauthorizedException carrying the code
00:02 +19: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 ΓåÆ ApiException carrying status + code
00:02 +20: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error ΓåÆ NetworkException (drives Offline)
00:02 +21: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException is typed, and is NOT otp_throttled
00:02 +22: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a delta-seconds Retry-After parses
00:02 +23: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an ABSENT header yields null ΓÇö and does not throw
00:02 +24: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a GARBAGE header yields null ΓÇö and does not throw
00:02 +25: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:02 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:02 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:02 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:03 +29: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:03 +30: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:03 +31: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:03 +32: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:03 +33: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:03 +34: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:03 +35: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:03 +36: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:03 +37: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:03 +38: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:03 +39: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:03 +40: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:03 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too ΓÇö one path, not two
00:03 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:04 +43: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route ΓåÆ /login
00:04 +44: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route ΓåÆ stay
00:04 +45: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:04 +46: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login ΓåÆ /home
00:04 +47: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / ΓÇö onboarding must be reachable
00:04 +48: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / ΓåÆ /home, never the onboarding pitch
00:04 +49: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / ΓåÆ wait; do not flash onboarding then bounce
00:04 +50: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route ΓåÆ stay
00:04 +51: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) ΓåÆ wait, never redirect
00:04 +52: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +55: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not receive Student A profile
00:07 +56: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not inherit Student A entitlements
00:07 +57: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device Student B does not inherit Student A subject catalogue
00:07 +58: F:/level/level_up/level_up_app/test/core/session/session_isolation_test.dart: Scenario A ΓÇö normal sign-out on a shared device the profile is re-fetched, not served from cache
00:07 +59: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:07 +60: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:07 +61: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:07 +62: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:07 +63: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:07 +64: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:07 +65: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: no provider is both invalidated and exempted
00:07 +66: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: the exemption list has no stale entries
00:07 +67: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: both sign-out paths call the invalidation
00:07 +68: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: forceLogout keeps its re-entry guard
00:08 +69: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places light and dark both define them
00:08 +70: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places copyWith round-trips each of them
00:08 +71: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp moves each of them ΓÇö a missing entry would pin one in place
00:08 +72: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp endpoints are exact
00:08 +73: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge is identical in both palettes ΓÇö it must not follow the accent flip
00:08 +74: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge equals the fill in the exported SVG ΓÇö not an estimate
00:08 +75: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge the badge keeps its white checkmark ΓÇö so it is never srcIn-tinted
00:08 +76: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: all three brand assets landed
00:09 +77: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:09 +78: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:09 +79: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:09 +80: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is a different colour on each canvas ΓÇö that is the entire point
00:09 +81: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow carries no alpha of its own ΓÇö the call site owns the depth
00:09 +82: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is wired into copyWith and lerp
00:09 +83: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:10 +84: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:10 +85: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:10 +86: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:10 +87: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:10 +88: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:10 +89: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:11 +90: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:12 +91: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: mock GET /catalog/subjects parses into Subjects
00:12 +92: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: every mocked subject has a walkable tree
00:12 +93: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) GET /me comes back as a university profile
00:12 +94: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) every university subject has a walkable lecture tree
00:12 +95: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) quizTypes vary per subject, so the tab row cannot be hardcoded
00:12 +96: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) a school subject id is out of scope for a university student
00:12 +97: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: an out-of-scope subject answers the contract 403
00:14 +98: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:14 +99: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me/entitlements parses, and agrees with the /me embed
00:15 +100: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:15 +101: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:15 +102: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable ΓÇö the 159:1852 variant
00:15 +103: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:15 +104: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:15 +105: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:15 +106: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:15 +107: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:15 +108: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:15 +109: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:15 +110: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:15 +111: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:16 +112: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent ΓÇö a repeat call replays the same summary
00:16 +113: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me ΓÇö what invalidating the profile shows
00:16 +114: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered ΓÇö expected, not a bug
00:16 +115: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 ΓÇö the polling path is walkable
00:16 +116: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:16 +117: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:17 +118: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:17 +119: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:17 +120: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:17 +121: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:17 +122: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:17 +123: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:17 +124: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:17 +125: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:17 +126: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:17 +127: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:17 +128: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:17 +129: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:17 +130: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:17 +131: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:17 +132: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:17 +133: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:17 +134: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:19 +135: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token ΓåÆ unauthenticated
00:19 +136: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token ΓåÆ authenticated
00:19 +137: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:19 +138: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:19 +139: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:20 +140: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:20 +141: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` registrationRequired ΓåÆ RegistrationRequiredResult with token + ttl
00:20 +142: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity ΓÇö required fields have no defensive defaults TokenPair throws when a required field is missing
00:20 +143: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:23 +144: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:25 +145: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:25 +146: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:27 +147: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: (setUpAll)
00:27 +147: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: renders in Arabic with RTL directionality
00:27 +148: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:27 +149: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:28 +150: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:28 +151: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:28 +152: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:29 +153: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:29 +154: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +155: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +156: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +157: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +158: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +159: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +160: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +161: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +162: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +163: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +164: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:30 +165: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:30 +166: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: (tearDownAll)
00:31 +166: F:/level/level_up/level_up_app/test/features/auth/verify_fork_test.dart: (setUpAll)
00:31 +166: F:/level/level_up/level_up_app/test/features/auth/verify_fork_test.dart: authenticated ΓåÆ tokens stored, then AuthenticatedOutcome
00:31 +167: F:/level/level_up/level_up_app/test/features/auth/verify_fork_test.dart: registrationRequired ΓåÆ carries token, does NOT store tokens
00:31 +168: F:/level/level_up/level_up_app/test/features/auth/verify_fork_test.dart: otp_invalid ΓåÆ inline error + red-box flag, no outcome
00:31 +169: F:/level/level_up/level_up_app/test/features/auth/verify_fork_test.dart: offline (NetworkException) surfaces as an offline-classified error
00:31 +170: F:/level/level_up/level_up_app/test/features/auth/verify_fork_test.dart: (tearDownAll)
00:31 +170: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: Subject parses a row of GET /catalog/subjects
00:31 +171: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: Subject a missing required field throws rather than defaulting
00:31 +172: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction is answered/total
00:31 +173: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction a subject with no questions is 0, not NaN
00:31 +174: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction is clamped, so bad server data cannot overflow the bar
00:31 +175: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree parses the whole nested structure from one payload
00:31 +176: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree an empty level parses as empty, not as an error
00:31 +177: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree a tree with no units at all parses
00:31 +178: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree a missing required field throws
00:31 +179: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree an unknown track value throws ΓÇö the discriminator is closed
00:31 +180: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree parses the university branch of the oneOf
00:31 +181: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree lectures carry a questionCounter ΓÇö unlike school units/chapters
00:31 +182: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree quizTypes parse as the contract enum, in server order
00:31 +183: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a quiz type outside the contract enum throws
00:31 +184: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a subject with no lectures parses ΓÇö that is EMPTY, not an error
00:31 +185: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a missing required field throws
00:31 +186: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: the sealed union both branches ARE a SubjectTree, and are told apart by type
00:31 +187: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: the sealed union the runtime type and the parsed track agree
00:32 +188: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +189: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +190: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +191: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +192: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +193: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +194: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +195: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +196: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +197: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +198: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +199: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +200: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +201: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +202: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +203: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +204: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +205: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +206: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +207: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +208: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +209: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +210: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +211: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +212: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:35 +213: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:36 +214: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: going back up and down again still does not re-fetch
00:38 +215: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:39 +216: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:40 +217: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:40 +218: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:41 +219: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:41 +220: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:41 +221: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:41 +222: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:42 +223: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:42 +224: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:42 +225: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:42 +226: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:42 +227: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:42 +228: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:42 +229: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:43 +230: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:43 +231: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:43 +232: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +233: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +234: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +235: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +236: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +237: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +238: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:43 +239: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:44 +240: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:44 +241: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:44 +242: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:44 +243: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:44 +244: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +245: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +246: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +247: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +248: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +249: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +281: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +282: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +284: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +285: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +288: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +289: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +290: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +291: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +292: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +293: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +294: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +295: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +296: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +297: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +298: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +299: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +300: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +301: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +302: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +303: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +304: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +305: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +306: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +307: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +308: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +309: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +310: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +311: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +312: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +313: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:47 +314: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me ΓÇö the hub already fetched it
00:48 +315: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
00:48 +316: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:48 +317: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:48 +318: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:48 +319: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:48 +320: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:48 +321: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:48 +322: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +323: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +324: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +325: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +326: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +327: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +328: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +329: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +330: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:48 +331: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:49 +332: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:49 +333: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:49 +334: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:50 +335: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:50 +336: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:50 +337: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +338: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +339: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +340: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +341: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +342: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +343: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +344: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +345: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +346: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +347: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +348: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +349: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +350: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +351: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +352: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +353: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +354: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +355: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +356: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +357: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +358: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +359: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +360: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +361: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +362: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:53 +363: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form the screen says out loud that an empty box deletes
00:53 +364: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states 403 insufficient_scope gets its own copy and NO retry
00:53 +365: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states 403 insufficient_scope gets its own copy and NO retry
00:53 +366: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:54 +367: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:54 +368: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:54 +369: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:54 +370: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:54 +371: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:55 +372: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:55 +373: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: disabled rows are present AND non-interactive profile_row_subscription renders but has no tap target
00:55 +374: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:55 +375: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:55 +376: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: disabled rows are present AND non-interactive every live row DOES have a tap target
00:55 +377: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:56 +378: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:56 +379: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar tapping Upload photo changes nothing
00:56 +380: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar tapping Upload photo changes nothing
00:56 +381: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar tapping Upload photo changes nothing
00:56 +382: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +383: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +384: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +385: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +386: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +387: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +388: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +389: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +390: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +391: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +392: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +393: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +394: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +395: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:56 +396: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +397: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +398: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +399: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +400: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +401: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +402: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +403: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +404: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +405: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +406: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +407: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +408: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +409: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +410: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +411: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:57 +412: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) a "Parent's Number" row is not built ΓÇö /me has no source
00:57 +413: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +414: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +415: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +416: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +417: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +418: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +419: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +420: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +421: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +422: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +423: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +424: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
00:58 +425: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +426: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +427: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +428: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +429: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +430: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +431: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +432: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +433: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +434: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +435: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +436: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +437: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +438: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +439: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +440: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a CODED city renders the English name in EN
00:58 +441: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:58 +442: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +443: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +444: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +445: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +446: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +447: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +448: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +449: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +450: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +451: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +452: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +453: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +454: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +455: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +456: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +457: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +458: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +459: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +460: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +461: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +462: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
00:59 +463: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
01:00 +464: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
01:00 +465: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
01:00 +466: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save 400 validation_failed lands as an inline error on the field
01:00 +467: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home ΓåÆ Account
01:01 +468: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:01 +469: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
01:01 +470: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save an empty name is rejected before a request is made
01:01 +471: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) dismiss does NOT log out
01:01 +472: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save offline shows the offline line, not a generic error
01:01 +473: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Go to Uni dialog opens, and its Confirm is genuinely disabled
01:01 +474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +475: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +476: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +477: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +478: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +479: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +480: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +481: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +482: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +483: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +484: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +485: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +486: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +487: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +488: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +489: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +490: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:03 +491: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +492: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +493: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +494: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:04 +495: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:04 +496: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +497: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +498: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +499: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +500: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:06 +501: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +502: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +503: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +504: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +505: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +506: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +507: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +508: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +509: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +510: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +511: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +512: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +513: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +514: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +515: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:06 +516: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:07 +517: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:07 +518: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:07 +519: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:07 +520: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:07 +521: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:07 +522: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +523: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +524: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +525: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +526: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +527: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +528: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +529: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +530: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +531: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:08 +532: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +533: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +534: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +535: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +536: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +537: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +538: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +539: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +540: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +541: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +542: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +543: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +544: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +545: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +546: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +547: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +548: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +549: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +550: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +551: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +552: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +553: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +554: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +555: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +556: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +557: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +558: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +559: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +560: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +561: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +562: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +563: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +564: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +565: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +566: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +567: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:08 +568: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering the subject line is absent ΓÇö no endpoint returns one
01:08 +569: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix Arabic (RTL)
01:08 +570: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:08 +571: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:08 +572: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:08 +573: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:09 +574: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
01:09 +575: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix leveledUp and newBadge parse but celebrate nothing
01:09 +576: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:09 +577: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:09 +578: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +579: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +580: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +581: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +582: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +583: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +584: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +585: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +586: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +587: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +588: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +589: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:09 +590: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +591: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +592: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +593: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +594: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +595: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +596: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +597: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +598: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +599: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +600: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +601: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:10 +602: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:10 +603: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
01:10 +604: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:10 +605: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:10 +606: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:11 +607: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
01:11 +608: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +609: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +610: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +611: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +612: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +613: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +614: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +615: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:11 +616: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
01:11 +617: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
01:11 +618: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
01:11 +619: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:11 +620: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:12 +621: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
01:12 +622: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
01:12 +623: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: states matrix Arabic (RTL) renders the Arabic copy
01:13 +624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:13 +629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:14 +631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +652: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:15 +653: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:16 +654: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +655: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +656: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +657: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +658: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +659: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +660: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +661: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +662: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:17 +663: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:17 +664: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +665: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +666: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:18 +667: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +668: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +669: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +670: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +671: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:19 +672: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:20 +673: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:20 +674: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:20 +675: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +676: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +677: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +678: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +679: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +680: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +681: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:21 +682: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:22 +683: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:22 +684: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:22 +685: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:22 +686: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:22 +687: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:23 +688: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:23 +689: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:23 +690: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:23 +691: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:23 +692: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:23 +693: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:24 +694: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:24 +695: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:24 +696: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:24 +697: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:24 +698: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:24 +699: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:25 +700: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:25 +701: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:25 +702: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:25 +703: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:25 +704: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:25 +705: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:26 +706: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:26 +707: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:26 +708: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:26 +709: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:26 +710: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:26 +711: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:27 +712: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:27 +713: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:27 +714: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:28 +715: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:28 +716: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:28 +717: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:28 +718: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:28 +719: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:28 +720: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:28 +721: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:28 +722: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:28 +723: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:29 +724: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:29 +725: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:29 +726: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:29 +727: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +728: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +729: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +730: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +731: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +732: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +733: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +734: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +735: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +736: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:30 +737: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:30 +738: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:30 +739: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:30 +740: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +741: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +742: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +743: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +744: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +745: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +746: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
01:31 +747: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:31 +748: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:31 +749: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:31 +750: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:31 +751: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:31 +752: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:31 +753: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +754: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +755: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +756: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +757: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +758: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +759: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +760: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +761: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +762: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:32 +763: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:33 +764: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:33 +765: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:33 +766: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:33 +767: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:33 +768: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +769: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +770: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +771: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +772: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +773: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +774: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +775: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +776: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +777: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +778: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +779: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +780: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +781: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +782: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +783: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +784: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:33 +785: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:34 +786: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:34 +787: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:34 +788: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +789: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +790: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +791: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +792: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +793: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +794: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +795: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +796: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +797: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +798: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +799: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +800: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +801: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +802: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +803: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +804: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +805: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +806: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +807: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +808: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +809: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +810: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +811: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +812: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +813: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +814: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +815: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +816: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +817: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +818: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:34 +819: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:35 +820: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) tapping one changes nothing and sends nothing
01:35 +821: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +822: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +823: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +824: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +825: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +826: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +827: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +828: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +829: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +830: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +831: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:35 +832: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:36 +833: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:36 +834: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:36 +835: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:36 +836: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:36 +837: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:36 +838: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity ΓåÆ the offline banner
01:36 +839: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:36 +840: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: expiry guard an expired token renders the expiry view instead of the form
01:37 +841: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: expiry guard no draft at all renders the expiry view
01:37 +842: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
01:37 +843: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:37 +844: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:37 +845: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:38 +846: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
01:39 +847: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" the picker is the default; the escape is a link under it
01:39 +848: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:40 +849: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" typing lands on the controller and clears the coded id
01:40 +850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
01:41 +851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
01:42 +852: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:42 +853: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:43 +854: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
01:43 +855: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable picking a school afterwards un-skips the field
01:44 +856: All tests passed!
```

