# Validation run - 2026-08-23T11:29:01Z

Produced by `tool/validate.ps1`. Self-contained: everything needed to judge a
failure (toolchain, branch, commit, full output) is in this one file.

| Step | Result | Detail |
| --- | --- | --- |
| `dart format` | **PASS** | 217 hand-written files checked |
| `flutter analyze` | **PASS** | 0 issue(s) |
| `flutter test` | **PASS** | 861 passed / 0 failed |

**OVERALL: PASS**

Started 2026-08-23T11:29:01Z - finished 2026-08-23T11:31:35Z

---

## 1. Environment

```text
started (UTC)  : 2026-08-23T11:29:01Z
host os        : Microsoft Windows NT 10.0.26200.0
powershell     : 5.1.26100.9168
repo root      : F:/level/level_up/level_up_app
branch         : merged
commit         : 98ecb4e
tree clean     : NO - uncommitted changes present
.metadata rev  : f6ff1529fd6d8af5f706051d9251ac9231c83407
pinned version : 3.44.7
```

## 2. Toolchain

```text
Flutter 3.44.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 84fc5cbb22 (5 weeks ago) • 2026-07-17 10:20:17 -0700
Engine • hash 7076f47b1d1a3a0edfd8837b17dc15be6abab661 (revision 69c8c61792) (1 months ago) • 2026-07-15 20:46:58.000Z
Tools • Dart 3.12.2 • DevTools 2.57.0

Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "windows_x64"
```

## 3. Dependencies (`flutter pub get`)

```text
Resolving dependencies...
Downloading packages...
  _fe_analyzer_shared 99.0.0 (105.0.0 available)
  analyzer 12.1.0 (14.1.0 available)
  build 4.0.7 (4.0.10 available)
  build_config 1.3.1 (1.3.2 available)
  build_daemon 4.1.2 (4.1.5 available)
  build_runner 2.15.1 (2.16.0 available)
  built_value 8.12.6 (8.12.7 available)
  code_assets 1.2.1 (2.0.0 available)
  connectivity_plus 7.3.0 (7.3.1 available)
  dart_style 3.1.8 (3.1.12 available)
  dbus 0.7.14 (0.7.15 available)
  dio 5.10.0 (5.11.0 available)
  dio_web_adapter 2.2.0 (2.2.1 available)
  flutter_riverpod 3.3.2 (3.4.2 available)
  flutter_secure_storage 10.3.1 (11.0.0 available)
  flutter_secure_storage_darwin 0.3.2 (0.4.0 available)
  flutter_secure_storage_linux 3.0.1 (3.0.2 available)
  flutter_secure_storage_platform_interface 2.0.1 (2.0.3 available)
  freezed 3.2.6-dev.1 (4.0.0 available)
  go_router 17.3.0 (17.5.0 available)
  hooks 2.0.2 (2.2.0 available)
  intl 0.20.2 (0.20.3 available)
  jni 1.0.0 (1.0.3 available)
  jni_flutter 1.0.1 (1.0.2 available)
  jovial_svg 1.1.29 (1.1.30 available)
  json_serializable 6.14.0 (6.14.1 available)
  matcher 0.12.19 (0.12.20 available)
  material_color_utilities 0.13.0 (0.13.1 available)
  meta 1.18.0 (1.19.0 available)
  mockito 5.6.4 (5.8.1 available)
  objective_c 9.4.1 (9.6.0 available)
  package_config 2.2.0 (3.0.0 available)
  record_use 0.6.0 (1.1.1 available)
  riverpod 3.3.2 (3.4.2 available)
  riverpod_analyzer_utils 1.0.0-dev.10 (1.0.0-dev.11 available)
  riverpod_annotation 4.0.3 (4.0.6 available)
  riverpod_generator 4.0.4 (4.0.8 available)
  source_gen 4.2.3 (4.3.0 available)
  source_helper 1.3.12 (1.3.13 available)
  source_maps 0.10.13 (0.10.14 available)
  synchronized 3.4.1+1 (3.4.1+2 available)
  test 1.31.0 (1.31.2 available)
  test_api 0.7.11 (0.7.13 available)
  test_core 0.6.17 (0.6.19 available)
  vector_graphics 1.2.2 (1.2.3 available)
  vector_graphics_compiler 1.2.6 (1.3.0 available)
  vector_math 2.2.0 (2.4.2 available)
  vm_service 15.2.0 (15.3.0 available)
  win32 6.3.0 (6.4.0 available)
  xml 6.6.1 (7.0.1 available)
Got dependencies!
50 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

## 4. Format (`dart format --set-exit-if-changed --output=none`)

Generated output (`*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*`)
is excluded - the generators format their own output.

```text
checking 217 hand-written Dart files

