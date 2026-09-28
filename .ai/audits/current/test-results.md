# Validation run - 2026-09-28T14:06:46Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 286 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 1693 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-09-28T14:06:46Z - finished 2026-09-28T14:09:03Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-28T14:06:46Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 634cc34
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 84fc5cbb22 (2 months ago) • 2026-07-17 10:20:17 -0700
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
  cached_network_image 3.4.1 (4.0.2 available)
  cached_network_image_platform_interface 4.1.1 (5.0.2 available)
  cached_network_image_web 1.3.1 (2.0.2 available)
  cli_util 0.4.2 (0.6.0 available)
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
  nm 0.5.0 (0.6.0 available)
  objective_c 9.4.1 (9.6.0 available)
  octo_image 2.1.0 (2.1.1 available)
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
82 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 286 hand-written Dart files

Formatted 60 files (0 changed) in 0.42 seconds.
Formatted 60 files (0 changed) in 0.37 seconds.
Formatted 60 files (0 changed) in 0.50 seconds.
Formatted 60 files (0 changed) in 0.57 seconds.
Formatted 46 files (0 changed) in 0.41 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 17.6s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**1693 passed, 0 failed, 0 skipped** (exit 0)


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
00:01 +22: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:01 +23: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:01 +24: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
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
00:02 +43: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:02 +44: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:02 +45: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:02 +46: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:02 +47: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:02 +48: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:02 +49: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:02 +50: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:02 +51: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:02 +52: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:02 +53: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:02 +54: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:02 +55: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:02 +56: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
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
00:03 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +84: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +85: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +86: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +87: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +88: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +89: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +90: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +91: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +92: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +93: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +94: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +95: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +96: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +97: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +98: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +99: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +100: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +101: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +102: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +103: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +104: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +105: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +106: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +107: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +108: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +109: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +110: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +111: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +112: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +113: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +114: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +115: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +116: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +117: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +118: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +119: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +120: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +121: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +122: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +123: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +124: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +125: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +126: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +127: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +128: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +129: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +130: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +131: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +132: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +133: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +134: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +135: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +136: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +137: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +138: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +139: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +140: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +141: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +142: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +143: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +144: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +145: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +146: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +147: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +148: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +149: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +150: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +151: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +152: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +153: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +154: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +155: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +156: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +157: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +158: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +159: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +160: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +161: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:05 +162: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:05 +163: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:05 +164: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:05 +165: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:05 +166: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:05 +167: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:05 +168: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:05 +169: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:06 +170: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:07 +171: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +172: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +173: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +174: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +175: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +176: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +177: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +178: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +179: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +180: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +181: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:07 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:07 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet no scrim leaves the framework sheet alone
00:08 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet no scrim leaves the framework sheet alone
00:08 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +209: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +210: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +211: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +212: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +213: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +214: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +215: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +216: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +217: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +218: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +219: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +220: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +221: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +222: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +223: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +224: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +225: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +226: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +227: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +228: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +229: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +230: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +231: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +232: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +233: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +234: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +235: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +236: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +237: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +238: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +239: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +240: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +241: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +242: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +243: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +244: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +245: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +246: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead en at 1.0x: nothing is scaled down
00:10 +247: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead ar at 1.0x: nothing is scaled down
00:10 +248: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the registration variant is a DIFFERENT chip
00:10 +249: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:10 +250: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:10 +251: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the standard variant takes the standard tokens
00:10 +252: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead ar at 1.3x: nothing is scaled down
00:10 +253: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead ar at 1.3x: nothing is scaled down
00:10 +254: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead ar at 1.3x: nothing is scaled down
00:10 +255: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead ar at 1.3x: nothing is scaled down
00:10 +256: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead ar at 1.3x: nothing is scaled down
00:10 +257: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the registration variant is a DIFFERENT chip
00:10 +258: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the registration variant is a DIFFERENT chip
00:10 +259: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light · the registration variant is a DIFFERENT chip
00:10 +260: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +261: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +262: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +263: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +264: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +265: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +266: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +267: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +268: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead the text-scale setting reaches EVERY label, not just the short ones
00:10 +269: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +270: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +271: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +272: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +273: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +274: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +275: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:10 +276: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: labels are laid out at full size, and the track yields instead labels that do NOT fit widen the groove past the viewport
00:10 +277: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:10 +278: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:10 +279: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:10 +280: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light draws the 1.17338 hairline and no Glass
00:11 +281: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:11 +282: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:11 +283: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:11 +284: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:11 +285: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:11 +286: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:11 +287: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:11 +288: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:11 +289: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark · the error state keeps its own 1.5
00:11 +290: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:11 +291: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +292: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +293: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +294: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +295: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +296: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +297: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +298: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +299: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:11 +300: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell disabled dims the whole field and kills the tap
00:11 +301: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell disabled dims the whole field and kills the tap
00:11 +302: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:11 +303: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:11 +304: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill dark has NO border at all, and Glass instead
00:11 +305: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:11 +306: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:11 +307: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:11 +308: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:11 +309: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:11 +310: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:11 +311: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:11 +312: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:11 +313: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:11 +314: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:12 +315: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:14 +316: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +317: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +318: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +319: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +320: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +321: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +322: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +323: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:14 +324: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:15 +325: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:15 +326: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:15 +327: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:15 +328: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +329: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +330: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +331: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +332: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +333: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +334: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:15 +335: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:15 +336: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:16 +337: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +338: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +339: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +340: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +341: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +342: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +343: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +344: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +345: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +346: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +347: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +348: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +349: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +350: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +351: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +352: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +353: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +354: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +355: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +356: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +357: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +358: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +359: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +360: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +361: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +362: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +363: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +364: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +365: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +366: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +367: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +367: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:16 +368: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +369: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:16 +370: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +371: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +372: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +373: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +374: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +375: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +376: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +377: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +378: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +379: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +380: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +381: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +382: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +383: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +384: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +385: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +386: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +387: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +388: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +389: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +390: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +391: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +392: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +393: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +394: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +395: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +396: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
unhandled element <filter/>; Picture key: Svg loader
00:17 +397: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:17 +398: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +399: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +400: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +401: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +402: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +403: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +404: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +405: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +406: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +407: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +408: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +409: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +410: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +411: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +411: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:18 +412: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +413: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +414: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +415: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:18 +416: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +417: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +418: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +419: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +420: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +421: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:20 +422: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +423: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +424: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +425: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +426: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +427: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +428: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +429: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +430: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +431: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +432: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +433: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:22 +434: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:23 +435: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:23 +436: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:23 +437: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:23 +438: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:23 +439: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:23 +440: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:23 +441: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +442: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +443: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +444: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +445: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +446: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +447: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:24 +448: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +449: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +450: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +451: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +452: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +453: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +454: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +455: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +456: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +457: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +458: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +459: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +460: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +461: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +462: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +463: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +464: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +465: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +466: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +467: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +468: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +469: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:25 +470: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +471: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +472: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +473: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +474: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +475: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +476: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +477: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +478: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +479: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +480: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +481: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +482: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +483: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +484: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +485: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +486: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +487: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +488: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +489: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +490: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +491: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +492: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +493: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +494: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +495: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +496: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +497: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +498: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +499: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +500: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +501: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +502: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +503: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +504: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +505: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:27 +506: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:27 +507: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:27 +508: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
00:27 +509: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +510: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +511: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +512: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:28 +513: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +514: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +515: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +516: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +517: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +518: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +519: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +520: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +521: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +522: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +523: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +524: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:28 +525: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:28 +526: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:28 +527: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:28 +528: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +529: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +530: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +531: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +532: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +533: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +534: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +535: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +536: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +537: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +538: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +539: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +540: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +541: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:29 +542: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:29 +543: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:29 +544: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:29 +545: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:29 +546: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:29 +547: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:29 +548: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +549: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +550: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +551: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +552: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +553: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:30 +554: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +555: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +556: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +557: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +558: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +559: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +560: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +561: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +562: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +563: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +564: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +565: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +566: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:30 +567: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:30 +568: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:31 +569: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:31 +570: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:31 +571: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:31 +572: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off falls back to normal when the subject omits it
00:31 +573: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders in dark theme too
00:31 +574: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders in dark theme too
00:31 +575: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: new points on /me (a finished quiz) refetch the board
00:31 +576: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +577: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +578: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +579: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +580: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +581: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +582: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +583: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +584: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states empty lectures get their OWN copy, not the school one
00:31 +585: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:31 +586: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:31 +587: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:31 +588: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +589: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +590: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +591: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +592: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +593: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +594: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states loading shows a row skeleton, not a bare spinner
00:31 +595: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:31 +596: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:31 +597: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:31 +598: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:31 +599: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:31 +600: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +601: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +602: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +603: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +604: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +605: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +606: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +607: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +608: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +609: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +610: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +611: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +612: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +613: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +614: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +615: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +616: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +617: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +618: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +619: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +620: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +621: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +622: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +623: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +624: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +625: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:32 +626: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:32 +627: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:32 +628: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:32 +629: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +630: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +631: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +632: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +633: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +634: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +635: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +636: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +637: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +638: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +639: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +640: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +641: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +642: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +643: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +644: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +645: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +646: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +647: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +648: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +649: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +650: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +651: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +652: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +653: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +654: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +655: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:33 +656: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +657: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +658: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +659: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +660: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:34 +661: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:34 +662: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:35 +663: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:35 +664: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:35 +665: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:35 +666: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:35 +667: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +668: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +669: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +670: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +671: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +672: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +673: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +674: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +675: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +676: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +677: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +678: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +679: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +680: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +681: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +682: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +683: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +684: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +685: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +686: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +687: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +688: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +689: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +690: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +691: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +692: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +693: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +694: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +695: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +696: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +697: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +698: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +699: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +700: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +701: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:37 +702: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:37 +703: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:37 +704: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:37 +705: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +706: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +707: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +708: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +709: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +710: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +711: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +712: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +713: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +714: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +715: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +716: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +717: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +718: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +719: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +720: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +721: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +722: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +723: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +724: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +725: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +726: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +727: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +728: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +729: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +730: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +731: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:38 +732: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:38 +733: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:38 +734: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:38 +735: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:38 +736: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer · Save wears the CTA elevation the primary tone, enabled while the form is idle
00:38 +737: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:38 +738: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:38 +739: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:38 +740: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:38 +741: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:38 +742: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:39 +743: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:39 +744: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +745: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +746: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +747: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +748: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +749: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +750: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +751: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +752: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +753: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +754: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +755: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +756: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +757: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +758: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +759: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +760: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +761: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +762: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +763: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +764: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +765: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +766: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +767: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:39 +768: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +769: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +770: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +771: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +772: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +773: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:40 +774: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +775: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +776: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +777: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +778: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +779: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +780: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +781: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +782: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +783: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +784: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +785: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +786: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +787: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +788: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +789: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +790: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +791: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +792: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:41 +793: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +794: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +795: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +796: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +797: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +798: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +799: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +800: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +801: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +802: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +803: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:42 +804: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form CLEARED: emptying the box sends the key with an explicit null
00:42 +805: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form CLEARED: emptying the box sends the key with an explicit null
00:42 +806: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a subject with no units is EMPTY, not a crash and not an error
00:42 +807: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a subject with no units is EMPTY, not a crash and not an error
00:42 +808: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +809: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +810: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +811: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +812: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +813: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +814: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +815: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +816: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +817: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:43 +818: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:43 +819: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:43 +820: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:43 +821: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:43 +822: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:44 +823: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:44 +824: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
00:44 +825: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +826: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +827: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +828: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +829: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +830: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +831: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +832: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +833: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +834: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +835: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +836: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +837: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +838: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +839: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +840: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +841: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +842: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +843: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +844: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +845: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:44 +846: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +847: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +848: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +849: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +850: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +851: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +852: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +853: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +854: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +855: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +856: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +857: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +858: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +859: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +860: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +861: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +862: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +863: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +864: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +865: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +866: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +867: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +868: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +869: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +870: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +871: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +872: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +873: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:45 +874: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +875: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +876: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +877: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +878: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +879: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +880: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +881: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +882: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +883: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +884: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +885: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +886: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +887: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +888: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +889: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +890: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +891: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +892: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +893: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +894: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +895: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +896: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +897: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +898: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:45 +899: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:46 +900: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +901: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +902: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +903: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +904: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +905: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +906: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +907: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +908: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +909: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +910: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +911: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +912: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +913: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +914: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +915: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +916: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +917: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +918: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +919: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +920: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +921: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +922: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +923: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +924: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +925: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +926: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +927: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +928: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +929: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +930: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +931: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +932: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +933: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +934: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +935: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +936: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +937: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +938: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:46 +939: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:47 +940: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:47 +941: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:47 +942: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +943: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +944: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +945: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +946: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +947: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +948: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +949: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +950: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +951: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:47 +952: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in en at 1.3x; rows grow together
00:47 +953: F:/level/level_up/level_up_app/test/features/quiz/quiz_repository_test.dart: createQuiz school: sends lessonId and OMITS lectureId/quizType entirely
00:47 +954: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +955: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +956: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +957: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +958: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +959: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +960: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +961: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +962: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +963: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:47 +964: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +965: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +966: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +967: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +968: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +969: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +970: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +971: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:48 +972: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity — the union at its first call site a CODED city renders the English name in EN
00:48 +973: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +974: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +975: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +976: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +977: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +978: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +979: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +980: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +981: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:48 +982: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in ar at 2.0x; rows grow together
00:48 +983: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in ar at 2.0x; rows grow together
00:48 +984: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:48 +985: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:48 +986: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +987: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +988: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +989: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +990: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +991: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +992: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +993: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:49 +994: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +995: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +996: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +997: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +998: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +999: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1000: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1001: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1002: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1003: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1004: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1005: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1006: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1007: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1008: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:50 +1009: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:51 +1010: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:51 +1011: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:51 +1012: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1013: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1014: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1015: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1016: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1017: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1018: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1019: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1020: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:51 +1021: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1022: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1023: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1024: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1025: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1026: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1027: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:52 +1028: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1029: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1030: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1031: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1032: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1033: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1034: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1035: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1036: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1037: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1038: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1039: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1040: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:52 +1041: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1042: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1043: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1044: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1045: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1046: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1047: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1048: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:53 +1049: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1050: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1051: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1052: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1053: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1054: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1055: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:53 +1056: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
00:53 +1057: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
00:53 +1058: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:53 +1059: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:53 +1060: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1061: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1062: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1063: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1064: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1065: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1066: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1067: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1068: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
00:54 +1069: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1070: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1071: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1072: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1073: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1074: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1075: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
00:54 +1076: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1077: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1078: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1079: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:54 +1080: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:54 +1081: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:54 +1082: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:54 +1083: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:55 +1084: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:55 +1085: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:55 +1086: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:55 +1087: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:55 +1088: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
00:55 +1089: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1090: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1091: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1092: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1093: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1094: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1095: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1096: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1097: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1098: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1099: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
00:55 +1100: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
00:55 +1101: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
00:55 +1102: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
00:55 +1103: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
00:55 +1104: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1105: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:55 +1106: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:56 +1107: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
00:56 +1108: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:56 +1109: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1110: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1111: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1112: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1113: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1114: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1115: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1116: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1117: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1118: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1119: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1120: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1121: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1122: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
00:56 +1123: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
00:56 +1124: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
00:56 +1125: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1126: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix leveledUp and newBadge parse but celebrate nothing
00:56 +1127: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
00:56 +1128: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1129: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1130: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1131: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1132: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1133: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1134: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1135: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1136: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1137: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
00:56 +1138: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1139: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1140: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1141: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1142: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1143: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1144: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:56 +1145: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:57 +1146: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:57 +1147: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:57 +1148: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:57 +1149: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:57 +1150: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
00:57 +1151: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
00:57 +1152: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
00:57 +1153: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
00:57 +1154: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
00:57 +1155: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
00:57 +1156: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1157: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1158: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1159: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1160: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1161: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1162: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1163: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1164: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1165: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
00:57 +1166: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1167: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1168: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1169: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1170: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1171: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1172: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1173: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1174: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1175: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1176: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1177: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1178: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1179: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1180: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
00:57 +1181: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:57 +1182: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
00:57 +1183: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
00:57 +1184: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is ON while the review screen is mounted
00:57 +1185: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
00:57 +1186: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
00:57 +1187: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
00:57 +1188: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:57 +1189: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:57 +1190: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1191: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined dark: the rewards card takes G14 and the lavender back-light
00:58 +1192: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1193: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1194: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1195: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1196: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1197: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1198: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1199: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1200: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1201: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1202: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1203: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1204: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1205: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1206: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1207: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1208: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1209: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states offline shows the banner and disables Start
00:58 +1210: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1211: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1212: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1213: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1214: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1215: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1216: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
00:58 +1217: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1218: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
00:58 +1219: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1220: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1221: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1222: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1223: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1224: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1225: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1226: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1227: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1228: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1229: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1230: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1231: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1232: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1233: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
00:58 +1234: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
00:59 +1235: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation a 403 reads as "not available", never as a broken quiz
00:59 +1236: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: states matrix dark theme renders the same content
00:59 +1237: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:59 +1238: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:59 +1239: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:59 +1240: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:59 +1241: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1242: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1243: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:59 +1244: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 · 337:6628) the subtitle is "Subject — Scope", inside the header, #4B675E
00:59 +1245: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:59 +1246: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:59 +1247: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:59 +1248: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:59 +1249: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:59 +1250: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
00:59 +1251: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1252: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1253: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1254: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1255: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1256: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1257: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1258: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1259: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1260: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1261: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1262: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1263: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1264: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1265: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1266: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1267: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1268: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1269: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1270: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1271: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1272: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1273: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1274: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1275: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1276: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1277: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1278: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1279: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1280: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1281: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1282: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1283: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1284: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1285: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1286: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1287: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:00 +1288: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1289: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1290: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1291: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1292: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1293: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1294: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1295: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1296: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1297: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1298: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1299: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1300: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1301: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1302: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1303: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1304: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1305: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1306: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1307: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:01 +1308: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1309: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1310: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1311: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1312: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1313: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1314: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1315: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1316: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1317: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1318: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1319: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1320: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1321: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1322: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1323: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1324: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1325: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1326: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1327: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1328: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1329: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1330: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1331: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1332: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1333: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1334: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1335: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1336: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:03 +1337: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1338: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1339: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1340: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1341: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1342: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1343: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1344: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1345: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1346: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1347: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1348: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1349: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1350: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1351: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1352: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1353: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1354: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1355: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1356: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1357: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1358: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1359: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1360: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1361: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1362: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1363: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1364: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1365: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1366: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:05 +1367: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1368: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1369: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1370: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1371: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1372: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1373: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:06 +1374: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:06 +1375: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:06 +1376: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:06 +1377: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:06 +1378: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:06 +1379: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1380: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1381: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1382: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1383: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1384: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1385: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1386: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1387: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1388: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1389: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1390: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1391: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1392: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1393: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1394: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1395: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1396: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1397: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1398: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1399: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1400: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1401: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1402: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:07 +1403: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1404: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1405: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1406: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1407: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1408: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1409: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1410: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1411: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1412: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1413: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1414: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1415: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1416: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1417: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1418: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:08 +1419: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:08 +1420: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:09 +1421: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1422: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1423: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1424: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1425: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1426: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1427: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1428: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1429: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1430: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:09 +1431: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light light: none, on either track
01:09 +1432: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:09 +1433: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:09 +1434: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) the frame's ONE switch is drawn as two, from /me
01:09 +1435: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /friends renders "Friends"
01:09 +1436: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) the header carries no AI icon, before or after grading
01:09 +1437: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: all five tabs are present, Home selected first
01:09 +1438: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:09 +1439: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:09 +1440: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:10 +1441: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:10 +1442: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:10 +1443: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:10 +1444: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:10 +1445: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) flipping leaderboardVisible sends ONLY leaderboardVisible
01:10 +1446: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: Message is the last coming-soon placeholder
01:10 +1447: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: academic years selecting a year stores its id
01:10 +1448: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: academic years selecting a year stores its id
01:10 +1449: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:10 +1450: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:10 +1451: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1452: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1453: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1454: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1455: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1456: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1457: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1458: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1459: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1460: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:10 +1461: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1462: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1463: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1464: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1465: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1466: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1467: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1468: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1469: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1470: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1471: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1472: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1473: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1474: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1475: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1476: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1477: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1478: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1479: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:12 +1480: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
01:12 +1481: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:12 +1482: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:12 +1483: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:12 +1484: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:12 +1485: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1486: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1487: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1488: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1489: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1490: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1491: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1492: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1493: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1494: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1495: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1496: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1497: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1498: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1499: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:12 +1500: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:12 +1501: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:12 +1502: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:12 +1503: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:12 +1504: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:13 +1505: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:13 +1506: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:13 +1507: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:13 +1508: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:13 +1509: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:13 +1510: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1511: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1512: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1513: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1514: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1515: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1516: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1517: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1518: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:13 +1519: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +1520: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +1521: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +1522: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +1523: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:13 +1524: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: the drawn controls render and are dead tapping a dead control does nothing at all
01:13 +1525: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track text scale 1.3 does not overflow in en
01:13 +1526: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:13 +1527: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:13 +1528: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch picking Arabic flips the whole app to RTL
01:13 +1529: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:13 +1530: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal — one screen, two documents, no copy no legal prose is rendered — the screen is one line
01:13 +1531: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch both names are written in their own language, in both locales
01:14 +1532: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch both names are written in their own language, in both locales
01:14 +1533: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages — the existing locale switch both names are written in their own language, in both locales
01:14 +1534: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark Arabic renders Arabic copy under RTL
01:15 +1535: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:15 +1536: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:15 +1537: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:15 +1538: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:15 +1539: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:15 +1540: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a canvas writes it, so the next launch keeps it
01:15 +1541: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark the legal screen is localized in Arabic
01:16 +1542: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a language writes it too
01:16 +1543: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:16 +1544: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:16 +1545: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:16 +1546: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:16 +1547: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:16 +1548: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:16 +1549: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:16 +1550: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1551: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1552: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1553: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1554: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1555: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:17 +1556: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1557: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1558: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1559: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1560: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1561: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1562: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1563: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1564: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1565: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1566: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:17 +1567: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1568: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1569: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1570: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1571: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1572: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1573: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1574: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1575: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1576: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1577: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1578: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1579: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1580: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:17 +1581: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:18 +1582: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1583: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1584: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1585: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1586: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1587: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1588: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1589: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1590: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1591: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1592: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1593: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1594: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1595: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1596: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1597: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1598: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1599: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1600: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1601: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1602: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1603: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1604: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1605: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1606: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1607: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1608: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1609: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1610: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1611: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1612: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1613: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1614: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1615: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1616: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1617: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1618: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1619: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1620: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1621: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1622: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1623: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1624: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1625: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1626: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1627: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1628: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1629: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1630: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1631: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1632: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1633: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1634: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1635: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1636: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1637: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1638: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1639: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1640: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1641: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1642: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1643: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1644: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1645: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1646: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1647: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1648: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1649: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1650: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1651: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1652: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1653: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1654: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1655: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1656: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:18 +1657: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:18 +1658: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a failing run reports its failures — the 2026-09-12 defect
01:18 +1659: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1660: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1661: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1662: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1663: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1664: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1665: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1666: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1667: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1668: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1669: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1670: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:18 +1671: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 3 selected
01:18 +1672: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:19 +1673: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:19 +1674: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:19 +1675: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:19 +1676: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:19 +1677: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:19 +1678: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: (tearDownAll)
01:19 +1678: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
01:19 +1679: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI runs the whole suite minus goldens, and the goldens by tag
01:19 +1680: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests every golden test file carries the golden tag
01:19 +1681: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth .flutter-version exists and is a plain version
01:19 +1682: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth CI reads the pin from the file rather than hardcoding it
01:19 +1683: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact the main manifest declares INTERNET
01:19 +1684: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact CI still inspects the built artefact, not just the source
01:19 +1685: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:19 +1686: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:19 +1687: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical both validate scripts exist
01:19 +1688: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical the pre-push hook reuses validate.sh instead of its own checks
01:19 +1689: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical PowerShell scripts are pure ASCII
01:19 +1690: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical every shell script that batches files is NUL-safe
01:19 +1691: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
01:19 +1692: F:/level/level_up/level_up_app/test/widget_test.dart: scaffold boots
01:19 +1693: All tests passed!
```

