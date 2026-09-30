# Validation run - 2026-09-30T11:52:49Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 319 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 1985 passed / 0 failed / 0 skipped |

**OVERALL: PASS**

Started 2026-09-30T11:52:49Z - finished 2026-09-30T11:54:46Z

---

## 1. Environment

```text
started (UTC)  : 2026-09-30T11:52:49Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9444
repo root      : F:/level/level_up/level_up_app/.claude/worktrees/w22-verify
branch         : HEAD
commit         : e86c79b
tree clean     : yes
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
checking 319 hand-written Dart files

Formatted 60 files (0 changed) in 0.25 seconds.
Formatted 60 files (0 changed) in 0.28 seconds.
Formatted 60 files (0 changed) in 0.22 seconds.
Formatted 60 files (0 changed) in 0.35 seconds.
Formatted 60 files (0 changed) in 0.39 seconds.
Formatted 19 files (0 changed) in 0.07 seconds.
```

No files need reformatting.

## 5. Static analysis (`flutter analyze`)

```text
Analyzing w22-verify...                                         
No issues found! (ran in 6.9s)
```

## 6. Tests (`flutter test --reporter=expanded`)

Full suite, goldens included. The golden baselines were captured on Windows,
so they are expected to pass here. On a Linux/macOS runner they fail on pixel
differences that are the platform, not the code.

**1985 passed, 0 failed, 0 skipped** (exit 0)


### Full test output

