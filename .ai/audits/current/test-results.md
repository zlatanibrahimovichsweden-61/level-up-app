# Validation run - 2026-09-04T09:38:00Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 217 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 862 passed / 0 failed |

**OVERALL: PASS**

Started 2026-09-04T09:38:00Z - finished 2026-09-04T09:39:25Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-04T09:38:00Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9168
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : b7d0dfb
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 ΓÇó channel stable ΓÇó https://github.com/flutter/flutter.git
Framework ΓÇó revision 84fc5cbb22 (7 weeks ago) ΓÇó 2026-07-17 10:20:17 -0700
Engine ΓÇó hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (1 months ago) ΓÇó 2026-07-15 20:46:58.000Z
Tools ΓÇó Dart 3.12.2 ΓÇó DevTools 2.57.0

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

Formatted 60 files (0 changed) in 0.35 seconds.
Formatted 60 files (0 changed) in 0.32 seconds.
Formatted 60 files (0 changed) in 0.42 seconds.
Formatted 37 files (0 changed) in 0.24 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 11.0s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**862 passed, 0 failed** (exit 0)


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
00:00 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded ΓåÆ forceLogout(superseded), cleared, no refresh
00:00 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh ΓåÆ refresh_token_invalid ΓåÆ forceLogout(sessionExpired)
00:00 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s ΓåÆ refresh called exactly once, all retried
00:00 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again ΓåÆ not refreshed/retried a 2nd time
00:00 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh ΓåÆ NO logout, surfaces the network error
00:01 +13: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException carries the ProblemDetails field map
00:01 +14: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException is still an ApiException (existing handlers keep working)
00:01 +15: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a missing/malformed errors map yields empty fields, not a crash
00:01 +16: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a non-list value is tolerated as a single message
00:01 +17: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:01 +18: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 ΓåÆ UnauthorizedException carrying the code
00:01 +19: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 ΓåÆ ApiException carrying status + code
00:01 +20: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error ΓåÆ NetworkException (drives Offline)
00:01 +21: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException is typed, and is NOT otp_throttled
00:01 +22: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a delta-seconds Retry-After parses
00:01 +23: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an ABSENT header yields null ΓÇö and does not throw
00:01 +24: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a GARBAGE header yields null ΓÇö and does not throw
00:01 +25: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:01 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:01 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:01 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:01 +29: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:01 +30: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:01 +31: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:01 +32: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:01 +33: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:01 +34: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:01 +35: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:01 +36: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:01 +37: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:01 +38: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:01 +39: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:01 +40: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:01 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too ΓÇö one path, not two
00:01 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:02 +43: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route ΓåÆ /login
00:02 +44: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route ΓåÆ stay
00:02 +45: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:02 +46: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login ΓåÆ /home
00:02 +47: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / ΓÇö onboarding must be reachable
00:02 +48: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / ΓåÆ /home, never the onboarding pitch
00:02 +49: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / ΓåÆ wait; do not flash onboarding then bounce
00:02 +50: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route ΓåÆ stay
00:02 +51: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) ΓåÆ wait, never redirect
00:02 +52: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +55: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +56: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +78: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:04 +79: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:04 +80: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:04 +81: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is a different colour on each canvas ΓÇö that is the entire point
00:04 +82: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow carries no alpha of its own ΓÇö the call site owns the depth
00:04 +83: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is wired into copyWith and lerp
00:04 +84: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +85: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +86: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +87: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +88: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +89: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +90: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +91: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +92: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +93: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +94: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +95: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +96: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +97: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:05 +98: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:05 +99: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:05 +100: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me/entitlements parses, and agrees with the /me embed
00:06 +101: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:06 +102: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:06 +103: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable ΓÇö the 159:1852 variant
00:06 +104: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:06 +105: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:06 +106: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:06 +107: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:06 +108: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:06 +109: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:06 +110: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:06 +111: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:06 +112: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:06 +113: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent ΓÇö a repeat call replays the same summary
00:06 +114: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me ΓÇö what invalidating the profile shows
00:06 +115: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered ΓÇö expected, not a bug
00:06 +116: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 ΓÇö the polling path is walkable
00:06 +117: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:06 +118: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:06 +119: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:06 +120: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:06 +121: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:06 +122: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:06 +123: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:06 +124: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:06 +125: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:06 +126: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:06 +127: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:06 +128: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:06 +129: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:06 +130: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:06 +131: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:06 +132: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:06 +133: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:06 +134: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:06 +135: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:07 +136: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token ΓåÆ unauthenticated
00:07 +137: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token ΓåÆ authenticated
00:07 +138: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:07 +139: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:07 +140: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:07 +141: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:07 +142: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` registrationRequired ΓåÆ RegistrationRequiredResult with token + ttl
00:07 +143: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity ΓÇö required fields have no defensive defaults TokenPair throws when a required field is missing
00:07 +144: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:08 +145: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +146: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +147: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +148: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +149: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +150: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +151: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +152: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +153: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +154: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:09 +155: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +156: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +157: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +158: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +159: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +160: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +161: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +162: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +163: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +164: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +165: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +166: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +167: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +168: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +169: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +170: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +171: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +172: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +173: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +174: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +175: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +176: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +177: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +178: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +179: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +180: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:11 +181: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:11 +182: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: offline ΓåÆ distinct banner shown and Send OTP disabled
00:11 +183: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:11 +184: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:11 +185: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:11 +186: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +187: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +188: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +189: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +190: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +190: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:11 +191: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +192: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +193: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:11 +194: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +195: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +196: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +197: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +198: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +199: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +200: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +201: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +202: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +203: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +204: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +205: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +206: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +207: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +208: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +209: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +210: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +211: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +212: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +213: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +214: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:14 +215: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:15 +216: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:15 +217: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:15 +218: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:15 +219: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:15 +220: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:15 +221: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:15 +222: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:15 +223: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:15 +224: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:16 +225: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:16 +226: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:16 +227: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:16 +228: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:16 +229: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:16 +230: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:16 +231: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:16 +232: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:16 +233: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:16 +234: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:16 +235: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:16 +236: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:16 +237: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +238: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +239: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +240: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +241: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +242: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +243: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +244: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +245: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +246: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +247: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +248: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +249: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:16 +259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +281: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +282: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +284: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +285: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +288: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +289: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +290: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +291: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +292: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +293: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +294: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +295: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +296: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:17 +297: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:18 +298: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:18 +299: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:18 +300: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:18 +301: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:18 +302: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:18 +303: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:18 +304: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:18 +305: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
00:18 +306: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:18 +307: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:18 +308: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:18 +309: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:18 +310: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:18 +311: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:18 +312: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +313: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +314: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +315: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +316: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +317: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +318: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +319: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +320: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +321: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +322: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +323: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +324: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +325: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +326: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +327: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +328: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +329: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +330: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +331: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +332: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +333: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +334: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +335: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +336: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +337: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +338: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +339: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +340: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +341: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +342: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +343: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +344: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +345: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +346: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +347: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +348: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +349: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +350: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +351: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +352: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +353: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:19 +354: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +355: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +356: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +357: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +358: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +359: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +360: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +361: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +362: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +363: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +364: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +365: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +366: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +367: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +368: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +369: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +370: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +371: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +372: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +373: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +374: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +375: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +376: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +377: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +378: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +379: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +380: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +381: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +382: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +383: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +384: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +385: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +386: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +387: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +388: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +389: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +390: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +391: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +392: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +393: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +394: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +395: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +396: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +397: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +398: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +399: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +400: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +401: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +402: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:20 +403: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +404: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +405: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +406: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +407: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +408: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +409: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +410: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +411: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +412: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +413: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +414: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +415: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +416: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +417: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +418: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +419: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +420: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +421: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:20 +422: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:21 +423: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:21 +424: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:21 +425: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:21 +426: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:21 +427: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:21 +428: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:21 +429: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:21 +430: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:21 +431: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:21 +432: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:21 +433: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:21 +434: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form TYPED: a new address is sent as a string
00:21 +435: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form TYPED: a new address is sent as a string
00:21 +436: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form TYPED: a new address is sent as a string
00:21 +437: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:22 +438: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:22 +439: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +440: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +441: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +442: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +443: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +444: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +445: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:22 +446: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +447: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +448: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +449: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +450: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +451: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +452: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +453: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +454: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +455: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +456: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +457: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +458: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +459: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +460: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +461: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +462: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +463: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +464: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +465: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +466: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +467: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +468: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +469: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +470: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +471: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +472: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +473: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +475: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +476: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +477: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +478: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +479: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +480: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +481: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +482: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +483: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +484: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +485: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +486: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +487: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +488: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +489: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +490: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +491: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +492: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +493: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +494: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +495: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +496: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:23 +497: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +498: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +499: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +500: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +501: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +502: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +503: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +504: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +505: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +506: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +507: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +508: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +509: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +510: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:24 +511: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +512: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +513: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +514: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +515: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +516: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +517: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +518: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +519: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +520: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +521: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +522: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +523: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +524: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +525: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +526: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +527: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +528: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:24 +529: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:24 +530: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:24 +531: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +532: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +533: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +534: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +535: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +536: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +537: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +538: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +539: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +540: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +541: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +542: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +543: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +544: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +545: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +546: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:25 +547: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back renders the percentage ring but NO Pass/Fail verdict
00:25 +548: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +549: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +550: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +551: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +552: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +553: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +554: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +555: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +556: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +557: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +558: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +559: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +560: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +561: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +562: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:25 +563: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:25 +564: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:26 +565: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:26 +566: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:26 +567: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:26 +568: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:26 +569: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:26 +570: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:26 +571: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:26 +572: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:26 +573: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:26 +574: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:26 +575: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:26 +576: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:26 +577: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:26 +578: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:26 +579: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:27 +580: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:27 +581: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +582: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +583: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +597: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +598: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +599: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +600: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +601: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +602: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +603: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +604: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +605: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +606: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +607: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +608: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +609: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +610: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +611: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +612: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +613: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +614: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +615: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +616: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +617: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +618: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +619: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:27 +620: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +621: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +622: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +623: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:28 +631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:29 +642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:30 +652: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +653: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +654: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +655: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +656: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +657: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +658: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +659: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +660: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +661: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +662: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +663: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:30 +664: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +665: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +666: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +667: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +668: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +669: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +670: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +671: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +672: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +673: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +674: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +675: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:31 +676: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:32 +677: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:32 +678: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:32 +679: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:32 +680: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:32 +681: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:32 +682: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:32 +683: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:32 +684: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:32 +685: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +686: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +687: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +688: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +689: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +690: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +691: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:33 +692: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:34 +693: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:34 +694: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:34 +695: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
00:34 +696: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
00:34 +697: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
00:34 +698: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:34 +699: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:34 +700: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:34 +701: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:34 +702: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:34 +703: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
00:34 +704: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:34 +705: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:35 +706: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:35 +707: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:35 +708: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:35 +709: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:35 +710: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +711: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +712: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +713: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +714: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +715: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +716: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +717: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +718: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +719: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +720: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +721: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:35 +722: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
00:36 +723: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
00:36 +724: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
00:36 +725: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
00:36 +726: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
00:36 +727: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
00:36 +728: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
00:36 +729: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +730: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +731: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +732: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +733: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +734: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +735: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +736: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +737: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +738: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +739: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +740: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +741: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +742: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +743: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +744: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +745: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +746: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +747: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +748: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +749: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +750: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +751: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +752: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +753: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +754: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +755: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:36 +756: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:37 +757: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:37 +758: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:37 +759: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:37 +760: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
00:37 +761: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +762: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +763: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +764: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +765: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +766: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +767: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +768: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +769: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +770: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +771: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +772: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +773: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +774: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +775: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +776: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +777: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +778: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +779: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +780: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +781: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +782: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +783: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +784: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +785: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +786: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
00:37 +787: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +788: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +789: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +790: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +791: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +792: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +793: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +794: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +795: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +796: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +797: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +798: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +799: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +800: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +801: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +802: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +803: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +804: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +805: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
00:38 +806: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
00:38 +807: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
00:38 +808: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
00:39 +809: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
00:39 +810: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
00:39 +811: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +812: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +813: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +814: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +815: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +816: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +817: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +818: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +819: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +820: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +821: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
00:39 +822: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:39 +823: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:39 +824: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:39 +825: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:39 +826: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:40 +827: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:40 +828: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
00:40 +829: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a canvas writes it, so the next launch keeps it
00:40 +830: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
00:40 +831: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
00:40 +832: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
00:40 +833: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
00:40 +834: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
00:40 +835: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
00:41 +836: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_promotions is structurally non-interactive
00:41 +837: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
00:41 +838: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
00:41 +839: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
00:41 +840: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
00:41 +841: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
00:41 +842: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic renders the Arabic section titles under RTL
00:41 +843: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity ΓåÆ the offline banner
00:41 +844: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
00:41 +845: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
00:41 +846: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: expiry guard an expired token renders the expiry view instead of the form
00:41 +847: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark offline pins the banner and Rank still reads from cache
00:42 +848: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark offline pins the banner and Rank still reads from cache
00:42 +849: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
00:42 +850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
00:42 +851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
00:42 +852: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
00:43 +853: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" the picker is the default; the escape is a link under it
00:43 +854: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
00:43 +855: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" typing lands on the controller and clears the coded id
00:43 +856: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
00:44 +857: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
00:44 +858: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
00:44 +859: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
00:45 +860: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
00:45 +861: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable picking a school afterwards un-skips the field
00:45 +862: All tests passed!
```

