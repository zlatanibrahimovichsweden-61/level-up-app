# Validation run - 2026-09-19T20:12:17Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 262 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 1177 passed / 0 failed / 1 skipped |

**OVERALL: PASS**

Started 2026-09-19T20:12:17Z - finished 2026-09-19T20:14:16Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-19T20:12:17Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : f987f20
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 ΓÇó channel stable ΓÇó https://github.com/flutter/flutter.git
Framework ΓÇó revision 84fc5cbb22 (9 weeks ago) ΓÇó 2026-07-17 10:20:17 -0700
Engine ΓÇó hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (2 months ago) ΓÇó 2026-07-15 20:46:58.000Z
Tools ΓÇó Dart 3.12.2 ΓÇó DevTools 2.57.0

Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "windows_x64"
```

## 3. Dependencies (`flutter pub get`)

```text
Resolving dependencies...
Downloading packages...
  _fe_analyzer_shared 99.0.0 (108.0.0 available)
  analyzer 12.1.0 (14.4.0 available)
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
  code_assets 1.2.1 (2.1.0 available)
  code_builder 4.11.1 (4.12.0 available)
  connectivity_plus 7.3.0 (7.3.1 available)
  dart_style 3.1.8 (3.1.13 available)
  dbus 0.7.14 (0.8.0 available)
  dio 5.10.0 (5.11.1 available)
  dio_web_adapter 2.2.0 (2.2.2 available)
  flutter_cache_manager 3.4.2 (3.4.3 available)
  flutter_riverpod 3.3.2 (3.4.3 available)
  flutter_secure_storage 10.3.1 (11.2.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.3 available)
  flutter_secure_storage_linux 3.0.1 (3.0.3 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.1.1 available)
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
  platform 3.1.6 (3.2.0 available)
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
  sqflite 2.4.3 (2.4.4 available)
  sqflite_android 2.4.3 (2.4.4 available)
  sqflite_common 2.5.11 (2.5.13 available)
  sqflite_darwin 2.4.3+1 (2.4.4 available)
  sqflite_platform_interface 2.4.1 (2.4.2 available)
  stack_trace 1.12.1 (1.12.2 available)
  stream_transform 2.1.1 (2.1.2 available)
  synchronized 3.4.1+1 (3.4.2 available)
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
79 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 262 hand-written Dart files

