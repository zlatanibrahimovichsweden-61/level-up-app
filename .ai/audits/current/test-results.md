# Validation run - 2026-09-30T11:48:17Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 304 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 2036 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-09-30T11:48:17Z - finished 2026-09-30T11:50:43Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-30T11:48:17Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : cccd2f1
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
  cached_network_image 3.4.1 (4.0.2 available)
  cached_network_image_platform_interface 4.1.1 (5.0.2 available)
  cached_network_image_web 1.3.1 (2.0.2 available)
  cli_util 0.4.2 (0.6.0 available)
  clock 1.1.2 (1.1.3 available)
  code_assets 1.2.1 (2.1.0 available)
  code_builder 4.11.1 (4.12.0 available)
  connectivity_plus 7.3.0 (7.3.1 available)
  cupertino_icons 1.0.9 (2.0.0 available)
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
  go_router 17.3.0 (18.0.2 available)
  hooks 2.0.2 (2.2.0 available)
  intl 0.20.2 (0.20.3 available)
  io 1.0.5 (1.1.0 available)
  jni 1.0.0 (1.0.3 available)
  jni_flutter 1.0.1 (1.0.3 available)
  jovial_svg 1.1.29 (1.1.31 available)
  json_serializable 6.14.0 (6.14.1 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.0 (1.19.0 available)
  mime 2.0.0 (2.1.0 available)
  mockito 5.6.4 (5.8.1 available)
  nm 0.5.0 (0.6.0 available)
  objective_c 9.4.1 (9.6.0 available)
  octo_image 2.1.0 (2.1.1 available)
  package_config 2.2.0 (3.0.0 available)
  petitparser 7.0.2 (7.1.0 available)
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
  xml 6.6.1 (7.1.0 available)
  yaml 3.1.3 (3.1.4 available)
Got dependencies!
85 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 304 hand-written Dart files

Formatted 60 files (0 changed) in 0.49 seconds.
Formatted 60 files (0 changed) in 0.38 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 60 files (0 changed) in 0.54 seconds.
Formatted 60 files (0 changed) in 0.60 seconds.
Formatted 4 files (0 changed) in 0.05 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 35.4s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**2036 passed, 0 failed, 0 skipped** (exit 0)


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
00:00 +25: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:00 +26: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
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
00:01 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:01 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:01 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:01 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on /login/otp → stay (the success view shows)
00:01 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:01 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:01 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:01 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:01 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:01 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:01 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
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
00:02 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:02 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +84: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +85: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +86: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +87: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +88: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +89: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +90: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +91: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +92: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +93: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +94: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +95: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +96: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +97: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +98: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +99: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +100: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +101: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +102: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +103: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +104: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +105: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +106: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +107: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +108: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +109: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +110: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +111: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +112: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +113: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +114: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +115: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +116: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +117: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +118: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +119: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +120: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +121: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +122: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +123: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +124: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +125: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +126: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +127: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +128: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +129: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +130: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +131: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +132: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +133: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +134: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +135: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +136: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +137: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +138: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +139: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +140: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +141: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +142: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +143: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +144: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +145: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +146: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +147: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +148: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +149: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +150: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +151: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +152: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +153: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +154: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +155: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +156: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +157: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +158: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +159: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +160: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +161: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +162: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +163: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +164: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +165: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +166: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +167: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +168: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +169: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +170: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places both ThemeData objects carry it
00:03 +171: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:03 +172: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:03 +173: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:03 +174: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:04 +175: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:04 +176: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:04 +177: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:04 +178: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:04 +179: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:04 +180: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: a text takes its first strong character's direction, else the app's
00:04 +181: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: it is the quiz question's rule, exactly
00:04 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:05 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:05 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:05 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:05 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:05 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:05 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:05 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:05 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:05 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:05 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:05 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:05 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:05 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:05 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:05 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:05 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:05 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:05 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:05 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:05 +209: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:05 +210: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink no onTap means no InkWell at all
00:05 +211: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 lightIntensity scales it linearly
00:05 +212: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 lightIntensity scales it linearly
00:05 +213: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog barrierDismissible false keeps it open
00:05 +214: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog barrierDismissible false keeps it open
00:05 +215: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog barrierDismissible false keeps it open
00:05 +216: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog barrierDismissible false keeps it open
00:05 +217: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: back-lights a back-light without Glass trips the debug assert
00:05 +218: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog system back still pops it, and returns its value
00:06 +219: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog system back still pops it, and returns its value
00:06 +220: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +221: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +222: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +223: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +224: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +225: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +226: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +227: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +228: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:06 +229: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +230: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +231: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +232: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +233: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +234: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +235: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:06 +236: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:07 +237: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:07 +238: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:07 +239: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:07 +240: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:07 +241: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:07 +242: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +243: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +244: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +245: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +246: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +247: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +248: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +249: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +250: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +251: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +252: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +253: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +254: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +255: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +256: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +257: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:07 +258: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +259: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +260: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +261: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +262: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +263: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +264: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +265: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +266: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +267: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +268: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +269: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +270: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +271: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +272: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +273: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +274: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +275: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +276: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +277: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:07 +278: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:08 +279: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:08 +280: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:08 +281: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:08 +282: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:08 +283: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:08 +284: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:08 +285: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation every cause answers with ONE byte-identical body that names no id
00:08 +286: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +287: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +288: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +289: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +290: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +291: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +292: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +293: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +294: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +295: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +296: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +297: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +298: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +299: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +300: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +301: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +302: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:08 +303: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:08 +304: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:08 +305: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:08 +306: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:08 +307: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:08 +308: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:08 +309: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:08 +310: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:08 +311: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:08 +312: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:08 +313: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:08 +314: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:08 +315: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:08 +316: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:08 +317: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:08 +318: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:08 +319: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:08 +320: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: fixtures the deck exercises what the study surface must render
00:08 +321: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:08 +322: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:08 +323: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:08 +324: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:08 +325: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:08 +326: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:08 +327: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me a new name is in the answer and in the next GET /me
00:08 +328: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:08 +329: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:08 +330: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:08 +331: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:08 +332: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:08 +333: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me a malformed e-mail is 400 validation_failed on `email`
00:08 +334: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:08 +335: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:08 +336: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:08 +337: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader dark: the FILL is whatever the screen passes; the track and counter are shared
00:08 +338: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:08 +339: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:08 +340: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:08 +341: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader Arabic mirrors the ✕: 16 from the right edge
00:08 +342: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:08 +343: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:08 +344: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:08 +345: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:08 +346: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable — the 159:1852 variant
00:08 +347: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:08 +348: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:08 +349: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:08 +350: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:08 +351: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:08 +352: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:08 +353: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:08 +354: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:08 +355: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:08 +356: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:08 +357: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:08 +358: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:08 +359: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:08 +360: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:08 +361: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:08 +362: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:08 +363: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:08 +364: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:08 +365: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:09 +366: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:09 +367: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:09 +368: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:09 +369: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:09 +370: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:09 +371: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:09 +372: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:09 +373: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:09 +374: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:09 +375: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:09 +376: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:09 +377: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:09 +378: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:09 +379: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:09 +380: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:09 +381: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:09 +382: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:09 +383: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:09 +384: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:09 +385: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:09 +386: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:09 +387: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:09 +388: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:09 +389: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:09 +390: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:09 +391: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:10 +392: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:11 +393: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:11 +394: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:11 +395: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:12 +396: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:12 +397: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:12 +398: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:12 +399: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:12 +400: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:12 +401: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:12 +402: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:12 +403: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +404: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +405: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +406: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +407: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +408: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +409: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:12 +410: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +411: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +412: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +413: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +414: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +414: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:13 +415: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +416: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +417: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +418: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +419: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +420: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +421: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +422: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +423: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +424: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +425: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +426: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +427: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +428: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +429: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +430: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +431: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +432: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +433: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +434: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +435: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +436: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:13 +437: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +438: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +438: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:14 +439: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +440: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +441: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +442: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +443: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +444: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +445: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +446: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +447: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:14 +448: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:15 +449: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
unhandled element <filter/>; Picture key: Svg loader
00:15 +450: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:15 +451: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +452: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +453: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +454: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +455: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +456: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +457: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +458: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +459: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +460: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +461: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +462: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +463: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +464: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +465: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +466: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +467: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +468: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:15 +469: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +470: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +471: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +472: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +473: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +474: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +475: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +476: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +477: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +478: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +479: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +480: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +481: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +482: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +483: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:16 +484: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +485: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +486: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +487: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +488: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +489: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +490: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +491: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +492: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +493: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +494: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:16 +495: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:17 +496: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:17 +497: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:17 +498: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:18 +499: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:18 +500: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:18 +501: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:18 +502: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:18 +503: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +504: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +505: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +506: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +507: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +508: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +509: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:19 +510: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +511: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +512: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:20 +513: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:20 +514: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:20 +515: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:20 +516: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:20 +517: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:21 +518: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:21 +519: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:21 +520: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:21 +521: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:21 +522: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:21 +523: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:21 +524: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +525: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +526: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +527: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +528: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +529: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +530: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +531: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +532: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:22 +533: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +534: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +535: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +536: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +537: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +538: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +539: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +540: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +541: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +542: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +543: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +544: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +545: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +546: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +547: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +548: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +549: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +550: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +551: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +552: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +553: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +554: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +555: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +556: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +557: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +558: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +559: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +560: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +561: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +562: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +563: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +564: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:23 +565: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:24 +566: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:24 +567: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +568: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +569: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +570: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +571: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +572: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +573: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +574: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +575: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +576: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +577: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
00:24 +578: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
00:24 +579: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +580: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +581: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +582: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +583: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +584: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +585: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +586: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +587: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +588: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +589: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +590: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
00:24 +591: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:25 +592: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:25 +593: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:25 +594: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:25 +595: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +596: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +597: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +598: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:25 +599: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
00:25 +600: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +601: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +602: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +603: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +604: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +605: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +606: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:25 +607: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +608: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:26 +609: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
00:26 +610: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab the default selection is unchanged — Normal, with every lecture and its bar
00:26 +611: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces flipped shows the answer and not the question
00:26 +612: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
00:26 +613: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
00:26 +614: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
00:26 +615: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
00:26 +616: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
00:26 +617: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
00:26 +618: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
00:26 +619: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
00:26 +620: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption — the contract has no flashcard progress
00:26 +621: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption — the contract has no flashcard progress
00:26 +622: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption — the contract has no flashcard progress
00:26 +623: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption — the contract has no flashcard progress
00:26 +624: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:26 +625: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:26 +626: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:26 +627: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
00:26 +628: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
00:26 +629: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
00:26 +630: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
00:26 +631: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
00:26 +632: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states offline gets its own view, distinct from a generic error
00:27 +633: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: the flip it turns over 300 ms, ease-out, and is at rest after
00:27 +634: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +635: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +636: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +637: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +638: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +639: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +640: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +641: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +642: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +643: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +644: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +645: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +646: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +647: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +648: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +649: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +650: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +651: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +652: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +653: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +654: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +655: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +656: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +657: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:27 +658: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +659: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +660: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +661: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +662: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +663: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +664: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +665: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +666: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +667: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +668: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +669: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +670: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +671: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +672: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +673: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +674: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +675: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +676: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +677: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +678: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +679: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +680: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +681: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +682: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +683: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +684: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +685: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +686: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +687: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +688: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +689: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +690: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +691: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +692: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +693: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +694: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +695: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +696: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +697: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +698: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +699: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +700: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +701: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:28 +702: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:29 +703: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:29 +704: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:29 +705: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:29 +706: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:29 +707: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a short round reads 1/4: the total is what was delivered
00:29 +708: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a short round reads 1/4: the total is what was delivered
00:29 +709: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:29 +710: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:29 +711: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:29 +712: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: the pill is text, not a control tapping the pill goes nowhere and asks for nothing
00:29 +713: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header the header is the shared one: 89.18 tall, ✕ 16 in
00:29 +714: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:29 +715: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:29 +716: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:29 +717: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header AR: the title sits on the screen centre
00:29 +718: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start a second tap during the transition does not stack a second study screen
00:30 +719: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start a second tap during the transition does not stack a second study screen
00:30 +720: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:30 +721: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:30 +722: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
00:30 +723: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start Start can be used again after the student comes back
00:30 +724: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +725: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +726: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +727: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +728: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +729: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +730: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +731: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +732: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +733: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +734: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +735: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +736: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +737: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:31 +738: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +739: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +740: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +741: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +742: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +743: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +744: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +745: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +746: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +747: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +748: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +749: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +750: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +751: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +752: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +753: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +754: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +755: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +756: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +757: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +758: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +759: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +760: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +761: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +762: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +763: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +764: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +765: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +766: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +767: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +768: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +769: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +770: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +771: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +772: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +773: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +774: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +775: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +776: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +777: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +778: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +779: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +780: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +781: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +782: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +783: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +784: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +785: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +786: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +787: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +788: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +789: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +790: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +791: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +792: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +793: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +794: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +795: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +796: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +797: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +798: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +799: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +800: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +801: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +802: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +803: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +804: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +805: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:33 +806: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +807: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +808: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +809: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +810: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +811: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +812: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +813: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +814: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +815: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +816: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +817: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.0: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +818: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.0: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +819: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.0: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +820: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.0: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +821: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.0: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +822: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:33 +823: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:33 +824: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:33 +825: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:33 +826: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading insufficient_scope on Got it: its copy stays and BOTH grade buttons are off for that card
00:33 +827: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading insufficient_scope on Got it: its copy stays and BOTH grade buttons are off for that card
00:33 +828: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading insufficient_scope on Got it: its copy stays and BOTH grade buttons are off for that card
00:33 +829: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading insufficient_scope on Got it: its copy stays and BOTH grade buttons are off for that card
00:33 +830: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading insufficient_scope on Got it: its copy stays and BOTH grade buttons are off for that card
00:33 +831: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.3: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +832: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.3: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +833: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.3: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +834: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) ar at text scale 1.3: five tabs (four quiz types + Flashcard) stay equal, and every label keeps its full size
00:33 +835: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +836: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +837: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
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
00:34 +853: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +854: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +855: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +856: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +857: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
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
00:34 +871: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +872: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +873: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +874: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +875: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +876: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +877: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +878: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +879: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +880: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +881: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +882: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +883: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +884: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +885: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +886: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included — #81
00:34 +887: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included — #81
00:34 +888: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included — #81
00:34 +889: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +890: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +891: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +892: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +893: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +894: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +895: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +896: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +897: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +898: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +899: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +900: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +901: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +902: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
00:34 +903: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the setup path builds Setup with the nav bar
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
00:36 +921: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +922: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +923: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +924: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +925: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +926: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +927: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +928: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +929: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +930: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +931: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +932: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +933: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +934: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +935: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +936: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +937: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +938: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark · each place has its own badge colours
00:36 +939: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark · each place has its own badge colours
00:36 +940: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark · each place has its own badge colours
00:36 +941: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark · each place has its own badge colours
00:36 +942: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark · each place has its own badge colours
00:36 +943: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
00:36 +944: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
00:36 +945: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
00:36 +946: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
00:36 +947: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +948: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +949: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +950: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +951: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +952: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +953: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +954: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +955: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
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
00:38 +972: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +973: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
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
00:38 +984: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +985: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +986: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +987: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +988: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +989: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +990: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +991: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +992: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +993: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +994: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +995: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +996: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +997: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +998: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +999: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1000: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +1001: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1002: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1003: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1004: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1005: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1006: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1007: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1008: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1009: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +1010: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1011: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1012: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1013: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1014: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1015: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1016: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1017: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1018: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1019: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1020: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1021: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1022: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1023: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1024: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1025: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1026: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1027: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1028: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1029: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1030: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1031: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1032: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1033: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1034: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1035: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1036: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1037: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1038: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1039: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1040: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1041: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1042: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1043: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1044: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1045: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:39 +1046: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:40 +1047: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:40 +1048: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:40 +1049: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:40 +1050: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:40 +1051: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:40 +1052: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:40 +1053: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1054: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1055: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1056: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1057: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1058: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1059: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1060: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1061: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1062: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1063: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1064: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1065: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1066: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1067: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1068: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1069: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1070: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1071: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1072: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1073: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +1074: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1075: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1076: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1077: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1078: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1079: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1080: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1081: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1082: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1083: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1084: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1085: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1086: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1087: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1088: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1089: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1090: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1091: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1092: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1093: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1094: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +1095: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1096: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1097: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1098: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1099: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1100: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1101: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1102: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1103: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1104: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1105: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1106: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1107: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +1108: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert — no chevron, no tap
00:42 +1109: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert — no chevron, no tap
00:42 +1110: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:42 +1111: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:42 +1112: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +1113: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +1114: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +1115: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +1116: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +1117: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1118: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1119: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1120: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1121: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1122: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1123: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1124: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1125: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1126: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1127: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1128: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1129: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1130: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1131: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1132: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
00:43 +1133: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1134: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1135: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1136: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1137: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1138: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1139: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1140: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1141: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1142: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1143: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1144: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1145: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1146: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1147: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1148: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1149: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1150: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1151: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1152: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1153: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1154: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1155: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1156: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1157: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1158: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:43 +1159: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1160: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +1161: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1162: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1163: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1164: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1165: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1166: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1167: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1168: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1169: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1170: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1171: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1172: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1173: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:44 +1174: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:44 +1175: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:44 +1176: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:44 +1177: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1178: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1179: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1180: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1181: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1182: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1183: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1184: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1185: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1186: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1187: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1188: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1189: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1190: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1191: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:44 +1192: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1193: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1194: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1195: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1196: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1197: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1198: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1199: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1200: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1201: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1202: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1203: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1204: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1205: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1206: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:44 +1207: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
00:44 +1208: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
00:44 +1209: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1210: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1211: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1212: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1213: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1214: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1215: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1216: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1217: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1218: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1219: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1220: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1221: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1222: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1223: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1224: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1225: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1226: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1227: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1228: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1229: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1230: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1231: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1232: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1233: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1234: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1235: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:45 +1236: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1237: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1238: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1239: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1240: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1241: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1242: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1243: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1244: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1245: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1246: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1247: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1248: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1249: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1250: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1251: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:45 +1252: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:46 +1253: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) each card is ONE button to TalkBack
00:46 +1254: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) each card is ONE button to TalkBack
00:46 +1255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) the phone is the value GET /me returned, verbatim
00:46 +1256: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1257: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1258: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1259: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1260: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1261: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1262: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1263: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1264: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1265: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1266: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1267: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1268: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1269: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1270: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1271: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1272: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1273: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1274: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1275: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1276: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1277: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1278: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1279: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +1280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) a skipped school reads as resolved, not as missing data
00:46 +1281: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
00:46 +1282: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:46 +1283: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:46 +1284: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
00:46 +1285: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
00:46 +1286: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
00:46 +1287: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:46 +1288: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:46 +1289: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:46 +1290: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1291: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1292: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1293: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1294: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1295: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1296: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1297: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1298: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1299: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1300: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1301: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1302: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1303: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1304: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1305: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:47 +1306: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:48 +1307: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:48 +1308: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:48 +1309: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:48 +1310: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:48 +1311: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1312: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1313: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1314: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1315: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1316: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1317: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1318: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1319: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1320: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1321: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1322: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1323: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1324: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1325: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:48 +1326: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:48 +1327: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1328: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1329: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1330: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1331: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1332: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1333: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1334: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1335: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1336: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1337: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:49 +1338: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1339: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1340: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1341: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1342: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1343: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1344: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1345: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1346: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1347: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1348: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1349: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:49 +1350: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1351: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1352: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1353: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1354: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1355: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1356: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1357: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1358: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1359: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:50 +1360: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:50 +1361: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:50 +1362: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:50 +1363: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:50 +1364: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:50 +1365: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:50 +1366: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1367: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1368: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1369: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1370: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1371: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1372: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1373: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:50 +1374: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:50 +1375: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:50 +1376: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:50 +1377: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:50 +1378: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:51 +1379: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:51 +1380: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
00:51 +1381: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
00:51 +1382: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
00:51 +1383: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
00:51 +1384: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the avatar block (176:1343 · 176:1346) en: the disc 25 under the bar, the badge 14 below the disc, the first label 1 under the badge
00:51 +1385: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
00:51 +1386: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
00:51 +1387: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
00:51 +1388: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
00:51 +1389: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:51 +1390: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:51 +1391: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:51 +1392: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:51 +1393: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:51 +1394: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:51 +1395: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:51 +1396: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
00:51 +1397: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
00:51 +1398: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
00:51 +1399: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
00:51 +1400: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:52 +1401: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:52 +1402: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:52 +1403: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:52 +1404: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
00:52 +1405: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:52 +1406: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:52 +1407: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:52 +1408: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:52 +1409: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:52 +1410: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:52 +1411: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1412: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1413: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1414: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1415: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1416: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1417: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1418: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1419: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1420: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:52 +1421: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:52 +1422: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
00:52 +1423: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:52 +1424: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:52 +1425: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:52 +1426: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:52 +1427: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:52 +1428: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
00:52 +1429: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
00:52 +1430: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
00:52 +1431: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
00:52 +1432: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
00:52 +1433: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
00:52 +1434: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
00:52 +1435: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
00:52 +1436: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
00:52 +1437: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1438: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1439: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1440: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1441: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1442: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1443: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1444: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:52 +1445: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:53 +1446: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:53 +1447: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:53 +1448: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz Start hands the subject on to the quiz, display only (API→UI Wave 13)
00:53 +1449: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility filter chips meet the 48dp minimum tap target
00:53 +1450: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the action sheet (216:3341) dark (337:8135): the handle #FCFBF9, the hairline the same #4B675E at 60%
00:53 +1451: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1452: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1453: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1454: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1455: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1456: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the action sheet (216:3341) the scrim dismisses it, and nothing changes
00:53 +1457: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1458: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1459: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1460: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1461: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1462: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1463: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1464: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1465: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
00:53 +1466: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1467: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1468: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1469: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1470: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1471: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1472: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1473: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1474: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1475: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1476: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1477: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1478: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1479: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:53 +1480: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1481: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1482: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1483: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1484: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1485: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1486: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1487: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1488: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1489: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1490: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1491: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1492: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1493: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1494: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1495: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1496: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1497: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1498: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1499: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1500: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1501: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1502: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1503: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1504: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:53 +1505: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) light: the frame's ✕, 27 from the card's start, with a 48 x 48 target
00:53 +1506: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) light: the frame's ✕, 27 from the card's start, with a 48 x 48 target
00:53 +1507: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the review path consumes nothing and persists nothing calls no endpoint
00:53 +1508: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
00:53 +1509: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
00:54 +1510: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1511: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1512: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1513: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1514: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1515: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1516: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1517: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1518: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1519: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1520: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1521: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1522: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1523: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1524: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1525: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1526: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1527: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1528: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1529: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1530: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1531: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:54 +1532: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1533: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1534: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1535: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1536: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1537: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1538: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1539: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1540: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1541: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1542: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:54 +1543: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:54 +1544: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:54 +1545: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:54 +1546: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:54 +1547: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:54 +1548: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined D-006 still holds — no level, no points total, no meter
00:55 +1549: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1550: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1551: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1552: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1553: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1554: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1555: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1556: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1557: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1558: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1559: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1560: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1561: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1562: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:55 +1563: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:55 +1564: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:55 +1565: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:55 +1566: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: states matrix Arabic + dark + offline all at once
00:55 +1567: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) dark header: cream title over the same rule
00:55 +1568: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1569: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1570: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1571: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1572: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1573: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1574: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:55 +1575: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the length chips are raised, not outlined 171 x 45, no hairline, and the frame's own shadow
00:55 +1576: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: "Correct" and "Wrong" lead with the frame's 16 discs, 10 before the label
00:55 +1577: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 · 337:6628) dark: title #FCFBF9, subtitle #EEEEEE, same rule
00:55 +1578: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is ON when the quiz screen mounts
00:55 +1579: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:55 +1580: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:56 +1581: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:56 +1582: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1583: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1597: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1598: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1599: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1600: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1601: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1602: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:56 +1603: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1604: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1605: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1606: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1607: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1608: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1609: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1610: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1611: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1612: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1613: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1614: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1615: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1616: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1617: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1618: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1619: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1620: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1621: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1622: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1623: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:57 +1644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1652: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1653: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:58 +1654: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) empty name blocks Continue with an inline error
00:58 +1655: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: offline shows the banner and an offline state, not an error
00:58 +1656: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) a second 403 opens ONE card, not two
00:58 +1657: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +1658: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:58 +1659: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1660: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1661: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1662: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1663: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1664: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1665: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1666: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1667: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1668: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1669: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1670: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1671: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1672: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1673: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1674: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1675: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1676: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1677: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1678: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1679: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1680: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:59 +1681: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +1682: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +1683: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +1684: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:00 +1685: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1686: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1687: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1688: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1689: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1690: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1691: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1692: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1693: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1694: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:00 +1695: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:00 +1696: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:00 +1697: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1698: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1699: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1700: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1701: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1702: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1703: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1704: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1705: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1706: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1707: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:01 +1708: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1709: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1710: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1711: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1712: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1713: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1714: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1715: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1716: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1717: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1718: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1719: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1720: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1721: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1722: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1723: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:01 +1724: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1725: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1726: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1727: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1728: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1729: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1730: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1731: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1732: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1733: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:02 +1734: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1735: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1736: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1737: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1738: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1739: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1740: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1741: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:02 +1742: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:03 +1743: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1744: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1745: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1746: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1747: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1748: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1749: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1750: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1751: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1752: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1753: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1754: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +1755: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1756: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1757: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1758: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1759: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1760: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1761: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +1762: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:03 +1763: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:03 +1764: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: academic years selecting a year stores its id
01:03 +1765: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: academic years selecting a year stores its id
01:03 +1766: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1767: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1768: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1769: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1770: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1771: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1772: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1773: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1774: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1775: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1776: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:04 +1777: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1778: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1779: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1780: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1781: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1782: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1783: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1784: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1785: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1786: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1787: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1788: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1789: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:04 +1790: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1791: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1792: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1793: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1794: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1795: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1796: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1797: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1798: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1799: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1800: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1801: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1802: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1803: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1804: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:05 +1805: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1806: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1807: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1808: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1809: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1810: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1811: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1812: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1813: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1814: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1815: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1816: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:05 +1817: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1818: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1819: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1820: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1821: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1822: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1823: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1824: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1825: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1826: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1827: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1828: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1829: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:06 +1830: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:06 +1831: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:06 +1832: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:06 +1833: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:06 +1834: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:06 +1835: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:06 +1836: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:06 +1837: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:06 +1838: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:07 +1839: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:07 +1840: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:07 +1841: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:07 +1842: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:07 +1843: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:07 +1844: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:07 +1845: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1846: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1847: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1848: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1849: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:07 +1852: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:07 +1853: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:07 +1854: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:07 +1855: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:07 +1856: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:07 +1857: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:07 +1858: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:08 +1859: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:08 +1860: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:08 +1861: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:08 +1862: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:08 +1863: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal — one screen, two documents, no copy both routes render the same empty body, different titles
01:08 +1864: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal — one screen, two documents, no copy both routes render the same empty body, different titles
01:08 +1865: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1866: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1867: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1868: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1869: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1870: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1871: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1872: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1873: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1874: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1875: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1876: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1877: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1878: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1879: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:08 +1880: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:09 +1881: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:09 +1882: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:09 +1883: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:09 +1884: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:09 +1885: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:09 +1886: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:09 +1887: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:09 +1888: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:09 +1889: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1890: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1891: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1892: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1893: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1894: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1895: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1896: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1897: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:09 +1898: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:10 +1899: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:10 +1900: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:10 +1901: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:10 +1902: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:10 +1903: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:10 +1904: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1905: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1906: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1907: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1908: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1909: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1910: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1911: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1912: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1913: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1914: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1915: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1916: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:10 +1917: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1918: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1919: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1920: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1921: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1922: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1923: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1924: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1925: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1926: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1927: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1928: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1929: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1930: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1931: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1932: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1933: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1934: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1935: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1936: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1937: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:10 +1938: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1939: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1940: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1941: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1942: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1943: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1944: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1945: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1946: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1947: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1948: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1949: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1950: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1951: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1952: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1953: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1954: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1955: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1956: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1957: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1958: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1959: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1960: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1961: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1962: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1963: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1964: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1965: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1966: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1967: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1968: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:11 +1969: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects a COMMENT describing a BoxShadow is not a violation
01:11 +1970: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1971: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1972: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1973: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1974: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1975: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1976: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1977: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1978: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1979: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1980: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1981: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1982: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1983: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1984: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1985: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1986: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1987: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1988: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1989: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1990: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1991: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1992: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1993: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1994: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1995: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1996: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1997: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1998: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +1999: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:11 +2000: F:/level/level_up/level_up_app/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) a COMMENT showing the old helper is not a violation
01:11 +2001: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:11 +2002: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 3 selected
01:11 +2003: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:11 +2004: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:11 +2005: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:11 +2006: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:11 +2007: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:11 +2008: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:11 +2009: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a "+N" inside test output is not mistaken for a tally
01:11 +2010: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2011: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2012: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2013: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2014: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2015: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2016: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:11 +2017: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:11 +2018: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:11 +2019: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:11 +2020: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
01:11 +2021: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:11 +2022: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:11 +2023: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:11 +2024: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:11 +2025: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:11 +2026: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact the main manifest declares INTERNET
01:11 +2027: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: (tearDownAll)
01:11 +2027: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact CI still inspects the built artefact, not just the source
01:11 +2028: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:11 +2029: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:12 +2030: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:12 +2031: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical both validate scripts exist
01:12 +2032: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical the pre-push hook reuses validate.sh instead of its own checks
01:12 +2033: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical PowerShell scripts are pure ASCII
01:12 +2034: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical every shell script that batches files is NUL-safe
01:12 +2035: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
01:12 +2036: All tests passed!
```