```text
00:00 +0: loading F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart
00:00 +0: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: toJson — contract `format: date` (yyyy-MM-dd) emits a bare date, never an ISO-8601 timestamp
00:00 +1: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: toJson — contract `format: date` (yyyy-MM-dd) zero-pads month and day
00:00 +2: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: toJson — contract `format: date` (yyyy-MM-dd) a local midnight does NOT shift a day (Egypt is UTC+2 — a DoB is a calendar date, not an instant)
00:00 +3: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: fromJson parses a contract date string
00:00 +4: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: fromJson round-trips
00:00 +5: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: NullableDateOnlyConverter passes null through both ways
00:00 +6: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/models/date_only_converter_test.dart: NullableDateOnlyConverter formats a value identically to the non-null converter
00:01 +7: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: (setUpAll)
00:01 +7: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion recognises the code
00:01 +8: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion does not confuse it with the OTHER 403 the same routes answer
00:01 +9: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion ignores transport failures and non-API errors
00:01 +10: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: isAccountPendingDeletion matches on the code, so a subclass is recognised too
00:01 +11: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz — all four quiz endpoints share one helper
00:01 +12: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it quiz — the existing codes are untouched
00:01 +13: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile — PATCH /me is NOT on the allowlist, only GET /me is
00:01 +14: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: every error-copy funnel consults it profile — offline still outranks it, and validation still works
00:01 +15: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for a pending deletion
00:01 +16: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: suppressesRetry withholds Retry for quiz_already_finished too
00:01 +17: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: suppressesRetry leaves every other failure retryable
00:01 +18: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: suppressesRetry is not the same question as opensLimitSheet
00:01 +19: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: the copy itself exists in both locales and is not the generic message
00:01 +20: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: the copy itself is purchase-silent (adr-049 §3)
00:01 +21: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/account_pending_deletion_test.dart: (tearDownAll)
00:05 +21: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/auth_interceptor_test.dart: authentication_required → refresh once → original retried → success
00:05 +22: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:05 +23: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:05 +24: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:05 +25: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:05 +26: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
00:05 +27: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException carries the ProblemDetails field map
00:05 +28: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException is still an ApiException (existing handlers keep working)
00:05 +29: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a missing/malformed errors map yields empty fields, not a crash
00:05 +30: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 400 validation_failed → ValidationException a non-list value is tolerated as a single message
00:05 +31: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 400 with a different code stays a plain ApiException
00:05 +32: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 401 → UnauthorizedException carrying the code
00:05 +33: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping 409 → ApiException carrying status + code
00:05 +34: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: other statuses keep their existing mapping connection error → NetworkException (drives Offline)
00:05 +35: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException is typed, and is NOT otp_throttled
00:05 +36: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a delta-seconds Retry-After parses
00:05 +37: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an ABSENT header yields null — and does not throw
00:05 +38: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a GARBAGE header yields null — and does not throw
00:05 +39: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException an HTTP-date Retry-After yields null rather than a guess
00:05 +40: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 429 rate_limited → RateLimitedException a 429 with a DIFFERENT code stays a plain ApiException
00:05 +41: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 404 country_not_found maps to an ApiException carrying that code, not `unknown`
00:05 +42: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/network/error_interceptor_test.dart: 404 country_not_found a malformed countryCode is the 400, not the 404
00:05 +43: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore an empty file has nothing stored
00:05 +44: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore both preferences round-trip
00:05 +45: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore the canvas is stored by name, not by enum index
00:05 +46: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore ThemeMode.system clears the key rather than storing a third value
00:05 +47: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore an unrecognised value reads as nothing stored
00:05 +48: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore a value of the wrong TYPE does not throw
00:05 +49: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: PreferencesStore a corrupt key is overwritten by the next write
00:05 +50: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build no store at all yields the defaults
00:05 +51: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build a stored canvas and language are in force before anything is read
00:05 +52: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build a corrupt file yields the defaults and does not throw
00:05 +53: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a canvas writes it
00:05 +54: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build selecting a language writes it
00:05 +55: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build the language PILL writes it too — one path, not two
00:05 +56: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/preferences_store_test.dart: the controllers read the store at first build re-selecting the current value does not rewrite it
00:07 +57: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:07 +58: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:07 +59: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:07 +60: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on /login/otp → stay (the success view shows)
00:07 +61: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:07 +62: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:07 +63: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:07 +64: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:07 +65: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:07 +66: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:07 +67: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +68: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +69: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +70: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +71: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +72: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +73: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +74: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +75: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +76: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +77: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +78: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +79: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +80: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +81: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +82: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:08 +83: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +84: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +85: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +86: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +87: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +88: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +89: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +90: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +91: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +92: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +93: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +94: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +95: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +96: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +97: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +98: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +99: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +100: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +101: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +102: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +103: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +104: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +105: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +106: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +107: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +108: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +109: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +110: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +111: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +112: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +113: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +114: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +115: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +116: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +117: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +118: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +119: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +120: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:09 +121: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the blur conversion kFigmaBlurToSigma is the CSS definition, not a tunable
00:09 +122: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the blur conversion sigma is NOT what BoxShadow would have produced
00:09 +123: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the blur conversion frost converts with its own constant
00:09 +124: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration nav bar: the two canvases differ in colour AND blur
00:09 +125: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the three CTA tokens
00:09 +126: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration back chip: light shadow, dark Glass — not a missing shadow
00:09 +127: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration the registration back chip is a different Glass from G5
00:09 +128: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration language pill: G3 differs from G5 only in lightIntensity
00:09 +129: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration form fields: G4, and the 0.03 hairline kept verbatim
00:09 +130: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration onboarding sheet: the only Glass in the light frames
00:09 +131: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit2 — shell, auth, onboarding, registration scrims: five frames, five readings
00:09 +132: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes level card: light shadow, dark Glass plus a back-light
00:09 +133: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes daily tasks: G7, and two differently sized back-lights
00:09 +134: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes top student: same border width on both canvases
00:09 +135: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes continue learning: two shadows, one with a negative spread
00:09 +136: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subjects search: the file's only 10% shadows
00:09 +137: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes subject card: identical on both canvases — this is #34's proof
00:09 +138: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes mistakes pill and card
00:09 +139: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit3 — home, catalog, mistakes the segmented pill track inverts its inner shadow when selected
00:09 +140: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the five near-identical small shadows stay five tokens
00:09 +141: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard length chips, AI panel and leaderboard list keep dark shadows
00:09 +142: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard AI panel: G18 outside, G5 inside, one back-light
00:09 +143: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard quiz previous button: G13 confirms the angle convention
00:09 +144: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard result buckets, rewards card and star disc
00:09 +145: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard the scope toggle is the file's only white inner shadow
00:09 +146: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit4 — quiz, result, review, leaderboard a leaderboard row carries two different Glass effects
00:09 +147: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card profile header, edit chip and stat card keep a dark shadow
00:09 +148: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card avatar badge
00:09 +149: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card settings sections and their two back-lights
00:09 +150: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card OTP: the timer inset and the one lavender drop shadow
00:09 +151: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: edit5 — profile, settings, OTP, track card the two track cards carry two different Glass angles
00:09 +152: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: API→UI Wave 22 — flashcards the card is one INNER shadow, the same on both canvases
00:09 +153: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: API→UI Wave 22 — flashcards it is wired through copyWith and lerp
00:09 +154: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream every dark DROP shadow is black except the two glows
00:09 +155: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream the withdrawn cream appears in no token, on either canvas
00:09 +156: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: #34 — the dark canvas drops BLACK shadows, never cream a dark token with no shadow is a reading, not a gap
00:09 +157: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism the onboarding sheet is the ONLY light Glass
00:09 +158: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every dark surface that Figma glassed has a token
00:09 +159: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: Glass is a dark-canvas mechanism every back-light is dark-only and takes the palette colour
00:09 +160: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places props covers every field
00:09 +161: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places copyWith round-trips, and leaves the others alone
00:09 +162: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp endpoints are exact
00:09 +163: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp actually moves, and snaps what cannot be interpolated
00:09 +164: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places lerp ignores a foreign extension, as ThemeExtension requires
00:09 +165: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places equality is by value, not by identity
00:09 +166: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/app_elevation_test.dart: the extension is wired in all four places both ThemeData objects carry it
00:09 +167: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:09 +168: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:09 +169: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:09 +170: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontSize at a call site
00:10 +171: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/typography_discipline_test.dart: no type metric is decided outside the scale no fontWeight at a call site
00:10 +172: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/typography_discipline_test.dart: the scale itself every style sits on the sizes the designer specified
00:10 +173: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/typography_discipline_test.dart: the scale itself no style names a font family
00:10 +174: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/typography_discipline_test.dart: the scale itself no style carries a colour
00:10 +175: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/theme/typography_discipline_test.dart: the scale itself both themes serve the scale through TextTheme
00:10 +176: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/content_text_direction_test.dart: a text takes its first strong character's direction, else the app's
00:10 +177: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/content_text_direction_test.dart: it is the quiz question's rule, exactly
00:10 +178: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:11 +179: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog no scrim leaves the framework barrier alone
00:11 +180: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:11 +181: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:11 +182: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses rounded rectangle
00:11 +183: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/figma_shadow_painter_test.dart: the sigma conversion a larger blur really does spread further
00:11 +184: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:11 +185: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:11 +186: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog sigma > 0 blurs the page at exactly that sigma
00:11 +187: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses circle
00:11 +188: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses circle
00:11 +189: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +190: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +191: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +192: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +193: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +194: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +195: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +196: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog the barrier keeps its dismiss semantics label
00:11 +197: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it renders every shape the design uses a top-only hairline renders without a uniform one
00:11 +198: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:11 +199: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog a barrier tap still dismisses, blurred
00:11 +200: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: the backdrop is opt-in content — the onboarding sheet — creates exactly one
00:11 +201: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppDialog barrierDismissible false keeps it open
00:11 +202: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:11 +203: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:11 +204: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +205: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +206: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +207: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +208: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +209: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +210: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/glass_rim_calibration_test.dart: the rim has a lit side (DESIGN_ISSUES #72) at lightAngle −45 the top and left are the bright ones
00:12 +211: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: back-lights a back-light without Glass trips the debug assert
00:12 +212: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: back-lights a back-light without Glass trips the debug assert
00:12 +213: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet sigma > 0 blurs the page at exactly that sigma
00:12 +214: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet sigma > 0 blurs the page at exactly that sigma
00:12 +215: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it adds no semantics of its own
00:12 +216: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/elevated_surface_test.dart: it adds no semantics of its own
00:12 +217: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:12 +218: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:12 +219: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/app_modal_test.dart: showAppModalSheet showDragHandle still inserts the handle, blurred
00:12 +220: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:12 +221: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:12 +222: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:12 +223: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:12 +224: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/primary_cta_test.dart: light — a shadow, and no glow the primary tone paints the measured black
00:12 +225: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:12 +226: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:12 +227: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:12 +228: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:12 +229: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:12 +230: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +231: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +232: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +233: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +234: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +235: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +236: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +237: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/elevation/segmented_track_test.dart: an unselected segment paints NOTHING, whatever the style says
00:13 +238: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +239: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +240: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +241: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +242: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +243: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +244: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +245: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +246: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +247: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +248: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +249: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +250: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +251: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +252: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +253: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +254: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +255: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +256: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +257: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: CircleBackButton dark · the standard variant takes the standard tokens
00:13 +258: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +259: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +260: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +261: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +262: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +263: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +264: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +265: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:13 +266: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:14 +267: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:14 +268: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:14 +269: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:14 +270: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader draws the title it is given, not the quiz's
00:14 +271: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: FieldShell dark draws the 0.03 seam under Glass
00:14 +272: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging 24 cards page 10 / 10 / 4 by cursor, and hasMore says when to stop
00:14 +273: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - paging 24 cards page 10 / 10 / 4 by cursor, and hasMore says when to stop
00:14 +274: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +275: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +276: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +277: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +278: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +279: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +280: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +281: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +282: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +283: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +284: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +285: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +286: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader EN: the title sits on the screen centre, short or ellipsised
00:14 +287: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_flashcards_test.dart: GET /flashcards/lectures/{id}/cards - scope and validation every cause answers with ONE byte-identical body that names no id
00:14 +288: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:14 +289: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:14 +290: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: FieldShell it is still 60 tall and start-aligned
00:14 +291: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:14 +292: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:14 +293: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:14 +294: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:14 +295: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:14 +296: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader AR: the title sits on the screen centre, short or ellipsised
00:14 +297: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:14 +298: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill light draws the 0.629032 hairline and no Glass
00:14 +299: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +300: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +301: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +302: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +303: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +304: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +305: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader holds exactly one SvgPicture (the ✕) and one tappable
00:14 +306: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:14 +307: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:14 +308: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:14 +309: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:14 +310: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/shared_chrome_test.dart: LanguagePill it is a stadium at the frame height, and taps
00:14 +311: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:14 +312: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:14 +313: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the bar and the counter follow position and total
00:14 +314: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_flashcards_test.dart: PUT /flashcards/cards/{id}/self-grade a grade that is missing or not gotIt/again is validation_failed on grade
00:14 +315: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:14 +316: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:14 +317: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader a short pool reads n/short, and the last card fills the bar
00:14 +318: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_flashcards_test.dart: fixtures every lecture flashcardCount equals the cards it serves, and hasFlashcards agrees
00:14 +319: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:14 +320: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:14 +321: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader an empty deck is an empty bar, and a position past the end stops at full
00:14 +322: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:14 +323: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:14 +324: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader light: the FILL is whatever the screen passes; the track and counter are shared
00:14 +325: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader dark: the FILL is whatever the screen passes; the track and counter are shared
00:14 +326: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader the keys land on the container and the ✕ button
00:14 +327: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader without keys it still builds
00:14 +328: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader tapping the ✕ calls onClose, and it is named Close
00:14 +329: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudySessionHeader Arabic mirrors the ✕: 16 from the right edge
00:14 +330: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton is the 79 x 58 pill, and tapping it calls onPressed
00:14 +331: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton en: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:14 +332: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton ar: the glyph is the frame's 27 x 54 arrow box, 4 under the top, centred
00:14 +333: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton announces itself as PREVIOUS, not as back
00:15 +334: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:15 +335: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:15 +336: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton a null onPressed is dimmed, inert and disabled to TalkBack
00:15 +337: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:15 +338: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:15 +339: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:15 +340: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:15 +341: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:15 +342: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/core/widgets/study_session_chrome_test.dart: StudyPreviousButton the chevron is mirrored in LTR and left alone in RTL
00:15 +343: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:15 +344: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:15 +345: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:15 +346: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:15 +347: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:15 +348: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent — a repeat call replays the same summary
00:15 +349: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me — what invalidating the profile shows
00:15 +350: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered — expected, not a bug
00:15 +351: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:15 +352: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:15 +353: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:15 +354: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:15 +355: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:15 +356: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:15 +357: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:15 +358: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:15 +359: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:15 +360: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:15 +361: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:15 +362: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:15 +363: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:15 +364: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:15 +365: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:15 +366: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:15 +367: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:15 +368: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:15 +369: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:15 +370: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:15 +371: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:15 +372: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:15 +373: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:15 +374: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:15 +375: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:16 +376: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:16 +377: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:16 +378: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:16 +379: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:16 +380: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +381: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:17 +382: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:18 +383: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +384: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +385: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +386: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +387: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +388: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +389: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +390: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +391: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +392: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +393: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +394: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +395: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: #30 the resend-timer pill 42 tall, 15 of padding, and a stadium
00:18 +396: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +397: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +398: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +399: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +400: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +401: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +402: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +403: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +404: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +405: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:18 +406: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +407: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +408: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +409: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +410: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +411: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +412: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +413: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +414: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +414: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:19 +415: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +416: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +417: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +418: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +419: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +420: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +421: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +422: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +423: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +424: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +425: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +426: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +427: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +428: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +429: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +430: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +431: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +432: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +433: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +434: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +435: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +436: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +437: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +438: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +439: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +440: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +441: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +442: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +443: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +444: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +445: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +446: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +447: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +448: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +449: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:19 +450: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
00:20 +451: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_success_router_test.dart: a correct code shows the success view — no jump to /home
unhandled element <filter/>; Picture key: Svg loader
00:20 +452: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +453: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +453: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/auth/otp_elevation_test.dart: §7.11a the two CTAs the success screen's Continue is wrapped and enabled
unhandled element <filter/>; Picture key: Svg loader
00:20 +454: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +455: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +456: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +457: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +458: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +459: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +460: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +461: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +462: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +463: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +464: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +465: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +466: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +467: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +468: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +469: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +470: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:20 +471: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_header_test.dart: school: a fresh Subjects root draws no back chip
00:21 +472: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +473: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +474: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +475: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +476: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +477: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +478: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +479: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +480: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +481: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +482: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +483: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +484: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +485: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:22 +486: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +487: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +488: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +489: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:22 +490: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +491: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +492: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +493: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +494: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +495: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +496: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/chapters_screen_test.dart: the rows sit 16 apart
00:23 +497: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +498: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +499: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +500: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +501: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:24 +502: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:24 +503: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:24 +504: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:24 +505: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:25 +506: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:25 +507: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lessons_screen_test.dart: the rows sit 16 apart
00:25 +508: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:25 +509: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:25 +510: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +511: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +512: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +513: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:25 +514: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +515: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +516: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +517: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +518: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +519: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +520: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +521: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +522: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +523: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +524: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +525: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +526: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +527: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +528: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +529: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +530: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +531: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +532: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +533: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +534: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +535: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +536: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +537: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +538: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +539: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +540: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +541: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +542: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +543: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +544: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +545: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +546: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +547: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +548: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +549: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +550: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +551: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +552: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: school Units: the rows sit 16 apart
00:26 +553: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +554: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +555: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +556: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +557: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Onboarding Get Started is the primary tone
00:26 +558: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:27 +559: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:27 +560: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:27 +561: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:27 +562: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures: the rows sit 16 apart, the first 25 below the tabs
00:27 +563: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +564: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +565: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +566: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +567: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +568: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +569: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +570: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +571: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +572: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +573: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +574: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +575: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +576: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/elevation/cta_call_sites_test.dart: Login Send OTP is primary, Create New Account is outline
00:27 +577: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subjects_screen_test.dart: search clearing the query restores the full list
00:27 +578: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:27 +579: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/subject_tree_layout_test.dart: university Lectures, Flashcard tab: same 25 under the tabs, same 16 pitch
00:27 +580: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +581: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +582: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +583: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:27 +584: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +585: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +586: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +587: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +588: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +589: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +590: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +591: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +592: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +593: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +594: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +595: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +596: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_flip_card_test.dart: faces the front shows the question and not the answer
00:28 +597: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +598: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +599: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +600: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +601: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +602: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:28 +603: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +604: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +605: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +606: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +607: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +608: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +609: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +610: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +611: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +612: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +613: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +614: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +615: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +616: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +617: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +618: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +619: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +620: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +621: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +622: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +623: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +624: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +625: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +626: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +627: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +628: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +629: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +630: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +631: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +632: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +633: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +634: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +635: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +636: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +637: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +638: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +639: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +640: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +641: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +642: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +643: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +644: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +645: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +646: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +647: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: what the frame draws title, subject caption, lecture heading, pill, helper and Start (EN)
00:29 +648: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:29 +649: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +650: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +651: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +652: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +653: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +654: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +655: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +656: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +657: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +658: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +659: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +660: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +661: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +662: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +663: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +664: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +665: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +666: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +667: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +668: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +669: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +670: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +671: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the counter and the header a full round reads 1/10, and the fill is the flashcard token
00:30 +672: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +673: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +674: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +675: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +676: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +677: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +678: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +679: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +680: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +681: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:30 +682: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/coming_soon_section_test.dart: Daily Tasks · 308:4305 / 337:5357 dark · fill, radius and border come from the tokens
00:31 +683: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +684: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +685: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +686: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +687: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +688: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +689: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +690: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +691: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +692: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +693: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +694: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +695: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +696: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +697: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +698: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +699: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +700: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +701: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +702: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +703: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +704: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +705: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_header_unread_test.dart: the unread dot does NOT render while the flag is false
00:31 +706: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +707: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +708: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +709: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +710: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +711: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +712: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +713: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +714: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +715: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +716: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +717: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +718: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:31 +719: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +720: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +721: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +722: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +723: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +724: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +725: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +726: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +727: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:32 +728: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +729: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +730: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +731: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +732: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +733: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +734: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +735: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +736: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +737: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +738: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +739: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +740: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +741: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +742: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +743: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +744: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +745: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: which board (owner, Wave 05) school reads the board the tab opens on: system
00:32 +746: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:32 +747: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +748: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +749: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark a one-scope board still collapses to nothing
00:33 +750: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:33 +751: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:33 +752: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:33 +753: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +754: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +755: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +756: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +757: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +758: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +759: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +760: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +761: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Start right after a round finished tapped after the pop has finished, it fetches the next round exactly once
00:33 +762: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:33 +763: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_elevation_test.dart: ScopeToggle · 158:839 light / 337:5615 dark the track takes the scope toggle's own fills, not the pill track's
00:33 +764: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +765: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +766: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +767: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +768: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +769: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:33 +770: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:33 +771: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:33 +772: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:33 +773: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:33 +774: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:33 +775: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:33 +776: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: the card an answer with several lines is one wrapping block
00:33 +777: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states connectivity down with data on screen → pinned banner
00:33 +778: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/home_screen_test.dart: states connectivity down with data on screen → pinned banner
00:33 +779: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/home/top_student_section_test.dart: rows · 59:2091 / 337:5461 dividers sit BETWEEN rows only, in the hairline colour
00:33 +780: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: Setup never touches the flashcards endpoint the lecture list is read from the cached tree: one tree request
00:33 +781: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +782: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +783: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +784: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +785: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +786: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +787: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +788: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +789: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +790: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows row numbers go through the locale, not string interpolation
00:33 +791: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: grading "Got it" sends ONE gotIt for the card and advances to 2/10
00:33 +792: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: grading "Got it" sends ONE gotIt for the card and advances to 2/10
00:33 +793: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_study_screen_test.dart: grading "Got it" sends ONE gotIt for the card and advances to 2/10
00:33 +794: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: the round position is dropped once Setup is popped
00:33 +795: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: the round position is dropped once Setup is popped
00:33 +796: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: the round position is dropped once Setup is popped
00:33 +797: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: the round position is dropped once Setup is popped
00:33 +798: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +799: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +800: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +801: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +802: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +803: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +804: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +805: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +806: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +807: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +808: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +809: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +810: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: lecture rows dark theme renders the same content
00:33 +811: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:33 +812: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +813: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +814: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +815: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +816: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +817: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +818: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +819: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +820: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +821: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +822: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +823: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +824: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +825: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +826: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +827: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +828: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +829: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +830: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +831: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +832: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +833: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +834: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +835: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +836: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +837: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +838: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +839: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +840: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +841: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +842: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +843: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +844: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_row_test.dart: light · rank, name and points are all #4F4F4F
00:34 +845: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +846: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +847: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +848: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +849: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +850: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +851: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +852: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +853: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +854: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +855: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +856: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +857: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:34 +858: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +859: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +860: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +861: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +862: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +863: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +864: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +865: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +866: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +867: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +868: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +869: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +870: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +871: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +872: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +873: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +874: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +875: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +876: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +877: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +878: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +879: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +880: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +881: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +882: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +883: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +884: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +885: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +886: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +887: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +888: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +889: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +890: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +891: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +892: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +893: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +894: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +895: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:35 +896: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +897: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +898: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +899: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +900: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +901: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +902: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +903: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +904: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/leaderboard/leaderboard_screen_test.dart: the scope switcher forks by track an Egyptian school student gets System + Governorate
00:36 +905: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) tapping a segment SELECTS it, in semantics
00:36 +906: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/catalog/lectures_screen_test.dart: the segmented track (edit3 #9) tapping a segment SELECTS it, in semantics
00:36 +907: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +908: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +909: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +910: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +911: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +912: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/flashcards/flashcard_setup_screen_test.dart: routes (real router) the study path builds the study screen over Setup, nav bar kept
00:36 +913: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +914: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +915: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +916: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +917: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:36 +918: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +919: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +920: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +921: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +922: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +923: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +924: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +925: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +926: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +927: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +928: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +929: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +930: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +931: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +932: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +933: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +934: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +935: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +936: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +937: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +938: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +939: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:37 +940: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +941: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +942: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +943: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +944: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +945: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +946: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +947: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +948: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +949: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +950: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +951: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +952: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +953: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +954: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +955: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +956: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +957: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +958: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +959: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +960: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +961: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the entry point the Day-6 coming-soon snackbar is gone
00:38 +962: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +963: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +964: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +965: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:38 +966: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +967: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +968: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +969: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +970: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +971: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +972: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +973: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +974: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +975: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +976: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +977: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +978: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +979: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +980: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +981: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +982: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +983: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +984: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +985: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +986: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +987: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +988: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +989: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +990: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +991: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +992: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +993: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_elevation_test.dart: #25 the avatar badge light: the frame's TIGHT shadow, not the borrowed one
00:39 +994: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +995: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +996: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +997: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +998: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +999: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1000: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:39 +1001: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:40 +1002: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:40 +1003: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:40 +1004: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:40 +1005: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:40 +1006: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:40 +1007: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1008: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1009: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1010: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1011: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1012: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #21 the header card light: the frame shadow, no Glass, no back-light
00:40 +1013: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:40 +1014: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:41 +1015: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:41 +1016: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:41 +1017: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:41 +1018: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory a student with no email gets an empty box, not "null"
00:41 +1019: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the OVERVIEW it is an enrolment state, and retryable
00:41 +1020: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #22 the edit chip the glyph is the READ colour, not the accent
00:41 +1021: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1022: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1023: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1024: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1025: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1026: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1027: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1028: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1029: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1030: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1031: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1032: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1033: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1034: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1035: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1036: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1037: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1038: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1039: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1040: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1041: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1042: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1043: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1044: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) on the SUBJECT route it still means "not your subject"
00:41 +1045: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:41 +1046: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_elevation_test.dart: #24 the menu rows EVERY tone draws the 35 dp disc — the refuted reading
00:41 +1047: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) account_pending_deletion is NOT swallowed as a scope error
00:41 +1048: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) account_pending_deletion is NOT swallowed as a scope error
00:41 +1049: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the two insufficient_scope meanings (#61) account_pending_deletion is NOT swallowed as a scope error
00:41 +1050: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:41 +1051: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:42 +1052: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:42 +1053: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the school tree four screens cost ONE tree fetch
00:42 +1054: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:42 +1055: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:42 +1056: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the school tree every row renders the SERVER count, never a sum
00:42 +1057: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form UNTOUCHED: retyping the same address sends nothing
00:42 +1058: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the school tree a LESSON is inert — no chevron, no tap
00:42 +1059: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form TYPED: a new address is sent as a string
00:43 +1060: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the school tree a subject with no units is EMPTY, not a crash and not an error
00:43 +1061: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form CLEARED: emptying the box sends the key with an explicit null
00:43 +1062: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the university tree is FLAT, has no quizType tabs, and its leaves are inert
00:43 +1063: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: email — the three states, through the form the screen says out loud that an empty box deletes
00:43 +1064: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: the university tree the OVERVIEW is the same screen on both tracks
00:43 +1065: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1066: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:43 +1067: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1068: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1069: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1070: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1071: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1072: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1073: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1074: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1075: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1076: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1077: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1078: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1079: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1080: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1081: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1082: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1083: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1084: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1085: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1086: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1087: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:44 +1088: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1089: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1090: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1091: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1092: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1093: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1094: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the second student sees their own profile on Home and on Profile (the mock: a token-less /me answers the first student)
00:45 +1095: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:45 +1096: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:45 +1097: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:45 +1098: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:45 +1099: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:45 +1100: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:46 +1101: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:46 +1102: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:46 +1103: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:46 +1104: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: ProfileCity — the union at its first call site a CODED city renders the English name in EN
00:46 +1105: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in ar at 2.0x; rows grow together
00:46 +1106: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 15: the frames (404:6292 · 404:7428) BUG-002: no overflow in ar at 2.0x; rows grow together
00:46 +1107: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
00:46 +1108: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
00:46 +1109: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
00:46 +1110: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
00:46 +1111: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: the sign-out drops the first student's profile from memory
00:46 +1112: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) Units: the list starts 25 under the header, rows 78 tall and 16 apart
00:46 +1113: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: loaded nine of the frame's ten rows render
00:46 +1114: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: ProfileCity — the union at its first call site a FREE-TEXT city has nothing to localize, so AR shows it too
00:46 +1115: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1116: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1117: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1118: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1119: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:46 +1120: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_relogin_test.dart: while the second student's /me is in flight, nothing of the first shows
00:47 +1121: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1122: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1123: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1124: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1125: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1126: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1127: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1128: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_stat_card_test.dart: the shadow is the frame's, on both canvases light draws black 25% at (0.02, 0.02) blur 2
00:47 +1129: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1130: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1131: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1132: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1133: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1134: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1135: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1136: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1137: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1138: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1139: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1140: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1141: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1142: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1143: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1144: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1145: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1146: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1147: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1148: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1149: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1150: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1151: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1152: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router the Account tab IS the Profile hub
00:47 +1153: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
00:47 +1154: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
00:47 +1155: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:48 +1156: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:48 +1157: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:48 +1158: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router Settings is the one live menu row
00:48 +1159: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: en at 1.3x nothing overflows, the rows grow and the count stays under the name
00:48 +1160: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a clean form leaves without asking
00:48 +1161: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router every disabled row leads nowhere — the location does not move
00:48 +1162: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 16: the frames (404:6539 · 404:7181 · 404:7765) BUG-002: ar at 1.3x nothing overflows, the rows grow and the count stays under the name
00:48 +1163: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/edit_profile_screen_test.dart: unsaved-changes guard a dirty form asks, and "Keep editing" stays put
00:48 +1164: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:48 +1165: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1166: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1167: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1168: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1169: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1170: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1171: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:49 +1172: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1173: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1174: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1175: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1176: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1177: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1178: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_education_glyph_test.dart: the box is the frame's 26.55 square
00:49 +1179: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:49 +1180: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: navigation, through the real router /me is fetched ONCE across Home → Account
00:49 +1181: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) each chapter row is ONE button node with the whole label
00:49 +1182: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) each chapter row is ONE button node with the whole label
00:50 +1183: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) each chapter row is ONE button node with the whole label
00:50 +1184: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) each chapter row is ONE button node with the whole label
00:50 +1185: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
00:50 +1186: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Logout dialog (the one thing that fully works) confirm calls the existing AuthController logout
00:50 +1187: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
00:50 +1188: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) Arabic mirrors the row: badge 17 from the right, chevron mirrored and 12 from the left
00:50 +1189: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Go to Uni dialog opens, and its Confirm is genuinely disabled
00:50 +1190: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a unit the tree does not have is EMPTY, not an error, and costs no second fetch
00:50 +1191: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Go to Uni dialog tapping the dead Confirm changes nothing
00:50 +1192: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
00:50 +1193: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
00:50 +1194: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) a failed load on Chapters offers Retry, which refetches this subject and shows the rows
00:50 +1195: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: states error → localized copy + a Retry that re-calls /me
00:50 +1196: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:50 +1197: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:50 +1198: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:50 +1199: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 17: the Chapters frames (404:6677 · 404:7894) offline pins the banner on Chapters and keeps the rows
00:50 +1200: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark renders in dark theme
00:50 +1201: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:51 +1202: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) light: the list starts 25 under the header, rows 16 apart, each 78 tall
00:51 +1203: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the dialogs are localized too
00:51 +1204: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1205: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1206: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1207: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1208: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1209: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1210: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1211: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1212: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1213: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1214: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1215: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1216: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1217: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1218: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1219: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1220: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1221: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1222: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1223: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:51 +1224: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1225: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/ai_explanation_panel_test.dart: offers a try again after the poll cap gives up
00:52 +1226: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1227: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1228: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1229: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1230: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1231: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1232: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1233: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1234: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1235: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1236: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1237: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1238: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1239: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1240: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText draws the underline and never the tags
00:52 +1241: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:52 +1242: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) each lesson row is ONE node with the whole label, not a button
00:52 +1243: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) Logout: the No / Yes pair (180:4757) dark: No #EF4444, Yes #AE87E7, both shadow-only
00:52 +1244: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/question_stem_text_test.dart: QuestionStemText an Arabic stem in the English app is its own RTL paragraph, still set from the left
00:52 +1245: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1246: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1247: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1248: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1249: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1250: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1251: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1252: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1253: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1254: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1255: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) English: the lesson counts pluralise ("1 mistake")
00:52 +1256: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) the ✕ (180:4706) dark: the frame's cross in #FCFBF9, 24 from the card's start, a 48 x 48 target
00:52 +1257: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) the ✕ (180:4706) dark: the frame's cross in #FCFBF9, 24 from the card's start, a 48 x 48 target
00:52 +1258: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) the ✕ (180:4706) dark: the frame's cross in #FCFBF9, 24 from the card's start, a 48 x 48 target
00:52 +1259: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) the ✕ (180:4706) dark: the frame's cross in #FCFBF9, 24 from the card's start, a 48 x 48 target
00:52 +1260: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) the ✕ (180:4706) dark: the frame's cross in #FCFBF9, 24 from the card's start, a 48 x 48 target
00:52 +1261: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) the ✕ (180:4706) dark: the frame's cross in #FCFBF9, 24 from the card's start, a 48 x 48 target
00:52 +1262: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:52 +1263: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:52 +1264: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:52 +1265: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:52 +1266: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:52 +1267: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1268: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1269: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1270: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1271: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1272: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1273: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1274: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1275: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1276: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1277: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1278: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1279: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1280: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1281: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic: the lesson counts take the one, two, few and many forms
00:53 +1282: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/profile/profile_screen_test.dart: Wave 19: the frames (166:4416 · 180:4704 · 180:4445) Go to Uni keeps ONE button, 284 wide and centred (180:4572)
00:53 +1283: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_bloc_test.dart: explanation asking twice does not restart a generation the server charges for
00:53 +1284: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
00:53 +1285: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
00:53 +1286: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
00:53 +1287: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) Arabic mirrors the row: badge 17 from the right, the text starting 12 to its left, no chevron
00:53 +1288: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_bloc_test.dart: explanation account_pending_deletion is NOT re-issued, however often it is asked
00:53 +1289: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1290: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1291: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1292: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1293: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1294: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1295: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1296: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1297: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1298: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:53 +1299: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) arriving from Chapters shows the rows at once, from the cached tree
00:54 +1300: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/mistakes/mistakes_screens_test.dart: Wave 18: the Lessons frames (404:6762 · 549:19390) a cold link shows the skeleton on Lessons until the tree arrives
00:54 +1301: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1302: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1303: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1304: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1305: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: a 0.5 green hairline, no Glass, no back-light
00:54 +1306: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark dark: NO hairline, G18 Glass and the lavender back-light
00:55 +1307: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark dark: the inner card carries the WRAPPER's shadow — blur 3, black
00:55 +1308: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark dark: the inner card is glassed only where the frame says so
00:55 +1309: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: the inner card carries the WRAPPER's shadow — blur 3, black
00:55 +1310: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark light: the inner card is glassed only where the frame says so
00:55 +1311: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark all four states still render, and only three draw the card
00:55 +1312: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: AiExplanationPanel · 159:1811 light / 337:9270 dark the back-light is on the OUTER surface, the one whose frost makes it visible
00:55 +1313: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: QuestionOptionTile · 308:5153 light / 337:6440 dark the dark idle hairline is LAVENDER, not the green ring's value
00:55 +1314: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: QuestionOptionTile · 308:5153 light / 337:6440 dark light is unchanged — both tokens are the same green there
00:55 +1315: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_elevation_test.dart: QuestionOptionTile · 308:5153 light / 337:6440 dark the graded states are untouched by this wave
00:56 +1316: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: Quiz parses a school quiz — no quizType at all
00:56 +1317: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: Quiz parses a university quiz — quizType maps by member name
00:56 +1318: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: Quiz questionCount reads the questions DELIVERED, not the length asked for
00:56 +1319: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: Quiz a missing required field throws rather than defaulting
00:56 +1320: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: Quiz all three contract modes parse
00:56 +1321: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: Quiz round-trips through encode/decode
00:56 +1322: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizQuestion parses isFavorite — required, so the model must carry it
00:56 +1323: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizQuestion imageUrl is null on a text-only question
00:56 +1324: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizQuestion imageUrl parses when present — the "with photo" variant
00:56 +1325: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizQuestion carries NO correctness — the contract never ships it with questions
00:56 +1326: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizQuestion minItems is 2, not 4 — a three-option question parses
00:56 +1327: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: AnswerResult parses the graded response
00:56 +1328: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: AnswerResult a wrong answer still reveals correctOptionId
00:56 +1329: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: AnswerResult pointsDelta of 0 on a replay parses as 0, not as absent
00:56 +1330: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary parses every required field, newBadge and recap rows included
00:56 +1331: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary a 2.x body still carrying totalPoints and level parses unchanged
00:56 +1332: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary recap rows carry a null `correct` for unanswered questions
00:56 +1333: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary wrong is answeredCount - score, NOT totalQuestions - score
00:56 +1334: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary a fully-answered quiz has nothing skipped
00:56 +1335: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary a quiz answered perfectly but abandoned early
00:56 +1336: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary fraction is the ring, clamped, and never divides by zero
00:56 +1337: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary server drift cannot render a negative bucket
00:56 +1338: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizSummary round-trips through encode/decode
00:56 +1339: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizMode / QuizLength carries all three contract values
00:56 +1340: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizMode / QuizLength but only normal is OFFERED today
00:56 +1341: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_models_test.dart: QuizMode / QuizLength length is exactly the contract enum 10/30/50
00:56 +1342: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz school: sends lessonId and OMITS lectureId/quizType entirely
00:56 +1343: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz university: sends lectureId + quizType and OMITS lessonId
00:56 +1344: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz never sends both ids — the args type makes it unrepresentable
00:56 +1345: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz mode is a parameter, not a hardcoded string
00:56 +1346: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz parses the 201 into a Quiz
00:56 +1347: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz 403 weekly_question_limit_reached surfaces with its code
00:56 +1348: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz 422 not_enough_questions surfaces with its code
00:56 +1349: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: createQuiz offline surfaces as OfflineException
00:56 +1350: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: submitAnswer posts questionId + optionId to the quiz-scoped path
00:56 +1351: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: submitAnswer a retry sends the IDENTICAL body — no client-side suppression
00:56 +1352: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: submitAnswer 409 quiz_already_finished surfaces with its code
00:56 +1353: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: submitAnswer a malformed grading body surfaces as UnknownException (F-7-01)
00:56 +1354: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: finishQuiz posts to the finish path and parses the summary
00:56 +1355: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: finishQuiz 403 insufficient_scope surfaces with its code
00:56 +1356: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: getExplanation 200 → ExplanationReady with the text
00:56 +1357: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: getExplanation 202 → ExplanationGenerating, not an error
00:56 +1358: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: getExplanation a 200 without text is contract drift, not an empty panel
00:56 +1359: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_repository_test.dart: getExplanation 403 insufficient_scope still throws — the caller ordered wrongly
00:57 +1360: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:58 +1361: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +1362: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states correct, wrong and skipped rows all render together
00:59 +1363: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1364: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1365: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1366: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1367: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1368: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1369: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1370: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1371: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1372: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1373: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1374: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1375: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1376: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1377: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1378: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1379: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1380: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1381: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1382: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1383: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1384: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1385: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1386: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1387: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1388: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1389: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:59 +1390: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:00 +1391: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:00 +1392: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
01:00 +1393: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable — no regression
01:00 +1394: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable — no regression
01:00 +1395: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/reference_dropdown_test.dart: an enabled option is still selectable — no regression
01:00 +1396: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a quiz finished with ZERO answers is all skipped
01:00 +1397: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1398: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1399: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1400: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1401: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1402: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1403: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1404: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1405: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1406: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1407: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering shows NO points preview and NO question-pool card
01:00 +1408: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back with no subject in hand, the scope stands alone
01:00 +1409: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back with no subject in hand, the scope stands alone
01:00 +1410: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: what the frame draws but the contract cannot back with no subject in hand, the scope stands alone
01:00 +1411: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1412: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1413: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1414: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1415: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1416: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1417: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1418: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1419: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1420: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1421: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1422: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1423: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1424: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1425: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1426: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1427: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1428: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1429: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1430: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1431: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1432: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1433: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1434: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1435: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1436: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1437: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1438: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1439: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1440: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1441: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1442: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1443: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1444: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the four render states a malformed extra renders the unavailable view, not a crash
01:00 +1445: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1446: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1447: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1448: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1449: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1450: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1451: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1452: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1453: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
01:00 +1454: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1455: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1456: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1457: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1458: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1459: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1460: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1461: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1462: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1463: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1464: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions is LIVE and opens the review screen
01:00 +1465: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1466: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1467: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1468: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1469: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1470: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1471: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1472: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1473: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1474: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1475: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1476: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1477: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:00 +1478: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1479: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1480: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
01:01 +1481: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Review Questions review is pushed, so Back returns to the result
01:01 +1482: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: the per-question submit model selecting an option sends NOTHING and enables Confirm
01:01 +1483: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the AI glyph is absent when the server has no explanation
01:01 +1484: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: the AI glyph is absent when the server has no explanation
01:01 +1485: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1486: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1487: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1488: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1489: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1490: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1491: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1492: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1493: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz school sends the lessonId and the chosen length
01:01 +1494: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1495: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1496: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: navigation Back leaves for Learn, never into the finished quiz
01:01 +1497: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:01 +1498: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz university sends the lectureId and quizType — SAME screen
01:01 +1499: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: the per-question submit model an answered question cannot be re-answered
01:01 +1500: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: states matrix Arabic (RTL)
01:01 +1501: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: legibility the correct row keeps its own token, which is GREEN in light
01:01 +1502: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: creating a quiz a created quiz pushes the taking screen
01:02 +1503: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: the per-question submit model the primary action becomes Next once graded
01:02 +1504: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1505: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: states matrix dark theme
01:02 +1506: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1507: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1508: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1509: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1510: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1511: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1512: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1513: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1514: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1515: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1516: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1517: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1518: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:02 +1519: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1520: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1521: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1522: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1523: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1524: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1525: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1526: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1527: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1528: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1529: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1530: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1531: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1532: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1533: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1534: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1535: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1536: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1537: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1538: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1539: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1540: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1541: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1542: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1543: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1544: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1545: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1546: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1547: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1548: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1549: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1550: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1551: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:03 +1552: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1553: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1554: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1555: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1556: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1557: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1558: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1559: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1560: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1561: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1562: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1563: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1564: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1565: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1566: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
01:04 +1567: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1568: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1569: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1570: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1571: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1572: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1573: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1574: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1575: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1576: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1577: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1578: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1579: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1580: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1581: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:04 +1582: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1583: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1584: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1585: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1586: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1587: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1588: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1589: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1590: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1591: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1592: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1593: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1594: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
01:05 +1595: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:05 +1596: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:05 +1597: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:05 +1598: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:05 +1599: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:05 +1600: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) chips: an idle label is #384F47 in light, cream in dark
01:05 +1601: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout shows the frame fields in order after Date of Birth
01:05 +1602: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout shows the frame fields in order after Date of Birth
01:05 +1603: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: exit guard closing asks first — progress cannot be lost silently
01:05 +1604: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/registration_screens_test.dart: Sign Up_1 (identity) on-screen field errors follow a language toggle
01:05 +1605: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_setup_screen_test.dart: Wave 11: the header matches both frames dark: subject and scope are both #FCFBF9, not the accent
01:05 +1606: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_review_screen_test.dart: Wave 14: the frames (162:2377 · 337:6705) rows: 19 apart
01:05 +1607: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_result_screen_test.dart: Wave 13: the frames (159:1964 · 337:6628) dark: the #2E2D32 track, the same gradient, a cream figure
01:05 +1608: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout includes the Date of Birth field the Figma frame is missing (DESIGN_ISSUES #2 — contract-required)
01:05 +1609: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout includes the Date of Birth field the Figma frame is missing (DESIGN_ISSUES #2 — contract-required)
01:06 +1610: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout includes the Date of Birth field the Figma frame is missing (DESIGN_ISSUES #2 — contract-required)
01:06 +1611: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout includes the Date of Birth field the Figma frame is missing (DESIGN_ISSUES #2 — contract-required)
01:06 +1612: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout includes the Date of Birth field the Figma frame is missing (DESIGN_ISSUES #2 — contract-required)
01:06 +1613: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1614: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1615: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1616: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1617: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1618: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1619: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1620: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1621: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1622: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1623: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1624: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1625: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1626: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1627: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1628: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1629: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1630: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1631: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1632: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1633: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1634: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1635: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1636: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1637: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1638: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:06 +1639: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1640: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1641: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1642: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1643: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1644: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1645: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1646: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1647: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1648: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1649: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/track_card_elevation_test.dart: #32 light: a drop shadow, a gradient outline, no Glass the card is an ElevatedSurface at 112 / r25
01:07 +1650: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1651: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1652: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1653: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1654: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1655: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1656: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1657: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1658: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1659: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1660: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1661: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1662: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1663: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1664: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:07 +1665: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1666: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1667: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1668: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1669: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1670: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1671: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1672: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1673: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
01:08 +1674: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1675: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1676: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1677: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1678: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1679: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1680: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1681: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1682: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1683: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1684: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1685: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1686: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1687: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1688: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1689: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:08 +1690: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1691: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1692: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1693: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1694: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1695: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1696: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1697: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1698: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1699: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1700: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1701: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1702: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the section card light: the LAVENDER hairline, not the hub's purple-grey
01:09 +1703: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1704: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1705: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1706: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1707: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1708: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1709: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:09 +1710: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1711: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1712: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1713: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1714: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1715: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1716: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1717: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1718: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1719: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1720: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:10 +1721: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1722: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1723: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1724: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1725: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1726: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1727: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1728: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1729: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1730: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1731: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:10 +1732: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:10 +1733: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1734: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1735: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1736: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1737: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1738: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1739: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1740: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: post-login lands on /home INSIDE the shell
01:11 +1741: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:11 +1742: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:11 +1743: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:11 +1744: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:11 +1745: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:11 +1746: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light dark university: B15, six pixels higher
01:11 +1747: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:11 +1748: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:11 +1749: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:11 +1750: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:11 +1751: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route /legal/privacy renders "Privacy & policy"
01:11 +1752: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/nav_centre_tab_test.dart: the glyph never takes the accent — it goes grey to white
01:11 +1753: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) after the popup the button stays, and asking again asks the server again
01:11 +1754: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) after the popup the button stays, and asking again asks the server again
01:11 +1755: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) after the popup the button stays, and asking again asks the server again
01:11 +1756: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light no back-light while /me has not answered
01:11 +1757: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light no back-light while /me has not answered
01:11 +1758: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light no back-light while /me has not answered
01:11 +1759: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light no back-light while /me has not answered
01:11 +1760: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light no back-light while /me has not answered
01:11 +1761: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #28 the Notification Preferences back-light no back-light while /me has not answered
01:12 +1762: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:12 +1763: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) paging back to that question does not reopen it
01:12 +1764: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/quiz/quiz_screen_test.dart: Wave 12: the frames (159:845 · 159:1695 · 216:2973) paging back to that question does not reopen it
01:12 +1765: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) neither toggle carries name, email or avatarId
01:12 +1766: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1767: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1768: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1769: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1770: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1771: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1772: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1773: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1774: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1775: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: each shell exists at its route the right screen class, not a placeholder
01:12 +1776: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:12 +1777: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:12 +1778: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:12 +1779: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:12 +1780: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: the Account tab is the real Profile hub, not a placeholder
01:12 +1781: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: no invented data /refer has nothing to type into and nothing to list
01:12 +1782: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:12 +1783: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:13 +1784: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:13 +1785: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) when /me has never loaded, Rank degrades and the rest works
01:13 +1786: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: switching tabs preserves Home — /me is not re-fetched
01:13 +1787: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: switching tabs preserves Home — /me is not re-fetched
01:13 +1788: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/shell/main_shell_test.dart: switching tabs preserves Home — /me is not re-fetched
01:13 +1789: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_elevation_test.dart: #50 Languages is a segmented track ENGLISH is the first segment — the frame's order
01:13 +1790: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:13 +1791: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:13 +1792: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:13 +1793: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1794: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1795: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1796: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1797: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1798: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:13 +1799: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1800: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1801: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/cta_golden_test.dart: primary CTA · light · enabled
01:14 +1802: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:14 +1803: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:14 +1804: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:14 +1805: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1806: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1807: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1808: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1809: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1810: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1811: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1812: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1813: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1814: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1815: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1816: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1817: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1818: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1819: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/design_goldens_test.dart: level card · light
01:14 +1820: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:14 +1821: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:15 +1822: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:15 +1823: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:15 +1824: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:15 +1825: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:15 +1826: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit3_surfaces_golden_test.dart: home section · daily tasks · dark
01:15 +1827: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1828: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1829: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1830: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1831: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1832: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1833: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1834: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1835: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1836: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1837: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1838: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1839: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1840: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit4_surfaces_golden_test.dart: AI explanation panel · dark
01:15 +1841: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:15 +1842: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:16 +1843: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:16 +1844: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: profile header card · dark
01:16 +1845: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:16 +1846: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:16 +1847: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark dark does not quietly re-enable anything
01:16 +1848: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/elevation_primitives_test.dart: level card surface · light
01:16 +1849: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/elevation_primitives_test.dart: level card surface · light
01:16 +1850: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/elevation_primitives_test.dart: level card surface · light
01:16 +1851: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/elevation_primitives_test.dart: level card surface · light
01:16 +1852: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1853: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1854: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1855: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1856: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1857: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1858: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1859: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1860: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1861: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1862: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1863: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1864: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1865: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1866: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1867: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1868: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1869: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1870: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1871: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1872: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/edit5_surfaces_golden_test.dart: OTP code card and digit cells · dark
01:16 +1873: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:16 +1874: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:16 +1875: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1876: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1877: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1878: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1879: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1880: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1881: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1882: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1883: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1884: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1885: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1886: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1887: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1888: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1889: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1890: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1891: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1892: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1893: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1894: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1895: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 0 selected
01:17 +1896: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1897: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1898: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1899: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1900: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1901: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1902: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1903: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1904: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1905: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1906: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1907: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1908: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1909: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1910: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1911: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1912: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1913: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1914: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1915: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1916: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1917: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1918: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1919: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1920: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:17 +1921: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:17 +1922: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 1 selected
01:17 +1923: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1924: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1925: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1926: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1927: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1928: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1929: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1930: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1931: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1932: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1933: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1934: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1935: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1936: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1937: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1938: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1939: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1940: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1941: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1942: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1943: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1944: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1945: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1946: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1947: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1948: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:17 +1949: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · light · tab 3 selected
01:17 +1950: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1951: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1952: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1953: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1954: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1955: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1956: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1957: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1958: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1959: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1960: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1961: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1962: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1963: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1964: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1965: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:17 +1966: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 2 selected
01:17 +1967: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark offline pins the banner and Rank still reads from cache
01:17 +1968: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark offline pins the banner and Rank still reads from cache
01:17 +1969: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: nav bar · dark · tab 4 selected
01:18 +1970: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/goldens/nav_bar_golden_test.dart: (tearDownAll)
01:18 +1970: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI never passes a directory to flutter test
01:18 +1971: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: test discovery cannot silently omit tests CI runs the whole suite minus goldens, and the goldens by tag
01:18 +1972: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: test discovery cannot silently omit tests every golden test file carries the golden tag
01:18 +1973: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: the pinned SDK version has one source of truth .flutter-version exists and is a plain version
01:18 +1974: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: the pinned SDK version has one source of truth CI reads the pin from the file rather than hardcoding it
01:18 +1975: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact the main manifest declares INTERNET
01:18 +1976: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: release networking protection (Tier-0 C-1) stays intact CI still inspects the built artefact, not just the source
01:18 +1977: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: the release build command names the production entrypoint every runnable release-build command targets lib/main_prod.dart
01:18 +1978: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:18 +1979: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: the release build command names the production entrypoint the scan actually finds the release commands it is guarding
01:18 +1980: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: canonical validation stays canonical both validate scripts exist
01:18 +1981: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: canonical validation stays canonical the pre-push hook reuses validate.sh instead of its own checks
01:18 +1982: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: canonical validation stays canonical PowerShell scripts are pure ASCII
01:18 +1983: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: canonical validation stays canonical every shell script that batches files is NUL-safe
01:18 +1984: F:/level/level_up/level_up_app/.claude/worktrees/w22-verify/test/guards/workflow_test.dart: canonical validation stays canonical validate.sh feeds xargs a NUL-delimited list
01:18 +1985: All tests passed!
```