Formatted 60 files (0 changed) in 0.35 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 60 files (0 changed) in 0.40 seconds.
Formatted 37 files (0 changed) in 0.29 seconds.
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

**861 passed, 0 failed** (exit 0)


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
00:01 +8: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: session_superseded → forceLogout(superseded), cleared, no refresh
00:01 +9: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: refresh → refresh_token_invalid → forceLogout(sessionExpired)
00:01 +10: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: concurrent 401s → refresh called exactly once, all retried
00:01 +11: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: already-retried request 401s again → not refreshed/retried a 2nd time
00:01 +12: F:/level/level_up/level_up_app/test/core/network/auth_interceptor_test.dart: offline during refresh → NO logout, surfaces the network error
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
00:03 +43: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated on a protected route → /login
00:03 +44: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated already on an auth route → stay
00:03 +45: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) the whole /register wizard stays reachable while signed out
00:03 +46: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated sitting on /login → /home
00:03 +47: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unauthenticated at / STAYS on / — onboarding must be reachable
00:03 +48: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated at / → /home, never the onboarding pitch
00:03 +49: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown at / → wait; do not flash onboarding then bounce
00:03 +50: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) authenticated on a protected route → stay
00:03 +51: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: authRedirect (pure guard) unknown (first frame) → wait, never redirect
00:03 +52: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +53: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:04 +54: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +55: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +56: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +57: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +58: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +59: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +60: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +61: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +62: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:05 +63: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +64: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +65: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +66: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +67: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:06 +68: F:/level/level_up/level_up_app/test/core/router/app_router_test.dart: forceLogout flips the app from a protected route to /login
00:07 +69: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places light and dark both define them
00:07 +70: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places copyWith round-trips each of them
00:07 +71: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp moves each of them — a missing entry would pin one in place
00:07 +72: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: Day-00 tokens are wired in all four places lerp endpoints are exact
00:07 +73: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge is identical in both palettes — it must not follow the accent flip
00:07 +74: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge equals the fill in the exported SVG — not an estimate
00:07 +75: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: successBadge the badge keeps its white checkmark — so it is never srcIn-tinted
00:07 +76: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: the OTP stopwatch export is stroked in the light primary
00:07 +77: F:/level/level_up/level_up_app/test/core/theme/app_colors_test.dart: all three brand assets landed
00:07 +78: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw hex at a call site
00:08 +79: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette no raw black or white at a call site
00:08 +80: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: no colour is decided outside the palette the status bar is styled in exactly one place
00:08 +81: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is a different colour on each canvas — that is the entire point
00:08 +82: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow carries no alpha of its own — the call site owns the depth
00:08 +83: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: elevationShadow is wired into copyWith and lerp
00:08 +84: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +85: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +86: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +87: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +88: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:08 +89: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +90: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas light draws the frame-measured black at 25%
00:09 +91: F:/level/level_up/level_up_app/test/core/theme/palette_discipline_test.dart: a card on each canvas dark draws the canvas shadow, not the light one
00:09 +92: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: mock GET /catalog/subjects parses into Subjects
00:09 +93: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: every mocked subject has a walkable tree
00:09 +94: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) GET /me comes back as a university profile
00:09 +95: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) every university subject has a walkable lecture tree
00:09 +96: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) quizTypes vary per subject, so the tab row cannot be hardcoded
00:09 +97: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: university mode (OTP code 111111) a school subject id is out of scope for a university student
00:09 +98: F:/level/level_up/level_up_app/test/dev/mock_backend_catalog_test.dart: an out-of-scope subject answers the contract 403
00:10 +99: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me parses into a StudentProfile Home can render
00:10 +100: F:/level/level_up/level_up_app/test/dev/mock_backend_profile_test.dart: mock GET /me/entitlements parses, and agrees with the /me embed
00:11 +101: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes parses into a Quiz with the requested number of questions
00:11 +102: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes questions ship WITHOUT correct answers
00:11 +103: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes a photo question is reachable — the 159:1852 variant
00:11 +104: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 not_enough_questions on an empty pool
00:11 +105: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 422 when the length exceeds a non-empty pool
00:11 +106: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 subscription_required on a paid scope
00:11 +107: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes 403 weekly_question_limit_reached once 50 questions are used
00:11 +108: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers grades, and reveals correctOptionId only now
00:11 +109: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay returns the ORIGINAL grade and awards nothing
00:11 +110: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers a replay with a DIFFERENT option does not re-grade
00:11 +111: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/answers 409 quiz_already_finished after finish
00:11 +112: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish summarises a PARTIALLY answered quiz truthfully
00:11 +113: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish is idempotent — a repeat call replays the same summary
00:11 +114: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: POST /quizzes/{quizId}/finish the award reaches GET /me — what invalidating the profile shows
00:11 +115: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 403 before the student has answered — expected, not a bug
00:11 +116: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation 202 then 200 — the polling path is walkable
00:11 +117: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: GET /questions/{questionId}/explanation some questions report no explanation at all
00:11 +118: F:/level/level_up/level_up_app/test/dev/mock_backend_quiz_test.dart: both tracks reach the quiz endpoints (000000 / 111111)
00:11 +119: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a coded-city, coded-school Egyptian registration succeeds
00:11 +120: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 an Egyptian registration with NO school succeeds (adr-028 §2)
00:11 +121: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 schoolName is REJECTED as an unknown property, not echoed
00:11 +122: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 neither cityId nor cityName is validation_failed
00:11 +123: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 BOTH cityId and cityName is validation_failed
00:11 +124: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: POST /auth/register enforces adr-028 a schoolId outside Egypt is rejected — the coded list is Egyptian
00:12 +125: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a coded registration comes back as the CODED arm
00:12 +126: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used a free-text registration comes back as the FREE-TEXT arm
00:12 +127: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the profile echoes the city arm the registration actually used no profile fixture carries a schoolName key any more
00:12 +128: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added an unrecognised countryCode is 404 country_not_found
00:12 +129: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added a MALFORMED countryCode is 400, not 404 — the split is easy to get backwards
00:12 +130: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added country codes normalize case-insensitively
00:12 +131: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added cities 404 on an unrecognised country too
00:12 +132: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the 429 trigger yields RateLimitedException with a parsed Retry-After
00:12 +133: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added governorates carry the same 429
00:12 +134: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added the school search has its own 429 trigger
00:12 +135: F:/level/level_up/level_up_app/test/dev/mock_backend_v11_test.dart: the /reference/* failure paths v1.1 added every trigger row is reachable from the country picker
00:12 +136: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with no token → unauthenticated
00:13 +137: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: app start with a token → authenticated
00:13 +138: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: forceLogout uses clearTokens (device_id preserved), NOT clear()
00:13 +139: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: logout swallows a failing server call and clears tokens anyway
00:13 +140: F:/level/level_up/level_up_app/test/features/auth/auth_controller_test.dart: clearReason drops the reason but stays unauthenticated
00:13 +141: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` authenticated → AuthenticatedResult with parsed tokens + opaque profile
00:13 +142: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: AuthResult.fromJson — discriminated on contract `result` registrationRequired → RegistrationRequiredResult with token + ttl
00:13 +143: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: Contract fidelity — required fields have no defensive defaults TokenPair throws when a required field is missing
00:13 +144: F:/level/level_up/level_up_app/test/features/auth/auth_result_test.dart: OtpRequestResult.fromJson maps the 202 body
00:14 +145: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +146: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +147: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +148: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +149: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +150: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +151: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +152: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +153: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +154: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +155: F:/level/level_up/level_up_app/test/features/auth/login_logout_message_test.dart: superseded reason shows the message once (EN), then clears
00:17 +156: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:18 +157: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: invalid phone blocks submit — error shown, repo never called
00:18 +158: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +159: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +160: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +161: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +162: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +163: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: renders 6 OTP boxes and, at 0 countdown, the Resend action
00:18 +164: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: offline → distinct banner shown and Send OTP disabled
00:18 +165: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +166: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +167: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +168: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +169: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +170: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +171: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +172: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +173: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +174: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +175: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +176: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +177: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +178: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +179: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +180: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +181: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +182: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +183: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: countdown > 0 → timer pill with the stopwatch; Resend inert until 0
00:19 +184: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard — it starts the same phone → OTP flow
00:19 +185: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) no longer dead-ends on the registration expiry guard — it starts the same phone → OTP flow
00:20 +186: F:/level/level_up/level_up_app/test/features/auth/otp_screen_test.dart: authenticated verify → success screen with Continue
unhandled element <filter/>; Picture key: Svg loader
00:20 +187: F:/level/level_up/level_up_app/test/features/auth/login_validation_test.dart: Create New Account (DESIGN_ISSUES #8) an empty phone surfaces the same inline error
00:20 +188: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:20 +189: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +190: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +191: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +192: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +193: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +194: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +195: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +196: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +197: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +198: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +199: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +200: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +201: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +202: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +203: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +204: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +205: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +206: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +207: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +208: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +209: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +210: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +211: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +212: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +213: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:21 +214: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: Subjects → Units → Chapters → Lessons costs ONE tree fetch
00:24 +215: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:26 +216: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:26 +217: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:26 +218: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:26 +219: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: the one route branches on the tree, not on the profile a university tree renders Lectures
00:26 +220: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: loaded renders a 2-column grid from GET /catalog/subjects
00:27 +221: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:27 +222: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:27 +223: F:/level/level_up/level_up_app/test/features/home/home_screen_test.dart: loaded renders the header and the level card from GET /me
00:27 +224: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:27 +225: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +226: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +227: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +228: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +229: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +230: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +231: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +232: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +233: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +234: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +235: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +236: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +237: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +238: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:28 +239: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:29 +240: F:/level/level_up/level_up_app/test/features/onboarding/onboarding_screen_test.dart: content renders the title, tagline, subtitle and both buttons
00:29 +241: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +242: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +243: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +244: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +245: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +246: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +247: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +248: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +249: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +250: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +251: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +252: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +253: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +254: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +255: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +256: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +257: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +258: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +259: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +260: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +261: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +262: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +263: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:29 +264: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +265: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +266: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +267: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +268: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +269: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +270: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +271: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +272: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +273: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +274: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +275: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +276: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +277: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +278: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:30 +279: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +280: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +281: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +282: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +283: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +284: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +285: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +286: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +287: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +288: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +289: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +290: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +291: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +292: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +293: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +294: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +295: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +296: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +297: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +298: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +299: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +300: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +301: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:31 +302: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:32 +303: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: the form is seeded from the /me already in memory name and email arrive pre-filled
00:32 +304: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +305: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +306: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: row anatomy (Figma 337:5926) rows are numbered 1..n in list order
00:32 +307: F:/level/level_up/level_up_app/test/features/catalog/subjects_screen_test.dart: states loading shows a skeleton grid, not a bare spinner
00:32 +308: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +309: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +310: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +311: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +312: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +313: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +314: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +315: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +316: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +317: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +318: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:32 +319: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:33 +320: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:33 +321: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:33 +322: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:33 +323: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:33 +324: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs are built from tree.quizTypes, not a hardcoded five
00:33 +325: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +326: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +327: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +328: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +329: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:33 +330: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +331: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +332: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +333: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +334: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +335: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +336: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +337: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: loaded renders the header from GET /me
00:34 +338: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:34 +339: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:34 +340: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:34 +341: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:34 +342: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs a subject offering one type shows exactly one tab
00:34 +343: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +344: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +345: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +346: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +347: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +348: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +349: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +350: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +351: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +352: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +353: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +354: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +355: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +356: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +357: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +358: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +359: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +360: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +361: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +362: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +363: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +364: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +365: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +366: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +367: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +368: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:34 +369: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +370: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +371: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +372: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +373: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +374: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +375: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +376: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +377: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +378: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +379: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +380: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +381: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +382: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +383: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +384: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +385: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +386: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +387: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +388: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +389: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +390: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +391: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +392: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +393: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +394: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +395: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +396: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +397: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted an untouched form sends no request at all
00:35 +398: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:35 +399: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:35 +400: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: tree failures error shows copy + a retry that re-requests
00:35 +401: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:35 +402: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +403: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +404: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: quiz-type tabs selecting a tab does NOT re-fetch the tree
00:36 +405: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +406: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +407: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +408: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +409: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +410: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +411: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +412: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +413: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +414: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +415: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +416: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +417: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +418: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +419: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +420: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +421: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +422: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +423: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +424: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +425: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +426: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +427: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +428: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted changing the name sends `name` and nothing else
00:36 +429: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:37 +430: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows are numbered 1..n with a bar from their own counter
00:37 +431: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:37 +432: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:37 +433: F:/level/level_up/level_up_app/test/features/catalog/catalog_navigation_test.dart: the drill-down keeps the nav bar and survives a tab switch
00:37 +434: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: only changed fields are submitted the six read-only facts never appear in the body
00:38 +435: F:/level/level_up/level_up_app/test/features/catalog/lectures_screen_test.dart: lecture rows the counter never disables or hides a lecture
00:38 +436: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:38 +437: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:38 +438: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:38 +439: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:38 +440: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +441: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +442: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +443: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +444: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +445: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +446: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +447: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +448: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +449: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +450: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:39 +451: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +452: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +453: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +454: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +455: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +456: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +457: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +458: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +459: F:/level/level_up/level_up_app/test/features/quiz/quiz_result_screen_test.dart: a PARTIALLY answered quiz wrong is answeredCount - score, and Skipped is rendered
00:40 +460: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +461: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +462: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +463: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +464: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +465: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +466: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +467: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +468: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +469: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +470: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +471: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +472: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +473: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +474: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +475: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +476: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +477: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +478: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +479: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +480: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +481: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +482: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +483: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +484: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +485: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +486: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +487: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +488: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +489: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +490: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +491: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +492: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +493: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +494: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +495: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +496: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +497: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +498: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +499: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +500: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +501: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +502: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +503: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +504: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +505: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +506: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows the question, its options and the n/total counter
00:41 +507: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:42 +508: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:42 +509: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering titles itself with the scope and offers 10/30/50
00:42 +510: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +511: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +512: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +513: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +514: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +515: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +516: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +517: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +518: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +519: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +520: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +521: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +522: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +523: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +524: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +525: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +526: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +527: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:42 +528: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +529: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +530: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +531: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +532: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +533: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +534: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +535: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +536: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +537: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:43 +538: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +539: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +540: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +541: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +542: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +543: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +544: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +545: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +546: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +547: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +548: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +549: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +550: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router each shell row lands on its own screen
00:44 +551: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:44 +552: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:44 +553: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: avatar the picker reads the SAME /reference/avatars registration does
00:44 +554: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:45 +555: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:45 +556: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: rendering shows no points figure anywhere during the quiz
00:45 +557: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +558: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +559: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +560: F:/level/level_up/level_up_app/test/features/profile/profile_screen_test.dart: navigation, through the real router the pencil routes to /profile/edit (Step 2 replaces it)
00:46 +561: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:46 +562: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:46 +563: F:/level/level_up/level_up_app/test/features/quiz/quiz_setup_screen_test.dart: rendering 30 is preselected, and tapping another length moves it
00:46 +564: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:47 +565: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:47 +566: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:47 +567: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:47 +568: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:47 +569: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +570: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +571: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +572: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +573: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +574: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +575: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +576: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:48 +577: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +578: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +579: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +580: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +581: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +582: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +583: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +584: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +585: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +586: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +587: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +588: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +589: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +590: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +591: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +592: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +593: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +594: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +595: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +596: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +597: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +598: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +599: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +600: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +601: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +602: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +603: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +604: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +605: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +606: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +607: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:49 +608: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +609: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +610: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +611: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +612: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +613: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +614: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:50 +615: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +616: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +617: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +618: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:51 +619: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +620: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +621: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +622: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +623: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:52 +624: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +625: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +626: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +627: F:/level/level_up/level_up_app/test/features/registration/registration_router_flow_test.dart: router-driven OTP → /register renders Sign Up_1 without red-screening
00:53 +628: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:53 +629: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:53 +630: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:54 +631: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:54 +632: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:54 +633: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:54 +634: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:54 +635: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:54 +636: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +637: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +638: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +639: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +640: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +641: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +642: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +643: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +644: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +645: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +646: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +647: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +648: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +649: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:55 +650: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:56 +651: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:56 +652: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:56 +653: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: frame 337:5269 — layout renders the title, subtitle and Start learning CTA
00:56 +654: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing the last question offers Finish and lands on the result
00:56 +655: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
00:56 +656: F:/level/level_up/level_up_app/test/features/profile/edit_profile_screen_test.dart: save editing after a failure clears the stale error
00:57 +657: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
00:57 +658: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
00:57 +659: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: finishing finishing invalidates /me so Home shows the new points
00:57 +660: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:58 +661: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:58 +662: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:58 +663: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:58 +664: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:59 +665: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:59 +666: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: frame 337:10373 — layout renders the title, subtitle and Start learning CTA
00:59 +667: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
00:59 +668: F:/level/level_up/level_up_app/test/features/quiz/quiz_screen_test.dart: screenshot protection is OFF again when the quiz screen is disposed
01:00 +669: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:00 +670: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:00 +671: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:00 +672: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:00 +673: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:00 +674: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +675: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +676: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +677: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +678: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +679: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +680: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +681: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:01 +682: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:02 +683: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:02 +684: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:02 +685: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:02 +686: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +687: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +688: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: the screen replaces the placeholder /settings renders the real screen
01:03 +689: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +690: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:03 +691: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:04 +692: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:04 +693: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:04 +694: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:05 +695: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:05 +696: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:05 +697: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:05 +698: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:05 +699: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: each shell exists at its route /refer renders "Refer a Friend"
01:06 +700: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:06 +701: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:06 +702: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:06 +703: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:06 +704: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:06 +705: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:07 +706: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:07 +707: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:07 +708: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:07 +709: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) renders in the picker's EXISTING error slot, with Retry
01:07 +710: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:07 +711: F:/level/level_up/level_up_app/test/features/shell/nav_centre_tab_test.dart: idle centre tab: lavender circle, grey glyph
01:07 +712: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Rank — two independent booleans (S27) neither toggle carries name, email or avatarId
01:07 +713: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:07 +714: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:07 +715: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:08 +716: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:08 +717: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:08 +718: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:08 +719: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:08 +720: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: geography the city escape swaps the picker for free text here too
01:08 +721: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:08 +722: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:08 +723: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +724: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +725: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +726: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +727: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +728: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +729: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:09 +730: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) the message stands alone when Retry-After was unusable
01:10 +731: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +732: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +733: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +734: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +735: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +736: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +737: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +738: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +739: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +740: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +741: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +742: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:10 +743: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +744: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +745: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +746: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +747: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +748: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +749: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +750: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +751: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +752: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +753: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +754: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +755: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +756: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:11 +757: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +758: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +759: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +760: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +761: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +762: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +763: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +764: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +765: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +766: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +767: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +768: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +769: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +770: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +771: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +772: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +773: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +774: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +775: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states error → message + retry
01:12 +776: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +777: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +778: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +779: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +780: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +781: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +782: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:12 +783: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +784: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +785: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +786: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +787: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +788: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +789: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +790: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) and is localized
01:13 +791: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +792: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +793: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +794: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +795: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +796: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +797: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: no invented data the only live control on a shell is the way back
01:13 +798: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +799: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +800: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Mode — two canvases, not the frame's three (S26) picking Light again comes back
01:13 +801: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:13 +802: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:13 +803: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:14 +804: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:14 +805: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:14 +806: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:14 +807: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:14 +808: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states offline → its own copy
01:14 +809: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:14 +810: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:14 +811: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:14 +812: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: rate limiting (429 rate_limited) country_not_found still shows the GENERIC geography error
01:14 +813: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: picker states no connectivity → the offline banner
01:14 +814: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal — one screen, two documents, no copy both routes render the same empty body, different titles
01:15 +815: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal — one screen, two documents, no copy both routes render the same empty body, different titles
01:15 +816: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: legal — one screen, two documents, no copy both routes render the same empty body, different titles
01:15 +817: F:/level/level_up/level_up_app/test/features/registration/university_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors, sends no request
01:15 +818: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states empty → the localized empty line, not a blank field
01:15 +819: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states empty → the localized empty line, not a blank field
01:15 +820: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored language is already in force, in the right direction
01:15 +821: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored language is already in force, in the right direction
01:15 +822: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: both choices survive a launch a stored language is already in force, in the right direction
01:15 +823: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:15 +824: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:15 +825: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:15 +826: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:16 +827: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:16 +828: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:16 +829: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:16 +830: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:17 +831: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:17 +832: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states error → message + a user-tapped Retry that refetches
01:17 +833: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) settings_notif_announcements is structurally non-interactive
01:17 +834: F:/level/level_up/level_up_app/test/features/settings/shell_screens_test.dart: AR (RTL) + EN × light + dark the legal screen is localized in Arabic
01:17 +835: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:17 +836: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:18 +837: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:18 +838: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:18 +839: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states offline → its own copy, distinct from a generic error
01:18 +840: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: Notification Preferences — four dead toggles (S28) each announces itself disabled, with a reason
01:18 +841: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: picker states no connectivity → the offline banner
01:19 +842: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic renders the Arabic section titles under RTL
01:19 +843: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: submit pre-flight an incomplete form shows inline errors and sends no request
01:19 +844: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +845: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +846: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark Arabic + dark, and the disabled reason is localized too
01:19 +847: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) renders Arabic copy under RTL directionality
01:19 +848: F:/level/level_up/level_up_app/test/features/settings/settings_screen_test.dart: AR (RTL) + EN × light + dark offline pins the banner and Rank still reads from cache
01:19 +849: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) reference rows display their Arabic names
01:19 +850: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) picker errors are localized in Arabic
01:21 +851: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: Arabic (RTL) both adr-028 escapes carry Seif's Arabic copy
01:21 +852: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" the picker is the default; the escape is a link under it
01:21 +853: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" tapping it SWAPS the dropdown for a text field in place
01:22 +854: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" typing lands on the controller and clears the coded id
01:23 +855: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" "Choose from the list" returns AND clears the free text
01:24 +856: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: city escape — "my city isn't listed" a free-text city still permits a school search
01:25 +857: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable the skip affordance sits under the Egyptian picker
01:25 +858: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable skipping marks the field RESOLVED, not blank
01:26 +859: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable an Egyptian student can submit having skipped it
01:26 +860: F:/level/level_up/level_up_app/test/features/registration/school_detail_screen_test.dart: school step — Egypt only, and skippable picking a school afterwards un-skips the field
01:27 +861: All tests passed!
```

