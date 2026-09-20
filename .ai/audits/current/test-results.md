# Validation run - 2026-09-20T19:39:33Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 265 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 1317 passed / 0 failed / 1 skipped |

**OVERALL: PASS**

Started 2026-09-20T19:39:33Z - finished 2026-09-20T19:42:35Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-20T19:39:33Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 4215e1c
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 84fc5cbb22 (9 weeks ago) • 2026-07-17 10:20:17 -0700
Engine • hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (2 months ago) • 2026-07-15 20:46:58.000Z
Tools • Dart 3.12.2 • DevTools 2.57.0

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
  flutter_cache_manager 3.4.2 (3.4.5 available)
  flutter_riverpod 3.3.2 (3.4.3 available)
  flutter_secure_storage 10.3.1 (11.2.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.3 available)
  flutter_secure_storage_linux 3.0.1 (3.0.3 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.1.1 available)
  freezed 3.2.6-dev.1 (4.0.2 available)
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
  vector_math 2.2.0 (2.4.3 available)
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
checking 265 hand-written Dart files

Formatted 60 files (0 changed) in 0.26 seconds.
Formatted 60 files (0 changed) in 0.22 seconds.
Formatted 60 files (0 changed) in 0.27 seconds.
Formatted 60 files (0 changed) in 0.34 seconds.
Formatted 25 files (0 changed) in 0.14 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 22.0s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**1317 passed, 0 failed, 1 skipped** (exit 0)


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
00:00 +7: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required → refresh once → original retried → success
00:00 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:00 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:00 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:00 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:00 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
00:01 +13: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException carries the ProblemDetails field map
00:01 +14: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException is still an ApiException (existing handlers keep working)
00:01 +15: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a missing/malformed errors map yields empty fields, not a crash
00:01 +16: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a non-list value is tolerated as a single message
00:01 +17: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:01 +18: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 → UnauthorizedException carrying the code
00:01 +19: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 → ApiException carrying status + code
00:01 +20: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error → NetworkException (drives Offline)
00:01 +21: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException is typed, and is NOT otp_throttled
00:01 +22: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a delta-seconds Retry-After parses
00:01 +23: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an ABSENT header yields null — and does not throw
00:01 +24: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a GARBAGE header yields null — and does not throw
00:01 +25: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:01 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:01 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:01 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:02 +29: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:02 +30: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:02 +31: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:02 +32: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:02 +33: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:02 +34: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:02 +35: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:02 +36: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:02 +37: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:02 +38: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:02 +39: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:02 +40: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:02 +41: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:02 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:02 +43: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:02 +44: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:03 +45: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:03 +46: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:03 +47: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:03 +48: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:03 +49: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:03 +50: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:03 +51: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:03 +52: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +55: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +56: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +69: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places light and dark both define them
00:05 +70: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places copyWith round-trips each of them
00:05 +71: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp moves each of them — a missing entry would pin one in place
00:05 +72: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp endpoints are exact
00:05 +73: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone light is unchanged by the dark correction
00:05 +74: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone dark is the 404:7428 family, not the light values
00:05 +75: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone the two new tokens are wired through copyWith and lerp
00:05 +76: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge is identical in both palettes — it must not follow the accent flip
00:05 +77: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge equals the fill in the exported SVG — not an estimate
00:05 +78: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge the badge keeps its white checkmark — so it is never srcIn-tinted
00:05 +79: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: the OTP stopwatch export is stroked in the light primary
00:05 +80: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the dark canvas washes at 20%, it does not paint an opaque card
00:05 +81: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the three dark surfaces that are deliberately OPAQUE
00:05 +82: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces light values are the frames, not a reuse of an old token
00:05 +83: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the five light-only borders are null in dark, not a fallback
00:05 +84: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces otpCardGlow is dark-only, and is the OTP card shadow colour
00:05 +85: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the tokens that must NOT flip with the canvas
00:05 +86: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces every new token is wired through copyWith and lerp
00:05 +87: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the three review-row fills: light opaque, dark at the frame's 20%
00:05 +88: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the wrong row keeps the SHIPPED hue, not the review frame's drift
00:05 +89: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle quizReviewRowContent stopped being canvas-independent, and had to
00:05 +90: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the previous-button glyph is cream on BOTH canvases
00:05 +91: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the light selected scope fill is #DBB0FF — the re-read value
00:05 +92: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the idle scope label is a dark GREEN, not textSecondary grey
00:05 +93: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the badge ring took the frame's lavender without moving the shared token
00:05 +94: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle every edit4 token is wired through copyWith and lerp
00:05 +95: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: all three brand assets landed
00:05 +96: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion kFigmaBlurToSigma is the CSS definition, not a tunable
00:05 +97: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion sigma is NOT what BoxShadow would have produced
00:05 +98: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion frost converts with its own constant
00:05 +99: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration nav bar: the two canvases differ in colour AND blur
00:05 +100: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the three CTA tokens
00:05 +101: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration back chip: light shadow, dark Glass — not a missing shadow
00:06 +102: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the registration back chip is a different Glass from G5
00:06 +103: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration language pill: G3 differs from G5 only in lightIntensity
00:06 +104: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration form fields: G4, and the 0.03 hairline kept verbatim
00:06 +105: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration onboarding sheet: the only Glass in the light frames
00:06 +106: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration scrims: five frames, five readings
00:06 +107: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes level card: light shadow, dark Glass plus a back-light
00:06 +108: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes daily tasks: G7, and two differently sized back-lights
00:06 +109: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes top student: same border width on both canvases
00:06 +110: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes continue learning: two shadows, one with a negative spread
00:06 +111: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subjects search: the file's only 10% shadows
00:06 +112: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subject card: identical on both canvases — this is #34's proof
00:06 +113: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes mistakes pill and card
00:06 +114: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes the segmented pill track inverts its inner shadow when selected
00:06 +115: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the five near-identical small shadows stay five tokens
00:06 +116: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard length chips, AI panel and leaderboard list keep dark shadows
00:06 +117: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard AI panel: G18 outside, G5 inside, one back-light
00:06 +118: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard quiz previous button: G13 confirms the angle convention
00:06 +119: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard result buckets, rewards card and star disc
00:06 +120: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the scope toggle is the file's only white inner shadow
00:06 +121: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard a leaderboard row carries two different Glass effects
00:06 +122: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card profile header, edit chip and stat card keep a dark shadow
00:06 +123: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card avatar badge
00:06 +124: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card settings sections and their two back-lights
00:06 +125: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:06 +126: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card the two track cards carry two different Glass angles
00:06 +127: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:06 +128: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:06 +129: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:06 +130: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism the onboarding sheet is the ONLY light Glass
00:06 +131: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every dark surface that Figma glassed has a token
00:06 +132: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every back-light is dark-only and takes the palette colour
00:06 +133: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places props covers every field
00:06 +134: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places copyWith round-trips, and leaves the others alone
00:06 +135: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp endpoints are exact
00:06 +136: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp actually moves, and snaps what cannot be interpolated
00:06 +137: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp ignores a foreign extension, as ThemeExtension requires
00:06 +138: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places equality is by value, not by identity
00:06 +139: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places both ThemeData objects carry it
00:06 +140: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:06 +141: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:06 +142: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:07 +143: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:07 +144: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:07 +145: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:07 +146: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:07 +147: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:07 +148: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:07 +149: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:08 +150: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +151: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +152: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +153: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +154: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:09 +155: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:09 +156: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:09 +157: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:09 +158: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog system back still pops it, and returns its value
00:09 +159: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +160: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +161: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +162: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +163: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +164: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +165: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +166: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +167: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +168: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:09 +169: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +170: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +171: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +172: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +173: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +174: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +175: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +176: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +177: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:09 +178: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:09 +179: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:09 +180: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:09 +181: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:09 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:09 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: back-lights the vertical offset is NOT mirrored
00:09 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:09 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:09 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it adds no semantics of its own
00:09 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it adds no semantics of its own
00:09 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it adds no semantics of its own
00:09 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:10 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) the dim side is the measured 0.65 of the lit one
00:10 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 a straight edge at −45 keeps Figma's 0.50 / 0.33 profile
00:10 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the shipped strength is the ruled fraction of the measured
00:10 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 lightIntensity scales it linearly
00:10 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the corners perpendicular to the light stay bare
00:10 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:10 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow no glow is painted at all
00:10 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the outline tone uses its own token
00:10 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: dark — the same shadow, plus a glow on the primary tone only primary paints shadow AND glow
00:11 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:11 +209: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:11 +210: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:11 +211: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +212: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +213: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +214: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +215: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +216: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +217: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +218: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +219: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +220: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +221: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +222: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +223: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +224: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +225: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +226: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +227: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +228: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +229: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +230: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +231: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +232: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:12 +233: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the registration variant is a DIFFERENT chip
00:12 +234: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the standard variant takes the standard tokens
00:12 +235: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:12 +236: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the registration variant is a DIFFERENT chip
00:12 +237: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me/entitlements parses, and agrees with the /me embed
00:12 +238: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark elevates with Glass and NO shadow — a reading, not a gap
00:12 +239: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the two dark variants really are different values
00:12 +240: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:13 +241: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:13 +242: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light draws the 1.17338 hairline and no Glass
00:13 +243: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:13 +244: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:13 +245: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:13 +246: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell disabled dims the whole field and kills the tap
00:13 +247: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:13 +248: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:13 +249: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill dark has NO border at all, and Glass instead
00:13 +250: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:13 +251: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:13 +252: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:13 +253: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable — the 159:1852 variant
00:13 +254: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:13 +255: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:13 +256: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:13 +257: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:13 +258: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:13 +259: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:13 +260: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:13 +261: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:13 +262: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:13 +263: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent — a repeat call replays the same summary
00:13 +264: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me — what invalidating the profile shows
00:13 +265: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered — expected, not a bug
00:13 +266: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:13 +267: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:13 +268: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:14 +269: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:14 +270: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:14 +271: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:14 +272: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:14 +273: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:14 +274: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:14 +275: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:14 +276: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:14 +277: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:14 +278: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:14 +279: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:14 +280: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:14 +281: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:14 +282: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:14 +283: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:14 +284: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:14 +285: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:14 +286: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:14 +287: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:14 +288: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:15 +289: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:15 +290: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:15 +291: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:15 +292: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:15 +293: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:15 +294: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:16 +295: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +296: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +297: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:18 +298: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +299: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +300: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +301: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +302: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +303: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +304: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +305: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +306: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +307: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +308: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +309: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +310: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +311: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +312: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:19 +313: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +314: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +315: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +316: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +317: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +318: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +319: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +320: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +321: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:19 +322: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #31 the code card it holds BOTH the digits and Verify — the whole finding
00:19 +323: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +324: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:20 +325: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:20 +326: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells six of them, still 48 x 56 at r16, still forced LTR
00:20 +327: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: offline → distinct banner shown, Verify + Resend disabled
00:20 +328: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells in Arabic the page turns RTL and the cells still fill LEFT to right
00:20 +329: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +330: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +331: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +332: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +333: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +334: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +335: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +336: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +337: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +338: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
00:20 +339: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:20 +340: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +341: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +342: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +343: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +344: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +345: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +346: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +347: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +348: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +349: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells dark: a 20% cell, a 0.5 hairline and G19
00:20 +350: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells the focused cell keeps its 1.5 primary stroke
00:20 +351: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #52 the digit cells an otp_invalid verify turns EVERY cell red
00:21 +352: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs Verify is wrapped, and DISABLED until six digits
00:21 +353: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +353: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:21 +354: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +355: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +356: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +357: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +358: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +359: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +360: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +361: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +362: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +363: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +364: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +365: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +366: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +367: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +368: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +369: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +370: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +371: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +372: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +373: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +374: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +375: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +376: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +377: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +378: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +379: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +380: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +381: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:23 +382: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: going back up and down again still does not re-fetch
00:24 +383: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:25 +384: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:25 +385: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:25 +386: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:25 +387: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +388: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:26 +389: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +390: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +391: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +392: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +393: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +394: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +395: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:26 +396: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:27 +397: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:27 +398: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:27 +399: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: questionCounter never disables or hides a lesson row
00:27 +400: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:27 +401: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:27 +402: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:27 +403: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded a finished or empty counter never disables or hides a card
00:27 +404: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +405: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +406: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +407: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +408: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +409: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +410: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +411: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +412: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +413: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +414: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +415: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +416: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +417: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile university is FLAT — a lecture is the leaf, not a drill-down
00:28 +418: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:28 +419: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:28 +420: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:28 +421: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:28 +422: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:28 +423: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:28 +424: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: an empty level shows the empty state, not an error
00:29 +425: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
00:29 +426: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title is the subject name from the CACHED subjects list
00:29 +427: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title is the subject name from the CACHED subjects list
00:29 +428: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title is the subject name from the CACHED subjects list
00:29 +429: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: a subject with no units at all is empty, not broken
00:29 +430: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: a subject with no units at all is empty, not broken
00:30 +431: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search a query that matches nothing shows its own message
00:30 +432: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title falls back to the bare title when the name is not cached
00:30 +433: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:31 +434: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:31 +435: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:31 +436: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) every level titles itself after its parent
00:31 +437: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:31 +438: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
00:31 +439: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:31 +440: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:31 +441: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:31 +442: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:31 +443: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:32 +444: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +445: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +446: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +447: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +448: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +449: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +450: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +451: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +452: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +453: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +454: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +455: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +456: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +457: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +458: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +459: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +460: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +461: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +462: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:32 +463: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:32 +464: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:32 +465: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +466: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +467: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +468: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +469: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +470: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +471: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +472: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +473: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +474: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +475: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +476: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +477: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +478: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +479: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +480: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +481: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +482: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +483: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) units and chapters draw NO progress bar — the contract gives them no counter
00:33 +484: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:33 +485: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:33 +486: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:33 +487: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:33 +488: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:33 +489: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs never draw a Flashcard tab — it is not in the contract
00:33 +490: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:34 +491: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:34 +492: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) lessons DO draw a bar, straight from questionCounter
00:35 +493: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes Arabic renders RTL with Arabic copy
00:35 +494: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:35 +495: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:35 +496: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +497: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +498: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +499: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +500: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +501: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +502: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +503: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +504: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +505: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +506: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +507: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +508: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +509: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +510: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +511: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +512: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +513: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:36 +514: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:36 +515: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:36 +516: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:36 +517: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:36 +518: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:37 +519: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:37 +520: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:37 +521: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures offline gets its own view
00:37 +522: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:37 +523: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:37 +524: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:37 +524 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:37 +525 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:37 +526 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:37 +527 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:37 +528 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:37 +529 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:37 +530 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
00:38 +531 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:38 +532 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:38 +533 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:38 +534 ~1: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
00:38 +535 ~1: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:39 +536 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:39 +537 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:39 +538 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:40 +539 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:40 +540 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:40 +541 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:40 +542 ~1: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:41 +543 ~1: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:41 +544 ~1: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:41 +545 ~1: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:41 +546 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:41 +547 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:41 +548 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:41 +549 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:41 +550 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +551 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +552 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +553 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +554 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +555 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +556 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +557 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +558 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +559 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +560 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +561 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +562 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +563 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:42 +564 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:43 +565 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +566 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +567 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +568 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +569 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +570 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +571 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +572 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +573 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +574 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +575 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +576 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +577 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +578 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +579 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:43 +580 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:44 +581 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:44 +582 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:44 +583 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:44 +584 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:44 +585 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:45 +586 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +587 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +588 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +589 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +590 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +591 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +592 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +593 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +594 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:45 +595 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +596 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +597 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +598 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +599 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +600 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +601 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +602 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +603 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +604 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +605 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +606 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +607 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +608 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +609 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +610 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +611 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +612 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:46 +613 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:46 +614 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:46 +615 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:46 +616 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:46 +617 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states 403 insufficient_scope gets its own copy and NO retry
00:46 +618 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states 403 insufficient_scope gets its own copy and NO retry
00:46 +619 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states 403 insufficient_scope gets its own copy and NO retry
00:47 +620 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +621 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +622 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +623 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +624 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +625 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +626 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +627 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +628 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +629 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +630 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +631 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +632 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:47 +633 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:48 +634 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:48 +635 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:49 +636 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:49 +637 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:49 +638 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:50 +639 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:50 +640 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:50 +641 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:50 +642 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:50 +643 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:50 +644 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:50 +645 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:50 +646 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +647 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +648 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +649 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +650 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +651 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +652 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:51 +653 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:51 +654 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:51 +655 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:51 +656 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:51 +657 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +658 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +659 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +660 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +661 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +662 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +663 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +664 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +665 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +666 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +667 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +668 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +669 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +670 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:51 +671 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +672 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +673 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +674 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +675 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +676 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +677 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +678 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert — no chevron, no tap
00:53 +679 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert — no chevron, no tap
00:53 +680 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.0: four tabs stay equal, and every label keeps its full size
00:53 +681 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +682 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +683 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +684 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +685 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +686 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +687 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +688 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +689 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +690 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +691 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +692 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +693 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +694 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +695 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +696 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +697 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +698 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +699 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +700 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +701 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:53 +702 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +703 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +704 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +705 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +706 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +707 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +708 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +709 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +710 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +711 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +712 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +713 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +714 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:54 +715 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +716 ~1: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) no label is scaled AT ALL — D-012
00:55 +717 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +718 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +719 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +720 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +721 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +722 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +723 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +724 ~1: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:56 +725 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +726 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +727 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +728 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +729 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +730 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +731 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:56 +732 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +733 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +734 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +735 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +736 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +737 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +738 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +739 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +740 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +741 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +742 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +743 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +744 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +745 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +746 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +747 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +748 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +749 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +750 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +751 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +752 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +753 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +754 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +755 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +756 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +757 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +758 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:57 +759 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:58 +760 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:59 +761 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:59 +762 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +763 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +764 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +765 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +766 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +767 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +768 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +769 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +770 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +771 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +772 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +773 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +774 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +775 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +776 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +777 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +778 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +779 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:59 +780 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:00 +781 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:00 +782 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:01 +783 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
01:01 +784 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
01:01 +785 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +786 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
01:02 +787 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
01:03 +788 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar tapping Upload photo changes nothing
01:03 +789 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz the three buckets account for every question
01:03 +790 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:03 +791 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:03 +792 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:03 +793 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:03 +794 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:03 +795 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:03 +796 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:04 +797 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
01:04 +798 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
01:04 +799 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
01:04 +800 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
01:04 +801 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +802 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +803 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +804 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +805 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
01:05 +806 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) dismiss does NOT log out
01:06 +807 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:06 +808 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:06 +809 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:06 +810 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:06 +811 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:06 +812 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +813 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +814 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +815 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +816 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +817 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +818 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +819 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +820 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +821 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +822 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +823 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +824 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +825 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +826 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +827 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +828 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +829 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:07 +830 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:08 +831 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
01:08 +832 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
01:08 +833 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
01:08 +834 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
01:08 +835 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity — the union at its first call site a CODED city renders the Arabic name in AR
01:08 +836 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity — the union at its first call site a CODED city renders the Arabic name in AR
01:09 +837 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:09 +838 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:09 +839 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:09 +840 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:09 +841 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +842 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +843 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +844 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +845 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +846 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +847 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +848 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +849 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +850 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +851 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +852 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +853 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +854 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +855 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +856 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +857 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +858 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +859 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +860 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +861 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +862 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +863 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +864 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +865 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:10 +866 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:10 +867 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:10 +868 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:10 +869 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +870 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +871 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +872 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +873 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +874 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +875 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +876 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +877 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +878 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +879 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +880 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +881 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +882 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +883 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +884 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +885 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +886 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +887 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +888 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:10 +889 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:11 +890 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:11 +891 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:11 +892 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
01:11 +893 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +894 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +895 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +896 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +897 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +898 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +899 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +900 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +901 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +902 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +903 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +904 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +905 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +906 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +907 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +908 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +909 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +910 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +911 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +912 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +913 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +914 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +915 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +916 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +917 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +918 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +919 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:12 +920 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:13 +921 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
01:13 +922 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:14 +923 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:14 +924 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:14 +925 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +926 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +927 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +928 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +929 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +930 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +931 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +932 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +933 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +934 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +935 ~1: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
01:15 +936 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:15 +937 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:15 +938 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:16 +939 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:16 +940 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:16 +941 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
01:16 +942 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
01:17 +943 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:17 +944 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:17 +945 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:17 +946 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
01:18 +947 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save 400 validation_failed lands as an inline error on the field
01:18 +948 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save 400 validation_failed lands as an inline error on the field
01:18 +949 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
01:18 +950 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:19 +951 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:19 +952 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:19 +953 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:19 +954 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:19 +955 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:20 +956 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:20 +957 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:20 +958 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:21 +959 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:21 +960 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +961 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +962 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +963 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +964 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +965 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +966 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +967 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +968 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +969 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +970 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +971 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +972 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +973 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +974 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +975 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:21 +976 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +977 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +978 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +979 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +980 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +981 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +982 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +983 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +984 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +985 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +986 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
01:22 +987 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
01:22 +988 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
01:22 +989 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
01:23 +990 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
01:23 +991 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) valid input stores identity (referral collected) and routes to track
01:23 +992 ~1: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) valid input stores identity (referral collected) and routes to track
01:23 +993 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: states matrix dark theme renders the same content
01:23 +994 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined dark: the rewards card takes G14 and the lavender back-light
01:24 +995 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a clean form leaves without asking
01:24 +996 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:24 +997 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:24 +998 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:24 +999 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
01:24 +1000 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:24 +1001 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1002 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1003 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1004 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1005 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1006 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1007 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:25 +1008 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:26 +1009 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:26 +1010 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:26 +1011 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:26 +1012 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:27 +1013 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:27 +1014 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:27 +1015 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:27 +1016 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:27 +1017 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:28 +1018 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:28 +1019 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:28 +1020 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:28 +1021 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:28 +1022 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is ON when the quiz screen mounts
01:28 +1023 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the Review Questions CTA wears the primary treatment it is wrapped, and nothing else on the screen is
01:28 +1024 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: states offline gets its own view, not the generic error
01:28 +1025 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: states offline gets its own view, not the generic error
01:28 +1026 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the Start CTA wears the primary treatment offline dims the treatment as well as the button
01:28 +1027 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1028 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1029 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1030 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1031 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1032 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1033 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1034 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1035 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:28 +1036 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:29 +1037 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:29 +1038 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:29 +1039 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:29 +1040 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:29 +1041 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) a non-Egypt country hides Governorate AND the school step entirely
01:30 +1042 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes EN lays out LTR
01:30 +1043 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: exit guard closing asks first — progress cannot be lost silently
01:30 +1044 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) switching country clears the dependent geography
01:31 +1045 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes dark renders the same form on the dark canvas
01:31 +1046 ~1: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:31 +1047 ~1: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:31 +1048 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) City stays gated until a governorate is chosen (Egypt)
01:31 +1049 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes AR + dark together
01:31 +1050 ~1: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes AR + dark together
01:31 +1051 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: states matrix dark theme
01:31 +1052 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: states matrix dark theme
01:32 +1053 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: states matrix dark theme
01:32 +1054 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: states matrix dark theme
01:32 +1055 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) choosing a governorate unlocks the city list
01:32 +1056 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) choosing a governorate unlocks the city list
01:32 +1057 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) choosing a governorate unlocks the city list
01:32 +1058 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) choosing a governorate unlocks the city list
01:32 +1059 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) choosing a governorate unlocks the city list
01:32 +1060 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:32 +1061 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:32 +1062 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:32 +1063 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:32 +1064 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:32 +1065 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:33 +1066 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:33 +1067 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:33 +1068 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:33 +1069 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:33 +1070 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:33 +1071 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:33 +1072 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:33 +1073 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:34 +1074 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:34 +1075 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:34 +1076 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:34 +1077 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:34 +1078 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:35 +1079 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:35 +1080 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:35 +1081 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:36 +1082 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:36 +1083 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:36 +1084 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:36 +1085 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:36 +1086 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:37 +1087 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:37 +1088 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:37 +1089 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:37 +1090 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:37 +1091 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:37 +1092 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1093 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1094 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1095 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1096 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1097 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1098 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:38 +1099 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill dark carries G13 and NO shadow — the empty list is a reading
01:39 +1100 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill dark carries G13 and NO shadow — the empty list is a reading
01:39 +1101 ~1: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill dark carries G13 and NO shadow — the empty list is a reading
01:39 +1102 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:39 +1103 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:39 +1104 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:39 +1105 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:39 +1106 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:40 +1107 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:40 +1108 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:40 +1109 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:40 +1110 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:40 +1111 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:40 +1112 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:40 +1113 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:40 +1114 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:41 +1115 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:41 +1116 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:42 +1117 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:42 +1118 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:42 +1119 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:42 +1120 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:42 +1121 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:42 +1122 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:43 +1123 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:43 +1124 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:43 +1125 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:43 +1126 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:43 +1127 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1128 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1129 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1130 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1131 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1132 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1133 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:44 +1134 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:45 +1135 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:45 +1136 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:45 +1137 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:45 +1138 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:45 +1139 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:45 +1140 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1141 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1142 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1143 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1144 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1145 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1146 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1147 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1148 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:46 +1149 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:47 +1150 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:47 +1151 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:47 +1152 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:48 +1153 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:48 +1154 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:48 +1155 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:49 +1156 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:49 +1157 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:49 +1158 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:49 +1159 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:49 +1160 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:50 +1161 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:50 +1162 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:50 +1163 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:50 +1164 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:51 +1165 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:51 +1166 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:51 +1167 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:51 +1168 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:52 +1169 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:52 +1170 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:52 +1171 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:52 +1172 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:52 +1173 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:53 +1174 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:53 +1175 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:53 +1176 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:53 +1177 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1178 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1179 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1180 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1181 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1182 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1183 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1184 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1185 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1186 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:54 +1187 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:55 +1188 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:55 +1189 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:55 +1190 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:55 +1191 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:55 +1192 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:55 +1193 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1194 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1195 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1196 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1197 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1198 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1199 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1200 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1201 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1202 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1203 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1204 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1205 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1206 ~1: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:56 +1207 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:56 +1208 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:56 +1209 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:56 +1210 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:56 +1211 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:56 +1212 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:56 +1213 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:57 +1214 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1215 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1216 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1217 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1218 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1219 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1220 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1221 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1222 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1223 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1224 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1225 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1226 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1227 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1228 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1229 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1230 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1231 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1232 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1233 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1234 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1235 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1236 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1237 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1238 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1239 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1240 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1241 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1242 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1243 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1244 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1245 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1246 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1247 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1248 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1249 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:57 +1250 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:58 +1251 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:58 +1252 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:58 +1253 ~1: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:58 +1254 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored language is already in force, in the right direction
01:58 +1255 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored language is already in force, in the right direction
01:58 +1256 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1257 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1258 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1259 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1260 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1261 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1262 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1263 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1264 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1265 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1266 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1267 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1268 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1269 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1270 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:59 +1271 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1272 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1273 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1274 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1275 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1276 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1277 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1278 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1279 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1280 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1281 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1282 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1283 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1284 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1285 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1286 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1287 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:00 +1288 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:01 +1289 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
02:01 +1290 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_announcements is structurally non-interactive
02:01 +1291 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
02:01 +1292 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
02:01 +1293 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
02:02 +1294 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
02:02 +1295 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
02:02 +1296 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
02:02 +1297 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
02:03 +1298 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity → the offline banner
02:03 +1299 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
02:03 +1300 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
02:03 +1301 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
02:03 +1302 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
02:03 +1303 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
02:03 +1304 ~1: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark offline pins the banner and Rank still reads from cache
02:03 +1305 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
02:03 +1306 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
02:05 +1307 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
02:05 +1308 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" the picker is the default; the escape is a link under it
02:05 +1309 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
02:06 +1310 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
02:07 +1311 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
02:07 +1312 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
02:08 +1313 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
02:09 +1314 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
02:09 +1315 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable an Egyptian student can submit having skipped it
02:10 +1316 ~1: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
02:10 +1317 ~1: All tests passed!
```

