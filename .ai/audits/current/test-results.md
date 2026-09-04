# Validation run - 2026-09-04T09:12:31Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 217 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 861 passed / 0 failed |

**OVERALL: PASS**

Started 2026-09-04T09:12:31Z - finished 2026-09-04T09:15:16Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-04T09:12:31Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9168
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 9798dfa
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 84fc5cbb22 (7 weeks ago) • 2026-07-17 10:20:17 -0700
Engine • hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (1 months ago) • 2026-07-15 20:46:58.000Z
Tools • Dart 3.12.2 • DevTools 2.57.0

Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "windows_x64"
```

## 3. Dependencies (`flutter pub get`)

```text
Resolving dependencies...
Downloading packages...
  _fe_analyzer_shared 99.0.0 (107.0.0 available)
  analyzer 12.1.0 (14.3.0 available)
  analyzer_buffer 0.3.3 (0.3.4 available)
  build 4.0.7 (4.0.11 available)
  build_config 1.3.1 (1.3.3 available)
  build_daemon 4.1.2 (4.1.6 available)
  build_runner 2.15.1 (2.16.1 available)
  built_value 8.12.6 (8.13.0 available)
  cached_network_image 3.4.1 (4.0.0 available)
  cached_network_image_platform_interface 4.1.1 (5.0.0 available)
  cached_network_image_web 1.3.1 (2.0.0 available)
  clock 1.1.2 (1.1.3 available)
  code_assets 1.2.1 (2.0.0 available)
  code_builder 4.11.1 (4.12.0 available)
  connectivity_plus 7.3.0 (7.3.1 available)
  dart_style 3.1.8 (3.1.13 available)
  dbus 0.7.14 (0.7.15 available)
  dio 5.10.0 (5.11.1 available)
  dio_web_adapter 2.2.0 (2.2.2 available)
  flutter_riverpod 3.3.2 (3.4.3 available)
  flutter_secure_storage 10.3.1 (11.0.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.0 available)
  flutter_secure_storage_linux 3.0.1 (3.0.2 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.0.3 available)
  freezed 3.2.6-dev.1 (4.0.1 available)
  glob 2.1.3 (2.2.0 available)
  go_router 17.3.0 (18.0.1 available)
  hooks 2.0.2 (2.2.0 available)
  intl 0.20.2 (0.20.3 available)
  io 1.0.5 (1.1.0 available)
  jni 1.0.0 (1.0.3 available)
  jni_flutter 1.0.1 (1.0.3 available)
  jovial_svg 1.1.29 (1.1.30 available)
  json_serializable 6.14.0 (6.14.1 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.0 (1.19.0 available)
  mime 2.0.0 (2.1.0 available)
  mockito 5.6.4 (5.8.1 available)
  objective_c 9.4.1 (9.6.0 available)
  package_config 2.2.0 (3.0.0 available)
  pool 1.5.2 (1.5.3 available)
  pub_semver 2.2.0 (2.2.1 available)
  pubspec_parse 1.5.0 (1.6.0 available)
  record_use 0.6.0 (1.1.1 available)
  riverpod 3.3.2 (3.4.3 available)
  riverpod_analyzer_utils 1.0.0-dev.10 (1.0.0-dev.12 available)
  riverpod_annotation 4.0.3 (4.0.7 available)
  riverpod_generator 4.0.4 (4.0.9 available)
  shared_preferences_android 2.4.27 (2.4.28 available)
  shared_preferences_foundation 2.5.6 (2.5.7 available)
  source_gen 4.2.3 (4.3.0 available)
  source_helper 1.3.12 (1.3.13 available)
  source_maps 0.10.13 (0.10.14 available)
  stack_trace 1.12.1 (1.12.2 available)
  stream_transform 2.1.1 (2.1.2 available)
  synchronized 3.4.1+1 (3.4.1+2 available)
  test 1.31.0 (1.32.0 available)
  test_api 0.7.11 (0.7.14 available)
  test_core 0.6.17 (0.6.20 available)
  url_launcher_android 6.3.32 (6.3.33 available)
  url_launcher_ios 6.4.1 (6.4.2 available)
  url_launcher_linux 3.2.2 (3.2.3 available)
  url_launcher_macos 3.2.5 (3.2.6 available)
  url_launcher_windows 3.1.5 (3.1.6 available)
  vector_graphics 1.2.2 (1.2.3 available)
  vector_graphics_compiler 1.2.6 (1.3.0 available)
  vector_math 2.2.0 (2.4.2 available)
  vm_service 15.2.0 (15.3.0 available)
  win32 6.3.0 (6.4.0 available)
  xml 6.6.1 (7.0.1 available)
  yaml 3.1.3 (3.1.4 available)
Got dependencies!
72 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 217 hand-written Dart files

Formatted 60 files (0 changed) in 0.52 seconds.
Formatted 60 files (0 changed) in 0.50 seconds.
Formatted 60 files (0 changed) in 0.86 seconds.
Formatted 37 files (0 changed) in 0.60 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 23.7s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**861 passed, 0 failed** (exit 0)


### Full test output

```text
00:00 +0: loading F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart
00:00 +0: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: toJson — contract `format: date` (yyyy-MM-dd) emits a bare date, never an ISO-8601 timestamp
00:00 +1: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: toJson — contract `format: date` (yyyy-MM-dd) zero-pads month and day
00:00 +2: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: toJson — contract `format: date` (yyyy-MM-dd) a local midnight does NOT shift a day (Egypt is UTC+2 — a DoB is a calendar date, not an instant)
00:00 +3: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: fromJson parses a contract date string
00:00 +4: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: fromJson round-trips
00:00 +5: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: NullableDateOnlyConverter passes null through both ways
00:00 +6: F:/level/level_up/level_up_app/test/core/models/date_only_converter_test.dart: NullableDateOnlyConverter formats a value identically to the non-null converter
00:01 +7: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required → refresh once → original retried → success
00:01 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:01 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:01 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:01 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:01 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
00:02 +13: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException carries the ProblemDetails field map
00:02 +14: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException is still an ApiException (existing handlers keep working)
00:02 +15: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a missing/malformed errors map yields empty fields, not a crash
00:02 +16: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a non-list value is tolerated as a single message
00:02 +17: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:02 +18: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 → UnauthorizedException carrying the code
00:02 +19: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 → ApiException carrying status + code
00:02 +20: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error → NetworkException (drives Offline)
00:02 +21: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException is typed, and is NOT otp_throttled
00:02 +22: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a delta-seconds Retry-After parses
00:02 +23: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an ABSENT header yields null — and does not throw
00:02 +24: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a GARBAGE header yields null — and does not throw
00:02 +25: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:02 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:02 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:02 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:02 +29: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
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
00:03 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:03 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:03 +43: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:04 +44: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:04 +45: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:04 +46: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:04 +47: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:04 +48: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:04 +49: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:04 +50: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:04 +51: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:04 +52: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +55: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +56: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +80: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:08 +81: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:08 +82: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:08 +83: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:08 +84: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:08 +85: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +86: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +87: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +88: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +89: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +90: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +91: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +92: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +93: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +94: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +95: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +96: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +97: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +98: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:09 +99: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:09 +100: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:10 +101: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:10 +102: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:10 +103: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable — the 159:1852 variant
00:10 +104: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:10 +105: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:10 +106: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:10 +107: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:10 +108: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:10 +109: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:10 +110: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:10 +111: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:10 +112: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:11 +113: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent — a repeat call replays the same summary
00:11 +114: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me — what invalidating the profile shows
00:11 +115: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered — expected, not a bug
00:11 +116: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:11 +117: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:11 +118: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:11 +119: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:11 +120: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:11 +121: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:11 +122: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:11 +123: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:11 +124: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:11 +125: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:11 +126: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:11 +127: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:11 +128: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:11 +129: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:11 +130: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:11 +131: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:11 +132: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:11 +133: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:11 +134: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:11 +135: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:12 +136: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:12 +137: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:12 +138: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:12 +139: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:12 +140: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:12 +141: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:12 +142: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:12 +143: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:12 +144: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:13 +145: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +146: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +147: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +148: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +149: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +150: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +151: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +152: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +153: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +154: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:16 +155: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +156: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +157: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +158: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +159: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +160: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +161: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +162: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +163: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +164: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +165: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +166: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +167: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +168: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +169: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +170: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +171: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +172: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +173: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +174: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +175: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +176: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +177: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +178: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +179: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:18 +180: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +181: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +182: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +183: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +184: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +185: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +186: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +187: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +188: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +189: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +190: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +191: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +192: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +193: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +194: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +195: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +196: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +197: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +198: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +199: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +200: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +200: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:20 +201: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +202: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +203: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +204: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +205: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +206: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +207: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +208: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +209: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +210: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +211: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +212: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +213: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +214: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:24 +215: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:25 +216: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:25 +217: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:25 +218: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:25 +219: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:26 +220: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +221: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +222: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +223: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +224: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +225: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +226: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +227: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +228: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +229: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:27 +230: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +231: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +232: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +233: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +234: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +235: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +236: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +237: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +238: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +239: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +240: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +241: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +242: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +243: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +244: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +245: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +246: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +247: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +248: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +249: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:28 +263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +281: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +282: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +284: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +285: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +288: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +289: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +290: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +291: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +292: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +293: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +294: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +295: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +296: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +297: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +298: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +299: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +300: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +301: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title falls back to the bare title when the name is not cached
00:31 +302: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:31 +303: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:31 +304: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:32 +305: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:32 +306: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:32 +307: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:32 +308: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:32 +309: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:32 +310: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:32 +311: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:32 +312: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +313: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +314: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +315: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +316: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +317: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +318: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +319: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +320: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +321: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +322: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +323: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +324: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +325: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +326: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +327: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +328: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +329: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +330: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +331: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +332: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +333: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +334: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +335: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +336: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +337: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +338: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +339: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +340: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +341: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +342: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +343: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +344: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +345: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +346: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +347: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +348: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +349: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +350: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +351: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +352: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +353: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +354: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +355: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +356: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +357: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +358: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +359: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +360: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +361: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +362: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +363: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +364: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +365: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +366: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +367: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +368: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +369: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +370: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +371: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +372: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +373: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +374: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +375: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +376: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +377: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +378: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +379: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +380: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +381: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +382: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +383: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +384: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +385: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +386: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +387: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +388: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +389: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +390: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +391: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +392: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +393: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +394: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:35 +395: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +396: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +397: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +398: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +399: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +400: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +401: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +402: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +403: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:36 +404: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +405: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +406: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +407: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +408: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +409: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +410: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +411: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +412: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +413: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +414: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +415: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +416: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +417: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +418: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:37 +419: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:37 +420: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:37 +421: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:38 +422: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:38 +423: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:38 +424: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded points.total is printed, not re-summed from the dual pools (adr-003)
00:38 +425: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:38 +426: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:38 +427: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:39 +428: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:39 +429: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:39 +430: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:39 +431: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:39 +432: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:39 +433: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form TYPED: a new address is sent as a string
00:40 +434: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form TYPED: a new address is sent as a string
00:40 +435: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form TYPED: a new address is sent as a string
00:40 +436: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +437: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +438: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +439: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +440: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:41 +441: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:41 +442: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:41 +443: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:41 +444: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +445: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +446: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +447: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +448: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +449: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +450: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +451: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +452: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +453: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +454: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +455: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +456: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +457: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:42 +458: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +459: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +460: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +461: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +462: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +463: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +464: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +465: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +466: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +467: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +468: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +469: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +470: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +471: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +472: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +473: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +475: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +476: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +477: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +478: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +479: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +480: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +481: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +482: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +483: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +484: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +485: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +486: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +487: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +488: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +489: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +490: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +491: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +492: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +493: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +494: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +495: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +496: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +497: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +498: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +499: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +500: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +501: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +502: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +503: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +504: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +505: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:43 +506: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:44 +507: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:44 +508: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:44 +509: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:44 +510: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:44 +511: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:44 +512: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +513: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +514: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +515: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +516: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +517: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +518: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +519: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +520: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +521: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +522: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +523: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +524: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +525: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +526: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +527: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +528: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +529: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +530: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:45 +531: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +532: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +533: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +534: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +535: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +536: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +537: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +538: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +539: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +540: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:45 +541: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:46 +542: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:46 +543: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:46 +544: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:46 +545: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:46 +546: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) the phone is the value GET /me returned, verbatim
00:46 +547: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) the phone is the value GET /me returned, verbatim
00:46 +548: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +549: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +550: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +551: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +552: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +553: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +554: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +555: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:46 +556: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:47 +557: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:47 +558: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:47 +559: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:47 +560: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:47 +561: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +562: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +563: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:48 +564: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:48 +565: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:48 +566: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:48 +567: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:48 +568: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:49 +569: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:49 +570: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:49 +571: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:49 +572: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:49 +573: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:49 +574: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:50 +575: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:50 +576: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:50 +577: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:50 +578: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +579: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +580: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +581: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +582: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +583: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +597: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +598: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +599: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +600: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +601: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +602: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +603: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +604: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +605: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +606: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +607: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +608: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +609: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +610: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +611: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +612: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +613: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +614: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +615: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +616: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +617: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +618: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +619: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +620: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +621: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +622: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +623: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:54 +628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:54 +629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:54 +630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:55 +631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:55 +632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:55 +633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:55 +634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +652: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:57 +653: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +654: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +655: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +656: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +657: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +658: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +659: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +660: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +661: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +662: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +663: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +664: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +665: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +666: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +667: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +668: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +669: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:01 +670: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:01 +671: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:01 +672: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:01 +673: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +674: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +675: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:02 +676: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:02 +677: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:02 +678: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:02 +679: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:02 +680: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +681: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +682: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +683: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +684: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +685: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +686: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:04 +687: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:04 +688: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:04 +689: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:05 +690: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:05 +691: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:05 +692: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:05 +693: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:06 +694: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:06 +695: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:06 +696: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:06 +697: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:06 +698: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:06 +699: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:07 +700: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:07 +701: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:07 +702: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:07 +703: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:07 +704: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:07 +705: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:07 +706: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:07 +707: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:07 +708: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:07 +709: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +710: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +711: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +712: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +713: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +714: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +715: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +716: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +717: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:08 +718: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:09 +719: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:09 +720: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:09 +721: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:09 +722: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:09 +723: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:09 +724: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:09 +725: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:09 +726: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:10 +727: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:10 +728: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) a successful save re-reads /me — the server decides the value
01:10 +729: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) a successful save re-reads /me — the server decides the value
01:10 +730: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) a successful save re-reads /me — the server decides the value
01:10 +731: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +732: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +733: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +734: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +735: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +736: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +737: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +738: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +739: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +740: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +741: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +742: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +743: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +744: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +745: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +746: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +747: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +748: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +749: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +750: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +751: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +752: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +753: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +754: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +755: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:11 +756: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:12 +757: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:12 +758: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:12 +759: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +760: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +761: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +762: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +763: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +764: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +765: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +766: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +767: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +768: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +769: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +770: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +771: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +772: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +773: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +774: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +775: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +776: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +777: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +778: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +779: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +780: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +781: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +782: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +783: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +784: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:13 +785: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:14 +786: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +787: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +788: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +789: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +790: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +791: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +792: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +793: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +794: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +795: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +796: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +797: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +798: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +799: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +800: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +801: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +802: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +803: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +804: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +805: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:15 +806: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:15 +807: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:16 +808: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:16 +809: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +810: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +811: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +812: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +813: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +814: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +815: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:17 +816: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:17 +817: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:17 +818: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:17 +819: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:17 +820: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:17 +821: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +822: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +823: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +824: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +825: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +826: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:18 +827: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:18 +828: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a canvas writes it, so the next launch keeps it
01:18 +829: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:18 +830: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:18 +831: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:19 +832: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:19 +833: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:19 +834: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_announcements is structurally non-interactive
01:19 +835: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:20 +836: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:20 +837: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:20 +838: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:20 +839: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:21 +840: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:21 +841: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:21 +842: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity → the offline banner
01:21 +843: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:21 +844: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:21 +845: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:21 +846: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: expiry guard no draft at all renders the expiry view
01:21 +847: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark offline pins the banner and Rank still reads from cache
01:22 +848: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
01:22 +849: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:22 +850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:23 +851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
01:23 +852: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" the picker is the default; the escape is a link under it
01:24 +853: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:24 +854: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:25 +855: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:26 +856: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:26 +857: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:27 +858: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:27 +859: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable an Egyptian student can submit having skipped it
01:28 +860: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:28 +861: All tests passed!
```

