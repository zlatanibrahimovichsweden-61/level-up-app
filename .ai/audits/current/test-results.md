# Validation run - 2026-10-09T15:40:27Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 326 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 2082 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-10-09T15:40:27Z - finished 2026-10-09T15:42:45Z

---

## 1. Environment

```text
started (UTC)  : 2026-10-09T15:40:27Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : b227f61
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
  _fe_analyzer_shared 99.0.0 (109.0.0 available)
  analyzer 12.1.0 (14.5.0 available)
  analyzer_buffer 0.3.3 (0.3.4 available)
  build 4.0.7 (4.0.11 available)
  build_config 1.3.1 (1.3.3 available)
  build_daemon 4.1.2 (4.1.6 available)
  build_runner 2.15.1 (2.16.2 available)
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
  jni_flutter 1.0.1 (1.0.4+1 available)
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
  shared_preferences 2.5.5 (2.5.6 available)
  shared_preferences_android 2.4.27 (2.4.28 available)
  shared_preferences_foundation 2.5.6 (2.5.7 available)
  source_gen 4.2.3 (4.3.0 available)
  source_helper 1.3.12 (1.3.13 available)
  source_maps 0.10.13 (0.10.14 available)
  sqflite 2.4.3 (2.4.4+1 available)
  sqflite_android 2.4.3 (2.4.4 available)
  sqflite_common 2.5.11 (2.5.13+1 available)
  sqflite_darwin 2.4.3+1 (2.4.4 available)
  sqflite_platform_interface 2.4.1 (2.4.2 available)
  stack_trace 1.12.1 (1.12.2 available)
  stream_transform 2.1.1 (2.1.2 available)
  synchronized 3.4.1+1 (3.4.2 available)
  test 1.31.0 (1.33.0 available)
  test_api 0.7.11 (0.7.15 available)
  test_core 0.6.17 (0.6.21 available)
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
90 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 326 hand-written Dart files

Formatted 60 files (0 changed) in 0.36 seconds.
Formatted 60 files (0 changed) in 0.38 seconds.
Formatted 60 files (0 changed) in 0.34 seconds.
Formatted 60 files (0 changed) in 0.38 seconds.
Formatted 60 files (0 changed) in 0.58 seconds.
Formatted 26 files (0 changed) in 0.15 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 13.9s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**2082 passed, 0 failed, 0 skipped** (exit 0)


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
00:01 +21: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required → refresh once → original retried → success
00:01 +22: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:01 +23: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:01 +24: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:01 +25: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:01 +26: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
00:01 +27: F:/level/level_up/level_up_app/test/core/network/dio_client_test.dart: (setUpAll)
00:01 +27: F:/level/level_up/level_up_app/test/core/network/dio_client_test.dart: Accept: application/json on every request (contract 3.32.0-m1) the main client sends it on GET, POST, PATCH and DELETE
00:01 +28: F:/level/level_up/level_up_app/test/core/network/dio_client_test.dart: Accept: application/json on every request (contract 3.32.0-m1) the Bearer token and the content type travel beside it
00:01 +29: F:/level/level_up/level_up_app/test/core/network/dio_client_test.dart: Accept: application/json on every request (contract 3.32.0-m1) the bare refresh client sends it too, and never a token
00:01 +30: F:/level/level_up/level_up_app/test/core/network/dio_client_test.dart: Accept: application/json on every request (contract 3.32.0-m1) it is a default, not a lock: a per-request Accept wins
00:01 +31: F:/level/level_up/level_up_app/test/core/network/dio_client_test.dart: (tearDownAll)
00:01 +31: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException carries the ProblemDetails field map
00:02 +32: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException is still an ApiException (existing handlers keep working)
00:02 +33: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a missing/malformed errors map yields empty fields, not a crash
00:02 +34: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a non-list value is tolerated as a single message
00:02 +35: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:02 +36: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 → UnauthorizedException carrying the code
00:02 +37: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 → ApiException carrying status + code
00:02 +38: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error → NetworkException (drives Offline)
00:02 +39: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException is typed, and is NOT otp_throttled
00:02 +40: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a delta-seconds Retry-After parses
00:02 +41: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an ABSENT header yields null — and does not throw
00:02 +42: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a GARBAGE header yields null — and does not throw
00:02 +43: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:02 +44: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:02 +45: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:02 +46: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:02 +47: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome 502 with a null body → ApiException(502, unknown)
00:02 +48: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome 502 with an empty string → ApiException(502, unknown)
00:02 +49: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome 502 with a proxy HTML page → ApiException(502, unknown)
00:02 +50: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome 502 with a JSON list → ApiException(502, unknown)
00:02 +51: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome 502 with a map without a code → ApiException(502, unknown)
00:02 +52: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome 502 with a map with a non-string code → ApiException(502, unknown)
00:02 +53: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome a bodyless 401 stays UnauthorizedException, code unknown
00:02 +54: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: a non-2xx without a parsable ProblemDetails is an unknown outcome a bodyless 400 is NOT a ValidationException, code unknown
00:02 +55: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:02 +56: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:02 +57: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:02 +58: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:02 +59: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:02 +60: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:02 +61: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:02 +62: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:02 +63: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:02 +64: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:02 +65: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:02 +66: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:02 +67: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:02 +68: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:03 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:03 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:03 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:03 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on /login/otp → stay (the success view shows)
00:03 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:03 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:03 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:03 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:03 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:03 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:03 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:03 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
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
00:05 +125: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +126: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +127: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +128: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +129: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +130: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +131: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +132: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +133: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +134: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +135: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +136: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +137: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +138: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +139: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +140: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +141: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +142: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +143: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +144: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +145: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +146: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +147: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +148: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +149: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +150: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +151: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +152: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +153: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +154: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +155: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +156: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +157: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +158: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +159: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +160: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +161: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +162: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +163: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +164: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +165: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card settings sections and their two back-lights
00:05 +166: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:05 +167: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card the two track cards carry two different Glass angles
00:05 +168: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: API→UI Wave 22 — flashcards the card is one INNER shadow, the same on both canvases
00:05 +169: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: API→UI Wave 22 — flashcards it is wired through copyWith and lerp
00:05 +170: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:05 +171: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:05 +172: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:05 +173: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism the onboarding sheet is the ONLY light Glass
00:05 +174: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every dark surface that Figma glassed has a token
00:05 +175: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every back-light is dark-only and takes the palette colour
00:05 +176: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places props covers every field
00:05 +177: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the extension is wired in all four places copyWith round-trips, and leaves the others alone
00:05 +178: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +179: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +180: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +181: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +182: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +183: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:05 +184: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:05 +185: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:06 +186: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:06 +187: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:06 +188: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:06 +189: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:06 +190: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:06 +191: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:06 +192: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: a text takes its first strong character's direction, else the app's
00:06 +193: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: it is the quiz question's rule, exactly
00:07 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:07 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:08 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:08 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a BackdropFilter exists only when sigma > 0
00:08 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a BackdropFilter exists only when sigma > 0
00:08 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: knockout — edit1.md R4 an offset with no blur lands on the offset side only
00:08 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:08 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:08 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:08 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:08 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses stadium
00:08 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:08 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:08 +209: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:08 +210: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:08 +211: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +212: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +213: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +214: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +215: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +216: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +217: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:08 +218: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:08 +219: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:08 +220: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:08 +221: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:08 +222: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog system back still pops it, and returns its value
00:08 +223: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog system back still pops it, and returns its value
00:08 +224: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink no onTap means no InkWell at all
00:08 +225: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +226: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +227: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +228: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +229: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +230: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +231: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +232: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +233: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:08 +234: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +235: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +236: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +237: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +238: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +239: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +240: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:09 +241: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +242: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +243: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +244: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +245: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +246: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +247: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:09 +248: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:10 +249: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:10 +250: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:10 +251: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:10 +252: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:10 +253: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:10 +254: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +255: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +256: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +257: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +258: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +259: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +260: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +261: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +262: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +263: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +264: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +265: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +266: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +267: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +268: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +269: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:10 +270: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +271: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +272: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +273: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +274: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:10 +275: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +276: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +277: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +278: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +279: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +280: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +281: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +282: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +283: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +284: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +285: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +286: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +287: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +288: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +289: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +290: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +291: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +292: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +293: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +294: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +295: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +296: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +297: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +298: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +299: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +300: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +301: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +302: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +303: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +304: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +305: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +306: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +307: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +308: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +309: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +310: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +311: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +312: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:11 +313: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +314: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +315: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light · the error state keeps its own 1.5
00:11 +316: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +317: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +318: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +319: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +320: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +321: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +322: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +323: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +324: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +325: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +326: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +327: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +328: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +329: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +330: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +331: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +332: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +333: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +334: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +335: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:11 +336: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:11 +337: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:11 +338: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:11 +339: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:11 +340: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:11 +341: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:11 +342: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:11 +343: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:11 +344: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:11 +345: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:11 +346: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:11 +347: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:11 +348: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:11 +349: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:12 +350: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:12 +351: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:12 +352: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:12 +353: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:12 +354: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:12 +355: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:12 +356: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:12 +357: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:12 +358: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:12 +359: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:12 +360: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:12 +361: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:12 +362: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:12 +363: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:12 +364: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +365: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +366: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +367: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +368: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +369: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +370: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +371: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:12 +372: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader Arabic mirrors the ✕: 16 from the right edge
00:12 +373: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:12 +374: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:12 +375: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:12 +376: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:12 +377: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:12 +378: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:12 +379: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:12 +380: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:12 +381: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:12 +382: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:12 +383: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:12 +384: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:12 +385: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:12 +386: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:12 +387: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +388: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +389: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +390: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +391: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +392: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +393: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +394: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +395: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:12 +396: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +397: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +398: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +399: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +400: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +401: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +402: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +403: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +404: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:13 +405: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:14 +406: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:15 +407: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +408: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +409: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +410: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +411: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +412: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +413: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +414: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +415: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +416: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +417: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +418: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +419: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:16 +420: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:16 +421: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:16 +422: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:16 +423: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:16 +424: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:16 +425: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:16 +426: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:16 +427: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:16 +428: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:17 +429: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:17 +430: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +431: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +432: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +433: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +434: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +435: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +436: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +437: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +438: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +439: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +440: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +441: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +442: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
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
00:17 +462: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:17 +463: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:17 +464: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +465: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +466: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +467: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +468: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +469: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +470: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +471: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +472: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +473: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +474: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +475: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +476: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +477: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +478: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +479: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +480: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +481: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
unhandled element <filter/>; Picture key: Svg loader
00:19 +482: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +483: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +484: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +485: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +486: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +487: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +488: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +489: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +490: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +491: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +492: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +493: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +494: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +495: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +496: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +497: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +498: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +499: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +500: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +501: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +502: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +503: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +504: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +505: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +505: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:19 +506: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +507: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +508: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +509: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:19 +510: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +511: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +512: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +513: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +514: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +515: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +516: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:21 +517: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +518: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +519: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +520: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +521: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +522: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:23 +523: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:23 +524: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:23 +525: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:23 +526: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +527: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +528: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +529: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +530: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +531: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:25 +532: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:25 +533: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:25 +534: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:25 +535: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +536: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +537: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +538: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +539: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +540: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +541: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +542: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +543: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +544: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +545: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +546: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +547: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +548: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +549: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +550: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +551: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +552: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +553: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +554: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +555: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +556: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +557: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +558: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +559: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +560: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +561: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +562: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +563: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +564: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +565: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +566: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +567: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +568: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +569: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +570: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +571: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:27 +572: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +573: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +574: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +575: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +576: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +577: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +578: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +579: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +580: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +581: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:27 +582: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +583: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +584: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +585: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +586: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +587: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +588: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +589: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +590: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +591: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +592: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +593: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +594: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:28 +595: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:28 +596: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:28 +597: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:28 +598: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:28 +599: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:28 +600: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
00:28 +601: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
00:28 +602: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
00:28 +603: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:28 +604: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:28 +605: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:29 +606: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:29 +607: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:29 +608: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:29 +609: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +610: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +611: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +612: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +613: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +614: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +615: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +616: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +617: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:29 +618: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search a query that matches nothing shows its own message
00:29 +619: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:29 +620: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:30 +621: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Arabic walks the same path under RTL
00:30 +622: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +623: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +624: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +625: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +626: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +627: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +628: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +629: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +630: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +631: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +632: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +633: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +634: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +635: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +636: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +637: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +638: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:30 +639: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +640: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +641: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +642: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +643: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +644: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +645: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +646: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +647: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +648: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +649: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +650: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +651: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +652: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +653: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +654: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +655: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +656: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +657: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +658: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +659: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +660: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +661: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +662: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +663: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +664: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +665: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +666: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +667: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +668: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +669: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +670: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +671: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +672: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +673: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:31 +674: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:31 +675: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:31 +676: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:31 +677: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:31 +678: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +679: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +680: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +681: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +682: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +683: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +684: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +685: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +686: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +687: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +688: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +689: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +690: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +691: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +692: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +693: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +694: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +695: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +696: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:32 +697: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +698: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +699: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +700: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +701: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +702: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +703: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +704: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +705: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:32 +706: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:33 +707: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:33 +708: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:33 +709: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:33 +710: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +711: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +712: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +713: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +714: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +715: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +716: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +717: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +718: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +719: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +720: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +721: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +722: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +723: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +724: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +725: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +726: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +727: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +728: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +729: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +730: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +731: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +732: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +733: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +734: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:33 +735: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:34 +736: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:34 +737: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:34 +738: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:34 +739: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:34 +740: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +741: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +742: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +743: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +744: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +745: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +746: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +747: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +748: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +749: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +750: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +751: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +752: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +753: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +754: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +755: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +756: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:34 +757: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:35 +758: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:35 +759: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:35 +760: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:35 +761: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
00:35 +762: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
00:35 +763: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
00:35 +764: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +765: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +766: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +767: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +768: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +769: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +770: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:35 +771: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:36 +772: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:36 +773: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:36 +774: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:36 +775: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
00:36 +776: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +777: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +778: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +779: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +780: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +781: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +782: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +783: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +784: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +785: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +786: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +787: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +788: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +789: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +790: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +791: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +792: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +793: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +794: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +795: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +796: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +797: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +798: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +799: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +800: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +801: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:36 +802: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +803: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +804: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +805: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +806: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +807: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +808: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +809: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +810: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +811: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +812: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +813: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +814: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +815: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +816: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +817: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +818: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +819: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +820: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +821: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +822: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +823: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +824: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +825: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:37 +826: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:37 +827: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:37 +828: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:37 +829: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:37 +830: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: geometry against the frame (402 wide) the helper is start-aligned, in AR too
00:37 +831: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) university reads the board the tab opens on: global
00:37 +832: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) university reads the board the tab opens on: global
00:37 +833: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading light: the failure line reads on the canvas it is drawn on
00:37 +834: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +835: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +836: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +837: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +838: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +839: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +840: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:37 +841: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:37 +842: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:37 +843: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:37 +844: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:37 +845: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:38 +846: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries lectureId, name, subject and the DEFAULT quiz type
00:38 +847: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: light and dark dark reuses the quiz setup's scope colours
00:38 +848: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading tapping again retries, and a success clears the line and advances
00:38 +849: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading tapping again retries, and a success clears the line and advances
00:38 +850: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading tapping again retries, and a success clears the line and advances
00:38 +851: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading tapping again retries, and a success clears the line and advances
00:38 +852: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +853: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +854: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +855: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +856: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +857: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +858: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +859: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +860: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +861: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +862: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +863: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the /quiz/setup hand-off carries the SELECTED quiz type
00:38 +864: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +865: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +866: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +867: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +868: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +869: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +870: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +871: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +872: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +873: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +874: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +875: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +876: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +877: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +878: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +879: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +880: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:38 +881: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +882: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +883: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +884: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +885: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +886: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +887: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +888: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +889: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +890: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +891: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +892: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +893: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +894: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +895: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +896: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +897: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +898: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +899: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +900: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:39 +901: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +902: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +903: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +904: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +905: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +906: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +907: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +908: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +909: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +910: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +911: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +912: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +913: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:39 +914: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +915: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +916: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +917: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +918: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +919: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +920: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +921: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +922: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +923: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +924: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +925: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +926: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +927: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +928: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +929: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +930: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +931: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +932: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +933: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +934: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +935: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +936: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +937: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +938: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +939: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +940: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +941: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +942: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +943: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +944: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:40 +945: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +946: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +947: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +948: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +949: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +950: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +951: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +952: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +953: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +954: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:41 +955: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:41 +956: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:41 +957: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:41 +958: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:41 +959: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:41 +960: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +961: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +962: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +963: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +964: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +965: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +966: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +967: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) Learn → subject → Flashcard tab → lecture → Setup → Start → study, and back the same way
00:42 +968: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +969: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +970: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +971: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +972: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +973: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +974: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +975: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +976: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:42 +977: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +978: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +979: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +980: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +981: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +982: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +983: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +984: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +985: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +986: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +987: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +988: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +989: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +990: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +991: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +992: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:43 +993: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +994: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +995: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +996: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +997: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +998: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +999: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1000: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1001: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1002: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1003: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1004: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1005: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1006: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1007: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1008: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1009: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1010: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1011: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1012: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1013: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1014: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1015: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1016: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1017: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1018: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1019: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:44 +1020: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:44 +1021: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1022: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1023: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1024: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1025: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1026: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1027: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1028: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1029: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1030: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1031: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1032: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1033: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1034: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:45 +1035: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1036: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1037: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1038: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1039: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1040: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1041: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1042: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:45 +1043: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1044: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1045: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1046: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1047: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1048: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1049: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1050: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1051: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1052: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1053: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1054: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1055: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1056: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1057: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1058: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1059: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1060: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1061: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1062: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1063: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:46 +1064: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:46 +1065: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:46 +1066: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:46 +1067: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:46 +1068: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me — the hub already fetched it
00:46 +1069: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:46 +1070: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:46 +1071: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES — the frames write "1 questions"
00:46 +1072: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1073: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1074: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1075: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1076: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1077: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1078: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1079: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1080: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1081: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1082: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1083: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1084: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1085: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1086: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1087: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1088: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1089: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1090: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1091: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1092: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1093: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1094: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1095: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:47 +1096: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1097: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1098: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1099: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1100: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1101: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1102: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:48 +1103: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1104: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1105: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1106: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1107: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1108: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1109: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1110: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1111: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1112: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1113: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1114: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1115: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1116: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1117: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1118: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1119: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1120: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1121: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1122: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1123: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1124: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1125: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1126: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1127: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:49 +1128: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:50 +1129: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:50 +1130: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:50 +1131: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:50 +1132: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:50 +1133: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:50 +1134: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:50 +1135: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:50 +1136: F:/level/level_up/level_up_app/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:50 +1137: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form CLEARED: emptying the box sends the key with an explicit null
00:50 +1138: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form CLEARED: emptying the box sends the key with an explicit null
00:50 +1139: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:50 +1140: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:50 +1141: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:50 +1142: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:50 +1143: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:50 +1144: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1145: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1146: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1147: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1148: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1149: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1150: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1151: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1152: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1153: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1154: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1155: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1156: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1157: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1158: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1159: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1160: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1161: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1162: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1163: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1164: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1165: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1166: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1167: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1168: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1169: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1170: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1171: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1172: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1173: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1174: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1175: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1176: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1177: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1178: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1179: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1180: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1181: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1182: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1183: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1184: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1185: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1186: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1187: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1188: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1189: F:/level/level_up/level_up_app/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1190: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
00:52 +1191: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1192: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1193: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1194: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1195: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1196: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1197: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1198: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1199: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1200: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1201: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1202: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1203: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1204: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1205: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1206: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1207: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1208: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1209: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1210: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1211: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1212: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1213: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1214: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1215: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1216: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1217: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1218: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1219: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:52 +1220: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:52 +1221: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:52 +1222: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:52 +1223: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:52 +1224: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:52 +1225: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:52 +1226: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent a failed load offers a Retry
00:52 +1227: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent a failed load offers a Retry
00:52 +1228: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1229: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1230: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1231: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1232: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1233: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1234: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1235: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1236: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1237: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1238: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1239: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1240: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:53 +1241: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1242: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1243: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1244: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1245: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1246: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1247: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1248: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1249: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Upload photo is present and genuinely non-interactive
00:54 +1267: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1268: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1269: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1270: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1271: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1272: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1273: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1274: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1275: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1276: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1277: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1278: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1279: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1280: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1281: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1282: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1283: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1284: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1285: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1286: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1287: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1288: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1289: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1290: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1291: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1292: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1293: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1294: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1295: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1296: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1297: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1298: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:54 +1299: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:55 +1300: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:55 +1301: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:55 +1302: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +1303: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +1304: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +1305: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +1306: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +1307: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:55 +1308: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1309: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1310: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1311: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1312: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1313: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1314: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1315: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1316: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1317: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:56 +1318: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1319: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1320: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1321: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1322: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1323: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1324: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1325: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1326: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:57 +1327: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +1328: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +1329: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +1330: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +1331: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +1332: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:57 +1333: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +1334: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +1335: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +1336: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +1337: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +1338: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:58 +1339: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1340: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1341: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1342: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1343: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1344: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1345: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1346: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1347: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1348: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1349: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:58 +1350: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1351: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1352: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1353: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1354: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1355: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1356: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1357: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1358: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1359: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1360: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1361: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1362: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1363: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1364: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1365: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:59 +1366: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states a quiz finished with ZERO answers is all skipped
00:59 +1367: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back with no subject in hand, the scope stands alone
00:59 +1368: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: en at 1.3x nothing overflows, the rows grow and the count stays under the name
00:59 +1369: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: en at 1.3x nothing overflows, the rows grow and the count stays under the name
00:59 +1370: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: en at 1.3x nothing overflows, the rows grow and the count stays under the name
00:59 +1371: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: en at 1.3x nothing overflows, the rows grow and the count stays under the name
00:59 +1372: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:00 +1373: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:00 +1374: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:00 +1375: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Discard" leaves
01:00 +1376: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1377: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1378: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1379: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1380: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1381: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1382: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1383: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1384: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1385: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1386: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1387: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1388: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1389: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1390: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1391: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1392: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: filtering Correct and Wrong partition, and never renumber a row
01:00 +1393: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1394: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1395: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1396: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1397: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1398: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1399: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1400: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1401: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1402: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: ar at 2.0x nothing overflows, the rows grow and the count stays under the name
01:01 +1403: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: ar at 2.0x nothing overflows, the rows grow and the count stays under the name
01:01 +1404: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:01 +1405: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1406: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1407: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1408: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1409: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1410: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1411: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1412: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) light: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:01 +1413: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) light: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:01 +1414: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) light: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:01 +1415: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
01:02 +1416: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row follows the canvas now, because its fill does
01:02 +1417: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:02 +1418: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:02 +1419: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:02 +1420: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
01:02 +1421: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1422: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1423: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1424: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1425: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1426: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1427: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1428: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1429: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
01:02 +1430: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1431: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1432: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1433: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1434: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1435: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:02 +1436: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:02 +1437: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:02 +1438: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
01:02 +1439: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
01:02 +1440: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
01:02 +1441: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) the rows take the frame geometry of 404:6697 here too
01:02 +1442: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
01:02 +1443: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:03 +1444: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:03 +1445: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:03 +1446: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:03 +1447: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
01:03 +1448: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) each chapter row is ONE button node with the whole label
01:03 +1449: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined light: every bucket has a shadow and no hairline
01:03 +1450: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the avatar block (176:1343 · 176:1346) the disc is the frame's radial gradient under the image
01:03 +1451: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 422 not_enough_questions is inline and NEVER silently retried
01:03 +1452: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
01:03 +1453: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1454: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1455: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1456: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1457: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1458: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1459: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1460: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1461: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1462: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1463: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1464: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1465: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1466: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1467: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1468: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz 403 limit opens the same paywall sheet
01:03 +1469: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
01:03 +1470: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 weekly_question_limit_reached opens the sheet, WEEKLY copy
01:03 +1471: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the locked rows follow the frames (owner ruling, #105) university (180:6349): Phone, Faculty, Academic Year, City, University name
01:03 +1472: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
01:04 +1473: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
01:04 +1474: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
01:04 +1475: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) a mid-quiz account_pending_deletion shows the copy and NO Retry
01:04 +1476: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
01:04 +1477: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
01:04 +1478: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
01:04 +1479: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
01:04 +1480: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
01:04 +1481: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
01:04 +1482: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1483: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1484: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1485: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1486: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1487: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1488: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1489: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1490: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1491: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1492: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1493: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1494: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1495: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1496: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1497: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1498: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1499: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: screenshot protection is OFF again once it is popped
01:04 +1500: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1501: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1502: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1503: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1504: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1505: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1506: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards card is radius 15 and carries the star disc
01:04 +1507: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1508: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1509: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1510: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1511: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1512: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1513: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1514: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1515: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1516: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1517: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1518: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1519: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1520: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1521: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1522: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1523: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1524: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1525: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation is not offered when the server says there is none
01:04 +1526: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
01:04 +1527: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
01:04 +1528: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the review path consumes nothing and persists nothing calls no endpoint
01:04 +1529: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the review path consumes nothing and persists nothing calls no endpoint
01:04 +1530: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
01:04 +1531: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states a request in flight shows a spinner and blocks a second tap
01:04 +1532: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: AI explanation 202 → poll → 200 renders the text, in ONE section
01:05 +1533: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
01:05 +1534: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
01:05 +1535: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1536: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1537: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1538: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1539: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1540: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1541: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1542: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1543: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1544: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1545: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1546: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1547: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1548: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1549: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1550: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1551: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1552: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1553: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1554: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1555: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1556: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1557: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1558: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1559: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1560: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1561: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1562: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1563: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1564: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1565: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1566: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
01:05 +1567: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
01:05 +1568: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
01:05 +1569: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
01:05 +1570: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:05 +1571: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:06 +1572: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:06 +1573: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:06 +1574: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:06 +1575: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:06 +1576: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) dark: the list starts 25 under the header, rows 16 apart, each 78 tall
01:06 +1577: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: states matrix an Arabic error is localized
01:06 +1578: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1579: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1580: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1581: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1582: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1583: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1584: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1585: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1586: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1587: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (API→UI Wave 13)
01:06 +1588: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) Arabic: the ✕ mirrors to 27 from the card's right
01:06 +1589: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) dark header: cream title over the same rule
01:06 +1590: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
01:06 +1591: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
01:06 +1592: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
01:06 +1593: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) the rows take the frame geometry of 404:6782, with no chevron
01:06 +1594: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) the strip starts 21 in and 24 under the bar, and every cell is the gradient disc
01:06 +1595: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 · 216:3341 · 180:4153) the picker (180:4153) the strip starts 21 in and 24 under the bar, and every cell is the gradient disc
01:06 +1596: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
01:06 +1597: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the length chips are raised, not outlined selecting one swaps the fill without changing the shape
01:06 +1598: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: "Correct" and "Wrong" lead with the frame's 16 discs, 10 before the label
01:07 +1599: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1600: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1601: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1602: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1603: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1604: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) en: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1605: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1606: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1607: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1608: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1609: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1610: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1611: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:07 +1612: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1613: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1614: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) ar: every lesson row is inert — no chevron, no tap handler, and a tap goes nowhere
01:07 +1615: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: exit guard closing asks first — progress cannot be lost silently
01:07 +1616: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: exit guard closing asks first — progress cannot be lost silently
01:07 +1617: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:07 +1618: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1619: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1620: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1621: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1622: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1623: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1628: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1629: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1630: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1631: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1632: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1633: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1634: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1635: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:08 +1636: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1637: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1638: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1639: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1640: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1641: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1642: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1643: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1644: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1645: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1646: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1647: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1648: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1649: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1650: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1651: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1652: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1653: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1654: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1655: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1656: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1657: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1658: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1659: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1660: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1661: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1662: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1663: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1664: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1665: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1666: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1667: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1668: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1669: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:09 +1670: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1671: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1672: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1673: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1674: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1675: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1676: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1677: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1678: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1679: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1680: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:10 +1681: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:11 +1682: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:11 +1683: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:11 +1684: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:11 +1685: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:11 +1686: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:11 +1687: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) dark: the page-fill card and a light ✕
01:11 +1688: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) invalid parent phone blocks Continue
01:11 +1689: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) invalid parent phone blocks Continue
01:11 +1690: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1691: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1692: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1693: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1694: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1695: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1696: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1697: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1698: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1699: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1700: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:11 +1701: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1702: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1703: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1704: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1705: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1706: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1707: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1708: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:12 +1709: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1710: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1711: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1712: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1713: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1714: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1715: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1716: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:13 +1717: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:13 +1718: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:13 +1719: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:14 +1720: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:14 +1721: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:14 +1722: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:14 +1723: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1724: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1725: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1726: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1727: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1728: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1729: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1730: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1731: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1732: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1733: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1734: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1735: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:14 +1736: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:15 +1737: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1738: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1739: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1740: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1741: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1742: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1743: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1744: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1745: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1746: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1747: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1748: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1749: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1750: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1751: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1752: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1753: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:15 +1754: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1755: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1756: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1757: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1758: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1759: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1760: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:16 +1761: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1762: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1763: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1764: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1765: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1766: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1767: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:16 +1768: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:17 +1769: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:17 +1770: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar → heading, heading → control, control → heading: 25
01:17 +1771: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1772: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1773: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1774: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1775: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1776: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1777: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1778: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1779: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:17 +1780: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:17 +1781: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:17 +1782: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:17 +1783: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:17 +1784: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:17 +1785: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink …and in Arabic on the right edge (549:21816)
01:17 +1786: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder adds no request of its own — /me is still fetched once
01:18 +1787: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder adds no request of its own — /me is still fetched once
01:18 +1788: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:18 +1789: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:18 +1790: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
01:18 +1791: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1792: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1793: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1794: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1795: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1796: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1797: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1798: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1799: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
01:18 +1800: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:18 +1801: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:18 +1802: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:18 +1803: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1804: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1805: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1806: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1807: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1808: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1809: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1810: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1811: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1812: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1813: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1814: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1815: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1816: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1817: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1818: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1819: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1820: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:19 +1821: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1822: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1823: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1824: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1825: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1826: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1827: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1828: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1829: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1830: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1831: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1832: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1833: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1834: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:20 +1835: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1836: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1837: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1838: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1839: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1840: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1841: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:20 +1842: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
01:20 +1843: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
01:20 +1844: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data /friends has nothing to type into and nothing to list
01:21 +1845: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1846: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1847: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1848: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1849: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1852: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:21 +1853: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: the glyph never takes the accent — it goes grey to white
01:21 +1854: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1855: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1856: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1857: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1858: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1859: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1860: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1861: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
01:21 +1862: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:21 +1863: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:22 +1864: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:22 +1865: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:22 +1866: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:22 +1867: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:22 +1868: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:22 +1869: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) the status bar follows the canvas
01:22 +1870: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:22 +1871: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:22 +1872: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:22 +1873: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:22 +1874: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track tapping a segment still switches the locale
01:22 +1875: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track tapping a segment still switches the locale
01:22 +1876: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:23 +1877: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:23 +1878: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:23 +1879: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:23 +1880: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:23 +1881: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:23 +1882: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:23 +1883: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:23 +1884: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:23 +1885: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:23 +1886: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:23 +1887: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:23 +1888: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:23 +1889: F:/level/level_up/level_up_app/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:24 +1890: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1891: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1892: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1893: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1894: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1895: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1896: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1897: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1898: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1899: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1900: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1901: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: level card · light
01:24 +1902: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:24 +1903: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:24 +1904: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:24 +1905: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:24 +1906: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:25 +1907: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1908: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1909: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1910: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1911: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1912: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1913: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:25 +1914: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:25 +1915: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:25 +1916: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:25 +1917: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:25 +1918: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:25 +1919: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:26 +1920: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:26 +1921: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:26 +1922: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:26 +1923: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:26 +1924: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:26 +1925: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:26 +1926: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:26 +1927: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:26 +1928: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:26 +1929: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:26 +1930: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:26 +1931: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:27 +1932: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:27 +1933: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1934: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1935: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1936: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1937: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1938: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1939: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1940: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1941: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1942: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1943: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1944: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1945: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface · light
01:27 +1946: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1947: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1948: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1949: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1950: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1951: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1952: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1953: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1954: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1955: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1956: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1957: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1958: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1959: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1960: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1961: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1962: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1963: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1964: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:27 +1965: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1966: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1967: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1968: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1969: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1970: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1971: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1972: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:28 +1973: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: (setUpAll)
01:28 +1973: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:28 +1974: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:28 +1975: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: Bloc stays inside the quiz feature
01:28 +1976: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:28 +1977: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:28 +1978: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:28 +1979: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 2 selected
01:28 +1980: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: user-facing copy goes through AppLocalizations no NEW file introduces a hardcoded string
01:28 +1981: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 3 selected
01:28 +1982: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: user-facing copy goes through AppLocalizations the count does not grow
01:28 +1983: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:28 +1984: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 4 selected
01:28 +1985: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
01:28 +1986: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:28 +1987: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 0 selected
01:29 +1988: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: no glyph is swapped for its mirror image
01:29 +1989: F:/level/level_up/level_up_app/test/guards/rules_test.dart: stripComments — the primitive everything else depends on removes line comments
01:29 +1990: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1991: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1992: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1993: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1994: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1995: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1996: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1997: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1998: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +1999: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +2000: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +2001: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +2002: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +2003: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 1 selected
01:29 +2004: F:/level/level_up/level_up_app/test/guards/rules_test.dart: async providers opt out of the automatic retry a retry: that belongs to the NEXT declaration does not count
01:29 +2005: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2006: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2007: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2008: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2009: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2010: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2011: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2012: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2013: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2014: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2015: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2016: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2017: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2018: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2019: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2020: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2021: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2022: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2023: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2024: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2025: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:29 +2026: F:/level/level_up/level_up_app/test/guards/rules_test.dart: ARB key drift ignores @-metadata entries
01:29 +2027: F:/level/level_up/level_up_app/test/guards/rules_test.dart: ARB key drift agrees when both sides match
01:29 +2028: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2029: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2030: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2031: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2032: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2033: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2034: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2035: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2036: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2037: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2038: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2039: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2040: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2041: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 3 selected
01:29 +2042: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping the field each class DOES declare still resolves
01:29 +2043: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2044: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2045: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2046: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2047: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2048: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2049: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2050: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2051: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2052: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2053: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:29 +2054: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: (tearDownAll)
01:29 +2054: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a failing run reports its failures — the 2026-09-12 defect
01:29 +2055: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a passing run still reports its skipped tests
01:29 +2056: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a clean run with neither skips nor failures
01:29 +2057: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly failures without skips — the shape the old parser did handle
01:29 +2058: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly the final tally wins, not the first
01:29 +2059: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a "+N" inside test output is not mistaken for a tally
01:29 +2060: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the POSIX twin parses the same shape validate.sh captures the skipped counter
01:29 +2061: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the POSIX twin parses the same shape validate.sh anchors its counter read on the timestamp
01:29 +2062: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the POSIX twin parses the same shape both scripts surface the skipped count in their summary
01:29 +2063: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the gate is not the exit code alone validate.ps1 fails on an unparseable tally
01:29 +2064: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the gate is not the exit code alone validate.ps1 requires the reporter to have finished
01:29 +2065: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the gate is not the exit code alone validate.sh applies the same three extra failure conditions
01:29 +2066: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
01:29 +2067: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI runs the whole suite minus goldens, and the goldens by tag
01:29 +2068: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests every golden test file carries the golden tag
01:29 +2069: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth .flutter-version exists and is a plain version
01:29 +2070: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth CI reads the pin from the file rather than hardcoding it
01:29 +2071: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact the main manifest declares INTERNET
01:29 +2072: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact CI still inspects the built artefact, not just the source
01:29 +2073: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
01:29 +2074: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
01:30 +2075: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
01:30 +2076: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the coherence rule itself fires on each kind of bad command
01:30 +2077: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical both validate scripts exist
01:30 +2078: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical the pre-push hook reuses validate.sh instead of its own checks
01:30 +2079: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical PowerShell scripts are pure ASCII
01:30 +2080: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical every shell script that batches files is NUL-safe
01:30 +2081: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
01:30 +2082: All tests passed!
```

