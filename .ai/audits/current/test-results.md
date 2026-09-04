# Validation run - 2026-09-04T09:40:17Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 217 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 862 passed / 0 failed |

**OVERALL: PASS**

Started 2026-09-04T09:40:17Z - finished 2026-09-04T09:42:16Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-04T09:40:17Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9168
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 5c4b855
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

Formatted 60 files (0 changed) in 0.31 seconds.
Formatted 60 files (0 changed) in 0.28 seconds.
Formatted 60 files (0 changed) in 0.47 seconds.
Formatted 37 files (0 changed) in 0.31 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 10.8s)
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
00:01 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded ΓåÆ forceLogout(superseded), cleared, no refresh
00:01 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh ΓåÆ refresh_token_invalid ΓåÆ forceLogout(sessionExpired)
00:01 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s ΓåÆ refresh called exactly once, all retried
00:01 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again ΓåÆ not refreshed/retried a 2nd time
00:01 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh ΓåÆ NO logout, surfaces the network error
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
00:02 +37: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:02 +38: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:02 +39: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:02 +40: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:02 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too ΓÇö one path, not two
00:02 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
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
00:03 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
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
00:05 +78: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +79: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:05 +80: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:05 +81: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is a different colour on each canvas ΓÇö that is the entire point
00:05 +82: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow carries no alpha of its own ΓÇö the call site owns the depth
00:05 +83: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is wired into copyWith and lerp
00:05 +84: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
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
00:06 +97: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:06 +98: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:06 +99: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:06 +100: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me/entitlements parses, and agrees with the /me embed
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
00:07 +118: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:07 +119: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:07 +120: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:07 +121: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:07 +122: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:07 +123: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:07 +124: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:07 +125: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:07 +126: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:07 +127: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:07 +128: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:07 +129: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:07 +130: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:07 +131: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:07 +132: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:07 +133: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:07 +134: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:07 +135: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:07 +136: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token ΓåÆ unauthenticated
00:07 +137: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token ΓåÆ authenticated
00:07 +138: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:07 +139: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:07 +140: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:07 +141: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:08 +142: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` registrationRequired ΓåÆ RegistrationRequiredResult with token + ttl
00:08 +143: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity ΓÇö required fields have no defensive defaults TokenPair throws when a required field is missing
00:08 +144: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:08 +145: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +146: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +147: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +148: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +149: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +150: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +151: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +152: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +153: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +154: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +155: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:10 +156: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +157: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +158: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +159: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +160: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:10 +161: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +162: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +163: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +164: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +165: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +166: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +167: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +168: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +169: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +170: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +171: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +172: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +173: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +174: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +175: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +176: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +177: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +178: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +179: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:11 +180: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:11 +181: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:11 +182: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: offline ΓåÆ distinct banner shown and Send OTP disabled
00:11 +183: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:11 +184: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:12 +185: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:12 +185: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:12 +186: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard ΓÇö it starts the same phone ΓåÆ OTP flow
00:12 +187: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +188: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +189: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +190: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +191: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +192: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +193: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +194: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +195: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +196: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +197: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +198: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +199: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +200: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +201: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:12 +202: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +203: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +204: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +205: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +206: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +207: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +208: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +209: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +210: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +211: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +212: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +213: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:13 +214: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:15 +215: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:16 +216: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:18 +217: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:18 +218: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:18 +219: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:18 +220: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:19 +221: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:19 +222: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:19 +223: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:19 +224: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:19 +225: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +226: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +227: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +228: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +229: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +230: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +231: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:19 +232: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +233: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +234: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +235: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +236: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +237: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +238: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:20 +239: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:20 +240: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:20 +241: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +242: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +243: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +244: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +245: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +246: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +247: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +248: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +249: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:21 +267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +281: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +282: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +284: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +285: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +288: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +289: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +290: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +291: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +292: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:22 +293: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +294: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +295: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +296: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +297: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +298: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +299: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +300: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +301: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:23 +302: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:24 +303: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search a query that matches nothing shows its own message
00:24 +304: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search a query that matches nothing shows its own message
00:24 +305: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title falls back to the bare title when the name is not cached
00:24 +306: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:24 +307: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:25 +308: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:25 +309: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:25 +310: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:25 +311: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +312: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +313: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +314: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +315: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +316: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +317: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +318: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +319: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +320: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +321: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +322: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +323: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +324: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +325: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +326: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +327: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +328: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +329: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +330: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:26 +331: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:27 +332: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:27 +333: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +334: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +335: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +336: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +337: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +338: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +339: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +340: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +341: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +342: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +343: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +344: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +345: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +346: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +347: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +348: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +349: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +350: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +351: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +352: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +353: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +354: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +355: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +356: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +357: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +358: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:28 +359: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +360: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +361: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +362: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +363: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +364: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +365: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +366: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +367: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +368: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +369: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +370: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +371: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +372: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +373: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +374: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +375: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +376: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +377: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +378: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +379: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +380: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +381: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +382: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +383: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +384: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +385: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +386: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +387: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +388: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +389: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +390: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +391: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +392: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +393: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +394: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +395: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +396: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +397: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:29 +398: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +399: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +400: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +401: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +402: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +403: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +404: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +405: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +406: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +407: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +408: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +409: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +410: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +411: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +412: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +413: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +414: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +415: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +416: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +417: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +418: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +419: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +420: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:30 +421: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:31 +422: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:31 +423: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:31 +424: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:31 +425: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:31 +426: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:31 +427: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:31 +428: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:31 +429: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:32 +430: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:32 +431: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:32 +432: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded the university track gets the identical hub
00:32 +433: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:32 +434: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:32 +435: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:32 +436: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form TYPED: a new address is sent as a string
00:33 +437: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form TYPED: a new address is sent as a string
00:33 +438: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:33 +439: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:33 +440: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:33 +441: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:33 +442: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +443: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +444: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +445: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +446: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +447: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +448: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +449: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +450: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +451: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +452: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +453: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +454: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +455: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:34 +456: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +457: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +458: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +459: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +460: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +461: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +462: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +463: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +464: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +465: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +466: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +467: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +468: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +469: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +470: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +471: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +472: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +473: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +475: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +476: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +477: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +478: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +479: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +480: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +481: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +482: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +483: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +484: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +485: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +486: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +487: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:35 +488: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +489: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +490: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +491: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +492: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +493: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +494: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +495: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +496: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +497: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +498: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +499: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +500: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +501: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +502: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +503: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +504: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +505: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +506: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +507: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:36 +508: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:37 +509: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:37 +510: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:37 +511: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:37 +512: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +513: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +514: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +515: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +516: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +517: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +518: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +519: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +520: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +521: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +522: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +523: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +524: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +525: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +526: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +527: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +528: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +529: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +530: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +531: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +532: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +533: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +534: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +535: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +536: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +537: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:38 +538: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:39 +539: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +540: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +541: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +542: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +543: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +544: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +545: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +546: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +547: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +548: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +549: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +550: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +551: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +552: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:39 +553: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:40 +554: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:40 +555: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back renders the percentage ring but NO Pass/Fail verdict
00:40 +556: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) the phone is the value GET /me returned, verbatim
00:40 +557: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:40 +558: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:40 +559: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:40 +560: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:40 +561: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:41 +562: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:41 +563: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:41 +564: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:41 +565: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:41 +566: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:41 +567: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:42 +568: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:42 +569: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:42 +570: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:42 +571: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:42 +572: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:42 +573: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:42 +574: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:42 +575: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +576: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +577: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +578: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +579: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +580: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +581: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +582: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +583: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:43 +584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +597: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +598: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +599: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +600: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +601: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +602: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +603: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +604: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +605: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +606: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +607: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +608: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +609: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +610: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +611: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:44 +612: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +613: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +614: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +615: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +616: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +617: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +618: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +619: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +620: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +621: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +622: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:45 +623: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:46 +624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:46 +625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:46 +626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:46 +627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:46 +628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:47 +635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:48 +636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:48 +637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:48 +638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:48 +639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:48 +640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +652: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
00:49 +653: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:49 +654: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:50 +655: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:50 +656: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:50 +657: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:50 +658: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:50 +659: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:50 +660: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +661: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +662: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +663: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +664: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +665: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +666: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +667: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +668: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:51 +669: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +670: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +671: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +672: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +673: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +674: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +675: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:52 +676: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:53 +677: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:53 +678: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:53 +679: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:53 +680: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
00:54 +681: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:54 +682: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:54 +683: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:54 +684: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:54 +685: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:54 +686: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:55 +687: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:55 +688: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:55 +689: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:55 +690: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:55 +691: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:56 +692: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:56 +693: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
00:56 +694: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
00:56 +695: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
00:57 +696: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
00:57 +697: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:57 +698: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:57 +699: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:57 +700: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:58 +701: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:58 +702: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
00:58 +703: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
00:58 +704: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
00:58 +705: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:58 +706: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:58 +707: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:58 +708: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card ┬╖ light
00:58 +709: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:58 +710: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +711: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +712: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +713: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +714: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +715: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +716: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +717: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +718: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
00:59 +719: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:00 +720: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:00 +721: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:01 +722: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:01 +723: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:01 +724: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:01 +725: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:01 +726: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:01 +727: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:01 +728: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:01 +729: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:01 +730: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:01 +731: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:01 +732: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:01 +733: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +734: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +735: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +736: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +737: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +738: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +739: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +740: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +741: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +742: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +743: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +744: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +745: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +746: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +747: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +748: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:02 +749: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +750: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +751: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +752: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +753: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +754: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +755: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +756: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +757: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +758: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +759: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:03 +760: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:04 +761: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +762: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +763: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +764: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +765: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +766: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +767: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +768: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +769: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +770: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +771: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +772: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +773: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +774: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +775: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +776: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +777: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +778: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +779: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +780: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +781: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +782: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +783: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +784: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +785: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:04 +786: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:05 +787: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:05 +788: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +789: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +790: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +791: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +792: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +793: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +794: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +795: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +796: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +797: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +798: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +799: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +800: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +801: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +802: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:05 +803: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:06 +804: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:06 +805: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:06 +806: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:06 +807: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:06 +808: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:06 +809: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:07 +810: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:07 +811: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +812: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +813: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +814: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +815: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +816: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +817: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:07 +818: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:08 +819: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:08 +820: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:08 +821: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:08 +822: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:08 +823: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:08 +824: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:08 +825: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:08 +826: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:08 +827: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:08 +828: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
01:09 +829: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a canvas writes it, so the next launch keeps it
01:09 +830: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:09 +831: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:09 +832: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:10 +833: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:10 +834: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:10 +835: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_announcements is structurally non-interactive
01:10 +836: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:11 +837: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:11 +838: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:11 +839: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:11 +840: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:12 +841: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) each announces itself disabled, with a reason
01:12 +842: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity ΓåÆ the offline banner
01:12 +843: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic renders the Arabic section titles under RTL
01:12 +844: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:12 +845: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
01:12 +846: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
01:12 +847: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
01:12 +848: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
01:13 +849: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark offline pins the banner and Rank still reads from cache
01:13 +850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:13 +851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:14 +852: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
01:14 +853: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" the picker is the default; the escape is a link under it
01:14 +854: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:15 +855: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" typing lands on the controller and clears the coded id
01:16 +856: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
01:16 +857: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
01:17 +858: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:18 +859: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:18 +860: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
01:19 +861: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable picking a school afterwards un-skips the field
01:19 +862: All tests passed!
```