Formatted 60 files (0 changed) in 0.26 seconds.
Formatted 60 files (0 changed) in 0.22 seconds.
Formatted 60 files (0 changed) in 0.27 seconds.
Formatted 60 files (0 changed) in 0.31 seconds.
Formatted 22 files (0 changed) in 0.10 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 15.3s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**1177 passed, 0 failed, 1 skipped** (exit 0)


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
00:10 +7: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required ΓåÆ refresh once ΓåÆ original retried ΓåÆ success
00:10 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded ΓåÆ forceLogout(superseded), cleared, no refresh
00:10 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh ΓåÆ refresh_token_invalid ΓåÆ forceLogout(sessionExpired)
00:10 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s ΓåÆ refresh called exactly once, all retried
00:10 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again ΓåÆ not refreshed/retried a 2nd time
00:10 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh ΓåÆ NO logout, surfaces the network error
00:11 +13: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException carries the ProblemDetails field map
00:11 +14: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException is still an ApiException (existing handlers keep working)
00:11 +15: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a missing/malformed errors map yields empty fields, not a crash
00:11 +16: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a non-list value is tolerated as a single message
00:11 +17: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:11 +18: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 ΓåÆ UnauthorizedException carrying the code
00:11 +19: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 ΓåÆ ApiException carrying status + code
00:11 +20: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error ΓåÆ NetworkException (drives Offline)
00:11 +21: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException is typed, and is NOT otp_throttled
00:11 +22: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a delta-seconds Retry-After parses
00:11 +23: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an ABSENT header yields null ΓÇö and does not throw
00:11 +24: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a GARBAGE header yields null ΓÇö and does not throw
00:11 +25: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:11 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:11 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:11 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:11 +29: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:11 +30: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:11 +31: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:11 +32: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:11 +33: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:11 +34: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:11 +35: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:11 +36: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:11 +37: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:11 +38: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:11 +39: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:11 +40: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:11 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too ΓÇö one path, not two
00:11 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:15 +43: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route ΓåÆ /login
00:15 +44: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route ΓåÆ stay
00:15 +45: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:15 +46: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login ΓåÆ /home
00:15 +47: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / ΓÇö onboarding must be reachable
00:15 +48: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / ΓåÆ /home, never the onboarding pitch
00:15 +49: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / ΓåÆ wait; do not flash onboarding then bounce
00:15 +50: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route ΓåÆ stay
00:15 +51: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) ΓåÆ wait, never redirect
00:15 +52: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:16 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:16 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:16 +55: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:16 +56: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:16 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:17 +64: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: every session-scoped provider is cleared on sign-out
00:17 +65: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: no provider is both invalidated and exempted
00:17 +66: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: the exemption list has no stale entries
00:17 +67: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: both sign-out paths call the invalidation
00:17 +68: F:/level/level_up/level_up_app/test/core/session/session_scope_discipline_test.dart: forceLogout keeps its re-entry guard
00:17 +69: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places light and dark both define them
00:17 +70: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places copyWith round-trips each of them
00:17 +71: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp moves each of them ΓÇö a missing entry would pin one in place
00:17 +72: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp endpoints are exact
00:17 +73: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone light is unchanged by the dark correction
00:17 +74: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone dark is the 404:7428 family, not the light values
00:17 +75: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone the two new tokens are wired through copyWith and lerp
00:17 +76: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge is identical in both palettes ΓÇö it must not follow the accent flip
00:17 +77: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge equals the fill in the exported SVG ΓÇö not an estimate
00:18 +78: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge the badge keeps its white checkmark ΓÇö so it is never srcIn-tinted
00:18 +79: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: the OTP stopwatch export is stroked in the light primary
00:18 +80: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the dark canvas washes at 20%, it does not paint an opaque card
00:18 +81: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the three dark surfaces that are deliberately OPAQUE
00:18 +82: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces light values are the frames, not a reuse of an old token
00:18 +83: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the five light-only borders are null in dark, not a fallback
00:18 +84: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces otpCardGlow is dark-only, and is the OTP card shadow colour
00:18 +85: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the tokens that must NOT flip with the canvas
00:18 +86: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces every new token is wired through copyWith and lerp
00:18 +87: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: all three brand assets landed
00:18 +88: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion kFigmaBlurToSigma is the CSS definition, not a tunable
00:18 +89: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion sigma is NOT what BoxShadow would have produced
00:18 +90: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion frost converts with its own constant
00:18 +91: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration nav bar: the two canvases differ in colour AND blur
00:18 +92: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration the three CTA tokens
00:18 +93: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration back chip: light shadow, dark Glass ΓÇö not a missing shadow
00:18 +94: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration the registration back chip is a different Glass from G5
00:18 +95: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration language pill: G3 differs from G5 only in lightIntensity
00:18 +96: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration form fields: G4, and the 0.03 hairline kept verbatim
00:18 +97: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration onboarding sheet: the only Glass in the light frames
00:18 +98: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration scrims: five frames, five readings
00:18 +99: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes level card: light shadow, dark Glass plus a back-light
00:18 +100: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes daily tasks: G7, and two differently sized back-lights
00:18 +101: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes top student: same border width on both canvases
00:18 +102: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes continue learning: two shadows, one with a negative spread
00:18 +103: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes subjects search: the file's only 10% shadows
00:18 +104: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes subject card: identical on both canvases ΓÇö this is #34's proof
00:18 +105: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes mistakes pill and card
00:18 +106: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes the segmented pill track inverts its inner shadow when selected
00:18 +107: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard the five near-identical small shadows stay five tokens
00:18 +108: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard length chips, AI panel and leaderboard list keep dark shadows
00:18 +109: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard AI panel: G18 outside, G5 inside, one back-light
00:18 +110: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard quiz previous button: G13 confirms the angle convention
00:18 +111: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard result buckets, rewards card and star disc
00:18 +112: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard the scope toggle is the file's only white inner shadow
00:18 +113: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard a leaderboard row carries two different Glass effects
00:18 +114: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card profile header, edit chip and stat card keep a dark shadow
00:18 +115: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card avatar badge
00:18 +116: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card settings sections and their two back-lights
00:18 +117: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:18 +118: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card the two track cards carry two different Glass angles
00:18 +119: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 ΓÇö the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:18 +120: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 ΓÇö the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:18 +121: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 ΓÇö the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:18 +122: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism the onboarding sheet is the ONLY light Glass
00:18 +123: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every dark surface that Figma glassed has a token
00:18 +124: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every back-light is dark-only and takes the palette colour
00:18 +125: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places props covers every field
00:18 +126: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places copyWith round-trips, and leaves the others alone
00:18 +127: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp endpoints are exact
00:18 +128: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp actually moves, and snaps what cannot be interpolated
00:18 +129: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp ignores a foreign extension, as ThemeExtension requires
00:18 +130: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places equality is by value, not by identity
00:18 +131: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places both ThemeData objects carry it
00:19 +132: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:19 +133: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:19 +134: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:19 +135: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is a different colour on each canvas ΓÇö that is the entire point
00:19 +136: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow carries no alpha of its own ΓÇö the call site owns the depth
00:19 +137: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is wired into copyWith and lerp
00:19 +138: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:19 +139: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:19 +140: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:19 +141: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:19 +142: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:19 +143: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:19 +144: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:19 +145: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:20 +146: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:21 +147: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +148: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +149: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +150: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +151: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +152: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +153: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +154: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +155: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +156: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet no scrim leaves the framework sheet alone
00:21 +157: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +158: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +159: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +160: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +161: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +162: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +163: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:21 +164: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:22 +165: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +166: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +167: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +168: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +169: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +170: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +171: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +172: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +173: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:22 +174: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:22 +175: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:22 +176: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:22 +177: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:22 +178: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:22 +179: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:22 +180: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:22 +181: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: back-lights the vertical offset is NOT mirrored
00:22 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: back-lights the vertical offset is NOT mirrored
00:22 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: the tokens these helpers are fed light scrims never blur; dark ones always do
00:22 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: back-lights a back-light without Glass trips the debug assert
00:22 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it adds no semantics of its own
00:22 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle ΓêÆ45 the top and left are the bright ones
00:22 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) the dim side is the measured 0.65 of the lit one
00:22 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 a straight edge at ΓêÆ45 keeps Figma's 0.50 / 0.33 profile
00:22 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the shipped strength is the ruled fraction of the measured
00:22 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 lightIntensity scales it linearly
00:22 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the corners perpendicular to the light stay bare
00:22 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light ΓÇö a shadow, and no glow the primary tone paints the measured black
00:23 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light ΓÇö a shadow, and no glow no glow is painted at all
00:23 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:23 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:24 +206: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +207: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +208: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +209: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +210: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +211: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +212: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +213: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +214: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +215: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +216: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +217: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +218: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +219: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +220: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +221: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +222: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +223: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +224: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +225: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +226: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +227: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +228: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:24 +229: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the registration variant is a DIFFERENT chip
00:25 +230: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light ┬╖ the standard variant takes the standard tokens
00:25 +231: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light ┬╖ the registration variant is a DIFFERENT chip
00:25 +232: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark elevates with Glass and NO shadow ΓÇö a reading, not a gap
00:25 +233: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the two dark variants really are different values
00:25 +234: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:25 +235: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:25 +236: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:25 +237: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:25 +238: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light draws the 1.17338 hairline and no Glass
00:25 +239: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:25 +240: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark ┬╖ the error state keeps its own 1.5
00:25 +241: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light ┬╖ the error state keeps its own 1.5
00:25 +242: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell disabled dims the whole field and kills the tap
00:25 +243: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:25 +244: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:25 +245: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill dark has NO border at all, and Glass instead
00:25 +246: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:25 +247: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:25 +248: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:25 +249: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable ΓÇö the 159:1852 variant
00:25 +250: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:25 +251: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:25 +252: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:25 +253: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:25 +254: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:25 +255: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:25 +256: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:25 +257: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:25 +258: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:25 +259: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent ΓÇö a repeat call replays the same summary
00:25 +260: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me ΓÇö what invalidating the profile shows
00:25 +261: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered ΓÇö expected, not a bug
00:25 +262: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 ΓÇö the polling path is walkable
00:25 +263: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:25 +264: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:26 +265: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:26 +266: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:26 +267: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:26 +268: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:26 +269: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:26 +270: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:26 +271: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:26 +272: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:26 +273: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:26 +274: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:26 +275: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:26 +276: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:26 +277: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:26 +278: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:26 +279: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:26 +280: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:26 +281: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:26 +282: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token ΓåÆ unauthenticated
00:26 +283: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token ΓåÆ authenticated
00:26 +284: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:27 +285: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:27 +286: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:27 +287: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:27 +288: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` registrationRequired ΓåÆ RegistrationRequiredResult with token + ttl
00:27 +289: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity ΓÇö required fields have no defensive defaults TokenPair throws when a required field is missing
00:27 +290: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:28 +291: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:29 +292: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:29 +293: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:30 +294: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +295: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +296: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +297: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +298: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +299: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +300: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +301: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +302: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +303: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +304: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +305: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +306: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +307: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:30 +308: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) an empty phone surfaces the same inline error
00:30 +309: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:31 +310: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:31 +311: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:31 +312: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:31 +313: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:31 +314: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 ΓåÆ timer pill with the stopwatch; Resend inert until 0
00:31 +315: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline ΓåÆ distinct banner shown, Verify + Resend disabled
00:31 +316: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:31 +317: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: (tearDownAll)
00:31 +317: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: Subject parses a row of GET /catalog/subjects
00:31 +318: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: Subject a missing required field throws rather than defaulting
00:31 +319: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction is answered/total
00:31 +320: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction a subject with no questions is 0, not NaN
00:31 +321: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: QuestionCounter.fraction is clamped, so bad server data cannot overflow the bar
00:31 +322: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree parses the whole nested structure from one payload
00:31 +323: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree an empty level parses as empty, not as an error
00:31 +324: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree a tree with no units at all parses
00:31 +325: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree a missing required field throws
00:31 +326: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: SchoolSubjectTree an unknown track value throws ΓÇö the discriminator is closed
00:31 +327: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree parses the university branch of the oneOf
00:31 +328: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree lectures carry a questionCounter ΓÇö unlike school units/chapters
00:31 +329: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree quizTypes parse as the contract enum, in server order
00:31 +330: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a quiz type outside the contract enum throws
00:31 +331: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a subject with no lectures parses ΓÇö that is EMPTY, not an error
00:31 +332: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: UniversitySubjectTree a missing required field throws
00:31 +333: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: the sealed union both branches ARE a SubjectTree, and are told apart by type
00:31 +334: F:/level/level_up/level_up_app/test/features/catalog/catalog_models_test.dart: the sealed union the runtime type and the parsed track agree
00:32 +335: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +336: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +337: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +338: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +339: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +340: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +341: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +342: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +343: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +344: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +345: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +346: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +347: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +348: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +349: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +350: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +351: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +352: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +353: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +354: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +355: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +356: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +357: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +358: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +359: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:33 +360: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
00:34 +361: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: going back up and down again still does not re-fetch
00:34 +362: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:35 +363: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +364: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:36 +365: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:36 +366: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:36 +367: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:36 +368: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:36 +369: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:36 +370: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:37 +371: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:37 +372: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +373: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +374: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +375: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +376: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +377: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +378: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:37 +379: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:38 +380: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:38 +381: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
00:38 +382: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +383: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +384: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +385: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +386: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +387: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +388: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +389: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +390: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +391: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +392: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +393: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +394: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +395: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +396: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +397: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT ΓÇö a lecture is the leaf, not a drill-down
00:38 +398: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
00:38 +399: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
00:38 +400: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:38 +401: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +402: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +403: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +404: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +405: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +406: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +407: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +408: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +409: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title is the subject name from the CACHED subjects list
00:39 +410: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title is the subject name from the CACHED subjects list
00:39 +411: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title is the subject name from the CACHED subjects list
00:39 +412: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar ΓÇö the contract gives them no counter
00:39 +413: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar ΓÇö the contract gives them no counter
00:40 +414: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar ΓÇö the contract gives them no counter
00:40 +415: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar ΓÇö the contract gives them no counter
00:40 +416: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +417: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +418: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:40 +419: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:40 +420: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:40 +421: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:40 +422: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:40 +423: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +424: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +425: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +426: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +427: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +428: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +429: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +430: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +431: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:41 +432: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:41 +433: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:41 +434: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:41 +435: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
00:41 +436: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +437: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +438: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +439: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +440: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +441: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +442: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +443: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +444: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:41 +445: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: university (Figma 125:2373) school Home does NOT get the section
00:41 +446: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +447: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +448: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +449: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +450: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:42 +451: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:42 +452: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:42 +453: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:42 +454: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:42 +455: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:42 +456: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs never draw a Flashcard tab ΓÇö it is not in the contract
00:42 +457: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes Arabic renders RTL with Arabic copy
00:42 +458: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +459: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +460: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +461: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +462: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +463: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +464: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +465: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +466: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +467: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +468: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +469: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +470: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +471: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +472: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +473: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +474: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +475: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +476: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +477: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +478: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +479: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all ΓåÆ no tab row, and the list still renders
00:43 +480: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:43 +481: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub ΓÇö the snackbar is gone
00:44 +482: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub ΓÇö the snackbar is gone
00:44 +483: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub ΓÇö the snackbar is gone
00:44 +484: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub ΓÇö the snackbar is gone
00:44 +485: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub ΓÇö the snackbar is gone
00:44 +486: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:44 +487: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:44 +488: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:44 +489: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) is the frame's 35 dp pill, tappable over exactly itself
00:44 +490: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) is the frame's 35 dp pill, tappable over exactly itself
00:44 +490 ~1: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) is the frame's 35 dp pill, tappable over exactly itself
00:44 +491 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +492 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +493 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +494 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +495 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +496 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +497 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +498 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +499 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +500 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +501 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +502 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +503 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +504 ~1: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:47 +505 ~1: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:47 +506 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point it PUSHES, so the back chevron returns to Subjects
00:47 +507 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +508 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +509 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +510 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +511 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +512 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +513 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +514 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +515 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +516 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +517 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +518 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +519 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +520 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +521 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +522 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +523 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +524 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +525 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +526 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +527 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +528 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +529 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +530 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +531 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +532 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +533 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +534 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +535 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +536 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +537 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +538 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +539 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +540 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +541 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +542 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +543 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +544 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +545 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +546 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +547 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +548 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +549 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +550 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +551 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:48 +552 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:48 +553 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me ΓÇö the hub already fetched it
00:49 +554 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:49 +555 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:49 +556 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:49 +557 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +558 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +559 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +560 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +561 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +562 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +563 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +564 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +565 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +566 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:49 +567 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:49 +568 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:49 +569 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:49 +570 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:49 +571 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:49 +572 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:50 +573 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:50 +574 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:50 +575 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:51 +576 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:51 +577 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:51 +578 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:51 +579 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +580 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +581 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +582 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +583 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +584 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +585 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +586 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +587 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +588 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +589 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +590 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +591 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +592 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +593 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +594 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +595 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +596 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:52 +597 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:52 +598 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:52 +599 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:52 +600 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:52 +601 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:52 +602 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:52 +603 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:52 +604 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:52 +605 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:52 +606 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:52 +607 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +608 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +609 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +610 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +611 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +612 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +613 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +614 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +615 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +616 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:53 +617 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +618 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +619 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +620 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +621 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +622 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +623 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +624 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +625 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:53 +626 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +627 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +628 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +629 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +630 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +631 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +632 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +633 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +634 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) en at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +635 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +636 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +637 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +638 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +639 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +640 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +641 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +642 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +643 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:53 +644 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +645 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert ΓÇö no chevron, no tap
00:54 +646 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert ΓÇö no chevron, no tap
00:54 +647 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert ΓÇö no chevron, no tap
00:54 +648 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +649 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +650 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +651 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +652 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +653 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +654 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +655 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +656 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +657 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +658 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +659 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +660 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +661 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +662 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +663 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +664 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +665 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +666 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +667 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +668 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +669 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +670 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +671 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +672 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +673 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +674 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +675 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +676 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +677 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +678 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.3: four tabs stay equal, and every label keeps its full size
00:55 +679 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form the screen says out loud that an empty box deletes
00:56 +680 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +681 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +682 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +683 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +684 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +685 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +686 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +687 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +688 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +689 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +690 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +691 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +692 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +693 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +694 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +695 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +696 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +697 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +698 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +699 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +700 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +701 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +702 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +703 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +704 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:58 +705 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:58 +706 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +707 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +708 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +709 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +710 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +711 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +712 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +713 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +714 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +715 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +716 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:00 +717 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:00 +718 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:00 +719 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:00 +720 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:00 +721 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:00 +722 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:00 +723 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:00 +724 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:00 +725 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:01 +726 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:01 +727 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:01 +728 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:01 +729 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:01 +730 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:01 +731 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:01 +732 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +733 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +734 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +735 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +736 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +737 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +738 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +739 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +740 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +741 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +742 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +743 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +744 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +745 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +746 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +747 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +748 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +749 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +750 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +751 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +752 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +753 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +754 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +755 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +756 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +757 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +758 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:02 +759 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:03 +760 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:03 +761 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +762 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +763 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +764 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +765 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +766 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +767 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +768 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:03 +769 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:03 +770 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:03 +771 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark renders in dark theme
01:03 +772 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +773 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +774 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +775 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +776 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +777 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +778 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +779 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +780 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +781 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +782 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +783 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +784 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +785 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +786 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +787 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +788 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +789 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +790 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +791 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +792 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +793 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +794 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +795 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +796 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +797 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +798 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +799 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +800 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +801 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +802 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +803 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +804 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +805 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +806 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +807 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +808 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +809 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +810 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +811 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +812 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +813 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +814 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +815 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +816 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +817 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +818 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +819 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:03 +820 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
01:03 +821 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
01:03 +822 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: a university student sees their own academic block university, faculty and year replace the school rows
01:03 +823 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: a university student sees their own academic block university, faculty and year replace the school rows
01:03 +824 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row keeps its dark foreground in dark mode
01:03 +825 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:03 +826 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +827 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +828 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +829 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +830 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +831 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +832 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +833 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +834 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +835 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +836 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +837 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:03 +838 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +839 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +840 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +841 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +842 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +843 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +844 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +845 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +846 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +847 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +848 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +849 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +850 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +851 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +852 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +853 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:04 +854 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:04 +855 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:04 +856 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:04 +857 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
01:04 +858 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
01:04 +859 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:04 +860 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:04 +861 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:04 +862 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:04 +863 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:04 +864 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:04 +865 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:04 +866 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:04 +867 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:04 +868 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType ΓÇö SAME screen
01:04 +869 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:04 +870 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:04 +871 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:04 +872 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:04 +873 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:04 +874 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:04 +875 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:05 +876 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the review path consumes nothing and persists nothing calls no endpoint
01:05 +877 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
01:05 +878 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save an empty name is rejected before a request is made
01:05 +879 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:05 +880 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:05 +881 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:05 +882 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save offline shows the offline line, not a generic error
01:05 +883 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: states matrix Arabic (RTL)
01:05 +884 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:05 +885 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:05 +886 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 ΓåÆ poll ΓåÆ 200 renders the text, in ONE section
01:05 +887 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
01:05 +888 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:05 +889 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:05 +890 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:05 +891 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:05 +892 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:05 +893 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +894 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +895 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +896 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +897 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +898 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +899 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +900 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +901 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +902 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +903 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +904 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +905 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +906 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +907 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +908 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +909 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +910 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +911 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +912 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +913 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +914 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +915 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +916 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +917 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +918 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +919 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +920 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +921 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +922 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +923 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +924 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +925 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:06 +926 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +927 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +928 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +929 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +930 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +931 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +932 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +933 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +934 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +935 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +936 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +937 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +938 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +939 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +940 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +941 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +942 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:07 +943 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
01:08 +944 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +945 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +946 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +947 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +948 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +949 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +950 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +951 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +952 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:08 +953 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:09 +954 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:09 +955 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:09 +956 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 ΓÇö layout renders the title, subtitle and Start learning CTA
01:09 +957 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +958 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +959 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +960 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +961 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +962 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +963 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +964 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +965 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +966 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +967 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +968 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +969 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +970 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +971 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +972 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +973 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +974 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +975 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +976 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +977 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +978 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +979 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +980 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +981 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +982 ~1: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +983 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +984 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +985 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +986 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +987 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +988 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +989 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:11 +990 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:11 +991 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:11 +992 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:11 +993 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:11 +994 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:11 +995 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:12 +996 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:12 +997 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:12 +998 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:12 +999 ~1: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA ┬╖ light ┬╖ enabled
01:12 +1000 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1001 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1002 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1003 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1004 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1005 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1006 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1007 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1008 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1009 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1010 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1011 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1012 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1013 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1014 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1015 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1016 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1017 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1018 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1019 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1020 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1021 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:13 +1022 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:13 +1023 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:13 +1024 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:13 +1025 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:14 +1026 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:14 +1027 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error ΓåÆ message + retry
01:14 +1028 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:14 +1029 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +1030 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +1031 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +1032 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:14 +1033 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +1034 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +1035 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +1036 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +1037 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:15 +1038 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1039 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1040 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1041 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1042 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1043 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1044 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1045 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline ΓåÆ its own copy
01:15 +1046 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1047 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1048 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1049 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1050 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1051 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1052 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:15 +1053 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1054 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1055 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1056 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1057 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1058 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1059 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1060 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1061 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1062 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1063 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1064 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1065 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1066 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1067 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1068 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1069 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1070 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1071 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1072 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1073 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1074 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1075 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1076 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1077 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1078 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1079 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1080 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1081 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1082 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1083 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1084 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1085 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1086 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1087 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1088 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1089 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1090 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1091 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1092 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1093 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1094 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1095 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1096 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1097 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1098 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1099 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1100 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1101 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1102 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:16 +1103 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1104 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1105 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1106 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1107 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1108 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1109 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1110 ~1: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
01:16 +1111 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) all four render
01:16 +1112 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:16 +1113 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:16 +1114 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1115 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1116 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1117 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1118 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1119 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1120 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1121 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1122 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1123 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1124 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1125 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1126 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1127 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1128 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1129 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1130 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1131 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1132 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1133 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1134 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1135 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1136 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1137 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1138 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1139 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1140 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error ΓåÆ message + a user-tapped Retry that refetches
01:17 +1141 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic renders the Arabic section titles under RTL
01:17 +1142 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:17 +1143 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:17 +1144 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:17 +1145 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:17 +1146 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1147 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1148 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1149 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1150 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1151 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1152 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1153 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1154 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1155 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1156 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1157 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1158 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1159 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline ΓåÆ its own copy, distinct from a generic error
01:18 +1160 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity ΓåÆ the offline banner
01:18 +1161 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:18 +1162 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: expiry guard an expired token renders the expiry view instead of the form
01:18 +1163 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: expiry guard no draft at all renders the expiry view
01:18 +1164 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
01:18 +1165 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:18 +1166 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:19 +1167 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
01:19 +1168 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" the picker is the default; the escape is a link under it
01:19 +1169 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:19 +1170 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" typing lands on the controller and clears the coded id
01:19 +1171 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
01:20 +1172 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
01:20 +1173 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:20 +1174 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:20 +1175 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
01:21 +1176 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable picking a school afterwards un-skips the field
01:21 +1177 ~1: All tests passed!
```

