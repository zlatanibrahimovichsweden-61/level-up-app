# Validation run - 2026-09-22T15:34:18Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 286 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 1429 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-09-22T15:34:18Z - finished 2026-09-22T15:36:30Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-22T15:34:18Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : e683e8d
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 84fc5cbb22 (10 weeks ago) • 2026-07-17 10:20:17 -0700
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
checking 286 hand-written Dart files

Formatted 60 files (0 changed) in 0.41 seconds.
Formatted 60 files (0 changed) in 0.42 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 60 files (0 changed) in 0.53 seconds.
Formatted 46 files (0 changed) in 0.43 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 16.2s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**1429 passed, 0 failed, 0 skipped** (exit 0)


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
00:01 +7: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: (setUpAll)
00:01 +7: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion recognises the code
00:01 +8: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion does not confuse it with the OTHER 403 the same routes answer
00:01 +9: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion ignores transport failures and non-API errors
00:01 +10: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion matches on the code, so a subclass is recognised too
00:01 +11: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz — all four quiz endpoints share one helper
00:01 +12: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz — the existing codes are untouched
00:01 +13: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile — PATCH /me is NOT on the allowlist, only GET /me is
00:01 +14: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile — offline still outranks it, and validation still works
00:01 +15: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for a pending deletion
00:01 +16: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry leaves every other failure retryable
00:01 +17: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry is not the same question as opensLimitSheet
00:01 +18: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: the copy itself exists in both locales and is not the generic message
00:01 +19: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: the copy itself is purchase-silent (adr-049 §3)
00:01 +20: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: (tearDownAll)
00:07 +20: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required → refresh once → original retried → success
00:07 +21: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:07 +22: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:07 +23: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:07 +24: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:07 +25: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
00:08 +26: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException carries the ProblemDetails field map
00:08 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException is still an ApiException (existing handlers keep working)
00:08 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a missing/malformed errors map yields empty fields, not a crash
00:08 +29: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a non-list value is tolerated as a single message
00:08 +30: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:08 +31: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 → UnauthorizedException carrying the code
00:08 +32: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 → ApiException carrying status + code
00:08 +33: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error → NetworkException (drives Offline)
00:08 +34: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException is typed, and is NOT otp_throttled
00:08 +35: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a delta-seconds Retry-After parses
00:08 +36: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an ABSENT header yields null — and does not throw
00:08 +37: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a GARBAGE header yields null — and does not throw
00:08 +38: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:08 +39: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:08 +40: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:08 +41: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:08 +42: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:08 +43: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:08 +44: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:08 +45: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:08 +46: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:08 +47: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:08 +48: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:08 +49: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:08 +50: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:08 +51: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:08 +52: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:09 +53: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:09 +54: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:09 +55: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:11 +56: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:11 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:11 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:11 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:11 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:11 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:11 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:11 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:11 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:11 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:12 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:12 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:13 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +84: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +85: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +86: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +87: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +88: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +89: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +90: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +91: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +92: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +93: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +94: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:14 +95: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +96: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +97: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +98: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +99: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +100: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +101: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +102: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +103: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +104: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +105: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +106: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +107: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +108: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:15 +109: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion kFigmaBlurToSigma is the CSS definition, not a tunable
00:15 +110: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion sigma is NOT what BoxShadow would have produced
00:15 +111: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion frost converts with its own constant
00:15 +112: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration nav bar: the two canvases differ in colour AND blur
00:15 +113: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the three CTA tokens
00:15 +114: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration back chip: light shadow, dark Glass — not a missing shadow
00:15 +115: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the registration back chip is a different Glass from G5
00:15 +116: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration language pill: G3 differs from G5 only in lightIntensity
00:15 +117: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration form fields: G4, and the 0.03 hairline kept verbatim
00:15 +118: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration onboarding sheet: the only Glass in the light frames
00:15 +119: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration scrims: five frames, five readings
00:15 +120: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes level card: light shadow, dark Glass plus a back-light
00:15 +121: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes daily tasks: G7, and two differently sized back-lights
00:15 +122: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes top student: same border width on both canvases
00:15 +123: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes continue learning: two shadows, one with a negative spread
00:15 +124: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subjects search: the file's only 10% shadows
00:15 +125: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subject card: identical on both canvases — this is #34's proof
00:15 +126: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes mistakes pill and card
00:15 +127: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes the segmented pill track inverts its inner shadow when selected
00:15 +128: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the five near-identical small shadows stay five tokens
00:15 +129: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard length chips, AI panel and leaderboard list keep dark shadows
00:15 +130: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard AI panel: G18 outside, G5 inside, one back-light
00:15 +131: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard quiz previous button: G13 confirms the angle convention
00:15 +132: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard result buckets, rewards card and star disc
00:15 +133: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the scope toggle is the file's only white inner shadow
00:15 +134: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard a leaderboard row carries two different Glass effects
00:15 +135: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card profile header, edit chip and stat card keep a dark shadow
00:15 +136: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card avatar badge
00:15 +137: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card settings sections and their two back-lights
00:15 +138: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:15 +139: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card the two track cards carry two different Glass angles
00:15 +140: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:15 +141: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:15 +142: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:15 +143: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism the onboarding sheet is the ONLY light Glass
00:15 +144: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every dark surface that Figma glassed has a token
00:15 +145: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every back-light is dark-only and takes the palette colour
00:15 +146: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places props covers every field
00:15 +147: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places copyWith round-trips, and leaves the others alone
00:15 +148: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp endpoints are exact
00:15 +149: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp actually moves, and snaps what cannot be interpolated
00:15 +150: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp ignores a foreign extension, as ThemeExtension requires
00:15 +151: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places equality is by value, not by identity
00:15 +152: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places both ThemeData objects carry it
00:15 +153: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:16 +154: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:16 +155: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:17 +156: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:17 +157: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:17 +158: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:17 +159: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:17 +160: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:17 +161: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:17 +162: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:19 +163: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:19 +164: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a BackdropFilter exists only when sigma > 0
00:19 +165: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:19 +166: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:19 +167: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +168: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +169: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +170: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +171: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +172: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +173: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:19 +174: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +175: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +176: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +177: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +178: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +179: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +180: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +181: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:20 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:21 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:21 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses circle
00:21 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:21 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:21 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:21 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:21 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:22 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:22 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:22 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:22 +209: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow no glow is painted at all
00:22 +210: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the outline tone uses its own token
00:22 +211: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: dark — the same shadow, plus a glow on the primary tone only primary paints shadow AND glow
00:23 +212: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: dark — the same shadow, plus a glow on the primary tone only destructive has the shadow but NO glow
00:23 +213: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: dark — the same shadow, plus a glow on the primary tone only outline has the shadow but NO glow
00:23 +214: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: disabled every alpha is multiplied by 0.45
00:23 +215: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: disabled enabled is the default
00:23 +216: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: the wrapped button is untouched a FilledButton keeps its ink and its semantics
00:23 +217: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:23 +218: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:23 +219: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:23 +220: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:23 +221: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:24 +222: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +223: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +224: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +225: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +226: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +227: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +228: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:24 +229: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +230: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +231: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +232: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +233: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +234: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +235: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +236: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +237: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +238: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +239: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +240: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +241: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +242: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:25 +243: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead labels that do NOT fit widen the groove past the viewport
00:25 +244: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the registration variant is a DIFFERENT chip
00:25 +245: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the registration variant is a DIFFERENT chip
00:25 +246: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the registration variant is a DIFFERENT chip
00:25 +247: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the standard variant takes the standard tokens
00:25 +248: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the registration variant is a DIFFERENT chip
00:25 +249: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark elevates with Glass and NO shadow — a reading, not a gap
00:25 +250: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the two dark variants really are different values
00:25 +251: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:25 +252: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:25 +253: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:25 +254: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light draws the 1.17338 hairline and no Glass
00:25 +255: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light draws the 1.17338 hairline and no Glass
00:25 +256: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:26 +257: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:26 +258: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:26 +259: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell disabled dims the whole field and kills the tap
00:26 +260: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:26 +261: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:26 +262: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill dark has NO border at all, and Glass instead
00:26 +263: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:26 +264: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:26 +265: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:26 +266: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable — the 159:1852 variant
00:26 +267: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:26 +268: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:26 +269: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:26 +270: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:26 +271: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:26 +272: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:26 +273: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:26 +274: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:26 +275: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:26 +276: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent — a repeat call replays the same summary
00:26 +277: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me — what invalidating the profile shows
00:26 +278: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered — expected, not a bug
00:26 +279: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:26 +280: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:26 +281: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:26 +282: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:26 +283: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:26 +284: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:26 +285: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:26 +286: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:26 +287: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:26 +288: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:26 +289: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:26 +290: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:26 +291: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:26 +292: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:26 +293: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:26 +294: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:26 +295: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:26 +296: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:26 +297: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:27 +298: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:27 +299: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:27 +300: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:27 +301: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:27 +302: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:27 +303: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:27 +304: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:27 +305: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:27 +306: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:27 +307: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:28 +308: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +309: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +310: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +311: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +312: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +313: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +314: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +315: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +316: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:30 +317: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:30 +318: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:30 +319: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:30 +320: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:31 +321: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +322: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +323: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +324: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +325: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +326: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +327: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +328: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +329: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +330: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +331: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +332: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +333: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +334: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +335: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +336: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +337: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +338: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +339: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +340: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +341: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +342: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +343: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +344: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +345: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +346: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +347: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:31 +348: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:31 +349: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:32 +350: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard — it starts the same phone → OTP flow
00:32 +351: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill dark: a pale grey bevel in the TOP-RIGHT corner instead
00:32 +352: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:32 +353: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:32 +354: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:32 +355: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +356: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +357: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +358: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +359: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +360: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +361: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +362: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +363: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +364: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +365: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +366: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +367: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +367: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:32 +368: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +369: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +370: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +371: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +372: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +373: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +374: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +375: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:32 +376: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +377: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +378: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +379: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +380: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +381: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +382: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +383: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +384: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +385: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +386: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +387: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +388: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +389: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +390: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +391: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +392: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +393: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:33 +393: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:33 +394: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:34 +395: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:34 +396: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:35 +397: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:35 +398: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:35 +399: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:35 +400: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +401: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +402: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +403: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +404: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +405: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +406: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +407: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +408: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +409: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +410: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +411: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +412: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +413: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +414: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +415: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +416: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +417: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +418: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +419: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +420: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +421: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +422: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +423: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +424: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:36 +425: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:37 +426: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:37 +427: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +428: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:37 +429: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a school tree renders Units from the SAME route
00:37 +430: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded each card shows its own server counter
00:37 +431: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded each card shows its own server counter
00:37 +432: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:37 +433: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +434: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +435: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +436: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +437: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +438: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +439: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +440: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +441: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:38 +442: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:38 +443: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:38 +444: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:38 +445: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:38 +446: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +447: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +448: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +449: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +450: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +451: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +452: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +453: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +454: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +455: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +456: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +457: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +458: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +459: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +460: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +461: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +462: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +463: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:39 +464: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +465: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +466: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +467: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +468: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +469: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +470: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:39 +471: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +472: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +473: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +474: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +475: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +476: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +477: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:40 +478: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:40 +479: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:40 +480: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:40 +481: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:40 +482: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:41 +483: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:41 +484: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:41 +485: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:41 +486: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the tree shows a row skeleton while it loads
00:41 +487: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the tree shows a row skeleton while it loads
00:41 +488: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the tree shows a row skeleton while it loads
00:41 +489: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the tree shows a row skeleton while it loads
00:41 +490: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes Arabic renders RTL with Arabic copy
00:41 +491: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes Arabic renders RTL with Arabic copy
00:41 +492: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes Arabic renders RTL with Arabic copy
00:41 +493: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +494: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +495: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +496: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +497: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +498: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +499: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +500: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +501: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +502: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +503: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +504: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +505: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +506: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +507: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs no quiz types at all → no tab row, and the list still renders
00:41 +508: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +509: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +510: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:41 +511: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes the counter is localized in Arabic
00:41 +512: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes the counter is localized in Arabic
00:41 +513: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +514: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +515: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +516: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +517: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +518: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +519: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +520: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +521: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:41 +522: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: university (Figma 125:2373) adds Learning Tools, stubbed like every other section
00:41 +523: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: LeaderboardRow · 134:3538 light / 337:5630 dark an ordinary dark row is a 20% wash carrying Glass
00:42 +524: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:42 +525: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:42 +526: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:42 +527: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:42 +528: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:42 +529: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub — the snackbar is gone
00:42 +530: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:42 +531: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
00:42 +532: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +533: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +534: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +535: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +536: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +537: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +538: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +539: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +540: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +541: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +542: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +543: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +544: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +545: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +546: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +547: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +548: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +549: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +550: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +551: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +552: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +553: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +554: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +555: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +556: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +557: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +558: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:42 +559: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +560: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +561: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +562: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +563: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:43 +564: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:44 +565: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:44 +566: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:44 +567: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +568: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +569: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +570: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +571: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +572: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +573: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:45 +574: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +575: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +576: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +577: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +578: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +579: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +580: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +581: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +582: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +583: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +584: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +585: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:46 +586: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +587: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +588: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +589: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +590: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +591: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +592: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +593: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +594: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +595: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +596: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +597: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +598: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:46 +599: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +600: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +601: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +602: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +603: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +604: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +605: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +606: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +607: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +608: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +609: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +610: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +611: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +612: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +613: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +614: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +615: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +616: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +617: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:47 +618: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +619: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:47 +620: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +621: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +622: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +623: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +624: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +625: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +626: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +627: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +628: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +629: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +630: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +631: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +632: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +633: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +634: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +635: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +636: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +637: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +638: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +639: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +640: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +641: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +642: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +643: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +644: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +645: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +646: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:48 +647: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +648: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +649: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +650: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +651: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +652: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +653: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +654: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +655: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:48 +656: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:48 +657: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:48 +658: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
00:48 +659: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:48 +660: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:48 +661: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:49 +662: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:49 +663: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) no label is scaled AT ALL — D-012
00:49 +664: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:49 +665: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:49 +666: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:49 +667: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:49 +668: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows EVERY tone draws the 35 dp disc — the refuted reading
00:49 +669: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +670: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +671: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +672: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +673: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +674: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +675: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +676: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +677: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +678: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +679: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +680: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +681: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +682: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +683: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:49 +684: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included — #81
00:49 +685: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included — #81
00:50 +686: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:50 +687: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:50 +688: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows at text scale 1.3 the hub does not overflow in en
00:50 +689: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:50 +690: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:50 +691: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:51 +692: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +693: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +694: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +695: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +696: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +697: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +698: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +699: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +700: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +701: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +702: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +703: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +704: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +705: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +706: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +707: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +708: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:51 +709: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +710: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +711: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +712: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +713: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +714: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +715: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +716: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:52 +717: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +718: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +719: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +720: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +721: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +722: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +723: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +724: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +725: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +726: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +727: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +728: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +729: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +730: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +731: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +732: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +733: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +734: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +735: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +736: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +737: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +738: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +739: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +740: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +741: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +742: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +743: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +744: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +745: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +746: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +747: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +748: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +749: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +750: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +751: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +752: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +753: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +754: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +755: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +756: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +757: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +758: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +759: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +760: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +761: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +762: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +763: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +764: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:53 +765: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +766: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +767: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +768: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +769: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +770: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +771: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +772: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +773: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +774: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +775: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +776: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +777: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +778: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +779: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +780: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +781: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +782: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +783: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +784: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +785: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +786: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +787: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +788: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +789: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +790: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +791: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +792: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +793: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +794: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +795: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +796: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +797: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +798: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +799: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +800: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +801: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +802: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +803: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +804: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +805: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +806: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +807: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +808: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +809: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +810: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +811: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +812: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +813: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +814: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +815: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +816: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +817: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +818: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +819: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +820: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +821: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +822: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +823: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +824: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +825: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +826: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +827: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +828: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +829: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:54 +830: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
00:54 +831: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
00:54 +832: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent a failed load offers a Retry
00:54 +833: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent a failed load offers a Retry
00:55 +834: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent a failed load offers a Retry
00:55 +835: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +836: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +837: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +838: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +839: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:55 +840: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +841: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +842: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +843: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +844: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +845: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +846: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +847: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +848: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +849: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +850: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +851: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +852: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +853: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +854: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +855: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +856: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +857: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +858: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +859: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +860: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +861: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +862: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +863: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +864: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +865: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +866: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +867: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +868: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +869: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +870: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +871: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +872: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +873: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +874: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +875: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +876: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +877: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +878: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +879: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +880: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +881: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +882: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +883: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +884: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +885: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +886: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +887: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +888: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back the subject line is absent — QuizSummary carries no scope
00:59 +889: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back the subject line is absent — QuizSummary carries no scope
00:59 +890: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back the subject line is absent — QuizSummary carries no scope
00:59 +891: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states a quiz finished with ZERO answers is all skipped
00:59 +892: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
00:59 +893: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
00:59 +894: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
00:59 +895: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
00:59 +896: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders NO favourite or share control
00:59 +897: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
00:59 +898: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
00:59 +899: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +900: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +901: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +902: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +903: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +904: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +905: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +906: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +907: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +908: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +909: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +910: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +911: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:59 +912: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +913: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +914: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +915: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +916: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +917: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +918: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +919: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +920: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +921: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
01:00 +922: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
01:00 +923: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +924: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +925: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +926: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +927: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +928: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +929: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +930: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:00 +931: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:00 +932: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save offline shows the offline line, not a generic error
01:01 +933: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +934: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +935: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +936: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +937: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +938: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
01:01 +939: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:01 +940: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:01 +941: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:01 +942: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
01:01 +943: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
01:01 +944: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +945: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +946: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +947: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +948: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +949: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +950: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +951: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +952: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +953: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +954: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +955: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +956: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +957: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +958: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +959: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:01 +960: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +961: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +962: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +963: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +964: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +965: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +966: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +967: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +968: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +969: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +970: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +971: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +972: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +973: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +974: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:01 +975: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +976: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +977: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +978: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +979: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +980: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +981: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +982: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +983: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +984: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +985: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +986: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +987: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +988: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +989: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +990: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:02 +991: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:02 +992: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:02 +993: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
01:02 +994: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:02 +995: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:02 +996: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:02 +997: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix leveledUp and newBadge parse but celebrate nothing
01:02 +998: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +999: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1000: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1001: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1002: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1003: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1004: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1005: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1006: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1007: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1008: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1009: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1010: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1011: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1012: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1013: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1014: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1015: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1016: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1017: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1018: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1019: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1020: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1021: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1022: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1023: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1024: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:02 +1025: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
01:02 +1026: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
01:02 +1027: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes AR lays out RTL with Arabic labels
01:02 +1028: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes AR lays out RTL with Arabic labels
01:02 +1029: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1030: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1031: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1032: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1033: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1034: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1035: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1036: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1037: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1038: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1039: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:02 +1040: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1041: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1042: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1043: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
01:03 +1044: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
01:03 +1045: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: locales and themes dark renders the same form on the dark canvas
01:03 +1046: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
01:03 +1047: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
01:03 +1048: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
01:03 +1049: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
01:03 +1050: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
01:03 +1051: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
01:03 +1052: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the review path consumes nothing and persists nothing calls no endpoint
01:03 +1053: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:03 +1054: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:03 +1055: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:03 +1056: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:04 +1057: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:04 +1058: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:04 +1059: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:04 +1060: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:04 +1061: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1062: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1063: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1064: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1065: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1066: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1067: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1068: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1069: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1070: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1071: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1072: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1073: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1074: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1075: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1076: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1077: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1078: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1079: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1080: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1081: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1082: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1083: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1084: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1085: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1086: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1087: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1088: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1089: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1090: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1091: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1092: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1093: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1094: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:05 +1095: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1096: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1097: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1098: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1099: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1100: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1101: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1102: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1103: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1104: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1105: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1106: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1107: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1108: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:06 +1109: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:07 +1110: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:07 +1111: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:07 +1112: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:07 +1113: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:07 +1114: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:07 +1115: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:08 +1116: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1117: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1118: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1119: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1120: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1121: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1122: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1123: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:08 +1124: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:09 +1125: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:09 +1126: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:09 +1127: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:09 +1128: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1129: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1130: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1131: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1132: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1133: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1134: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1135: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1136: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1137: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:09 +1138: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1139: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1140: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1141: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1142: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1143: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1144: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1145: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1146: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1147: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1148: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1149: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1150: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1151: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1152: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1153: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1154: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1155: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1156: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1157: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1158: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:10 +1159: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1160: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1161: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1162: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1163: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1164: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1165: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1166: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1167: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1168: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1169: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:11 +1170: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1171: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1172: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:11 +1173: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1174: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1175: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1176: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1177: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1178: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1179: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1180: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:12 +1181: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1182: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1183: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1184: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1185: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1186: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:12 +1187: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1188: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1189: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1190: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1191: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1192: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1193: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1194: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1195: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1196: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:13 +1197: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1198: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1199: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1200: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1201: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1202: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1203: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1204: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1205: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:13 +1206: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1207: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1208: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1209: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1210: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1211: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1212: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1213: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1214: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1215: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1216: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1217: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1218: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1219: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1220: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1221: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1222: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1223: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1224: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:14 +1225: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1226: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1227: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1228: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1229: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:15 +1230: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:15 +1231: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:15 +1232: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:15 +1233: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:15 +1234: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:15 +1235: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:15 +1236: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1237: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1238: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1239: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1240: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1241: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1242: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1243: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1244: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1245: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1246: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1247: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1248: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:15 +1249: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:15 +1250: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:15 +1251: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:15 +1252: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:15 +1253: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:16 +1254: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:16 +1255: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:16 +1256: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:16 +1257: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:16 +1258: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:16 +1259: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track tapping a segment still switches the locale
01:16 +1260: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track tapping a segment still switches the locale
01:16 +1261: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:16 +1262: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:16 +1263: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:16 +1264: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:16 +1265: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:17 +1266: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:17 +1267: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:17 +1268: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:17 +1269: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:17 +1270: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:17 +1271: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch both names are written in their own language, in both locales
01:17 +1272: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch both names are written in their own language, in both locales
01:17 +1273: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:17 +1274: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:17 +1275: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:17 +1276: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored dark canvas is already painted, not flipped into
01:17 +1277: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored dark canvas is already painted, not flipped into
01:17 +1278: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable an Egyptian student can submit having skipped it
01:18 +1279: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable an Egyptian student can submit having skipped it
01:18 +1280: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:18 +1281: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:18 +1282: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:18 +1283: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:18 +1284: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:19 +1285: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:19 +1286: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:19 +1287: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:19 +1288: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:19 +1289: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:19 +1290: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:19 +1291: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:19 +1292: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:19 +1293: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:19 +1294: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:20 +1295: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:20 +1296: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:20 +1297: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:20 +1298: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1299: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1300: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1301: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1302: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1303: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1304: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1305: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1306: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1307: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1308: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1309: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1310: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1311: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1312: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:20 +1313: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1314: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1315: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1316: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1317: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1318: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1319: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1320: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1321: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:21 +1322: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:21 +1323: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:21 +1324: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:21 +1325: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1326: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1327: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1328: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1329: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1330: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1331: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1332: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1333: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1334: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1335: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1336: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1337: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1338: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1339: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1340: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1341: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1342: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1343: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1344: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1345: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1346: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1347: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1348: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1349: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1350: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1351: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1352: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1353: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1354: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1355: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1356: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1357: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1358: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1359: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1360: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:21 +1361: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1362: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1363: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1364: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1365: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1366: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1367: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1368: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1369: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1370: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1371: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1372: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1373: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1374: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1375: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1376: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1377: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1378: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1379: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1380: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1381: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1382: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1383: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1384: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1385: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1386: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1387: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1388: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1389: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1390: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1391: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1392: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1393: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1394: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1395: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1396: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1397: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1398: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1399: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1400: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1401: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1402: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1403: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1404: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:22 +1405: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:22 +1406: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:22 +1407: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 3 selected
01:22 +1408: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
01:22 +1409: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1410: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1411: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1412: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1413: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1414: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1415: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:22 +1416: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:22 +1417: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:22 +1418: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:22 +1419: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:22 +1420: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:22 +1421: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:23 +1422: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:23 +1423: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:23 +1424: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:23 +1425: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical the pre-push hook reuses validate.sh instead of its own checks
01:23 +1426: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical PowerShell scripts are pure ASCII
01:23 +1427: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical every shell script that batches files is NUL-safe
01:23 +1428: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
01:23 +1429: All tests passed!
```

