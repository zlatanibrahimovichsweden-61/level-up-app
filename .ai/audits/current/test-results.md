# Validation run - 2026-10-06T02:18:05Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 324 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 2067 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-10-06T02:18:05Z - finished 2026-10-06T02:20:04Z

---

## 1. Environment

```text
started (UTC)  : 2026-10-06T02:18:05Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : f10b112
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 84fc5cbb22 (3 months ago) • 2026-07-17 10:20:17 -0700
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
  built_collection 5.1.1 (5.1.2 available)
  built_value 8.12.6 (8.13.0 available)
  cached_network_image 3.4.1 (4.0.4 available)
  cached_network_image_platform_interface 4.1.1 (5.0.3 available)
  cached_network_image_web 1.3.1 (2.0.3 available)
  cli_util 0.4.2 (0.6.0 available)
  clock 1.1.2 (1.1.3 available)
  code_assets 1.2.1 (2.1.0 available)
  code_builder 4.11.1 (4.12.0 available)
  connectivity_plus 7.3.0 (7.3.2 available)
  cupertino_icons 1.0.9 (2.0.0 available)
  dart_style 3.1.8 (3.1.13 available)
  dbus 0.7.14 (0.8.0 available)
  device_info_plus 13.2.0 (13.3.0 available)
  dio 5.10.0 (5.11.1 available)
  dio_web_adapter 2.2.0 (2.2.2 available)
  flutter_cache_manager 3.4.2 (3.4.5 available)
  flutter_riverpod 3.3.2 (3.4.3 available)
  flutter_secure_storage 10.3.1 (11.2.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.3 available)
  flutter_secure_storage_linux 3.0.1 (3.0.3 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.1.1 available)
  freezed 3.2.6-dev.1 (4.0.2 available)
  frontend_server_client 4.0.0 (4.1.0 available)
  glob 2.1.3 (2.2.0 available)
  go_router 17.3.0 (18.0.2 available)
  hooks 2.0.2 (2.2.0 available)
  intl 0.20.2 (0.20.3 available)
  io 1.0.5 (1.1.0 available)
  jni 1.0.0 (1.1.0 available)
  jni_flutter 1.0.1 (1.0.3 available)
  jovial_svg 1.1.29 (1.1.31 available)
  json_serializable 6.14.0 (6.14.1 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.0 (1.19.0 available)
  mime 2.0.0 (2.1.0 available)
  mockito 5.6.4 (5.8.1 available)
  nm 0.5.0 (0.6.0 available)
  objective_c 9.4.1 (9.6.2 available)
  octo_image 2.1.0 (2.1.2 available)
  package_config 2.2.0 (3.0.0 available)
  petitparser 7.0.2 (7.1.0 available)
  pinput 6.0.2 (7.0.0 available)
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
  url_launcher 6.3.2 (6.3.3 available)
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
  xml 6.6.1 (7.1.0 available)
  yaml 3.1.3 (3.1.4 available)
Got dependencies!
89 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 324 hand-written Dart files

Formatted 60 files (0 changed) in 0.26 seconds.
Formatted 60 files (0 changed) in 0.27 seconds.
Formatted 60 files (0 changed) in 0.25 seconds.
Formatted 60 files (0 changed) in 0.29 seconds.
Formatted 60 files (0 changed) in 0.42 seconds.
Formatted 24 files (0 changed) in 0.11 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 12.1s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**2067 passed, 0 failed, 0 skipped** (exit 0)


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
00:00 +7: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: (setUpAll)
00:00 +7: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion recognises the code
00:00 +8: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion does not confuse it with the OTHER 403 the same routes answer
00:00 +9: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion ignores transport failures and non-API errors
00:00 +10: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion matches on the code, so a subclass is recognised too
00:00 +11: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz — all four quiz endpoints share one helper
00:00 +12: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz — the existing codes are untouched
00:00 +13: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile — PATCH /me is NOT on the allowlist, only GET /me is
00:00 +14: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile — offline still outranks it, and validation still works
00:00 +15: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for a pending deletion
00:00 +16: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for quiz_already_finished too
00:00 +17: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry leaves every other failure retryable
00:00 +18: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry is not the same question as opensLimitSheet
00:00 +19: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: the copy itself exists in both locales and is not the generic message
00:00 +20: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: the copy itself is purchase-silent (adr-049 §3)
00:00 +21: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: (tearDownAll)
00:00 +21: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required → refresh once → original retried → success
00:00 +22: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:00 +23: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:00 +24: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:01 +25: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:01 +26: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
00:01 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException carries the ProblemDetails field map
00:01 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException is still an ApiException (existing handlers keep working)
00:01 +29: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a missing/malformed errors map yields empty fields, not a crash
00:01 +30: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a non-list value is tolerated as a single message
00:01 +31: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:01 +32: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 → UnauthorizedException carrying the code
00:01 +33: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 → ApiException carrying status + code
00:01 +34: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error → NetworkException (drives Offline)
00:01 +35: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException is typed, and is NOT otp_throttled
00:01 +36: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a delta-seconds Retry-After parses
00:01 +37: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an ABSENT header yields null — and does not throw
00:01 +38: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a GARBAGE header yields null — and does not throw
00:01 +39: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:01 +40: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:01 +41: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:01 +42: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:01 +43: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:01 +44: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:01 +45: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:01 +46: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:01 +47: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:01 +48: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:01 +49: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:01 +50: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:01 +51: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:01 +52: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:01 +53: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:01 +54: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:01 +55: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:01 +56: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:02 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:02 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:02 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:02 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on /login/otp → stay (the success view shows)
00:02 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:02 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:02 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:02 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:02 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:02 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:02 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +84: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places light and dark both define them
00:03 +85: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places copyWith round-trips each of them
00:03 +86: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp moves each of them — a missing entry would pin one in place
00:03 +87: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp endpoints are exact
00:03 +88: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: brandLogo light is the shipped SVG's own fill; dark is the dark frame's
00:03 +89: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: brandLogo is wired through copyWith and lerp
00:03 +90: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone light is unchanged by the dark correction
00:03 +91: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone dark is the 404:7428 family, not the light values
00:03 +92: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Mistakes tokens follow the dark frames and leave light alone the two new tokens are wired through copyWith and lerp
00:03 +93: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge is identical in both palettes — it must not follow the accent flip
00:03 +94: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge equals the fill in the exported SVG — not an estimate
00:03 +95: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge the badge keeps its white checkmark — so it is never srcIn-tinted
00:03 +96: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: the OTP stopwatch export is stroked in the light otpTimerContent
00:03 +97: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: OTP timer content and error state timer content: #384F47 light, cream dark (82:1316 / 337:19503)
00:03 +98: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: OTP timer content and error state error line #FF465C and cell stroke #EB001B@50%, both canvases
00:03 +99: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: OTP timer content and error state copyWith and lerp carry the three tokens
00:03 +100: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the dark canvas washes at 20%, it does not paint an opaque card
00:03 +101: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the three dark surfaces that are deliberately OPAQUE
00:03 +102: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces light values are the frames, not a reuse of an old token
00:03 +103: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the five light-only borders are null in dark, not a fallback
00:03 +104: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces otpCardGlow is dark-only, and is the OTP card shadow colour
00:03 +105: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the tokens that must NOT flip with the canvas
00:03 +106: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces every new token is wired through copyWith and lerp
00:03 +107: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the three review-row fills: light opaque, dark at the frame's 20%
00:03 +108: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the wrong row keeps the SHIPPED hue, not the review frame's drift
00:03 +109: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle quizReviewRowContent stopped being canvas-independent, and had to
00:03 +110: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the previous-button glyph is cream on BOTH canvases
00:03 +111: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the light selected scope fill is #DBB0FF — the re-read value
00:03 +112: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the idle scope label is a dark GREEN, not textSecondary grey
00:03 +113: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle the badge ring took the frame's lavender without moving the shared token
00:03 +114: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 — quiz review rows, prev button, scope toggle every edit4 token is wired through copyWith and lerp
00:03 +115: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 20 avatar tokens the frames' values in both palettes
00:03 +116: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 20 avatar tokens every one is wired through copyWith and lerp
00:03 +117: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 21 Settings tokens the frames' values in both palettes
00:03 +118: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 21 Settings tokens every one is wired through copyWith and lerp
00:03 +119: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the designed values, light and dark
00:03 +120: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the grade-failure line is composed from existing error colours, not from the quiz's dark red
00:03 +121: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the grade-failure line reads on its own canvas: 4.5:1 for body text
00:03 +122: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the dark values with no frame are named stand-ins, not inventions
00:03 +123: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens every one is wired through copyWith and lerp
00:03 +124: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: all three brand assets landed
00:04 +125: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion kFigmaBlurToSigma is the CSS definition, not a tunable
00:04 +126: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion sigma is NOT what BoxShadow would have produced
00:04 +127: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion frost converts with its own constant
00:04 +128: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration nav bar: the two canvases differ in colour AND blur
00:04 +129: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the three CTA tokens
00:04 +130: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration back chip: light shadow, dark Glass — not a missing shadow
00:04 +131: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the registration back chip is a different Glass from G5
00:04 +132: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration language pill: G3 differs from G5 only in lightIntensity
00:04 +133: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration form fields: G4, and the 0.03 hairline kept verbatim
00:04 +134: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration onboarding sheet: the only Glass in the light frames
00:04 +135: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration scrims: five frames, five readings
00:04 +136: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes level card: light shadow, dark Glass plus a back-light
00:04 +137: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes daily tasks: G7, and two differently sized back-lights
00:04 +138: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes top student: same border width on both canvases
00:04 +139: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes continue learning: two shadows, one with a negative spread
00:04 +140: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subjects search: the file's only 10% shadows
00:04 +141: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subject card: identical on both canvases — this is #34's proof
00:04 +142: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes mistakes pill and card
00:04 +143: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes the segmented pill track inverts its inner shadow when selected
00:04 +144: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the five near-identical small shadows stay five tokens
00:04 +145: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard length chips, AI panel and leaderboard list keep dark shadows
00:04 +146: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard AI panel: G18 outside, G5 inside, one back-light
00:04 +147: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard quiz previous button: G13 confirms the angle convention
00:04 +148: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard result buckets, rewards card and star disc
00:04 +149: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the scope toggle is the file's only white inner shadow
00:04 +150: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard a leaderboard row carries two different Glass effects
00:04 +151: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card profile header, edit chip and stat card keep a dark shadow
00:04 +152: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card avatar badge
00:04 +153: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card settings sections and their two back-lights
00:04 +154: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:04 +155: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card the two track cards carry two different Glass angles
00:04 +156: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: API→UI Wave 22 — flashcards the card is one INNER shadow, the same on both canvases
00:04 +157: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: API→UI Wave 22 — flashcards it is wired through copyWith and lerp
00:04 +158: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:04 +159: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:04 +160: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:04 +161: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism the onboarding sheet is the ONLY light Glass
00:04 +162: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every dark surface that Figma glassed has a token
00:04 +163: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every back-light is dark-only and takes the palette colour
00:04 +164: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places props covers every field
00:04 +165: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places copyWith round-trips, and leaves the others alone
00:04 +166: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp endpoints are exact
00:04 +167: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp actually moves, and snaps what cannot be interpolated
00:04 +168: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp ignores a foreign extension, as ThemeExtension requires
00:04 +169: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places equality is by value, not by identity
00:04 +170: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places both ThemeData objects carry it
00:04 +171: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:04 +172: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:04 +173: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:04 +174: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:04 +175: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:04 +176: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:04 +177: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:04 +178: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:04 +179: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:05 +180: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: a text takes its first strong character's direction, else the app's
00:05 +181: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: it is the quiz question's rule, exactly
00:05 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:06 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:06 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:06 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:06 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:06 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:06 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:06 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:06 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:06 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:06 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses directional radii
00:06 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses directional radii
00:06 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses directional radii
00:06 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:06 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: the backdrop is opt-in uniform — the default — creates NO BackdropFilter
00:06 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog barrierDismissible false keeps it open
00:06 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: the backdrop is opt-in content — the onboarding sheet — creates exactly one
00:06 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog system back still pops it, and returns its value
00:06 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:06 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:06 +209: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +210: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +211: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +212: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +213: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +214: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +215: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +216: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +217: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +218: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:07 +219: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:07 +220: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:07 +221: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the shipped strength is the ruled fraction of the measured
00:07 +222: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:07 +223: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:07 +224: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:07 +225: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet a barrier tap still dismisses, blurred
00:07 +226: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: the tokens these helpers are fed the dark limit sheet is BLOCKED, not unscrimmed
00:07 +227: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: the tokens these helpers are fed light scrims never blur; dark ones always do
00:07 +228: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +229: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +230: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +231: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +232: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +233: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +234: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +235: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +236: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +237: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +238: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +239: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +240: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:08 +241: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +242: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +243: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +244: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +245: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +246: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +247: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +248: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +249: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +250: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +251: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +252: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +253: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:09 +254: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:09 +255: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +256: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +257: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +258: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +259: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +260: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +261: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +262: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +263: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +264: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +265: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +266: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:09 +267: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +268: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +269: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +270: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +271: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +272: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +273: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +274: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +275: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +276: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +277: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +278: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +279: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +280: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +281: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +282: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +283: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +284: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:10 +285: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging 24 cards page 10 / 10 / 4 by cursor, and hasMore says when to stop
00:10 +286: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:10 +287: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:10 +288: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging anatomy-l3 serves its 4 card(s) as ONE page, hasMore false
00:10 +289: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +290: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +291: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +292: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +293: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +294: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +295: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:10 +296: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation the School track is insufficient_scope
00:10 +297: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:10 +298: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:10 +299: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:10 +300: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:10 +301: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:10 +302: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation a pageSize that is not an integer is validation_failed too
00:10 +303: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:10 +304: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:10 +305: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:10 +306: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:10 +307: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance a charged card re-delivers free: page 1 twice spends the allowance ONCE
00:10 +308: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:10 +309: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:10 +310: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:10 +311: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:10 +312: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:10 +313: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance zero deliverable cards is flashcard_subscription_required, never an empty page
00:10 +314: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:10 +315: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:10 +316: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:10 +317: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:10 +318: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:10 +319: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade a card past the delivered prefix is out of reach; one inside it is not
00:10 +320: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader dark: the FILL is whatever the screen passes; the track and counter are shared
00:10 +321: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader dark: the FILL is whatever the screen passes; the track and counter are shared
00:10 +322: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader dark: the FILL is whatever the screen passes; the track and counter are shared
00:10 +323: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade a grade that is missing or not gotIt/again is validation_failed on grade
00:10 +324: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:10 +325: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:10 +326: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:10 +327: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:10 +328: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: fixtures card ids are unique, readable and named after their lecture
00:10 +329: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:10 +330: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:11 +331: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:11 +332: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:11 +333: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:11 +334: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:11 +335: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:11 +336: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:11 +337: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:11 +338: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:11 +339: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:11 +340: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me the privacy toggles round-trip (Wave 21 needs them)
00:11 +341: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:11 +342: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:11 +343: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:11 +344: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me edits stay with their track across a sign-in
00:11 +345: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:11 +346: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:11 +347: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:11 +348: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:11 +349: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:11 +350: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:11 +351: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable — the 159:1852 variant
00:11 +352: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:11 +353: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:11 +354: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:11 +355: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:11 +356: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:11 +357: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:11 +358: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:11 +359: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:11 +360: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:11 +361: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent — a repeat call replays the same summary
00:11 +362: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me — what invalidating the profile shows
00:11 +363: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered — expected, not a bug
00:11 +364: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:11 +365: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:11 +366: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:11 +367: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:12 +368: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:12 +369: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:12 +370: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:12 +371: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:12 +372: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:12 +373: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:12 +374: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:12 +375: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:12 +376: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:12 +377: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:12 +378: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:12 +379: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:12 +380: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:12 +381: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:12 +382: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:12 +383: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:12 +384: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:12 +385: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:12 +386: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:12 +387: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:12 +388: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:12 +389: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +390: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:13 +391: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:13 +392: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:13 +393: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:13 +394: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:14 +395: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +396: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:15 +397: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +398: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +399: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +400: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +401: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +402: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +403: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +404: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +405: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +406: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +407: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +408: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +409: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +410: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +411: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +412: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +413: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +414: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:15 +415: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:15 +416: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +417: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +418: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +419: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +420: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +421: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +422: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +423: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +424: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +425: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +426: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +427: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +428: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +429: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +430: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +430: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:16 +431: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +432: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +433: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +434: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +435: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +436: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +437: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +438: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +439: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +440: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +441: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +442: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +443: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +444: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +445: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +446: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +447: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +448: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +449: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +450: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +451: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +452: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +453: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +454: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +455: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +456: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +457: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +458: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +459: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +460: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +461: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +462: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +463: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +464: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +465: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +466: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
unhandled element <filter/>; Picture key: Svg loader
00:17 +467: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:17 +468: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:17 +468: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:17 +469: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:17 +470: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:17 +471: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:17 +472: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +473: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +474: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +475: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +476: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +477: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +478: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +479: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +480: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +481: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +482: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +483: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +484: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +485: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +486: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +487: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +488: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +489: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +490: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +491: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +492: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +493: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +494: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +495: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +496: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +497: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +498: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:19 +499: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
00:19 +500: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +501: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +502: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +503: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +504: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +505: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +506: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +507: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +508: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +509: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +510: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:21 +511: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:21 +512: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:21 +513: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:21 +514: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +515: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +516: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:22 +517: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:22 +518: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:22 +519: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:22 +520: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:22 +521: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:23 +522: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +523: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +524: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +525: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +526: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +527: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +528: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +529: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +530: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +531: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +532: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +533: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +534: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +535: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +536: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +537: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +538: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +539: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +540: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +541: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +542: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +543: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +544: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +545: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +546: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +547: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +548: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +549: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +550: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +551: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +552: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +553: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +554: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +555: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +556: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +557: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +558: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +559: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +560: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +561: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +562: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +563: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +564: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +565: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +566: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:24 +567: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
00:24 +568: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
00:24 +569: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in en at 2.0x; rows grow together
00:24 +570: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:24 +571: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:24 +572: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +573: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +574: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +575: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +576: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +577: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +578: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +579: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +580: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +581: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +582: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
00:25 +583: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
00:25 +584: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
00:25 +585: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
00:25 +586: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
00:25 +587: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:25 +588: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:25 +589: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:25 +590: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +591: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +592: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +593: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:25 +594: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:25 +595: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:25 +596: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
00:25 +597: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +598: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +599: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +600: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +601: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +602: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +603: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +604: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +605: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +606: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +607: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:26 +608: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
00:26 +609: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
00:26 +610: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:26 +611: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +612: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +613: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +614: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +615: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +616: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +617: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +618: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +619: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +620: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +621: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +622: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +623: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +624: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +625: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +626: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +627: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +628: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +629: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +630: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +631: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +632: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +633: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +634: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +635: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +636: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +637: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +638: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +639: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +640: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +641: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +642: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +643: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +644: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +645: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +646: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +647: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +648: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +649: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +650: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +651: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +652: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +653: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +654: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +655: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +656: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +657: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +658: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +659: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +660: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +661: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +662: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +663: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +664: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +665: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +666: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +667: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +668: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +669: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +670: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +671: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +672: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +673: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +674: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +675: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +676: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +677: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +678: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +679: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +680: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +681: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +682: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +683: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +684: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +685: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +686: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +687: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +688: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +689: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +690: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +691: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +692: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +693: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +694: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +695: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +696: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +697: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +698: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +699: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:29 +700: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +701: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +702: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +703: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +704: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +705: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +706: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +707: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +708: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +709: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +710: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +711: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +712: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +713: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +714: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +715: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +716: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +717: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +718: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +719: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +720: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +721: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +722: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +723: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +724: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +725: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +726: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +727: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +728: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:30 +729: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +730: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +731: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +732: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +733: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +734: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +735: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +736: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +737: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +738: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +739: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +740: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +741: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +742: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +743: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +744: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +745: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +746: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +747: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +748: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +749: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
00:31 +750: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
00:31 +751: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
00:31 +752: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +753: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +754: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +755: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +756: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +757: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +758: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +759: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +760: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +761: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:31 +762: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
00:31 +763: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
00:31 +764: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
00:31 +765: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
00:31 +766: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:31 +767: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:31 +768: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:32 +769: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:32 +770: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +771: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +772: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +773: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +774: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +775: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +776: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +777: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +778: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +779: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +780: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +781: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +782: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +783: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +784: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +785: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +786: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +787: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +788: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +789: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +790: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +791: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +792: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +793: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +794: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +795: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +796: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +797: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +798: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +799: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +800: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +801: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +802: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +803: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +804: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +805: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +806: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +807: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +808: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +809: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +810: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +811: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +812: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +813: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +814: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +815: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +816: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +817: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +818: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +819: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +820: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +821: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +822: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +823: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading dark: the failure line reads on the canvas it is drawn on
00:33 +824: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: geometry against the frame (402 wide) the helper is start-aligned, in AR too
00:33 +825: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +826: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +827: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +828: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +829: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +830: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +831: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +832: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +833: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +834: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +835: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +836: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +837: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +838: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +839: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +840: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +841: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +842: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +843: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +844: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +845: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +846: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +847: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +848: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +849: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +850: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +851: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +852: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +853: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +854: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +855: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +856: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +857: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +858: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +859: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +860: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +861: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +862: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +863: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +864: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +865: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +866: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +867: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +868: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +869: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +870: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +871: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on the restart button: its copy stays and BOTH grade buttons are off for that card
00:34 +872: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on the restart button: its copy stays and BOTH grade buttons are off for that card
00:34 +873: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on the restart button: its copy stays and BOTH grade buttons are off for that card
00:34 +874: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on the restart button: its copy stays and BOTH grade buttons are off for that card
00:34 +875: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +876: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +877: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +878: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +879: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +880: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +881: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +882: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +883: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +884: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +885: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +886: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +887: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +888: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +889: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +890: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +891: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +892: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +893: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +894: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +895: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +896: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +897: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +898: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +899: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +900: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +901: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +902: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +903: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +904: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +905: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +906: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +907: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +908: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +909: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +910: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +911: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +912: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +913: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +914: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +915: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +916: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +917: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +918: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +919: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +920: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +921: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +922: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +923: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +924: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +925: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +926: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +927: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +928: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +929: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +930: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +931: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +932: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +933: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +934: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +935: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +936: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +937: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +938: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +939: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +940: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +941: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +942: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +943: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +944: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +945: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +946: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +947: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +948: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +949: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +950: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +951: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +952: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +953: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +954: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +955: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +956: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +957: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +958: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +959: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +960: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +961: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +962: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +963: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +964: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +965: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +966: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +967: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +968: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +969: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +970: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +971: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +972: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +973: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +974: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +975: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +976: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +977: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +978: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +979: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +980: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +981: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +982: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +983: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +984: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +985: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +986: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +987: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +988: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +989: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +990: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +991: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +992: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +993: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +994: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +995: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +996: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +997: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +998: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +999: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1000: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1001: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1002: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1003: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1004: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1005: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1006: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1007: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1008: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1009: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1010: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1011: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1012: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1013: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1014: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1015: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1016: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1017: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1018: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1019: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1020: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1021: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1022: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1023: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1024: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1025: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1026: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1027: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1028: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1029: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge dark: a 20% CREAM wash under G5, same black shadow
00:39 +1030: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: account_pending_deletion (adr-114) — the grace window an ordinary failure still gets its Retry
00:39 +1031: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:40 +1032: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:40 +1033: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:40 +1034: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:40 +1035: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:40 +1036: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1037: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1038: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1039: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1040: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1041: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1042: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1043: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1044: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1045: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1046: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1047: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1048: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1049: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1050: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1051: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1052: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1053: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1054: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1055: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1056: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1057: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1058: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1059: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:41 +1060: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:41 +1061: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:41 +1062: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:41 +1063: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1064: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1065: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1066: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1067: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1068: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1069: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1070: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1071: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1072: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1073: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1074: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1075: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1076: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1077: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1078: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1079: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1080: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1081: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1082: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1083: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1084: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1085: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1086: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1087: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1088: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1089: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1090: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1091: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1092: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1093: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1094: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1095: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1096: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1097: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1098: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1099: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1100: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1101: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1102: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1103: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1104: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1105: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1106: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1107: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1108: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1109: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1110: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1111: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1112: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1113: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1114: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1115: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1116: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1117: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1118: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1119: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1120: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1121: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1122: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1123: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1124: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:43 +1125: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:44 +1126: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:44 +1127: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:44 +1128: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:44 +1129: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:44 +1130: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:44 +1131: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:44 +1132: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:44 +1133: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:44 +1134: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1135: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1136: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1137: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1138: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1139: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1140: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1141: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1142: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1143: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1144: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1145: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1146: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:44 +1147: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1148: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1149: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1150: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1151: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1152: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1153: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1154: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1155: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1156: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1157: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1158: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1159: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1160: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1161: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1162: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1163: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1164: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1165: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1166: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1167: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +1168: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1169: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1170: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1171: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1172: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1173: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1174: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1175: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1176: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1177: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1178: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:45 +1179: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1180: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1181: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1182: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1183: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1184: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1185: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1186: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1187: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1188: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1189: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1190: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1191: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1192: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:45 +1193: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1194: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1195: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1196: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1197: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1198: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1199: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1200: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1201: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1202: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1203: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1204: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1205: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1206: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1207: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1208: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1209: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1210: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1211: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:45 +1212: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1213: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1214: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1215: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +1216: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +1217: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +1218: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +1219: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +1220: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +1221: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) the chevron is the frame's 13 × 27 arrow: 12 from the end, centred on the card, #517066
00:46 +1222: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) the chevron is the frame's 13 × 27 arrow: 12 from the end, centred on the card, #517066
00:46 +1223: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) the chevron is the frame's 13 × 27 arrow: 12 from the end, centred on the card, #517066
00:46 +1224: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) the chevron is the frame's 13 × 27 arrow: 12 from the end, centred on the card, #517066
00:46 +1225: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:46 +1226: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:46 +1227: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) dark: the chevron is cream (404:7651)
00:46 +1228: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar tapping Upload photo changes nothing
00:47 +1229: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1230: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1231: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1232: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1233: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1234: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1235: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1236: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1237: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1238: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1239: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1240: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1241: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1242: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1243: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1244: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1245: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1246: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1247: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1248: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1249: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1250: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1251: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1252: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1253: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1254: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1255: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1256: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1257: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1258: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +1259: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:48 +1260: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:48 +1261: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:48 +1262: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:48 +1263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) a skipped school reads as resolved, not as missing data
00:48 +1264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) a skipped school reads as resolved, not as missing data
00:48 +1265: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 1.3x; rows grow together
00:48 +1266: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 1.3x; rows grow together
00:48 +1267: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 1.3x; rows grow together
00:48 +1268: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 1.3x; rows grow together
00:48 +1269: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1270: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1271: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1272: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1273: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1274: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1275: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1276: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1277: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1278: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1279: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1280: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1281: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1282: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1283: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1284: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1285: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1286: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1287: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1288: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1289: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1290: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1291: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1292: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1293: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1294: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +1295: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
00:48 +1296: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
00:48 +1297: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
00:48 +1298: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
00:49 +1299: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:49 +1300: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity — the union at its first call site a FREE-TEXT city has nothing to localize, so AR shows it too
00:49 +1301: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in ar at 2.0x; rows grow together
00:49 +1302: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
00:49 +1303: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1304: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1305: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1306: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1307: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1308: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1309: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1310: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +1311: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1312: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1313: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1314: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1315: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1316: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1317: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1318: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1319: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1320: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1321: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1322: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1323: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1324: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1325: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:50 +1326: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1327: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1328: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1329: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1330: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1331: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1332: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1333: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1334: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1335: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1336: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1337: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1338: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1339: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1340: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1341: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1342: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1343: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:51 +1344: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1345: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1346: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1347: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1348: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1349: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1350: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1351: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1352: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1353: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1354: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1355: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1356: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1357: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1358: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1359: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1360: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1361: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1362: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1363: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1364: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1365: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1366: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1367: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1368: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1369: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1370: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1371: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1372: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1373: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1374: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1375: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1376: F:/level/level_up/level_up_app/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable — no regression
00:53 +1377: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
00:53 +1378: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
00:53 +1379: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering only the All chip carries a count
00:53 +1380: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
00:53 +1381: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
00:53 +1382: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
00:53 +1383: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:53 +1384: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
00:53 +1385: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the avatar block (176:1343 · 176:1346) ar: the disc 25 under the bar, the badge 14 below the disc, the first label 1 under the badge
00:53 +1386: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the avatar block (176:1343 · 176:1346) ar: the disc 25 under the bar, the badge 14 below the disc, the first label 1 under the badge
00:53 +1387: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the avatar block (176:1343 · 176:1346) ar: the disc 25 under the bar, the badge 14 below the disc, the first label 1 under the badge
00:53 +1388: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1389: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1390: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1391: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1392: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1393: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1394: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1395: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1396: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1397: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1398: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1399: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1400: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1401: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1402: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:54 +1403: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1404: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1405: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1406: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1407: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1408: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:54 +1409: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:54 +1410: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:54 +1411: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
00:55 +1412: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
00:55 +1413: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
00:55 +1414: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
00:55 +1415: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:55 +1416: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1417: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1418: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1419: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1420: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:55 +1421: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:55 +1422: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:55 +1423: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix leveledUp and newBadge parse but celebrate nothing
00:55 +1424: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
00:55 +1425: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
00:55 +1426: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1427: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1428: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1429: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1430: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1431: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1432: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1433: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1434: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1435: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1436: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1437: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1438: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
00:55 +1439: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
00:55 +1440: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the action sheet (216:3341) a drag handle over two plain, full-width rows and one hairline: no title, no ✕, no icons
00:55 +1441: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
00:55 +1442: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
00:56 +1443: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
00:56 +1444: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
00:56 +1445: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:56 +1446: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:56 +1447: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:56 +1448: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:56 +1449: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:56 +1450: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:56 +1451: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz Start hands the subject on to the quiz, display only (API→UI Wave 13)
00:56 +1452: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the action sheet (216:3341) the scrim dismisses it, and nothing changes
00:56 +1453: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the action sheet (216:3341) the scrim dismisses it, and nothing changes
00:56 +1454: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1455: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1456: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1457: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1458: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1459: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1460: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1461: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1462: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1463: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1464: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1465: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1466: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1467: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1468: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1469: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1470: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:57 +1471: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) light: the frame's ✕, 27 from the card's start, with a 48 x 48 target
00:57 +1472: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the review path consumes nothing and persists nothing calls no endpoint
00:57 +1473: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:57 +1474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1475: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1476: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1477: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1478: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1479: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1480: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1481: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1482: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1483: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1484: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1485: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1486: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1487: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1488: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1489: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1490: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1491: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1492: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1493: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1494: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1495: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1496: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1497: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1498: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1499: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1500: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1501: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1502: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1503: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1504: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1505: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1506: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1507: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1508: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1509: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1510: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1511: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1512: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1513: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1514: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1515: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1516: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1517: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1518: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1519: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1520: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1521: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1522: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1523: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1524: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1525: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:57 +1526: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:57 +1527: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:57 +1528: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:57 +1529: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) the strip starts 21 in and 24 under the bar, and every cell is the gradient disc
00:57 +1530: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
00:57 +1531: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
00:58 +1532: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
00:58 +1533: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
00:58 +1534: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
00:58 +1535: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
00:58 +1536: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1537: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1538: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
00:58 +1539: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
00:58 +1540: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
00:58 +1541: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
00:58 +1542: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) dark header: cream title over the same rule
00:58 +1543: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) dark header: cream title over the same rule
00:58 +1544: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1545: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1546: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1547: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1548: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1549: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1550: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1551: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1552: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1553: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1554: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1555: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1556: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1557: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1558: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1559: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1560: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1561: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1562: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1563: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1564: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1565: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1566: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1567: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1568: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1569: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) a second tap on Save while the first is in flight sends nothing more
00:58 +1570: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) a second tap on Save while the first is in flight sends nothing more
00:58 +1571: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) a second tap on Save while the first is in flight sends nothing more
00:58 +1572: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
00:59 +1573: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 · 337:6628) dark: title #FCFBF9, subtitle #EEEEEE, same rule
00:59 +1574: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:59 +1575: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:59 +1576: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:59 +1577: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1578: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1579: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1580: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1581: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1582: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1583: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1584: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1585: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1586: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1587: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1588: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1589: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1590: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1591: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1592: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1593: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1594: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
00:59 +1595: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:59 +1596: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:59 +1597: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
01:00 +1598: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
01:00 +1599: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) rows: 19 apart
01:00 +1600: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the length chips are raised, not outlined selecting one swaps the fill without changing the shape
01:00 +1601: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:00 +1602: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:00 +1603: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:00 +1604: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:00 +1605: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
01:00 +1606: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
01:00 +1607: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the Start CTA wears the primary treatment offline dims the treatment as well as the button
01:00 +1608: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the Start CTA wears the primary treatment offline dims the treatment as well as the button
01:00 +1609: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is ON when the quiz screen mounts
01:00 +1610: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 · 337:6628) dark: the "Points" run is cream, the rest stays lavender
01:00 +1611: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
01:00 +1612: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
01:00 +1613: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
01:00 +1614: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
01:01 +1615: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:01 +1616: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:01 +1617: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) dark: label and question cream on every row; the label is NOT the frame's lavender (owner ruling)
01:01 +1618: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the header matches both frames the subject sits above the scope, as in 135:1622
01:01 +1619: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
01:01 +1620: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
01:01 +1621: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
01:01 +1622: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: exit guard closing asks first — progress cannot be lost silently
01:01 +1623: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the header matches both frames dark: subject and scope are both #FCFBF9, not the accent
01:01 +1624: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the header matches both frames dark: subject and scope are both #FCFBF9, not the accent
01:01 +1625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1652: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1653: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1654: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1655: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1656: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1657: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1658: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1659: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1660: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1661: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1662: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1663: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1664: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1665: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1666: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1667: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1668: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1669: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1670: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1671: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1672: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill light carries the small black shadow and no Glass
01:03 +1673: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) invalid parent phone blocks Continue
01:03 +1674: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) invalid parent phone blocks Continue
01:04 +1675: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1676: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1677: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1678: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1679: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1680: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1681: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1682: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1683: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1684: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1685: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1686: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1687: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1688: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1689: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1690: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1691: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1692: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1693: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1694: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1695: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1696: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1697: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1698: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill it sits 15 dp from the primary CTA
01:05 +1699: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_2 (track picker) selecting School sets the discriminator and routes to /school
01:05 +1700: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout shows the frame fields in order after Date of Birth
01:05 +1701: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the quiz CTAs wear the primary treatment Confirm is wrapped, and its enabled state follows the Bloc
01:05 +1702: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_2 (track picker) selecting University routes to /university
01:05 +1703: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1704: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1705: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1706: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1707: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1708: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1709: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1710: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1711: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1712: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1713: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1714: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1715: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1716: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1717: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1718: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1719: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1720: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1721: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1722: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1723: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1724: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1725: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1726: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1727: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1728: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1729: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) switching country clears the dependent geography
01:07 +1730: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) switching country clears the dependent geography
01:07 +1731: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #54 the illustration shadow 53% at sigma 3.7 — layer blur 7.4 halved (R3)
01:07 +1732: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) a 409 quiz_already_finished shows the copy and NO Retry
01:07 +1733: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) a 409 quiz_already_finished shows the copy and NO Retry
01:07 +1734: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) a 409 quiz_already_finished shows the copy and NO Retry
01:07 +1735: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) a 409 quiz_already_finished shows the copy and NO Retry
01:07 +1736: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) City stays gated until a governorate is chosen (Egypt)
01:07 +1737: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1738: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1739: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1740: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1741: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1742: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1743: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1744: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1745: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1746: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1747: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1748: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1749: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1750: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1751: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1752: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1753: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1754: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1755: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1756: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1757: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1758: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1759: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1760: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1761: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1762: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1763: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1764: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1765: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1766: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1767: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1768: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:09 +1769: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:09 +1770: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:09 +1771: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:09 +1772: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1773: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1774: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1775: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1776: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1777: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1778: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1779: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1780: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1781: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1782: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1783: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1784: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:10 +1785: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1786: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1787: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1788: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1789: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1790: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1791: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1792: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1793: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1794: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1795: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1796: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1797: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1798: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1799: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1800: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1801: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1802: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1803: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1804: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1805: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1806: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1807: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1808: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1809: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1810: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1811: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1812: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1813: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1814: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1815: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) flipping leaderboardVisible sends ONLY leaderboardVisible
01:12 +1816: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) flipping leaderboardVisible sends ONLY leaderboardVisible
01:12 +1817: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1818: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1819: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1820: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1821: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1822: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1823: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1824: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1825: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1826: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: Message is the last coming-soon placeholder
01:12 +1827: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: Message is the last coming-soon placeholder
01:12 +1828: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1829: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1830: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1831: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1832: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1833: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1834: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1835: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1836: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:13 +1837: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track ENGLISH is the first segment — the frame's order
01:13 +1838: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) a failed save says so and does not move the switch
01:13 +1839: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) a failed save says so and does not move the switch
01:13 +1840: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:13 +1841: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:13 +1842: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
01:13 +1843: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
01:13 +1844: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
01:13 +1845: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1846: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1847: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1848: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1849: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1850: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1851: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1852: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1853: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1854: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1855: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1856: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1857: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1858: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:14 +1859: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:14 +1860: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:14 +1861: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:14 +1862: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:14 +1863: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:14 +1864: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:15 +1865: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:15 +1866: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:15 +1867: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:15 +1868: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:15 +1869: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:15 +1870: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:15 +1871: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:15 +1872: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:15 +1873: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:15 +1874: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:15 +1875: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:15 +1876: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:15 +1877: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: language pill · light
01:15 +1878: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data a shell fetches nothing
01:15 +1879: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data a shell fetches nothing
01:15 +1880: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track text scale 1.3 does not overflow in ar
01:15 +1881: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track text scale 1.3 does not overflow in ar
01:15 +1882: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track text scale 1.3 does not overflow in ar
01:15 +1883: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the Rank states nothing had pumped while a save is in flight, BOTH switches are disabled
01:15 +1884: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:15 +1885: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:15 +1886: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:15 +1887: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:15 +1888: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:15 +1889: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:16 +1890: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:16 +1891: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:16 +1892: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:16 +1893: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:16 +1894: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:16 +1895: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:16 +1896: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:16 +1897: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1898: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1899: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1900: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1901: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1902: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1903: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1904: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1905: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1906: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1907: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1908: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1909: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +1910: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +1911: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:17 +1912: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1913: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1914: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1915: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1916: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1917: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1918: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1919: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1920: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1921: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1922: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1923: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1924: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1925: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1926: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1927: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1928: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1929: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1930: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1931: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1932: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1933: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1934: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1935: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1936: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1937: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1938: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1939: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1940: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1941: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1942: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1943: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1944: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1945: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1946: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1947: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1948: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1949: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1950: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1951: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_support is structurally non-interactive
01:18 +1952: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: (setUpAll)
01:18 +1952: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:18 +1953: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:18 +1954: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1955: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1956: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1957: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1958: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1959: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1960: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_system is structurally non-interactive
01:18 +1961: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 3 selected
01:18 +1962: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: user-facing copy goes through AppLocalizations the count does not grow
01:18 +1963: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:18 +1964: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:19 +1965: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:19 +1966: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:19 +1967: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:19 +1968: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:19 +1969: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) tapping one changes nothing and sends nothing
01:19 +1970: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:19 +1971: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1972: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1973: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1974: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1975: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1976: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1977: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1978: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1979: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1980: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1981: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1982: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1983: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1984: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1985: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1986: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1987: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1988: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1989: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1990: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1991: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1992: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1993: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1994: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1995: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1996: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1997: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1998: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +1999: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +2000: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:19 +2001: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2002: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2003: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2004: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2005: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2006: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2007: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2008: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2009: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +2010: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2011: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2012: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2013: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2014: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2015: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2016: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2017: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2018: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2019: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2020: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2021: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2022: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2023: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2024: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2025: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2026: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2027: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2028: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2029: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2030: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2031: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2032: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2033: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2034: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2035: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2036: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +2037: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2038: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2039: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2040: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2041: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2042: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2043: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2044: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2045: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2046: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2047: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2048: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2049: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +2050: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark offline pins the banner and Rank still reads from cache
01:19 +2051: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: (tearDownAll)
01:19 +2051: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
01:19 +2052: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI runs the whole suite minus goldens, and the goldens by tag
01:19 +2053: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests every golden test file carries the golden tag
01:19 +2054: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth .flutter-version exists and is a plain version
01:20 +2055: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth CI reads the pin from the file rather than hardcoding it
01:20 +2056: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact the main manifest declares INTERNET
01:20 +2057: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact CI still inspects the built artefact, not just the source
01:20 +2058: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
01:20 +2059: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
01:20 +2060: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
01:20 +2061: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the coherence rule itself fires on each kind of bad command
01:20 +2062: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical both validate scripts exist
01:20 +2063: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical the pre-push hook reuses validate.sh instead of its own checks
01:20 +2064: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical PowerShell scripts are pure ASCII
01:20 +2065: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical every shell script that batches files is NUL-safe
01:20 +2066: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
01:20 +2067: All tests passed!
```

