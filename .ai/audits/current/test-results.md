# Validation run - 2026-10-06T00:53:59Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 322 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 2059 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-10-06T00:53:59Z - finished 2026-10-06T00:59:29Z

---

## 1. Environment

```text
started (UTC)  : 2026-10-06T00:53:59Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 3913f86
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 ΓÇó channel stable ΓÇó https://github.com/flutter/flutter.git
Framework ΓÇó revision 84fc5cbb22 (3 months ago) ΓÇó 2026-07-17 10:20:17 -0700
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
checking 322 hand-written Dart files

Formatted 60 files (0 changed) in 0.35 seconds.
Formatted 60 files (0 changed) in 0.38 seconds.
Formatted 60 files (0 changed) in 0.34 seconds.
Formatted 60 files (0 changed) in 0.42 seconds.
Formatted 60 files (0 changed) in 0.61 seconds.
Formatted 22 files (0 changed) in 0.14 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing level_up_app...                                       
No issues found! (ran in 28.3s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**2059 passed, 0 failed, 0 skipped** (exit 0)


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
00:01 +7: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: (setUpAll)
00:01 +7: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion recognises the code
00:01 +8: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion does not confuse it with the OTHER 403 the same routes answer
00:01 +9: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion ignores transport failures and non-API errors
00:01 +10: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion matches on the code, so a subclass is recognised too
00:01 +11: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz ΓÇö all four quiz endpoints share one helper
00:01 +12: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz ΓÇö the existing codes are untouched
00:01 +13: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile ΓÇö PATCH /me is NOT on the allowlist, only GET /me is
00:01 +14: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile ΓÇö offline still outranks it, and validation still works
00:01 +15: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for a pending deletion
00:01 +16: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for quiz_already_finished too
00:01 +17: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry leaves every other failure retryable
00:01 +18: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: suppressesRetry is not the same question as opensLimitSheet
00:01 +19: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: the copy itself exists in both locales and is not the generic message
00:01 +20: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: the copy itself is purchase-silent (adr-049 ┬º3)
00:01 +21: F:/level/level_up/level_up_app/test/core/network/account_pending_deletion_test.dart: (tearDownAll)
00:02 +21: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: authentication_required ΓåÆ refresh once ΓåÆ original retried ΓåÆ success
00:02 +22: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded ΓåÆ forceLogout(superseded), cleared, no refresh
00:02 +23: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh ΓåÆ refresh_token_invalid ΓåÆ forceLogout(sessionExpired)
00:02 +24: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s ΓåÆ refresh called exactly once, all retried
00:02 +25: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again ΓåÆ not refreshed/retried a 2nd time
00:02 +26: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh ΓåÆ NO logout, surfaces the network error
00:03 +27: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException carries the ProblemDetails field map
00:03 +28: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException is still an ApiException (existing handlers keep working)
00:03 +29: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a missing/malformed errors map yields empty fields, not a crash
00:03 +30: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 400 validation_failed ΓåÆ ValidationException a non-list value is tolerated as a single message
00:03 +31: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:03 +32: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 ΓåÆ UnauthorizedException carrying the code
00:03 +33: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 ΓåÆ ApiException carrying status + code
00:03 +34: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error ΓåÆ NetworkException (drives Offline)
00:03 +35: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException is typed, and is NOT otp_throttled
00:03 +36: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a delta-seconds Retry-After parses
00:03 +37: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an ABSENT header yields null ΓÇö and does not throw
00:03 +38: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a GARBAGE header yields null ΓÇö and does not throw
00:03 +39: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:03 +40: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 429 rate_limited ΓåÆ RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:03 +41: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:03 +42: F:/level/level_up/level_up_app/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:04 +43: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:04 +44: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:04 +45: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:04 +46: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:04 +47: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:04 +48: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:04 +49: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:04 +50: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:04 +51: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:04 +52: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:04 +53: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:04 +54: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:04 +55: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too ΓÇö one path, not two
00:04 +56: F:/level/level_up/level_up_app/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:06 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route ΓåÆ /login
00:06 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route ΓåÆ stay
00:06 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:06 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on /login/otp ΓåÆ stay (the success view shows)
00:06 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login ΓåÆ /home
00:06 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / ΓÇö onboarding must be reachable
00:06 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / ΓåÆ /home, never the onboarding pitch
00:06 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / ΓåÆ wait; do not flash onboarding then bounce
00:06 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route ΓåÆ stay
00:06 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) ΓåÆ wait, never redirect
00:06 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +69: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +70: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +71: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +72: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +73: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +74: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +75: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +76: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +77: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +78: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +79: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +80: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +81: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +82: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +83: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +84: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +85: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +86: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +87: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +88: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +89: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +90: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +91: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +92: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +93: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +94: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +95: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:11 +96: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: the OTP stopwatch export is stroked in the light otpTimerContent
00:11 +97: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: OTP timer content and error state timer content: #384F47 light, cream dark (82:1316 / 337:19503)
00:11 +98: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: OTP timer content and error state error line #FF465C and cell stroke #EB001B@50%, both canvases
00:11 +99: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: OTP timer content and error state copyWith and lerp carry the three tokens
00:11 +100: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the dark canvas washes at 20%, it does not paint an opaque card
00:11 +101: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the three dark surfaces that are deliberately OPAQUE
00:11 +102: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces light values are the frames, not a reuse of an old token
00:11 +103: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the five light-only borders are null in dark, not a fallback
00:11 +104: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces otpCardGlow is dark-only, and is the OTP card shadow colour
00:11 +105: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces the tokens that must NOT flip with the canvas
00:11 +106: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: elevation-pass surfaces every new token is wired through copyWith and lerp
00:11 +107: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle the three review-row fills: light opaque, dark at the frame's 20%
00:11 +108: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle the wrong row keeps the SHIPPED hue, not the review frame's drift
00:11 +109: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle quizReviewRowContent stopped being canvas-independent, and had to
00:11 +110: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle the previous-button glyph is cream on BOTH canvases
00:11 +111: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle the light selected scope fill is #DBB0FF ΓÇö the re-read value
00:11 +112: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle the idle scope label is a dark GREEN, not textSecondary grey
00:11 +113: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle the badge ring took the frame's lavender without moving the shared token
00:11 +114: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: edit4 ΓÇö quiz review rows, prev button, scope toggle every edit4 token is wired through copyWith and lerp
00:11 +115: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 20 avatar tokens the frames' values in both palettes
00:11 +116: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 20 avatar tokens every one is wired through copyWith and lerp
00:11 +117: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 21 Settings tokens the frames' values in both palettes
00:11 +118: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 21 Settings tokens every one is wired through copyWith and lerp
00:11 +119: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the designed values, light and dark
00:11 +120: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the grade-failure line is composed from existing error colours, not from the quiz's dark red
00:11 +121: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the grade-failure line reads on its own canvas: 4.5:1 for body text
00:11 +122: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens the dark values with no frame are named stand-ins, not inventions
00:11 +123: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Wave 22 Flashcards tokens every one is wired through copyWith and lerp
00:11 +124: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: all three brand assets landed
00:11 +125: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion kFigmaBlurToSigma is the CSS definition, not a tunable
00:11 +126: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion sigma is NOT what BoxShadow would have produced
00:11 +127: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: the blur conversion frost converts with its own constant
00:11 +128: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration nav bar: the two canvases differ in colour AND blur
00:11 +129: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration the three CTA tokens
00:11 +130: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration back chip: light shadow, dark Glass ΓÇö not a missing shadow
00:11 +131: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration the registration back chip is a different Glass from G5
00:11 +132: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration language pill: G3 differs from G5 only in lightIntensity
00:11 +133: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration form fields: G4, and the 0.03 hairline kept verbatim
00:11 +134: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration onboarding sheet: the only Glass in the light frames
00:11 +135: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit2 ΓÇö shell, auth, onboarding, registration scrims: five frames, five readings
00:11 +136: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes level card: light shadow, dark Glass plus a back-light
00:11 +137: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes daily tasks: G7, and two differently sized back-lights
00:11 +138: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes top student: same border width on both canvases
00:11 +139: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes continue learning: two shadows, one with a negative spread
00:11 +140: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes subjects search: the file's only 10% shadows
00:11 +141: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes subject card: identical on both canvases ΓÇö this is #34's proof
00:11 +142: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes mistakes pill and card
00:11 +143: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit3 ΓÇö home, catalog, mistakes the segmented pill track inverts its inner shadow when selected
00:11 +144: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard the five near-identical small shadows stay five tokens
00:11 +145: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard length chips, AI panel and leaderboard list keep dark shadows
00:11 +146: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard AI panel: G18 outside, G5 inside, one back-light
00:11 +147: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard quiz previous button: G13 confirms the angle convention
00:11 +148: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard result buckets, rewards card and star disc
00:11 +149: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard the scope toggle is the file's only white inner shadow
00:11 +150: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit4 ΓÇö quiz, result, review, leaderboard a leaderboard row carries two different Glass effects
00:11 +151: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card profile header, edit chip and stat card keep a dark shadow
00:11 +152: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card avatar badge
00:11 +153: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card settings sections and their two back-lights
00:12 +154: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:12 +155: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: edit5 ΓÇö profile, settings, OTP, track card the two track cards carry two different Glass angles
00:12 +156: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: APIΓåÆUI Wave 22 ΓÇö flashcards the card is one INNER shadow, the same on both canvases
00:12 +157: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: APIΓåÆUI Wave 22 ΓÇö flashcards it is wired through copyWith and lerp
00:12 +158: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 ΓÇö the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:12 +159: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 ΓÇö the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:12 +160: F:/level/level_up/level_up_app/test/core/theme/app_elevation_test.dart: #34 ΓÇö the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:12 +161: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +162: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +163: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +164: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +165: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +166: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +167: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +168: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +169: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +170: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +171: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:12 +172: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:12 +173: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:13 +174: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:13 +175: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:13 +176: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:13 +177: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:13 +178: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:13 +179: F:/level/level_up/level_up_app/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:14 +180: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: a text takes its first strong character's direction, else the app's
00:14 +181: F:/level/level_up/level_up_app/test/core/widgets/content_text_direction_test.dart: it is the quiz question's rule, exactly
00:15 +182: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:17 +183: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a scrim supplies the barrier colour
00:17 +184: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a BackdropFilter exists only when sigma > 0
00:17 +185: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:17 +186: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:17 +187: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:17 +188: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:17 +189: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:17 +190: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:18 +191: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:18 +192: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:18 +193: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet sigma > 0 blurs the page at exactly that sigma
00:18 +194: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet sigma > 0 blurs the page at exactly that sigma
00:18 +195: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses circle
00:18 +196: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:18 +197: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:18 +198: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:18 +199: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:18 +200: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:18 +201: F:/level/level_up/level_up_app/test/core/widgets/elevation/elevated_surface_test.dart: ink onTap adds an InkWell over the fill and fires
00:18 +202: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:18 +203: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:19 +204: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:19 +205: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:19 +206: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:19 +207: F:/level/level_up/level_up_app/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet drag-to-dismiss still works, blurred
00:19 +208: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:19 +209: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:19 +210: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:19 +211: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:19 +212: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:19 +213: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:19 +214: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: knockout ΓÇö edit1.md R4 an outer shadow paints NOTHING inside the shape
00:19 +215: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: knockout ΓÇö edit1.md R4 an offset with no blur lands on the offset side only
00:19 +216: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: inset shadows are real insets ΓÇö edit1.md R7 an inset paints INSIDE the shape and never outside
00:19 +217: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: spread a positive spread grows the path, a negative one shrinks it
00:19 +218: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: spread zero spread returns the path untouched
00:19 +219: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: spread a spread that would consume the shape yields an empty path
00:19 +220: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: spread a negative spread pulls the shadow in
00:19 +221: F:/level/level_up/level_up_app/test/core/widgets/elevation/figma_shadow_painter_test.dart: an empty list is a no-op, not a crash
00:19 +222: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle ΓêÆ45 the top and left are the bright ones
00:20 +223: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) the dim side is the measured 0.65 of the lit one
00:20 +224: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 a straight edge at ΓêÆ45 keeps Figma's 0.50 / 0.33 profile
00:20 +225: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the shipped strength is the ruled fraction of the measured
00:20 +226: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 lightIntensity scales it linearly
00:20 +227: F:/level/level_up/level_up_app/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim matches the Figma measurement, scaled by D-011 the corners perpendicular to the light stay bare
00:20 +228: F:/level/level_up/level_up_app/test/core/widgets/elevation/primary_cta_test.dart: light ΓÇö a shadow, and no glow the primary tone paints the measured black
00:21 +229: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +230: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +231: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +232: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +233: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +234: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +235: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:21 +236: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:22 +237: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:22 +238: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:22 +239: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:22 +240: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:22 +241: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:22 +242: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: tapping an idle segment reports it
00:22 +243: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: the whole segment is the target, not just the label
00:22 +244: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: each segment carries mutually-exclusive selection semantics
00:22 +245: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: a screen-reader user can actually CHANGE the selection
00:23 +246: F:/level/level_up/level_up_app/test/core/widgets/elevation/segmented_track_test.dart: keyOf is honoured, so a screen keeps its existing test keys
00:23 +247: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +248: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +249: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +250: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +251: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +252: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +253: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +254: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +255: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +256: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +257: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:23 +258: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +259: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +260: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +261: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +262: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +263: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +264: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +265: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +266: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +267: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +268: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:25 +269: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:26 +270: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:26 +271: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:26 +272: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:26 +273: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:26 +274: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the standard variant takes the standard tokens
00:26 +275: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:26 +276: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark ┬╖ the registration variant is a DIFFERENT chip
00:26 +277: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:26 +278: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:26 +279: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton light ┬╖ the registration variant is a DIFFERENT chip
00:26 +280: F:/level/level_up/level_up_app/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:26 +281: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark elevates with Glass and NO shadow ΓÇö a reading, not a gap
00:26 +282: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the two dark variants really are different values
00:26 +283: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton the chevron still flips for RTL
00:27 +284: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: CircleBackButton it is still a button, and still taps
00:27 +285: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light draws the 1.17338 hairline and no Glass
00:27 +286: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: mock GET /catalog/subjects parses into Subjects
00:27 +287: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:27 +288: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: every mocked subject has a walkable tree
00:27 +289: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark ┬╖ the error state keeps its own 1.5
00:27 +290: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark ┬╖ the error state keeps its own 1.5
00:27 +291: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell dark ┬╖ the error state keeps its own 1.5
00:27 +292: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) quizTypes vary per subject, so the tab row cannot be hardcoded
00:27 +293: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light ┬╖ the error state keeps its own 1.5
00:27 +294: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light ┬╖ the error state keeps its own 1.5
00:27 +295: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell light ┬╖ the error state keeps its own 1.5
00:27 +296: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell disabled dims the whole field and kills the tap
00:27 +297: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:27 +298: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:27 +299: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill dark has NO border at all, and Glass instead
00:28 +300: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:28 +301: F:/level/level_up/level_up_app/test/core/widgets/shared_chrome_test.dart: LanguagePill it is ONE button node labelled by its text, not an image
00:30 +302: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging 24 cards page 10 / 10 / 4 by cursor, and hasMore says when to stop
00:30 +303: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging anatomy-l2 serves its 10 card(s) as ONE page, hasMore false
00:30 +304: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging anatomy-l3 serves its 4 card(s) as ONE page, hasMore false
00:30 +305: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging anatomy-l4 serves its 1 card(s) as ONE page, hasMore false
00:30 +306: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging physio-l2 serves its 3 card(s) as ONE page, hasMore false
00:30 +307: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging a lecture with no cards is 200 with empty items - not an error
00:30 +308: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging the default pageSize is 20
00:30 +309: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging pageSize 1 and pageSize 50 (the contract maximum) are accepted
00:30 +310: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging the wire shape is {id, front, back, imageUrl, selfGrade}
00:30 +311: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation the School track is insufficient_scope
00:30 +312: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation an unknown lecture id is insufficient_scope
00:30 +313: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation every cause answers with ONE byte-identical body that names no id
00:30 +314: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation a refused caller gets the scope refusal even with a bad query
00:30 +315: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation pageSize outside 1..50 is validation_failed on pageSize
00:30 +316: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation a pageSize that is not an integer is validation_failed too
00:30 +317: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation a malformed cursor is validation_failed on cursor
00:30 +318: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation a cursor issued for another lecture is refused, not followed
00:30 +319: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation a hand-altered cursor offset outside the list is validation_failed
00:30 +320: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance a charged card re-delivers free: page 1 twice spends the allowance ONCE
00:30 +321: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance ONE allowance across both surfaces: cards spend what quizzes draw from
00:30 +322: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance a drained allowance truncates the page to the affordable prefix
00:30 +323: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance a truncated FINAL page still says hasMore: branch on hasMore, not on the page end
00:30 +324: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance the prefix stops at the first unaffordable card, even when later cards are free
00:30 +325: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance zero deliverable cards is flashcard_subscription_required, never an empty page
00:30 +326: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - the shared weekly allowance a page of charged cards is delivered in full at zero allowance
00:30 +327: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade gotIt then again: 204 both times, and the LATEST is echoed on re-fetch
00:30 +328: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade is idempotent, and answers 204 with no body
00:30 +329: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade grading a card that was never shown is insufficient_scope, NOT flashcard_subscription_required
00:30 +330: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade a card past the delivered prefix is out of reach; one inside it is not
00:30 +331: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade an unknown card id is insufficient_scope
00:30 +332: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade the School track is insufficient_scope, even for a card charged earlier
00:30 +333: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade a grade that is missing or not gotIt/again is validation_failed on grade
00:30 +334: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade the gate is checked BEFORE the grade, so a bad grade on a foreign card is still a 403
00:30 +335: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: fixtures the tree declares the counts the study surface was specified with
00:30 +336: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: fixtures every lecture flashcardCount equals the cards it serves, and hasFlashcards agrees
00:30 +337: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: fixtures card ids are unique, readable and named after their lecture
00:30 +338: F:/level/level_up/level_up_app/test/dev/mock_backend_flashcards_test.dart: fixtures the deck exercises what the study surface must render
00:32 +339: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:32 +340: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me/entitlements parses, and agrees with the /me embed
00:32 +341: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me a new name is in the answer and in the next GET /me
00:32 +342: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me an e-mail set, then cleared with an explicit null
00:32 +343: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me an absent key leaves the field as it was
00:32 +344: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me a picked avatar comes back with its id and url
00:32 +345: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me the privacy toggles round-trip (Wave 21 needs them)
00:32 +346: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me a malformed e-mail is 400 validation_failed on `email`
00:32 +347: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me a name over 100 characters is 400 on `name`
00:32 +348: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock PATCH /me edits stay with their track across a sign-in
00:34 +349: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:34 +350: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:34 +351: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable ΓÇö the 159:1852 variant
00:34 +352: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:34 +353: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:34 +354: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:34 +355: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:34 +356: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:34 +357: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:34 +358: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:34 +359: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:34 +360: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:34 +361: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent ΓÇö a repeat call replays the same summary
00:34 +362: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me ΓÇö what invalidating the profile shows
00:34 +363: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered ΓÇö expected, not a bug
00:34 +364: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 ΓÇö the polling path is walkable
00:34 +365: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:34 +366: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:36 +367: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:36 +368: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 ┬º2)
00:36 +369: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:36 +370: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:36 +371: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:36 +372: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected ΓÇö the coded list is Egyptian
00:36 +373: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:36 +374: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:36 +375: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:36 +376: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:36 +377: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 ΓÇö the split is easy to get backwards
00:36 +378: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:36 +379: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:36 +380: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:36 +381: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:36 +382: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:36 +383: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:38 +384: F:/level/level_up/level_up_app/test/features/account_shells/disabled_action_button_test.dart: says its label ONCE, disabled, with the reason as the hint
00:40 +385: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token ΓåÆ unauthenticated
00:41 +386: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token ΓåÆ authenticated
00:41 +387: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:41 +388: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:41 +389: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:42 +390: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` authenticated ΓåÆ AuthenticatedResult with parsed tokens + opaque profile
00:42 +391: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson ΓÇö discriminated on contract `result` registrationRequired ΓåÆ RegistrationRequiredResult with token + ttl
00:42 +392: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity ΓÇö required fields have no defensive defaults TokenPair throws when a required field is missing
00:42 +393: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:44 +394: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:46 +395: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: sessionExpired reason shows the message in Arabic
00:46 +396: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit ΓÇö error shown, repo never called
00:49 +397: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:50 +398: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:50 +399: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:51 +400: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:51 +401: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:51 +402: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:51 +403: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:51 +404: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:52 +405: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:52 +406: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:52 +407: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:52 +408: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:52 +409: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +410: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +411: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +412: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +413: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +414: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +415: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +416: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +417: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +418: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +419: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +420: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +421: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +422: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +423: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +424: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:53 +425: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:53 +426: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:53 +427: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +428: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +429: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +430: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +431: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +432: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +433: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +434: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +435: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +436: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +437: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +437: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify ΓåÆ success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:54 +438: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:54 +439: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:55 +440: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:55 +441: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:55 +442: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:55 +443: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:55 +444: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:55 +444: F:/level/level_up/level_up_app/test/features/auth/otp_elevation_test.dart: ┬º7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:55 +445: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:56 +446: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
00:56 +447: F:/level/level_up/level_up_app/test/features/auth/otp_success_router_test.dart: a correct code shows the success view ΓÇö no jump to /home
unhandled element <filter/>; Picture key: Svg loader
00:57 +448: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:58 +449: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +450: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +451: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +452: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +453: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +454: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +455: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +456: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +457: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +458: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +459: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +460: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +461: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +462: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +463: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +464: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +465: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +466: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +467: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +468: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +469: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +470: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:59 +471: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
01:00 +472: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +473: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +474: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +475: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +476: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +477: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +478: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +479: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +480: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +481: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +482: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +483: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +484: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +485: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +486: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: school: the Subjects root stays chip-free after Settings rebuilt it (the W07-6 repro)
01:02 +487: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:03 +488: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +489: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +490: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +491: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +492: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +493: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +494: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +495: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +496: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +497: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +498: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +499: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:04 +500: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects ΓåÆ Units ΓåÆ Chapters ΓåÆ Lessons costs ONE tree fetch
01:05 +501: F:/level/level_up/level_up_app/test/features/catalog/catalog_header_test.dart: one level down the chip is there, and it goes back to the root
01:05 +502: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: going back up and down again still does not re-fetch
01:06 +503: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:07 +504: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:08 +505: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:08 +506: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:08 +507: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:08 +508: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:09 +509: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:09 +510: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:09 +511: F:/level/level_up/level_up_app/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
01:10 +512: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:10 +513: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:11 +514: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:12 +515: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:12 +516: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:12 +517: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:13 +518: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
01:13 +519: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:14 +520: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +521: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +522: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +523: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +524: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +525: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +526: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +527: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +528: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +529: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +530: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +531: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:15 +532: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +533: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +534: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +535: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +536: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +537: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +538: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +539: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:16 +540: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:17 +541: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
01:17 +542: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +543: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:17 +544: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +545: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +546: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +547: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +548: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +549: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +550: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +551: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +552: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +553: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +554: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +555: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +556: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +557: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +558: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +559: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +560: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +561: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:18 +562: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:19 +563: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
01:19 +564: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: every lesson row is a button, not a progress bar
01:20 +565: F:/level/level_up/level_up_app/test/features/catalog/lessons_screen_test.dart: every lesson row is a button, not a progress bar
01:20 +566: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 1.3x; rows grow together
01:20 +567: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +568: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +569: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +570: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +571: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +572: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +573: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +574: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +575: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +576: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +577: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:20 +578: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:21 +579: F:/level/level_up/level_up_app/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
01:21 +580: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:21 +581: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:22 +582: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
01:22 +583: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
01:22 +584: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
01:22 +585: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +586: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
01:22 +587: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
01:22 +588: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
01:23 +589: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
01:23 +590: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded BUG-002: no overflow in ar at 2.0x; rows grow together
01:23 +591: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title falls back to the bare title when the name is not cached
01:23 +592: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title falls back to the bare title when the name is not cached
01:23 +593: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +594: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +595: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +596: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +597: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +598: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +599: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +600: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +601: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +602: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +603: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:23 +604: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:24 +605: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:24 +606: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:24 +607: F:/level/level_up/level_up_app/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
01:24 +608: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded each card shows its own server counter
01:24 +609: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded each card shows its own server counter
01:24 +610: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
01:24 +611: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
01:24 +612: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
01:25 +613: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
01:25 +614: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: title Arabic titles it in Arabic, around the server copy
01:25 +615: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures 403 insufficient_scope gets its own copy and NO retry
01:25 +616: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
01:25 +617: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
01:25 +618: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded the progress bar is driven by answered/total
01:26 +619: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:26 +620: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:26 +621: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:26 +622: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
01:26 +623: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:26 +624: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:27 +625: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:27 +626: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:27 +627: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
01:27 +628: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:27 +629: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:27 +630: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:27 +631: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:27 +632: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +633: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +634: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +635: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +636: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +637: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +638: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +639: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
01:28 +640: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search filters client-side without calling the API
01:28 +641: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:29 +642: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:29 +643: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:29 +644: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:29 +645: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:29 +646: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:29 +647: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
01:30 +648: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search a query that matches nothing shows its own message
01:30 +649: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +650: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +651: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +652: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +653: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +654: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +655: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +656: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +657: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +658: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws a count of 24, 1 and 0 reads "24 Flash Cards", "1 Flash Card", "0 Flash Cards"
01:30 +659: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +660: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +661: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +662: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +663: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +664: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +665: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +666: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +667: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +668: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +669: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +670: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +671: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +672: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +673: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:30 +674: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:31 +675: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
01:31 +676: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
01:31 +677: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
01:31 +678: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header the header is the shared one: 89.18 tall, Γ£ò 16 in
01:31 +679: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
01:31 +680: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
01:31 +681: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
01:31 +682: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
01:32 +683: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
01:32 +684: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs Arabic labels the tabs in Arabic
01:32 +685: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:32 +686: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:32 +687: F:/level/level_up/level_up_app/test/features/home/coming_soon_section_test.dart: Daily Tasks ┬╖ 308:4305 / 337:5357 dark ┬╖ fill, radius and border come from the tokens
01:32 +688: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +689: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +690: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +691: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +692: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +693: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +694: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +695: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:32 +696: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states empty catalog gets its own message, not a blank grid
01:33 +697: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +698: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +699: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +700: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +701: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +702: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +703: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +704: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +705: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +706: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:33 +707: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab sits SECOND when any lecture has flashcards
01:34 +708: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
01:34 +709: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states error shows copy + a retry that re-requests
01:34 +710: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
01:34 +711: F:/level/level_up/level_up_app/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
01:34 +712: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:34 +713: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:34 +714: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:35 +715: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:35 +716: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:35 +717: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:35 +718: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:35 +719: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab all four quiz types ΓåÆ the design's five pills, in its order
01:35 +720: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: geometry against the frame (402 wide, 20 margins) card 2 adds the 79 pill and the 15 gap before "Got it"
01:35 +721: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: geometry against the frame (402 wide, 20 margins) card 2 adds the 79 pill and the 15 gap before "Got it"
01:36 +722: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes Arabic renders RTL with Arabic copy
01:36 +723: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:36 +724: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:36 +725: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:36 +726: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:36 +727: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:36 +728: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
01:37 +729: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes the counter is localized in Arabic
01:37 +730: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
01:37 +731: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
01:37 +732: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
01:37 +733: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
01:37 +734: F:/level/level_up/level_up_app/test/features/home/level_card_test.dart: en: the headline is whole on a 330 dp phone
01:37 +735: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab one lecture with cards is enough to offer it
01:37 +736: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab one lecture with cards is enough to offer it
01:38 +737: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab one lecture with cards is enough to offer it
01:38 +738: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab one lecture with cards is enough to offer it
01:38 +739: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab one lecture with cards is enough to offer it
01:38 +740: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: languages and themes dark theme renders the same content
01:38 +741: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:38 +742: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:38 +743: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:38 +744: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:39 +745: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 20 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:39 +746: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a subject with no quiz types but flashcards shows it ALONE
01:39 +747: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a subject with no quiz types but flashcards shows it ALONE
01:40 +748: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a subject with no quiz types but flashcards shows it ALONE
01:40 +749: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: Mistakes is no longer a stub ΓÇö the snackbar is gone
01:40 +750: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: states error ΓåÆ localized copy + a Retry that re-calls /me
01:40 +751: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:40 +752: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:40 +753: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:40 +754: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:40 +755: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:40 +756: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +757: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +758: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +759: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +760: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +761: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +762: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +763: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +764: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped 250 ms into the finished round's pop, it starts the NEXT round, not the one just finished
01:41 +765: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: university (Figma 125:2373) renders from a university /me ΓÇö the shared parts are shared
01:41 +766: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: university (Figma 125:2373) renders from a university /me ΓÇö the shared parts are shared
01:41 +767: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: university (Figma 125:2373) renders from a university /me ΓÇö the shared parts are shared
01:41 +768: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +769: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +770: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +771: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +772: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +773: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +774: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +775: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +776: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +777: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:42 +778: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:43 +779: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:43 +780: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:43 +781: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) announces as a BUTTON, in one node, like the one it replaced
01:43 +782: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +783: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +784: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +785: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +786: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +787: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +788: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +789: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +790: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +791: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +792: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +793: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +794: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +795: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +796: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +797: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +798: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +799: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:43 +800: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:44 +801: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:44 +802: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab selecting it lists ONLY lectures with cards, keeping their ORIGINAL numbers
01:44 +803: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:44 +804: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:44 +805: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:44 +806: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:44 +807: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:44 +808: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:45 +809: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:45 +810: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: the Mistakes pill (edit3 #7) a tap pushes the overview exactly once
01:45 +811: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption ΓÇö the contract has no flashcard progress
01:45 +812: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption ΓÇö the contract has no flashcard progress
01:45 +813: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption ΓÇö the contract has no flashcard progress
01:45 +814: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption ΓÇö the contract has no flashcard progress
01:45 +815: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption ΓÇö the contract has no flashcard progress
01:45 +816: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab its rows carry NO progress bar and NO caption ΓÇö the contract has no flashcard progress
01:45 +817: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: the round position stays alive while Setup is mounted, including under the study route
01:45 +818: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: the round position stays alive while Setup is mounted, including under the study route
01:45 +819: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: the round position stays alive while Setup is mounted, including under the study route
01:45 +820: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: the round position stays alive while Setup is mounted, including under the study route
01:45 +821: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading the restart button sends again for the card and advances
01:45 +822: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading the restart button sends again for the card and advances
01:45 +823: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading the restart button sends again for the card and advances
01:45 +824: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +825: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +826: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +827: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +828: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +829: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +830: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab going back to a quiz tab restores every lecture and its bar
01:46 +831: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading while the PUT is out: card, "<" and again are inert, and the index has not moved
01:46 +832: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading while the PUT is out: card, "<" and again are inert, and the index has not moved
01:46 +833: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading while the PUT is out: card, "<" and again are inert, and the index has not moved
01:47 +834: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:47 +835: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:47 +836: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:47 +837: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:47 +838: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_row_test.dart: light ┬╖ rank, name and points are all #4F4F4F
01:47 +839: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:47 +840: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:47 +841: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:47 +842: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:47 +843: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:47 +844: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:48 +845: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:48 +846: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:48 +847: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab is selected in semantics ΓÇö exactly one segment at a time
01:48 +848: F:/level/level_up/level_up_app/test/features/home/top_student_section_test.dart: surface ┬╖ 59:2090 / 337:5460 the school one has its back-light in dark
01:48 +849: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading light: the failure line reads on the canvas it is drawn on
01:48 +850: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:48 +851: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:48 +852: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:48 +853: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:48 +854: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:49 +855: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:49 +856: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab a quiz tab picked AFTER visiting Flashcard is the one handed to /quiz/setup
01:49 +857: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:49 +858: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:49 +859: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:50 +860: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:50 +861: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:50 +862: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:50 +863: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
01:50 +864: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark ┬╖ each place has its own badge colours
01:50 +865: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark ┬╖ each place has its own badge colours
01:50 +866: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark ┬╖ each place has its own badge colours
01:50 +867: F:/level/level_up/level_up_app/test/features/leaderboard/podium_test.dart: dark ┬╖ each place has its own badge colours
01:51 +868: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:51 +869: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:51 +870: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab Arabic: label is ┘ü┘ä╪º╪┤ ┘â╪º╪▒╪», second from the START, and the rows mirror
01:51 +871: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
01:51 +872: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
01:51 +873: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track a university student gets Global + Cohort
01:51 +874: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +875: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +876: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +877: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +878: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +879: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +880: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +881: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +882: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +883: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading account_pending_deletion on Got it: its copy stays and BOTH grade buttons are off for that card
01:51 +884: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +885: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +886: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +887: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +888: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +889: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +890: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:51 +891: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:52 +892: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:52 +893: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:52 +894: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:52 +895: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:52 +896: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the Flashcard tab dark theme lists the same rows
01:52 +897: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:52 +898: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:52 +899: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:52 +900: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:52 +901: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +902: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +903: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +904: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +905: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +906: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +907: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +908: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +909: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +910: F:/level/level_up/level_up_app/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track switching scope asks the server for the other board
01:53 +911: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading "<" goes back with no PUT, and is absent on card 1
01:53 +912: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading "<" goes back with no PUT, and is absent on card 1
01:53 +913: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_study_screen_test.dart: grading "<" goes back with no PUT, and is absent on card 1
01:53 +914: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:54 +915: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:54 +916: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:54 +917: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:54 +918: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:54 +919: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:54 +920: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:55 +921: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:55 +922: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:55 +923: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:55 +924: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +925: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +926: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +927: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +928: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +929: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +930: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +931: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +932: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +933: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +934: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +935: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:56 +936: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
01:57 +937: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
01:57 +938: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
01:57 +939: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:57 +940: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:58 +941: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:58 +942: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:58 +943: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:58 +944: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +945: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +946: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +947: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +948: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +949: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +950: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +951: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +952: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +953: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
01:59 +954: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +955: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +956: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +957: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +958: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +959: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +960: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
02:00 +961: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:00 +962: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +963: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +964: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +965: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +966: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +967: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +968: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +969: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +970: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:01 +971: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:02 +972: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:02 +973: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:02 +974: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:02 +975: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:02 +976: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:02 +977: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:03 +978: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:03 +979: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
02:03 +980: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count says MISTAKES, not "questions" (#59)
02:03 +981: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count says MISTAKES, not "questions" (#59)
02:03 +982: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
02:03 +983: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
02:03 +984: F:/level/level_up/level_up_app/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the school children of the subject route still resolve
02:03 +985: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer ┬╖ Save wears the CTA elevation the primary tone, enabled while the form is idle
02:04 +986: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer ┬╖ Save wears the CTA elevation the primary tone, enabled while the form is idle
02:04 +987: F:/level/level_up/level_up_app/test/features/profile/edit_profile_elevation_test.dart: #12 consumer ┬╖ Save wears the CTA elevation the primary tone, enabled while the form is idle
02:04 +988: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me ΓÇö the hub already fetched it
02:04 +989: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me ΓÇö the hub already fetched it
02:04 +990: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory no second GET /me ΓÇö the hub already fetched it
02:04 +991: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:04 +992: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +993: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +994: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +995: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +996: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +997: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +998: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +999: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +1000: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +1001: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +1002: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview the count PLURALISES ΓÇö the frames write "1 questions"
02:05 +1003: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
02:05 +1004: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
02:05 +1005: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
02:05 +1006: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
02:05 +1007: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
02:06 +1008: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
02:06 +1009: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
02:06 +1010: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the overview an empty list is the HAPPY PATH, not an error
02:06 +1011: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states offline gets its own view, distinct from a generic error
02:06 +1012: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: states offline gets its own view, distinct from a generic error
02:07 +1013: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:07 +1014: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:07 +1015: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:07 +1016: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:07 +1017: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:07 +1018: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:07 +1019: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:08 +1020: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:08 +1021: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:08 +1022: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
02:08 +1023: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1024: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1025: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1026: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1027: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1028: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1029: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1030: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1031: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1032: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1033: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1034: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1035: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1036: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1037: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1038: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1039: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1040: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1041: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1042: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1043: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1044: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1045: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1046: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1047: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1048: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1049: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1050: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1051: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1052: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:08 +1053: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:09 +1054: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:09 +1055: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:09 +1056: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:09 +1057: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
02:09 +1058: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
02:10 +1059: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
02:10 +1060: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
02:11 +1061: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
02:11 +1062: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows at text scale 1.3 the hub does not overflow in en
02:11 +1063: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows at text scale 1.3 the hub does not overflow in en
02:11 +1064: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows at text scale 1.3 the hub does not overflow in en
02:11 +1065: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows at text scale 1.3 the hub does not overflow in en
02:11 +1066: F:/level/level_up/level_up_app/test/features/profile/profile_elevation_test.dart: #24 the menu rows at text scale 1.3 the hub does not overflow in en
02:11 +1067: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:12 +1068: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:12 +1069: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1070: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1071: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1072: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1073: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1074: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1075: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1076: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1077: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1078: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1079: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1080: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1081: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1082: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1083: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1084: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:13 +1085: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:15 +1086: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:15 +1087: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:15 +1088: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:15 +1089: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1090: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1091: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1092: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1093: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1094: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1095: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:16 +1096: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:17 +1097: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:17 +1098: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
02:17 +1099: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert ΓÇö no chevron, no tap
02:17 +1100: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form CLEARED: emptying the box sends the key with an explicit null
02:17 +1101: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form CLEARED: emptying the box sends the key with an explicit null
02:17 +1102: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form CLEARED: emptying the box sends the key with an explicit null
02:17 +1103: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form CLEARED: emptying the box sends the key with an explicit null
02:17 +1104: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: email ΓÇö the three states, through the form CLEARED: emptying the box sends the key with an explicit null
02:17 +1105: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1106: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1107: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1108: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1109: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1110: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1111: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1112: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1113: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1114: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1115: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1116: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1117: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1118: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1119: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1120: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1121: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1122: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1123: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1124: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1125: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1126: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1127: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1128: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:18 +1129: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:19 +1130: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:19 +1131: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:19 +1132: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (staging: a token-less /me is a 401)
02:20 +1133: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included ΓÇö #81
02:20 +1134: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) raising the text scale enlarges EVERY label, the worst included ΓÇö #81
02:20 +1135: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
02:21 +1136: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar Use Avatar opens the reference picker and round-trips the id
02:21 +1137: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:21 +1138: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:21 +1139: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:21 +1140: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:21 +1141: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:21 +1142: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:22 +1143: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
02:22 +1144: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
02:22 +1145: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
02:22 +1146: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
02:23 +1147: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
02:23 +1148: F:/level/level_up/level_up_app/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
02:23 +1149: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:23 +1150: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:24 +1151: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:24 +1152: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
02:24 +1153: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1154: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1155: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1156: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1157: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1158: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1159: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent tapping Retry re-fetches and renders the avatars
02:24 +1160: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1161: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1162: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1163: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1164: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1165: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1166: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1167: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1168: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1169: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1170: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:24 +1171: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere ΓÇö the location does not move
02:25 +1172: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) the grid starts 25 under the header; cards 89 tall, 16.5 and 18 apart
02:25 +1173: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar a failed avatar load is recoverable, not permanent a successful load shows no Retry ΓÇö no regression
02:25 +1174: F:/level/level_up/level_up_app/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
02:25 +1175: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:25 +1176: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:25 +1177: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:25 +1178: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:25 +1179: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:25 +1180: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:25 +1181: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1182: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1183: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1184: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1185: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1186: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1187: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1188: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1189: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1190: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1191: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1192: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1193: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1194: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1195: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1196: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1197: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1198: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1199: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1200: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:26 +1201: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1202: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1203: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1204: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1205: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1206: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1207: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1208: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1209: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1210: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1211: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1212: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1213: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1214: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1215: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1216: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1217: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1218: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1219: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1220: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1221: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1222: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1223: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1224: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1225: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1226: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1227: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1228: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1229: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1230: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
02:27 +1231: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: read-only fields (conflict 1 / S20) the phone is the value GET /me returned, verbatim
02:28 +1232: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) Arabic: the chevron moves to the left edge and turns to point left; the text starts 9 from the right
02:28 +1233: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:29 +1234: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:29 +1235: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
02:29 +1236: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:29 +1237: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:29 +1238: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:29 +1239: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:29 +1240: F:/level/level_up/level_up_app/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel ┬╖ 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
02:29 +1241: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1242: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1243: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1244: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1245: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1246: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1247: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1248: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 1.3x; rows grow together
02:30 +1249: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1250: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1251: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1252: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1253: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1254: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1255: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
02:30 +1256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city renders its plain string
02:30 +1281: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
02:31 +1282: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in en at 2.0x; rows grow together
02:31 +1283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: ProfileCity ΓÇö the union at its first call site a FREE-TEXT city has nothing to localize, so AR shows it too
02:31 +1284: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Go to Uni dialog opens, and its Confirm is genuinely disabled
02:31 +1285: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 ┬╖ 404:7428) BUG-002: no overflow in ar at 2.0x; rows grow together
02:32 +1286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: a university student sees their own academic block university, faculty and year replace the school rows
02:32 +1287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: a university student sees their own academic block university, faculty and year replace the school rows
02:32 +1288: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1289: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1290: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1291: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1292: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1293: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1294: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1295: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1296: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1297: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1298: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1299: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1300: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1301: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1302: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1303: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1304: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1305: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1306: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1307: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1308: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
02:32 +1309: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
02:32 +1310: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save invalidates /me so the hub and Home repaint
02:33 +1311: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Lectures: the list starts 25 under the header, rows 78 tall and 16 apart
02:33 +1312: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Lectures: the list starts 25 under the header, rows 78 tall and 16 apart
02:33 +1313: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Lectures: the list starts 25 under the header, rows 78 tall and 16 apart
02:33 +1314: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) Lectures: the list starts 25 under the header, rows 78 tall and 16 apart
02:33 +1315: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
02:33 +1316: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save returns to the hub on success
02:33 +1317: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) badge, lines and chevron sit where 404:6642 puts them
02:33 +1318: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 ┬╖ 404:7181 ┬╖ 404:7765) badge, lines and chevron sit where 404:6642 puts them
02:34 +1319: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save 400 validation_failed lands as an inline error on the field
02:34 +1320: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
02:34 +1321: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
02:34 +1322: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the dialogs are localized too
02:34 +1323: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:35 +1324: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:35 +1325: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:35 +1326: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:35 +1327: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:35 +1328: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:36 +1329: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:36 +1330: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:36 +1331: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
02:36 +1332: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 ┬╖ 180:4704 ┬╖ 180:4445) the header (169:4631), not an AppBar Arabic: the same bar, "╪º┘ä┘à┘ä┘ü ╪º┘ä╪┤╪«╪╡┘è" centred
02:36 +1333: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:36 +1334: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:37 +1335: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:37 +1336: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:37 +1337: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:37 +1338: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:38 +1339: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:38 +1340: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:38 +1341: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:39 +1342: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:39 +1343: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:39 +1344: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:39 +1345: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:40 +1346: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:40 +1347: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:41 +1348: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:41 +1349: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:41 +1350: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
02:42 +1351: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:42 +1352: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:42 +1353: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:43 +1354: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:43 +1355: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:43 +1356: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:44 +1357: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:44 +1358: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:44 +1359: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:45 +1360: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:45 +1361: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:45 +1362: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:45 +1363: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:45 +1364: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1365: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1366: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1367: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1368: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1369: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1370: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1371: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:46 +1372: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:47 +1373: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
02:47 +1374: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:47 +1375: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:47 +1376: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:47 +1377: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:47 +1378: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:47 +1379: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:47 +1380: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:48 +1381: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
02:48 +1382: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the four render states a quiz finished with ZERO answers is all skipped
02:48 +1383: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
02:48 +1384: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering renders A/B/C/D badges, derived positionally
02:49 +1385: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering without a subject (a cold deep link) the scope stands alone
02:49 +1386: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering without a subject (a cold deep link) the scope stands alone
02:49 +1387: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
02:50 +1388: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
02:50 +1389: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
02:50 +1390: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) dark: the list starts 25 under the header, rows 16 apart, a one-line row 78 tall
02:50 +1391: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
02:50 +1392: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
02:50 +1393: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:51 +1394: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:51 +1395: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:51 +1396: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:51 +1397: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1398: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1399: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1400: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1401: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1402: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1403: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1404: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1405: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1406: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1407: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
02:52 +1408: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:52 +1409: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
02:53 +1410: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:53 +1411: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
02:53 +1412: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) each chapter row is ONE button node with the whole label
02:53 +1413: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
02:53 +1414: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
02:53 +1415: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
02:54 +1416: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
02:54 +1417: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix Arabic (RTL)
02:54 +1418: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:54 +1419: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:54 +1420: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:54 +1421: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1422: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1423: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1424: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1425: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1426: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1427: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1428: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1429: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1430: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1431: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1432: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1433: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1434: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1435: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1436: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
02:55 +1437: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the AI glyph is present on wrong rows when it is available
02:55 +1438: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: the AI glyph is present on wrong rows when it is available
02:55 +1439: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: states matrix leveledUp and newBadge parse but celebrate nothing
02:56 +1440: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
02:56 +1441: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model correctOptionId is revealed ONLY after Confirm
02:57 +1442: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
02:57 +1443: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
02:57 +1444: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
02:57 +1445: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
02:57 +1446: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the locked rows follow the frames (owner ruling, #105) a payload with both track blocks follows its track, with one City row and no duplicate key
02:57 +1447: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1448: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1449: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1450: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1451: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1452: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1453: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1454: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1455: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1456: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1457: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1458: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1459: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1460: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1461: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1462: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1463: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1464: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1465: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1466: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1467: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1468: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1469: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1470: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1471: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1472: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1473: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1474: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1475: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1476: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1477: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1478: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1479: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1480: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1481: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1482: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1483: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1484: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1485: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1486: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1487: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1488: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1489: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1490: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1491: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1492: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1493: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1494: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
02:58 +1495: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
02:58 +1496: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility a wrong row DOES follow the theme, because its fill does
02:59 +1497: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the action sheet (216:3341) a drag handle over two plain, full-width rows and one hairline: no title, no Γ£ò, no icons
02:59 +1498: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
02:59 +1499: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the Skipped bucket takes the same treatment, and only appears when the quiz ended early
02:59 +1500: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
02:59 +1501: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1502: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1503: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1504: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1505: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1506: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1507: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1508: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1509: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1510: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1511: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1512: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1513: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1514: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1515: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1516: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1517: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
03:00 +1518: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1519: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1520: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1521: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1522: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1523: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1524: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 ┬╖ 404:7894) offline pins the banner on Chapters and keeps the rows
03:00 +1525: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility every dark row is translucent and glassed - none is left opaque beside a glassed neighbour
03:00 +1526: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) the action sheet (216:3341) dark (337:8135): the handle #FCFBF9, the hairline the same #4B675E at 60%
03:00 +1527: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
03:00 +1528: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: error states 403 subscription_required opens the same sheet, other copy
03:00 +1529: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1530: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1531: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1532: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1533: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1534: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1535: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1536: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1537: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1538: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1539: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1540: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1541: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: submit retry (idempotency) retry re-sends the identical body, returns the ORIGINAL grade, and awards nothing twice
03:01 +1542: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
03:01 +1543: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
03:01 +1544: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: legibility rows and chips survive a large text scale without overflow
03:01 +1545: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:02 +1546: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:03 +1547: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:03 +1548: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:03 +1549: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:03 +1550: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:04 +1551: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:04 +1552: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:05 +1553: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:05 +1554: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:05 +1555: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:05 +1556: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: the result cards are raised, not outlined the rewards row survives a large text scale without a hard overflow
03:05 +1557: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:05 +1558: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:06 +1559: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:06 +1560: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:06 +1561: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:06 +1562: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:06 +1563: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:06 +1564: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1565: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1566: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1567: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1568: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1569: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1570: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1571: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1572: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP ΓåÆ /register renders Sign Up_1 without red-screening
03:07 +1573: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) I1: the system Back on a dirty form asks too (PopScope)
03:08 +1574: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) I1: the system Back on a dirty form asks too (PopScope)
03:08 +1575: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: Wave 20: the frames (176:1201 ┬╖ 216:3341 ┬╖ 180:4153) I1: the system Back on a dirty form asks too (PopScope)
03:08 +1576: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:08 +1577: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1578: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1579: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1580: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1581: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1582: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1583: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) ar: every lesson row is inert ΓÇö no chevron, no tap handler, and a tap goes nowhere
03:09 +1584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:10 +1585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:10 +1586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:10 +1587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:10 +1588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:11 +1589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:11 +1590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:11 +1591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:11 +1592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:11 +1593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:11 +1594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:12 +1595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:12 +1596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: Continue from Sign Up_1 reaches the Choose Your Track screen
03:12 +1597: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) valid input stores identity (referral collected) and routes to track
03:13 +1598: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) valid input stores identity (referral collected) and routes to track
03:13 +1599: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) valid input stores identity (referral collected) and routes to track
03:13 +1600: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: the Start CTA wears the primary treatment the limit sheet still carries no CTA at all
03:13 +1601: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
03:13 +1602: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
03:13 +1603: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
03:13 +1604: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the result carries the subject the quiz was launched with (APIΓåÆUI Wave 13)
03:13 +1605: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
03:14 +1606: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) English: the lesson counts pluralise ("1 mistake")
03:14 +1607: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:14 +1608: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:14 +1609: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:14 +1610: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:14 +1611: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:14 +1612: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:15 +1613: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:15 +1614: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) renders Arabic with RTL directionality
03:15 +1615: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) chips: an idle label is #384F47 in light, cream in dark
03:15 +1616: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is ON when the quiz screen mounts
03:15 +1617: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 ┬╖ 337:6628) dark: the "Points" run is cream, the rest stays lavender
03:15 +1618: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1619: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1620: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1621: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1622: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1623: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1624: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1625: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1626: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1627: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1628: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1629: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1630: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1631: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1632: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
03:16 +1633: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
03:16 +1634: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
03:16 +1635: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1636: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1637: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1638: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1639: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1640: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1641: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:16 +1642: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:17 +1643: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) it is a centred card, not a bottom sheet
03:17 +1644: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) rows: badge 9 in, text 3.5 after it and on to 5.82 from the end; the badge ring is its own fill
03:17 +1645: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) rows: badge 9 in, text 3.5 after it and on to 5.82 from the end; the badge ring is its own fill
03:17 +1646: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) rows: badge 9 in, text 3.5 after it and on to 5.82 from the end; the badge ring is its own fill
03:17 +1647: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:17 +1648: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:17 +1649: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:18 +1650: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:18 +1651: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:18 +1652: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:18 +1653: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) arriving from Chapters shows the rows at once, from the cached tree
03:18 +1654: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) the Γ£ò lands on the frame's box, with a full 48 dp target
03:18 +1655: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) the Γ£ò lands on the frame's box, with a full 48 dp target
03:18 +1656: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_2 (track picker) selecting School sets the discriminator and routes to /school
03:18 +1657: F:/level/level_up/level_up_app/test/features/registration/registration_screens_test.dart: Sign Up_2 (track picker) selecting School sets the discriminator and routes to /school
03:18 +1658: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: states matrix Arabic (RTL)
03:19 +1659: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
03:19 +1660: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
03:19 +1661: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:19 +1662: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:19 +1663: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:19 +1664: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1665: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1666: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1667: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1668: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1669: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1670: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1671: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1672: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1673: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1674: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1675: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout renders the title, subtitle and Start learning CTA
03:20 +1676: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
03:20 +1677: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
03:20 +1678: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
03:20 +1679: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a chapter the tree does not have is EMPTY, not an error, and costs no second fetch
03:20 +1680: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the limit card (199:2335) the Γ£ò is labelled and dismisses the card
03:21 +1681: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) text scale 1.3: the row grows around its lines, it never clips them
03:21 +1682: F:/level/level_up/level_up_app/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 ┬╖ 337:6705) text scale 1.3: the row grows around its lines, it never clips them
03:21 +1683: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill does not exist on question 1
03:21 +1684: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
03:22 +1685: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) a failed load on Lessons offers Retry, which refetches this subject and shows the rows
03:22 +1686: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout defaults the country to Egypt from the server list
03:22 +1687: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 ΓÇö layout defaults the country to Egypt from the server list
03:22 +1688: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill is a 79 x 58 pill once past question 1
03:23 +1689: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill is a 79 x 58 pill once past question 1
03:23 +1690: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
03:23 +1691: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
03:23 +1692: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
03:23 +1693: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
03:23 +1694: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
03:23 +1695: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
03:23 +1696: F:/level/level_up/level_up_app/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 ┬╖ 549:19390) offline pins the banner on Lessons and keeps the rows
03:23 +1697: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:23 +1698: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:23 +1699: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:23 +1700: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:24 +1701: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:24 +1702: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:24 +1703: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:24 +1704: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:24 +1705: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1706: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1707: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1708: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1709: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1710: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1711: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1712: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1713: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill takes its radius from the canvas ΓÇö 9 light, 10 dark
03:25 +1714: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) Egypt shows Governorate + the coded school picker
03:25 +1715: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) Egypt shows Governorate + the coded school picker
03:25 +1716: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) Egypt shows Governorate + the coded school picker
03:26 +1717: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) Egypt shows Governorate + the coded school picker
03:26 +1718: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: geography conditionality (adr-010) Egypt shows Governorate + the coded school picker
03:26 +1719: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill light carries the small black shadow and no Glass
03:26 +1720: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill light carries the small black shadow and no Glass
03:26 +1721: F:/level/level_up/level_up_app/test/features/registration/track_card_elevation_test.dart: behaviour survives the surface swap tapping a card selects it, and Continue then routes
03:27 +1722: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1723: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1724: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1725: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1726: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1727: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1728: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1729: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:27 +1730: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:28 +1731: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
03:28 +1732: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: the university ΓåÆ faculty ΓåÆ year cascade is gated choosing a University unlocks its own faculties
03:28 +1733: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: the university ΓåÆ faculty ΓåÆ year cascade is gated choosing a University unlocks its own faculties
03:28 +1734: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
03:28 +1735: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
03:29 +1736: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
03:29 +1737: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
03:29 +1738: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink bar ΓåÆ heading, heading ΓåÆ control, control ΓåÆ heading: 25
03:29 +1739: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
03:29 +1740: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
03:30 +1741: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the section card dark: NO hairline at all, and G16 instead
03:30 +1742: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
03:30 +1743: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
03:30 +1744: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill the chevron is mirrored in LTR and left alone in RTL
03:31 +1745: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill the chevron is mirrored in LTR and left alone in RTL
03:31 +1746: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill the chevron is mirrored in LTR and left alone in RTL
03:31 +1747: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
03:31 +1748: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
03:31 +1749: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
03:31 +1750: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
03:32 +1751: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder adds no request of its own ΓÇö /me is still fetched once
03:32 +1752: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the frame's 25, measured to ink ΓÇªand in Arabic on the right edge (549:21816)
03:32 +1753: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill it sits 15 dp from the primary CTA
03:32 +1754: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: the previous-question pill it sits 15 dp from the primary CTA
03:32 +1755: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
03:32 +1756: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
03:32 +1757: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
03:33 +1758: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1759: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1760: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1761: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1762: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1763: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1764: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:33 +1765: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:34 +1766: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark school: B8 at (0, 33)
03:34 +1767: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:34 +1768: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:34 +1769: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:34 +1770: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:35 +1771: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:35 +1772: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:35 +1773: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:35 +1774: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:35 +1775: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:35 +1776: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch row labels are Inter Regular 16 in the frame's colour
03:36 +1777: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
03:36 +1778: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
03:36 +1779: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
03:36 +1780: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
03:37 +1781: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
03:37 +1782: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
03:37 +1783: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
03:37 +1784: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:37 +1785: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:37 +1786: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:37 +1787: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1788: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1789: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1790: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1791: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1792: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1793: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:38 +1794: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:39 +1795: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:39 +1796: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:39 +1797: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:39 +1798: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
03:39 +1799: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) a successful save re-reads /me ΓÇö the server decides the value
03:39 +1800: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) a successful save re-reads /me ΓÇö the server decides the value
03:40 +1801: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) a successful save re-reads /me ΓÇö the server decides the value
03:40 +1802: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank ΓÇö two independent booleans (S27) a successful save re-reads /me ΓÇö the server decides the value
03:40 +1803: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: switching tabs preserves Home ΓÇö /me is not re-fetched
03:40 +1804: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: switching tabs preserves Home ΓÇö /me is not re-fetched
03:40 +1805: F:/level/level_up/level_up_app/test/features/shell/main_shell_test.dart: switching tabs preserves Home ΓÇö /me is not re-fetched
03:40 +1806: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:41 +1807: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:41 +1808: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:41 +1809: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:41 +1810: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:41 +1811: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:42 +1812: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:42 +1813: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:42 +1814: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light Rank never gets one, on either canvas
03:42 +1815: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
03:42 +1816: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
03:42 +1817: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:42 +1818: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1819: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1820: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1821: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1822: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1823: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1824: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:43 +1825: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:44 +1826: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:44 +1827: F:/level/level_up/level_up_app/test/features/settings/settings_frame_test.dart: Wave 21: the rows and the frame's switch dark has no hairline, so no inset: 16 from the card
03:44 +1828: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) exactly two options
03:44 +1829: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
03:44 +1830: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
03:45 +1831: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
03:45 +1832: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
03:45 +1833: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 ┬╖ 159:1695 ┬╖ 216:2973) explanation 403 subscription_required opens the contract popup, verbatim, on the limit card
03:45 +1834: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 ┬╖ 159:1695 ┬╖ 216:2973) explanation 403 subscription_required opens the contract popup, verbatim, on the limit card
03:45 +1835: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 ┬╖ 159:1695 ┬╖ 216:2973) explanation 403 subscription_required opens the contract popup, verbatim, on the limit card
03:45 +1836: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:45 +1837: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:45 +1838: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:46 +1839: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:46 +1840: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:47 +1841: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:47 +1842: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Dark changes the app's canvas, not just a flag
03:47 +1843: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:47 +1844: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:47 +1845: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:48 +1846: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:48 +1847: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:48 +1848: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:48 +1849: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:48 +1850: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1851: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1852: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1853: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1854: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1855: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1856: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
03:49 +1857: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
03:49 +1858: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
03:49 +1859: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) the status bar follows the canvas
03:49 +1860: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
03:50 +1861: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
03:50 +1862: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
03:50 +1863: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" "Choose from the list" returns AND clears the free text
03:50 +1864: F:/level/level_up/level_up_app/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track the track takes the shared pillTrack tokens
03:50 +1865: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:50 +1866: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1867: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1868: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1869: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1870: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1871: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1872: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1873: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:51 +1874: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:52 +1875: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode ΓÇö two canvases, not the frame's three (S26) picking Light again comes back
03:52 +1876: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
03:52 +1877: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
03:52 +1878: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
03:52 +1879: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
03:52 +1880: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape ΓÇö "my city isn't listed" a free-text city still permits a school search
03:53 +1881: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:53 +1882: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:53 +1883: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:53 +1884: F:/level/level_up/level_up_app/test/goldens/design_goldens_test.dart: track card, unselected ┬╖ light
03:53 +1885: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages ΓÇö the existing locale switch picking Arabic flips the whole app to RTL
03:53 +1886: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
03:53 +1887: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable the skip affordance sits under the Egyptian picker
03:53 +1888: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal ΓÇö one screen, two documents, no copy both routes render the same empty body, different titles
03:53 +1889: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal ΓÇö one screen, two documents, no copy both routes render the same empty body, different titles
03:54 +1890: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal ΓÇö one screen, two documents, no copy both routes render the same empty body, different titles
03:54 +1891: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal ΓÇö one screen, two documents, no copy both routes render the same empty body, different titles
03:54 +1892: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages ΓÇö the existing locale switch both names are written in their own language, in both locales
03:54 +1893: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
03:54 +1894: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
03:55 +1895: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable skipping marks the field RESOLVED, not blank
03:55 +1896: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Languages ΓÇö the existing locale switch tapping the language already in use is a no-op
03:55 +1897: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: leaving the back chip pops to where the student came from
03:55 +1898: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
03:55 +1899: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable an Egyptian student can submit having skipped it
03:55 +1900: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark Arabic renders Arabic copy under RTL
03:56 +1901: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored language is already in force, in the right direction
03:56 +1902: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step ΓÇö Egypt only, and skippable picking a school afterwards un-skips the field
03:56 +1903: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
03:56 +1904: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark dark does not quietly re-enable anything
03:57 +1905: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch picking a language writes it too
03:57 +1906: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a corrupt file still boots, on the defaults
03:57 +1907: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN ├ù light + dark the legal screen is localized in Arabic
03:57 +1908: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) all four render
03:57 +1909: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_announcements is structurally non-interactive
03:58 +1910: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_promotions is structurally non-interactive
03:58 +1911: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_support is structurally non-interactive
03:58 +1912: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) settings_notif_system is structurally non-interactive
03:58 +1913: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) tapping one changes nothing and sends nothing
03:58 +1914: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences ΓÇö four dead toggles (S28) each announces itself disabled, with a reason
03:59 +1915: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic renders the Arabic section titles under RTL
03:59 +1916: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark Arabic + dark, and the disabled reason is localized too
03:59 +1917: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN ├ù light + dark offline pins the banner and Rank still reads from cache
03:59 +1918: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: (tearDownAll)
04:00 +1918: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: (setUpAll)
04:00 +1918: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: home section ┬╖ daily tasks ┬╖ dark
04:01 +1919: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: quiz type tabs ┬╖ dark
04:01 +1920: F:/level/level_up/level_up_app/test/goldens/edit3_surfaces_golden_test.dart: (tearDownAll)
04:02 +1920: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: (setUpAll)
04:02 +1920: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel ┬╖ dark
04:04 +1921: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: leaderboard scope toggle ┬╖ dark
04:04 +1922: F:/level/level_up/level_up_app/test/goldens/edit4_surfaces_golden_test.dart: (tearDownAll)
04:05 +1922: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: (setUpAll)
04:05 +1922: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: profile header card ┬╖ dark
04:06 +1923: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: settings section ┬╖ dark, with the school back-light
04:06 +1924: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells ┬╖ dark
04:07 +1925: F:/level/level_up/level_up_app/test/goldens/edit5_surfaces_golden_test.dart: (tearDownAll)
04:08 +1925: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: (setUpAll)
04:08 +1925: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ light
04:09 +1926: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: translucent row ┬╖ light
04:09 +1927: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: inset track ┬╖ light
04:09 +1928: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: two-shadow card ┬╖ light
04:09 +1929: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: level card surface ┬╖ dark
04:09 +1930: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: translucent row ┬╖ dark
04:09 +1931: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: inset track ┬╖ dark
04:09 +1932: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: two-shadow card ┬╖ dark
04:09 +1933: F:/level/level_up/level_up_app/test/goldens/elevation_primitives_test.dart: (tearDownAll)
04:11 +1933: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: (setUpAll)
04:11 +1933: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1934: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1935: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1936: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1937: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1938: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1939: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1940: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1941: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1942: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 0 selected
04:12 +1943: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 1 selected
04:12 +1944: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 2 selected
04:12 +1945: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 3 selected
04:12 +1946: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ light ┬╖ tab 4 selected
04:13 +1947: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 0 selected
04:13 +1948: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 1 selected
04:13 +1949: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 2 selected
04:13 +1950: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 3 selected
04:13 +1951: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: nav bar ┬╖ dark ┬╖ tab 4 selected
04:13 +1952: F:/level/level_up/level_up_app/test/goldens/nav_bar_golden_test.dart: (tearDownAll)
04:13 +1952: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: (setUpAll)
04:13 +1952: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: the contract is actually being read
04:13 +1953: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: StudentProfile (GET /me, PATCH /me) ΓÇö every contract-required field is modelled
04:13 +1954: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: StudentProfile.school ΓÇö every contract-required field is modelled
04:13 +1955: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: StudentProfile.geography ΓÇö every contract-required field is modelled
04:13 +1956: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: StudentProfile.points ΓÇö every contract-required field is modelled
04:13 +1957: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: StudentProfile.privacy ΓÇö every contract-required field is modelled
04:13 +1958: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: StudentProfile.pendingDeletion (adr-114) ΓÇö every contract-required field is modelled
04:13 +1959: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: EntitlementState ΓÇö every contract-required field is modelled
04:13 +1960: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: UniversitySubjectTree ΓÇö every contract-required field is modelled
04:13 +1961: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: UniversitySubjectTree.lectures[] ΓÇö the hasFlashcards miss ΓÇö every contract-required field is modelled
04:13 +1962: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: SchoolSubjectTree ΓÇö every contract-required field is modelled
04:13 +1963: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: AnswerResult (submitAnswer) ΓÇö every contract-required field is modelled
04:13 +1964: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: NamedRef ΓÇö every contract-required field is modelled
04:13 +1965: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: FlashcardCard (getFlashcardsForLecture) ΓÇö every contract-required field is modelled
04:13 +1966: F:/level/level_up/level_up_app/test/guards/contract_models_test.dart: (tearDownAll)
04:14 +1966: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: (setUpAll)
04:14 +1966: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: lib/ is actually being scanned
04:14 +1967: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: Bloc stays inside the quiz feature
04:14 +1968: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: no provider is mutated during initState
04:14 +1969: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: autoDispose notifiers that await track their own disposal
04:14 +1970: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: user-facing copy goes through AppLocalizations no NEW file introduces a hardcoded string
04:14 +1971: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: user-facing copy goes through AppLocalizations the count does not grow
04:14 +1972: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: hardcoded fontSize does not increase (ratchet)
04:14 +1973: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: no raw elevation effect outside the two elevation folders
04:14 +1974: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: both ARB files carry the same keys
04:14 +1975: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: no glyph is swapped for its mirror image
04:14 +1976: F:/level/level_up/level_up_app/test/guards/project_rules_test.dart: (tearDownAll)
04:14 +1976: F:/level/level_up/level_up_app/test/guards/rules_test.dart: stripComments ΓÇö the primitive everything else depends on removes line comments
04:14 +1977: F:/level/level_up/level_up_app/test/guards/rules_test.dart: stripComments ΓÇö the primitive everything else depends on removes doc comments
04:14 +1978: F:/level/level_up/level_up_app/test/guards/rules_test.dart: stripComments ΓÇö the primitive everything else depends on removes block comments, including multi-line
04:14 +1979: F:/level/level_up/level_up_app/test/guards/rules_test.dart: stripComments ΓÇö the primitive everything else depends on leaves real code alone
04:14 +1980: F:/level/level_up/level_up_app/test/guards/rules_test.dart: bloc containment flags flutter_bloc outside the quiz feature
04:14 +1981: F:/level/level_up/level_up_app/test/guards/rules_test.dart: bloc containment allows flutter_bloc inside the quiz feature
04:14 +1982: F:/level/level_up/level_up_app/test/guards/rules_test.dart: bloc containment a COMMENT mentioning flutter_bloc is not a violation
04:14 +1983: F:/level/level_up/level_up_app/test/guards/rules_test.dart: provider mutation in initState (the BUG-001 guard) flags a bare notifier write
04:14 +1984: F:/level/level_up/level_up_app/test/guards/rules_test.dart: provider mutation in initState (the BUG-001 guard) allows a write deferred to after the frame
04:14 +1985: F:/level/level_up/level_up_app/test/guards/rules_test.dart: provider mutation in initState (the BUG-001 guard) allows initState that only READS a provider
04:14 +1986: F:/level/level_up/level_up_app/test/guards/rules_test.dart: provider mutation in initState (the BUG-001 guard) a COMMENT describing the violation is not a violation
04:14 +1987: F:/level/level_up/level_up_app/test/guards/rules_test.dart: provider mutation in initState (the BUG-001 guard) nested braces do not truncate the body scan
04:14 +1988: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw Text literals flags a hardcoded string
04:14 +1989: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw Text literals does not flag a localized call
04:14 +1990: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw Text literals respects the allowlist
04:14 +1991: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw Text literals a COMMENT containing Text('..') is not a violation
04:14 +1992: F:/level/level_up/level_up_app/test/guards/rules_test.dart: hardcoded fontSize ratchet counts real occurrences
04:14 +1993: F:/level/level_up/level_up_app/test/guards/rules_test.dart: hardcoded fontSize ratchet does not count a themed lookup
04:15 +1994: F:/level/level_up/level_up_app/test/guards/rules_test.dart: hardcoded fontSize ratchet does not count a commented example
04:15 +1995: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects flags a BoxShadow at a call site
04:15 +1996: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects flags a non-zero elevation, including a ternary
04:15 +1997: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects flags shadowColor
04:15 +1998: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects flags the blur and backdrop primitives
04:15 +1999: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects does NOT flag elevation: 0 ΓÇö flat is the state this rule wants
04:15 +2000: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects a COMMENT describing a BoxShadow is not a violation
04:15 +2001: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects both design-system folders are exempt
04:15 +2002: F:/level/level_up/level_up_app/test/guards/rules_test.dart: raw elevation effects reports path:line so a failure names the site
04:15 +2003: F:/level/level_up/level_up_app/test/guards/rules_test.dart: ARB key drift detects a key missing from Arabic
04:15 +2004: F:/level/level_up/level_up_app/test/guards/rules_test.dart: ARB key drift detects an orphan Arabic key
04:15 +2005: F:/level/level_up/level_up_app/test/guards/rules_test.dart: ARB key drift ignores @-metadata entries
04:15 +2006: F:/level/level_up/level_up_app/test/guards/rules_test.dart: ARB key drift agrees when both sides match
04:15 +2007: F:/level/level_up/level_up_app/test/guards/rules_test.dart: contract required-field extraction reads a top-level required list
04:15 +2008: F:/level/level_up/level_up_app/test/guards/rules_test.dart: contract required-field extraction reads a NESTED required list, not the outer one
04:15 +2009: F:/level/level_up/level_up_app/test/guards/rules_test.dart: contract required-field extraction does not leak into the next schema
04:15 +2010: F:/level/level_up/level_up_app/test/guards/rules_test.dart: contract required-field extraction raises ΓÇö never returns empty ΓÇö when the schema is absent
04:15 +2011: F:/level/level_up/level_up_app/test/guards/rules_test.dart: contract required-field extraction raises when the block has no required list
04:15 +2012: F:/level/level_up/level_up_app/test/guards/rules_test.dart: contract required-field extraction raises on a block-style required list, never reads it as empty
04:15 +2013: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart field declaration detects a declared constructor parameter
04:15 +2014: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart field declaration detects one followed by a trailing comma
04:15 +2015: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart field declaration a doc comment mentioning the field does NOT count
04:15 +2016: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart field declaration a JSON key read in a hand-written parser does NOT count
04:15 +2017: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart field declaration reports a genuinely missing field
04:15 +2018: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping returns only the named class body
04:15 +2019: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping ≡ƒö┤ THE POINT ΓÇö a sibling class no longer answers for this one
04:15 +2020: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping the field each class DOES declare still resolves
04:15 +2021: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping an unknown class is null, NOT the whole file
04:15 +2022: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping a brace inside a doc comment does not unbalance the body
04:15 +2023: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping `sealed` and `abstract` classes are found
04:15 +2024: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping a prefix name does not match ΓÇö `Profile` is not `ProfileSchool`
04:15 +2025: F:/level/level_up/level_up_app/test/guards/rules_test.dart: Dart class scoping an enum is not a class
04:15 +2026: F:/level/level_up/level_up_app/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) flags the helper Wave 07 removed, across lines
04:15 +2027: F:/level/level_up/level_up_app/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) flags any condition and the back-arrow pair, in either order
04:15 +2028: F:/level/level_up/level_up_app/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) allows the unconditional LTR glyph
04:15 +2029: F:/level/level_up/level_up_app/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) allows a conditional between unrelated glyphs
04:15 +2030: F:/level/level_up/level_up_app/test/guards/rules_test.dart: mirror-glyph swaps (the RTL double flip) a COMMENT showing the old helper is not a violation
04:15 +2031: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a failing run reports its failures ΓÇö the 2026-09-12 defect
04:15 +2032: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a passing run still reports its skipped tests
04:15 +2033: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a clean run with neither skips nor failures
04:15 +2034: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly failures without skips ΓÇö the shape the old parser did handle
04:15 +2035: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly the final tally wins, not the first
04:15 +2036: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the validator reads the test tally correctly a "+N" inside test output is not mistaken for a tally
04:15 +2037: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the POSIX twin parses the same shape validate.sh captures the skipped counter
04:15 +2038: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the POSIX twin parses the same shape validate.sh anchors its counter read on the timestamp
04:15 +2039: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the POSIX twin parses the same shape both scripts surface the skipped count in their summary
04:15 +2040: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the gate is not the exit code alone validate.ps1 fails on an unparseable tally
04:15 +2041: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the gate is not the exit code alone validate.ps1 requires the reporter to have finished
04:15 +2042: F:/level/level_up/level_up_app/test/guards/validate_reporting_test.dart: the gate is not the exit code alone validate.sh applies the same three extra failure conditions
04:16 +2043: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
04:16 +2044: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI runs the whole suite minus goldens, and the goldens by tag
04:16 +2045: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: test discovery cannot silently omit tests every golden test file carries the golden tag
04:16 +2046: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth .flutter-version exists and is a plain version
04:16 +2047: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: the pinned SDK version has one source of truth CI reads the pin from the file rather than hardcoding it
04:16 +2048: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact the main manifest declares INTERNET
04:16 +2049: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact CI still inspects the built artefact, not just the source
04:16 +2050: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint every runnable release-build command pairs --flavor with a matching entrypoint
04:16 +2051: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the scan actually finds the release commands it is guarding
04:16 +2052: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: release-build commands pair --flavor with a matching entrypoint the coherence rule itself fires on each kind of bad command
04:16 +2053: F:/level/level_up/level_up_app/test/widget_test.dart: scaffold boots
04:16 +2054: F:/level/level_up/level_up_app/test/widget_test.dart: scaffold boots
04:16 +2055: F:/level/level_up/level_up_app/test/widget_test.dart: scaffold boots
04:16 +2056: F:/level/level_up/level_up_app/test/widget_test.dart: scaffold boots
04:16 +2057: F:/level/level_up/level_up_app/test/widget_test.dart: scaffold boots
04:16 +2058: F:/level/level_up/level_up_app/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
04:16 +2059: All tests passed!
```

